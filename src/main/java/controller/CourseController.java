package controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import dto.user.grade.MyGrade;
import dto.user.login.Login;
import dto.user.mypage.MyPageData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dto.Attendance;
import dto.Course;
import dto.user.SessionUser;
import dto.user.User;
import dto.user.UserConst;
import dto.user.UserRole;
import service.CourseService;
import service.UserService;

@Controller
@RequestMapping("course")
public class CourseController {

	@Autowired
	CourseService courseService;
	@Autowired
	UserService userService;

	@GetMapping("subject")
	public ModelAndView getSubject(@RequestParam(value="no", defaultValue="1") int no, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		SessionUser user = (SessionUser) session.getAttribute("sessionUser");
		Course courseDetail = courseService.selectCourse(no);
		String profName = courseService.selectProfessorName(no);
		List<Course> courseList = courseService.selectAllCourses();
		List<User> studentList = courseService.selectStudentList(no);
		List<Attendance> attendanceList = courseService.selectAttendance(user.getUserNo(), no);
		long presentCount = attendanceList.stream().filter(a -> a.getStatus().equals("PRESENT")).count();
		long lateCount = attendanceList.stream().filter(a -> a.getStatus().equals("LATE")).count();
		long absentCount = attendanceList.stream().filter(a -> a.getStatus().equals("ABSENT")).count();
		mav.addObject("presentCount", presentCount);
		mav.addObject("lateCount", lateCount);
		mav.addObject("absentCount", absentCount);
		mav.addObject("AttendanceList", attendanceList);
		mav.addObject("Course", courseDetail);
		mav.addObject("courseList", courseList);
		mav.addObject("profName", profName);
		mav.addObject("studentList", studentList);
		mav.setViewName("course/subject");
		return mav;
	}

	@GetMapping("mainSubject")
	public ModelAndView getmainSubject(@RequestParam(value="no", defaultValue="1") int no) {
		ModelAndView mav = new ModelAndView();
		Course courseDetail = courseService.selectCourse(no);
		String profName = courseService.selectProfessorName(no);
		List<Course> courseList = courseService.selectAllCourses();
		mav.addObject("Course", courseDetail);
		mav.addObject("courseList", courseList);
		mav.addObject("profName", profName);
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
	public ModelAndView getProfScore(@RequestParam(value="no", defaultValue="1") int no, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		SessionUser user = (SessionUser) session.getAttribute("sessionUser");
		if (user == null) {
			mav.setViewName("redirect:/course/home");
			return mav;
		}
		UserRole role = user.getRole();
		if (role != UserRole.PROFESSOR && role != UserRole.ADMIN) {
			mav.setViewName("redirect:/");
			return mav;
		}
		List<User> studentList = courseService.selectStudentList(no);
		for (User u : studentList) {
			System.out.println("userNo: " + u.getUserNo() + ", name: " + u.getName());
		}
		Course courseDetail = courseService.selectCourse(no);
		String profName = courseService.selectProfessorName(no);
		List<Course> courseList = courseService.selectAllCourses();
		mav.addObject("studentList", studentList);
		mav.addObject("Course", courseDetail);
		mav.addObject("courseList", courseList);
		mav.addObject("profName", profName);
		mav.addObject("course", courseDetail);
		mav.setViewName("course/profScore");
		return mav;
	}

	@GetMapping("stuScore")
	public ModelAndView getStuScore(@RequestParam(value="no", defaultValue="1") int no, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		SessionUser user = (SessionUser) session.getAttribute("sessionUser");
		List<User> studentList = courseService.selectStudentList(no);
		for (User u : studentList) {
			System.out.println("userNo: " + u.getUserNo() + ", name: " + u.getName());
		}
		Course courseDetail = courseService.selectCourse(no);
		String profName = courseService.selectProfessorName(no);
		List<Course> courseList = courseService.selectAllCourses();
		Map<String, Object> gradeMap = courseService.selectGradeMap(no, user.getUserNo());
		mav.addObject("studentList", studentList);
		mav.addObject("Course", courseDetail);
		mav.addObject("courseList", courseList);
		mav.addObject("profName", profName);
		mav.addObject("gradeMap", gradeMap);
		mav.setViewName("course/stuScore");
		return mav;
	}

	@PostMapping("saveGrades")
	@ResponseBody
	public String saveGrades(@RequestBody List<Map<String, String>> gradeList) {
		courseService.saveGrades(gradeList);
		return "ok";
	}

	@PostMapping("saveAttendance")
	@ResponseBody
	public String saveAttendance(@RequestBody List<Map<String, String>> attendanceList) {
		courseService.saveAttendance(attendanceList);
		return "ok";
	}

	@GetMapping("home")
	public ModelAndView getHome(HttpSession session) {
		ModelAndView mav = new ModelAndView();
		SessionUser user = (SessionUser) session.getAttribute("sessionUser");

		if (user == null) {
			mav.setViewName("redirect:/user/login");
			return mav;
		}

		UserRole role = user.getRole();
		int userNo = user.getUserNo();

		List<Course> enrolledList; // 수강중인 강의
		List<Course> otherList;    // 전체 강의에서 수강중 제외

		if (role == UserRole.ADMIN) {
			// 관리자: 전체 강의를 수강중으로, 기타 없음
			enrolledList = courseService.selectAllCourses();
			otherList = new ArrayList<>();

		} else if (role == UserRole.PROFESSOR) {
			// 교수: 본인 개설 강의 / 나머지 전체
			enrolledList = courseService.selectCoursesByProfessor(userNo);
			List<Integer> enrolledNos = enrolledList.stream()
					.map(Course::getCourse_no)
					.collect(Collectors.toList());
			otherList = courseService.selectAllCourses().stream()
					.filter(c -> !enrolledNos.contains(c.getCourse_no()))
					.collect(Collectors.toList());

		} else {
			// 학생: 수강신청한 강의 / 나머지 전체
			enrolledList = courseService.selectCoursesByStudent(userNo);
			List<Integer> enrolledNos = enrolledList.stream()
					.map(Course::getCourse_no)
					.collect(Collectors.toList());
			otherList = courseService.selectAllCourses().stream()
					.filter(c -> !enrolledNos.contains(c.getCourse_no()))
					.collect(Collectors.toList());
		}

		Set<Integer> favSet = courseService.selectFavoriteSet(userNo);

		mav.addObject("enrolledList", enrolledList);
		mav.addObject("otherList", otherList);
		mav.addObject("favSet", favSet);
		mav.setViewName("course/home");
		return mav;
	}
	
	@GetMapping("score")
	public void score(@Login SessionUser sessionUser, Integer courseNo, Model model){
		List<User> studentList = courseService.selectStudentList(courseNo);
		Course course = courseService.selectCourse(courseNo);
		MyPageData data = userService.getMyPageData(sessionUser, userService.getSemester());
		model.addAttribute("course", course);
		model.addAttribute("myGrade", data.getGradeList());
		model.addAttribute("studentList", studentList);
	}
//	@GetMapping("*")
//	public void getCourse(Course course) {
//	}
}