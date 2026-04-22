package dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.CourseMapper;

import dto.Course;

@Repository
public class CourseDao {
	@Autowired
    private SqlSessionTemplate template;
	private Class<CourseMapper> cls = CourseMapper.class;
	public List<Course> list() {
		return template.getMapper(cls).list();
	}
	public Course selectCourse(int no) {
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
}
