package controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import dto.Course;
import service.CourseService;

@Controller
@RequestMapping("enrollment")
public class EnrollmentController {
	@Autowired
	private CourseService courseservice;
	// 기존 - JSP 페이지 로드용 (그대로 유지)
	@GetMapping("courseEnrollment")
	public String course(Model model) {
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

	    List<Course> list = courseservice.list(); // 나중에 필터 파라미터 넘기면 됨

	    Map<String, Object> result = new HashMap<>();
	    result.put("courses", list);
	    result.put("totalCount", list.size());
	    result.put("totalPages", (int) Math.ceil((double) list.size() / size));
	    return result;
	}
	
	@GetMapping("courseCreate")
	public String create() {
		return "enrollment/courseCreate";
	}
	
	@GetMapping("courseCreate2")
	public String create2() {
		return "enrollment/courseCreate2";
	}
	
	@GetMapping("blocked")
	public String blocked() {
		return "enrollment/blocked";
	}
	
	@GetMapping("enrollmentmockup")
	public String mockup() {
		return "enrollment/enrollmentmockup";
	}
}
