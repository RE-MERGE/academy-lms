package controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import dto.Course;
import service.CourseService;

@ControllerAdvice
public class GlobalControllerAdvice {
	
	@Autowired
	CourseService courseService;
	
	@ModelAttribute("courseList")
	public List<Course> courseList() {
	    List<Course> list = courseService.selectAllCourses();
	    System.out.println("courseList size: " + list.size()); // 추가
	    list.forEach(c -> System.out.println(c.getCourse_name())); // 추가
	    return list;
	}
}
