package controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import dto.Course;
import service.CourseService;

@Controller
@RequestMapping("course")
public class CourseController {
	
	@Autowired
	CourseService courseService;

	
	@GetMapping("subject")
    public ModelAndView getSubject(@RequestParam(value="no", defaultValue="1") int no) {
        ModelAndView mav = new ModelAndView();
        Course courseDetail = courseService.selectCourse(no);
        String profName = courseService.selectProfessorName(no);
        List<Course> courseList = courseService.selectAllCourses(); // 이게 있어야 함
        mav.addObject("Course", courseDetail);
        mav.addObject("courseList", courseList); // 이게 있어야 함
        mav.addObject("profName",profName);
        mav.setViewName("course/subject");
        return mav;
	}
	
//	@GetMapping("*")
//	public void getCourse(Course course) {
//	}
}