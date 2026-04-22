package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.CourseDao;
import dto.Course;

@Service
public class CourseService {
	@Autowired
	private CourseDao coursedao;

	public List<Course> list() {
		return coursedao.list();
	}

	public int insertCourse(Course course) {
		return coursedao.insertCourse(course);
		
	}

	public List<Course> getBlockedCourses(String room, String semester) {
    return coursedao.getBlockedCourses(room, semester);
}

	
}
