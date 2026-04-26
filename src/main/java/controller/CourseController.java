package controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dto.Course;
import dto.user.SessionUser;
import dto.user.User;
import dto.user.UserConst;
import service.CourseService;

@Controller
@RequestMapping("course")
public class CourseController {
	
	@Autowired
	CourseService courseService;

	
	@GetMapping("subject")
    public ModelAndView getSubject(@RequestParam(value="no", defaultValue="1") int no, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        Course courseDetail = courseService.selectCourse(no);
        String profName = courseService.selectProfessorName(no);
        List<Course> courseList = courseService.selectAllCourses(); // 이게 있어야 함
        List<User> studentList = courseService.selectStudentList(no);
        mav.addObject("Course", courseDetail);
        mav.addObject("courseList", courseList); // 이게 있어야 함
        mav.addObject("profName",profName);
        mav.addObject("studentList",studentList);
        mav.setViewName("course/subject");
        return mav;
	}
	@GetMapping("mainSubject")
	public ModelAndView getmainSubject(@RequestParam(value="no", defaultValue="1") int no) {
		ModelAndView mav = new ModelAndView();
		Course courseDetail = courseService.selectCourse(no);
        String profName = courseService.selectProfessorName(no);
        List<Course> courseList = courseService.selectAllCourses(); // 이게 있어야 함
        mav.addObject("Course", courseDetail);
        mav.addObject("courseList", courseList); // 이게 있어야 함
        mav.addObject("profName",profName);
        mav.setViewName("course/mainSubject");
		return mav;
	}
	
	@PostMapping("add")
	@ResponseBody
	public String add(@RequestParam int course_no, HttpSession session) {
	    SessionUser user = (SessionUser) session.getAttribute("sessionUser");
	    if (user == null) return "fail";
	    courseService.addFavorite(user.getUserNo(), course_no);
	    return "ok";
	}

	@PostMapping("remove")
	@ResponseBody
	public String remove(@RequestParam int course_no, HttpSession session) {
	    SessionUser user = (SessionUser) session.getAttribute("sessionUser");
	    if (user == null) return "fail";
	    courseService.removeFavorite(user.getUserNo(), course_no);
	    return "ok";
	}
	
	@GetMapping("profScore")
	public ModelAndView getProfScore(@RequestParam(value="no", defaultValue="1") int no) {
	    ModelAndView mav = new ModelAndView();
	    List<User> studentList = courseService.selectStudentList(no);
	    for(User u : studentList) {
	        System.out.println("userNo: " + u.getUserNo() + ", name: " + u.getName());
	    }
	    Course courseDetail = courseService.selectCourse(no);
        String profName = courseService.selectProfessorName(no);
        List<Course> courseList = courseService.selectAllCourses(); // 이게 있어야 함
	    mav.addObject("studentList", studentList);
	    mav.addObject("Course", courseDetail);
        mav.addObject("courseList", courseList); // 이게 있어야 함
        mav.addObject("profName",profName);
        mav.setViewName("course/profScore");  // WEB-INF/views/course/profScore.jsp
	    return mav;
	}
	
	@PostMapping("saveGrades")
	@ResponseBody
	public String saveGrades(@RequestBody List<Map<String,String>> gradeList) {
		courseService.saveGrades(gradeList);
		return "ok";
	}
	
//	@GetMapping("*")
//	public void getCourse(Course course) {
//	}
}