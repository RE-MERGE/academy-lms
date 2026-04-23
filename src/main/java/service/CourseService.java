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
	
	public Course selectCourse(int no) {
		Course course = coursedao.selectCourse(no);
    	return course;
	}

	public int insertCourse(Course course) {
		return coursedao.insertCourse(course);
	}

	public List<Course> getBlockedCourses(String room, String semester) {
    return coursedao.getBlockedCourses(room, semester);
  }
	public String selectProfessorName(int course_no) {
	    return coursedao.selectProfessorName(course_no);
	}

	public List<Course> selectAllCourses() {
		return coursedao.selectAllCourses();
	}
	
	 public List<Integer> getFavoriteCourseNos(int user_no) {
	        return coursedao.getFavoriteCourseNos(user_no);
	    }

	    public void addFavorite(int user_no, int course_no) {
	        coursedao.addFavorite(user_no, course_no);
	    }

	    public void removeFavorite(int user_no, int course_no) {
	        coursedao.removeFavorite(user_no, course_no);
	    }

		public List<Course> getlist(String semester) {
			return coursedao.getlist(semester);
		}

		public List<Course> getMyCourses(int userNo, String semester) {
			return coursedao.getMyCourse(userNo,semester);
		}

		public List<Course> getMyEnrollments(int userNo, String semester) {
			return coursedao.getMyenrollment(userNo,semester);
		}
}
