package controller;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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


@Controller
@RequestMapping("enrollment")
public class EnrollmentController {
	@Autowired
	private CourseService courseService;
	@Autowired
	private EnrollmentService enrollmentService;
	
	public static final String UPLOAD_CURRICULUM_PDF_PATH = "C:/upload/curriculum/";
	
	@GetMapping("courseCreate")
	public String courseCreate(Model model) {
	    LocalDate now = LocalDate.now();
	    int month = now.getMonthValue();
	    int year = now.getYear();
	    String term;

	    if (month >= 1 && month <= 6) {
	        term = "1"; // 1학기, 연도 그대로
	    } else {
	        term = "2";
	    }

	    model.addAttribute("currentSemester", year + "-" + term);
	    return "enrollment/courseCreate";
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
	            course.setProfessor_no(Integer.parseInt(params.get("professor_no")));
	        }
	        course.setStatus(params.get("status"));

	        String pdfName = saveCurriculumPdf(curriculumPdf, params.get("semester"));
	        course.setCurriculum_pdf(pdfName);

	        int success = courseService.insertCourse(course);
	        result.put("success", success > 0);
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
	public String course1(@Login SessionUser sessionUser,Model model) {
		model.addAttribute("user", sessionUser);
		model.addAttribute("currentSemester","2026-1");
		return "enrollment/courseEnrollment";
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
	public Map<String, Object> deleteCourses(@RequestBody Map<String, List<Integer>> body) {
	    Map<String, Object> result = new HashMap<>();
	    try {
	        List<Integer> courseNos = body.get("courseNos");
	        courseService.deleteCourses(courseNos);
	        result.put("success", true);
	        result.put("message", "삭제되었습니다.");
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", "삭제 중 오류가 발생했습니다.");
	    }
	    return result;
	}
	
	private static String saveCurriculumPdf(MultipartFile file, String semester) {
	    if (file != null && !file.isEmpty()) {
	        File saveFolder = new File(UPLOAD_CURRICULUM_PDF_PATH + semester + "/");
	        if (!saveFolder.exists()) {
	            saveFolder.mkdirs();
	        }

	        String originalFilename = file.getOriginalFilename();
	        String saveFileName = UUID.randomUUID().toString() + "_" + originalFilename;

	        try {
	            file.transferTo(new File(saveFolder, saveFileName));
	            return saveFileName;
	        } catch (IOException e) {
	            e.printStackTrace();
	            return null;
	        }
	    }
	    return null;
	}
}
