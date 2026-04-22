package dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import dto.Course;

public interface CourseMapper {
	@Select("select * from COURSE")
	public List<Course> list();

	@Select("select * from COURSE where course_no = #{course_no}")
    Course getCourse(Course course);

    @Select("SELECT USERS.name FROM USERS JOIN COURSE ON USERS.user_no = COURSE.professor_no WHERE COURSE.course_no = #{course_no}")
    String getProfessorName(@Param("course_no") int course_no);
    
    @Select("select * from COURSE")
    List<Course> getAllCourses();
    
    @Select("SELECT course_no FROM FAVORITE WHERE user_no = #{user_no}")
    List<Integer> getFavoriteCourseNos(int user_no);

    @Insert("INSERT INTO FAVORITE (user_no, course_no) VALUES (#{user_no}, #{course_no})")
    void addFavorite(@Param("user_no") int user_no, @Param("course_no") int course_no);

    @Delete("DELETE FROM FAVORITE WHERE user_no = #{user_no} AND course_no = #{course_no}")
    void removeFavorite(@Param("user_no") int user_no, @Param("course_no") int course_no);
}
