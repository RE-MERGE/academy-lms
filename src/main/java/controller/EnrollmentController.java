package controller;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import dto.Course;
import dto.user.SessionUser;
import dto.user.UserConst;
import dto.user.UserRole;
import dto.user.login.Login;
import service.CourseService;
import service.EnrollmentService;
import service.SupabaseStorageService;
import service.UserService;


@Controller
@RequestMapping("enrollment")
public class EnrollmentController {
	@Autowired
	private CourseService courseService;
	@Autowired
	private EnrollmentService enrollmentService;
	@Autowired
	private UserService userService;
	@Autowired
	private SupabaseStorageService storageService;
	
	
	@GetMapping("courseCreate")
	public String courseCreate(Model model) {
	    

	    model.addAttribute("currentSemester", enrollment_semester());
	    return "enrollment/courseCreate";
	}
	private static String enrollment_semester() {
		LocalDate now = LocalDate.now();
	    int month = now.getMonthValue();
	    int year = now.getYear();
	    String term;

	    if (month >= 1 && month <= 6) {
	        term = "1"; // 1학기, 연도 그대로
	    } else {
	        term = "2";
	    }
	    return year + "-" + term;
	}
	
	
	@PostMapping("create")
	@ResponseBody
	public Map<String, Object> createCourse(
	        @RequestParam Map<String, String> params,
	        @RequestParam(required = false) MultipartFile curriculumPdf,
	        @Login SessionUser sessionUser) {

	    Map<String, Object> result = new HashMap<>();
	    try {
	        Course course = new Course();
	        course.setCourse_name(params.get("course_name"));
	        course.setCourse_type(params.get("course_type"));
	        course.setCredits(Integer.parseInt(params.get("credits")));
	        course.setSemester(params.get("semester"));
	        course.setRoom_info(params.get("room_info"));
	        course.setDay_of_week(params.get("day_of_week"));
	        course.setStart_time(params.get("start_time"));
	        course.setEnd_time(params.get("end_time"));
	        course.setMax_students(Integer.parseInt(params.get("max_students")));

	        if (!"ADMIN".equals(sessionUser.getRole().toString())) {
	            course.setProfessor_no(sessionUser.getUserNo());
	        } else {
	        	Integer profNo = userService.getProfNo(Integer.parseInt(params.get("professor_no")));
	        	if(profNo == null) {
	        		 result.put("success", false);
	     	        result.put("message","해당 교수는 존재하지 않습니다.");
	     	        return result;
	        	}
	        	
	            course.setProfessor_no(profNo);
	        }
	        course.setStatus(params.get("status"));

	        String pdfUrl = storageService.uploadPdf(curriculumPdf, params.get("semester"));
	        course.setCurriculum_pdf(pdfUrl);

	        result = courseService.insertCourse(course);
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", e.getMessage());
	    }
	    return result;
	}
	
	@GetMapping("courseUpdate")
	public String courseUpdatePage(@RequestParam int courseNo, @Login SessionUser sessionUser, Model model) {
	    if (sessionUser.getRole() != UserRole.PROFESSOR && sessionUser.getRole() != UserRole.ADMIN) {
	        return "redirect:/enrollment/courseEnrollment";
	    }
	    model.addAttribute("currentSemester", enrollment_semester());
	    return "enrollment/courseUpdate";
	}
	
	@GetMapping("courseDetail")
	@ResponseBody
	public Map<String, Object> courseDetail(@RequestParam int courseNo, @Login SessionUser sessionUser) {
	    Map<String, Object> result = new HashMap<>();
	    try {
	        Course course = courseService.findByCourseNo(courseNo);
	        if (sessionUser.getRole() == UserRole.PROFESSOR && course.getProfessor_no() != sessionUser.getUserNo()) {
	            result.put("success", false);
	            result.put("message", "본인 강의만 조회할 수 있습니다.");
	            return result;
	        }
	        // ADMIN 수정 폼에서 사번으로 pre-fill할 수 있도록 user_code 추가
	        if (sessionUser.getRole() == UserRole.ADMIN && course.getProfessor_no() > 0) {
	            try {
	                int professorUserCode = userService.getUserCodeByProfNo(course.getProfessor_no());
	                result.put("professor_user_code", professorUserCode > 0 ? String.valueOf(professorUserCode) : "");
	            } catch (Exception e) {
	                result.put("professor_user_code", "");
	            }
	        }
	        result.put("success", true);
	        result.put("course", course);
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", e.getMessage());
	    }
	    return result;
	}
	
	@PostMapping("courseUpdate")
	@ResponseBody
	public Map<String, Object> updateCourse(
	        @RequestParam Map<String, String> params,
	        @RequestParam(required = false) MultipartFile curriculumPdf,
	        @Login SessionUser sessionUser) {

	    Map<String, Object> result = new HashMap<>();
	    
	    try {
	        int courseNo = Integer.parseInt(params.get("course_no"));
	        Course existing = courseService.findByCourseNo(courseNo);
	        if (sessionUser.getRole() == UserRole.PROFESSOR) {
	            
	            if (existing == null || existing.getProfessor_no() != sessionUser.getUserNo()) {
	                result.put("success", false);
	                result.put("message", "본인 강의만 수정할 수 있습니다.");
	                return result;
	            }
	        }

	        Course course = new Course();
	        course.setCourse_no(courseNo);
	        course.setCourse_name(params.get("course_name"));
	        course.setCourse_type(params.get("course_type"));
	        course.setCredits(Integer.parseInt(params.get("credits")));
	        course.setSemester(params.get("semester"));
	        course.setRoom_info(params.get("room_info"));
	        course.setDay_of_week(params.get("day_of_week"));
	        course.setStart_time(params.get("start_time"));
	        course.setEnd_time(params.get("end_time"));
	        course.setMax_students(Integer.parseInt(params.get("max_students")));
	        course.setProfessor_no(existing.getProfessor_no());

	        // ADMIN: user_code → professor_no 변환
	        if (UserRole.ADMIN == sessionUser.getRole()) {
	            String userCode = params.get("user_code");
	            if (userCode != null && !userCode.trim().isEmpty()) {
	                try {
	                    Integer profNo = userService.getProfNo(Integer.parseInt(userCode.trim()));
	                    if (profNo == null||profNo <= 0) {
	                        result.put("success", false);
	                        result.put("message", "해당 사번의 교수를 찾을 수 없습니다: [" + userCode + "]");
	                        return result;
	                    }
	                    course.setProfessor_no(profNo);
	                } catch (Exception e) {
	                    result.put("success", false);
	                    result.put("message", "교수 조회 중 오류: " + e.getMessage());
	                    return result;
	                }
	            }
	            // user_code가 비어있으면 professor_no 변경 없이 기존 유지
	        }

	        String pdfUrl = storageService.uploadPdf(curriculumPdf, params.get("semester"));
	        if (pdfUrl != null) course.setCurriculum_pdf(pdfUrl);

	        result = courseService.updateCourse(course);
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", e.getMessage());
	    }
	    return result;
	}
	
	@GetMapping("blocked")
	@ResponseBody
	public List<Course> blocked(@RequestParam String room, @RequestParam String semester) {
	    return courseService.getBlockedCourses(room, semester);
	}
	@GetMapping("courseEnrollment")
	public String course1(@Login SessionUser sessionUser, Model model) {
		model.addAttribute("user", sessionUser);
		model.addAttribute("currentSemester", enrollment_semester());

		// 수강신청 기간 계산
		LocalDate[] period = enrollment_period();
		DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy.MM.dd");
		model.addAttribute("enrollmentStart", period[0].format(fmt));
		model.addAttribute("enrollmentEnd",   period[1].format(fmt));

		return "enrollment/courseEnrollment";
	}

	// 수강신청 기간: 1학기 → 2월 둘째주 월~일, 2학기 → 8월 둘째주 월~일
	public static LocalDate[] enrollment_period() {
		LocalDate now = LocalDate.now();
		int month = now.getMonthValue() <= 6 ? 2 : 8;
		int year  = now.getYear();

		LocalDate secondMonday = LocalDate.of(year, month, 1)
				.with(TemporalAdjusters.firstInMonth(DayOfWeek.MONDAY))
				.plusWeeks(1);
		LocalDate sunday = secondMonday.plusDays(13); // 2주 후 일요일

		return new LocalDate[]{ secondMonday, sunday };
	}
	
	@GetMapping("courselist")
	@ResponseBody
	public Map<String, Object> getEnrollmentList(
	    @RequestParam(defaultValue = "1") int page,
	    @RequestParam(defaultValue = "10") int size,
	    @RequestParam(defaultValue = "") String type,
	    @RequestParam(defaultValue = "") String credits,
	    @RequestParam(defaultValue = "") String keyword,
	    @RequestParam(defaultValue = "") String status,
	    @RequestParam(defaultValue = "") String semester,
	    @Login SessionUser sessionUser
	) {
	    // DB에서 조회 후
	    Map<String, Object> result = new HashMap<>();
	    int offset = (page - 1) * size;
	    String effectiveStatus = status;
	    if (UserRole.STUDENT == sessionUser.getRole()) {
	        effectiveStatus = "APPROVED";
	        System.err.println("status="+effectiveStatus);
	    }
	    System.err.println("status="+effectiveStatus);
	    List<Map<String, Object>> courseList = courseService.getlist(semester, type, credits, keyword, effectiveStatus, offset,size);
	    int totalCount = courseService.getCount(semester, type, credits, keyword, effectiveStatus);
	    result.put("courses", courseList);
	    
	    result.put("totalCount", totalCount);
	    
	    result.put("totalPages", (int) Math.ceil((double) totalCount / size));
	    return result;
	}
	
	// STUDENT: 내 수강목록
	@GetMapping("mine")
	@ResponseBody
	public Map<String, Object> getMyEnrollments(@Login SessionUser sessionUser, @RequestParam(defaultValue = "") String semester) {
	    Map<String, Object> result = new HashMap<>();
	    List<Map<String, Object>> list = courseService.getEnrollments(sessionUser.getUserNo(),semester);
	    result.put("courses", list);
	    return result;
	}

	// PROFESSOR: 내 담당 강의
	@GetMapping("my-courses")
	@ResponseBody
	public Map<String, Object> getMyCourses(@Login SessionUser sessionUser, @RequestParam(defaultValue = "") String semester) {
	    Map<String, Object> result = new HashMap<>();
	    List<Course> list = courseService.getMyCourses(sessionUser.getUserNo(),semester);
	    result.put("courses", list);
	    return result;
	}
	
	@PostMapping("apply")
	@ResponseBody
	public Map<String, Object> applyEnrollment(
	        @Login SessionUser sessionUser,
	        @RequestBody Map<String, Integer> body) {

	    Map<String, Object> result = new HashMap<>();
	    try {
	        enrollmentService.apply(sessionUser.getUserNo(), body.get("courseNo"));
	        result.put("success", true);
	        result.put("message", "수강신청이 완료되었습니다.");
	    } catch (IllegalStateException e) {
	        result.put("success", false);
	        result.put("message", e.getMessage());
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", "수강신청 중 오류가 발생했습니다.");
	    }
	    return result;
	}

	@PostMapping("cancel")
	@ResponseBody
	public Map<String, Object> cancelEnrollment(
	        @Login SessionUser sessionUser,
	        @RequestBody Map<String, Integer> body) {

	    Map<String, Object> result = new HashMap<>();
	    try {
	        enrollmentService.cancel(sessionUser.getUserNo(), body.get("courseNo"));
	        result.put("success", true);
	        result.put("message", "수강신청이 취소되었습니다.");
	    } catch (IllegalStateException e) {
	        result.put("success", false);
	        result.put("message", e.getMessage());
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", "취소 중 오류가 발생했습니다.");
	    }
	    return result;
	}
	
	@PostMapping("status")
	@ResponseBody
	public Map<String, Object> updateCourseStatus(@RequestBody Map<String, Object> body) {
	    Map<String, Object> result = new HashMap<>();
	    try {
	        List<Integer> courseNos = (List<Integer>) body.get("courseNos");
	        String status = (String) body.get("status");
	        courseService.updateStatus(courseNos, status);
	        result.put("success", true);
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", e.getMessage());
	    }
	    return result;
	}
	@PostMapping("courseDelete")
	@ResponseBody
	public Map<String, Object> deleteCourses(@RequestBody Map<String, List<Integer>> body, @Login SessionUser sessionUser) {
	    Map<String, Object> result = new HashMap<>();
	    
	    
	    try {
	        List<Integer> courseNos = body.get("courseNos");
	        if (sessionUser.getRole().equals("PROFESSOR")) {
		        for (int courseNo : courseNos) {
		        	Course existing = courseService.findByCourseNo(courseNo);
		            if (existing == null || existing.getProfessor_no() != sessionUser.getUserNo()) {
		            	 result.put("success", false);
		     	        result.put("message", "내 강의만 삭제 가능합니다.");
		     	        return result;
		            }
		        }
		    }
	        courseService.deleteCourses(courseNos);
	        result.put("success", true);
	        result.put("message", "삭제되었습니다.");
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", "삭제 중 오류가 발생했습니다.");
	    }
	    return result;
	}
	
	
	@GetMapping("professor-blocked")
	@ResponseBody
	public List<Course> professorBlocked(@RequestParam int professorNo, @RequestParam String semester) {
	    return courseService.getProfessorBlockedCourses(professorNo, semester);
	}
}
