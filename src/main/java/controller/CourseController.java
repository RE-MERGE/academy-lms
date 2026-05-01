package controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import dto.user.grade.GradeForm;
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
import dto.user.UserRole;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
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
	public ModelAndView getSubject(@RequestParam(value="no", required=false) Integer no, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		SessionUser user = (SessionUser) session.getAttribute("sessionUser");
		List<Course> courseList;
	    if (UserRole.PROFESSOR == user.getRole()) {
	        courseList = courseService.selectCoursesByProfessor(user.getUserNo());
	    } else {
	        courseList = courseService.selectCoursesByStudent(user.getUserNo());
	    }

	    // ← no 결정을 먼저! 이후 코드에서 no 사용 가능
	    if (no == null) {
	        no = courseList.isEmpty() ? 1 : courseList.get(0).getCourse_no();
	    }
	    Course courseDetail = courseService.selectCourse(no);
	    String profName = courseService.selectProfessorName(no);
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
		mav.addObject("course", courseDetail);
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

	@GetMapping("courseHome")
	public ModelAndView getHome(HttpSession session) {
		ModelAndView mav = new ModelAndView();
		SessionUser user = (SessionUser) session.getAttribute("sessionUser");

		if (user == null) {
			session.invalidate();
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
			// 학생: APPROVED(수강중) / PENDING(신청중) / 나머지 전체
			enrolledList = courseService.selectCoursesByStatus(userNo, "APPROVED");
			List<Course> pendingList = courseService.selectCoursesByStatus(userNo, "PENDING");

			List<Integer> enrolledNos = enrolledList.stream()
					.map(Course::getCourse_no).collect(Collectors.toList());
			List<Integer> pendingNos = pendingList.stream()
					.map(Course::getCourse_no).collect(Collectors.toList());

			otherList = courseService.selectAllCourses().stream()
					.filter(c -> !enrolledNos.contains(c.getCourse_no()))
					.filter(c -> !pendingNos.contains(c.getCourse_no()))
					.collect(Collectors.toList());

			mav.addObject("pendingList", pendingList);
		}

		Set<Integer> favSet = courseService.selectFavoriteSet(userNo);

		mav.addObject("enrolledList", enrolledList);
		mav.addObject("otherList", otherList);
		mav.addObject("favSet", favSet);
		mav.setViewName("course/courseHome");
		return mav;
	}



	@PostMapping("cancelEnrollment")
	@ResponseBody
	public String cancelEnrollment(@RequestParam("course_no") int courseNo, @Login SessionUser sessionUser) {
		// 세션에서 로그인한 사용자 정보 가져오기 (클래스명은 본인의 프로젝트에 맞게 수정)

		if (sessionUser == null) {
			return "login_required";
		}

		try {
			// student_no와 course_no를 사용하여 해당 행 삭제
			// 단, status가 'PENDING'인 경우에만 삭제하도록 쿼리를 짜는 것이 안전합니다.
			boolean success = courseService.deletePendingEnrollment(sessionUser.getUserNo(), courseNo);
			return success ? "ok" : "fail";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
	}
//	@GetMapping("*")
//	public void getCourse(Course course) {
//	}
}