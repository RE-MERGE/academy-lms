package dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import dto.Course;

public interface CourseMapper {
	@Select("select * from COURSE")
	public List<Course> list();

	@Insert("INSERT INTO COURSE (professor_no, course_name, course_type, room_info, day_of_week, start_time, end_time, max_students, status, semester, credits, created_at) VALUES (#{professor_no}, #{course_name}, #{course_type}, #{room_info}, #{day_of_week}, #{start_time}, #{end_time}, #{max_students}, #{status}, #{semester}, #{credits}, NOW())")
	public int insertCourse(Course course);

	@Select("SELECT course_no, day_of_week, start_time, end_time FROM COURSE WHERE room_info = #{room} AND semester = #{semester} AND status != 'REJECTED'")
	public List<Course> getBlokcedCourse(@Param("room") String room, @Param("semester") String semester);

	@Select("select * from COURSE where course_no = #{course_no}")
    Course getCourse(Course course);

    @Select("SELECT USERS.name FROM USERS JOIN COURSE ON USERS.user_no = COURSE.professor_no WHERE COURSE.course_no = #{course_no}")
    String getProfessorName(@Param("course_no") int course_no);
    
    @Select("select * from COURSE")
    List<Course> getAllCourses();
}
