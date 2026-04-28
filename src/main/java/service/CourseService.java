package service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.CourseDao;
import dto.Course;
import dto.user.User;

@Service
public class CourseService {
	@Autowired
	private CourseDao coursedao;

	public List<Course> list() {
		return coursedao.list();
	}
	
	public Course selectCourse(Integer no) {
    	return coursedao.selectCourse(no);
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

		public List<Map<String, Object>> getlist(String semester, String type, String credits, String keyword, String status, int offset, int size) {
			return coursedao.getlist(semester, type, credits, keyword, status, offset, size);
		}

		public List<Course> getMyCourses(int userNo, String semester) {
			return coursedao.getMyCourse(userNo,semester);
		}

		public List<Map<String, Object>> getEnrollments(int userNo, String semester) {
			return coursedao.getEnrollment(userNo,semester);
		}

		public int getCount(String semester, String type, String credits, String keyword, String status) {
			
			return coursedao.getCount(semester,type, credits, keyword,status);
		}

		public List<User> selectStudentList(int userNo) {
			return coursedao.getStudentList(userNo);
		}

		public void saveGrades(List<Map<String, String>> gradeList) {
		    for (Map<String, String> grade : gradeList) {
		    	
		        int user_no = Integer.parseInt(grade.get("user_no"));
		        int course_no = Integer.parseInt(grade.get("course_no"));
		        int enrollment_no = coursedao.getselectEnrollmentNo(user_no, course_no);
		        System.out.println("user_no:유저넘버 " + user_no);
		        System.out.println("course_no: " + course_no);
		        System.out.println("enrollment_no: " + enrollment_no);
		        String alphabet = grade.get("alphabet");
		        
		        String midtermStr = grade.get("midterm");
		        String finalStr = grade.get("final_score");
		        String attendanceStr = grade.get("attendance");

		        // null 또는 빈값이면 저장 건너뜀
		        if (midtermStr == null || midtermStr.isEmpty() ||
		            finalStr == null || finalStr.isEmpty() ||
		            attendanceStr == null || attendanceStr.isEmpty()) {
		            continue;
		        }

		        coursedao.insertMidterm(enrollment_no, Integer.parseInt(grade.get("midterm")), alphabet);
		        coursedao.insertFinal(enrollment_no, Integer.parseInt(grade.get("final_score")), alphabet);
		        coursedao.insertAttendance(enrollment_no, Integer.parseInt(grade.get("attendance")), alphabet);
		    }
		}
		public void updateStatus(List<Integer> courseNos, String status) {
			coursedao.updateStatus(courseNos, status);
			
		}

		public void deleteCourses(List<Integer> courseNos) {
		    coursedao.deleteCourses(courseNos);
		}
	// BoardController 에서 사용!
	public Course getBoardCourse(Integer courseNo) {
		return coursedao.getBoardCourse(courseNo);
	}
}
