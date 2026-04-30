package controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import dto.user.login.Login;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import dto.Course;
import dto.user.SessionUser;
import service.CourseService;

@ControllerAdvice
public class GlobalControllerAdvice {
	
	@Autowired
	CourseService courseService;

	@ModelAttribute("favoriteCourseList")
	public List<Course> favoriteCourseList(@Login SessionUser sessionUser) {
		if (sessionUser == null) return new ArrayList<>();
		return courseService.getFavoriteCourses(sessionUser.getUserNo()); // 즐겨찾기 과목만
	}

	@ModelAttribute("favoriteNos")
	public List<Integer> favoriteNos(@Login SessionUser sessionUser, HttpServletRequest request) {
		if (sessionUser == null) return new ArrayList<>();

		String uri = request.getRequestURI();

		if (uri.contains("/home/home") || uri.contains("/user/editProfile") || uri.contains("/user/myPage"))
			return new ArrayList<>();

		return courseService.getFavoriteCourseNos(sessionUser.getUserNo());
	}
}
