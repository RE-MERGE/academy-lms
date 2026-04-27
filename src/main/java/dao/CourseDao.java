package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.CourseMapper;

import dto.Course;
import dto.user.User;

@Repository
public class CourseDao {
	@Autowired
  private SqlSessionTemplate template;
	private Class<CourseMapper> cls = CourseMapper.class;
	public List<Course> list() {
		return template.getMapper(cls).list();
	}
	public int insertCourse(Course course) {
		return template.getMapper(cls).insertCourse(course);
	}
	public List<Course> getBlockedCourses(String room, String semester) {
		return template.getMapper(cls).getBlokcedCourse(room,semester);
	}
	public Course selectCourse(Integer no) {
    	Course param = new Course();
    	param.setCourse_no(no);
    	return template.getMapper(cls).getCourse(param);
    }

    public String selectProfessorName(int course_no) {
        return template.getMapper(cls).getProfessorName(course_no);
    }
    
    public List<Course> selectAllCourses() {
    	return template.getMapper(cls).getAllCourses();
    }
    
    public List<Integer> getFavoriteCourseNos(int user_no) {
        return template.getMapper(cls).getFavoriteCourseNos(user_no);
    }

    public void addFavorite(int user_no, int course_no) {
        template.getMapper(cls).addFavorite(user_no, course_no);
    }

    public void removeFavorite(int user_no, int course_no) {
        template.getMapper(cls).removeFavorite(user_no, course_no);
    }
	public List<Map<String, Object>> getlist(String semester, String type, String credits, String keyword, String status, int offset, int size) {
		return template.getMapper(cls).getlist(semester, type, credits, keyword, status, offset,size);
  }


	public List<Map<String, Object>> getStudentMyCourseMap(int userNo, String semester) {
		return template.getMapper(cls).getStudentMyCourseMap(userNo,semester);
	}

	public List<Course> getMyCourse(int userNo, String semester) {
		return template.getMapper(cls).getMyCourse(userNo,semester);
	}
	public List<Map<String, Object>> getEnrollment(int userNo, String semester) {
		return template.getMapper(cls).getEnrollment(userNo,semester);
	}
	public Course findByCourseNo(Integer courseNo) {
		return template.getMapper(cls).find(courseNo);
	}

  public List<Map<String, Object>> getProfessorMyCourseMap(int userNo, String semester) {
		return template.getMapper(cls).getProfessorMyCourseMap(userNo, semester);
  }

   public List<Map<String, Object>> getListWithProfessorName(String semester) {
		return template.getMapper(cls).getListWithProfessorName(semester);
  }
	public void addCounts(Integer courseNo) {
		template.getMapper(cls).addCounts(courseNo);
		
	}
	public void minusCounts(Integer courseNo) {
		template.getMapper(cls).minusCounts(courseNo);
		
	}
	public int getCount(String semester, String type, String credits, String keyword, String status) {
		return template.getMapper(cls).getCount(semester, type,credits, keyword, status);
	}
	public List<User> getStudentList(int userNo) {
		return template.getMapper(cls).getStudentList(userNo);
	}
	public int getselectEnrollmentNo(int user_no, int course_no) {
		return template.getMapper(cls).getselectEnrollmentNo(user_no,course_no);
	}
	public void insertMidterm(int enrollment_no, int midterm, String alphabet) {
		template.getMapper(cls).insertMidterm(enrollment_no, midterm, alphabet);
	}
	public void insertFinal(int enrollment_no, int final_score, String alphabet) {
		template.getMapper(cls).insertFinal(enrollment_no, final_score, alphabet);
	}
	public void insertAttendance(int enrollment_no, int attendance, String alphabet) {
		template.getMapper(cls).insertAttendance(enrollment_no, attendance, alphabet);
	}
	
	public void updateStatus(List<Integer> courseNos, String status) {
		template.getMapper(cls).updateStatus(courseNos, status);
	}
	public void deleteCourses(List<Integer> courseNos) {
		template.getMapper(cls).deleteCourses(courseNos);
		
	}

	public Course getBoardCourse(Integer courseNo) {
		return template.getMapper(cls).getBoardCourse(courseNo);
	}
}
