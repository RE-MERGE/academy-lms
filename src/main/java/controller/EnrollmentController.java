package controller;

import java.time.LocalDate;
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

import dto.Course;
import dto.user.SessionUser;
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
	
	
	
	@GetMapping("courseCreate")
	public String courseCreate(Model model) {
	    // 서버에서 현재 학기 계산해서 내려주기
	    LocalDate now = LocalDate.now();
	    int month = now.getMonthValue();
	    String term = (month >= 3 && month <= 8) ? "1" : "2";
	    model.addAttribute("currentSemester", now.getYear() + "-" + term);
	    return "enrollment/courseCreate";
	}
	
	
	@PostMapping("create")
	@ResponseBody
	public Map<String, Object> createCourse(
	        @RequestBody Course course,
	        @Login SessionUser sessionUser) {

	    Map<String, Object> result = new HashMap<>();
	    try {
	        if (!"ADMIN".equals(sessionUser.getRole())) {
	            course.setProfessor_no(sessionUser.getUserNo());
	        }
	        course.setStatus("PENDING");
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
	    
	    result.put("totalCount", courseList.size());
	    
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
	
	
}
