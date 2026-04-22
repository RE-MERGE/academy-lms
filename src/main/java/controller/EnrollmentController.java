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
import dto.user.login.Login;
import service.CourseService;

@Controller
@RequestMapping("enrollment")
public class EnrollmentController {
	@Autowired
	private CourseService courseService;
	// 기존 - JSP 페이지 로드용 (그대로 유지)
	@GetMapping("courseEnrollment")
	public String course(@Login SessionUser sessionUser,Model model) {
		model.addAttribute("sessionUser", sessionUser);
	    return "enrollment/courseEnrollment";
	}

	
	// 추가 - AJAX JSON 응답용
	@GetMapping("list")
	@ResponseBody
	public Map<String, Object> courseList(
	        @RequestParam(defaultValue = "1")  int page,
	        @RequestParam(defaultValue = "10") int size,
	        @RequestParam(defaultValue = "") String dept,
	        @RequestParam(defaultValue = "") String type,
	        @RequestParam(defaultValue = "") String credits,
	        @RequestParam(defaultValue = "") String keyword) {

	    List<Course> list = courseService.list(); // 나중에 필터 파라미터 넘기면 됨

	    Map<String, Object> result = new HashMap<>();
	    result.put("courses", list);
	    System.out.println("course count: " + list.size()); 
	    result.put("totalCount", list.size());
	    result.put("totalPages", (int) Math.ceil((double) list.size() / size));
	    return result;
	}
	
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
	
	
}
