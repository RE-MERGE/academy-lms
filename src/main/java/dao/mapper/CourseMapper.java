package dao.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

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
    
    @Select("SELECT course_no FROM FAVORITE WHERE user_no = #{user_no}")
    List<Integer> getFavoriteCourseNos(int user_no);

    @Insert("INSERT INTO FAVORITE (user_no, course_no) VALUES (#{user_no}, #{course_no})")
    void addFavorite(@Param("user_no") int user_no, @Param("course_no") int course_no);

    @Delete("DELETE FROM FAVORITE WHERE user_no = #{user_no} AND course_no = #{course_no}")
    void removeFavorite(@Param("user_no") int user_no, @Param("course_no") int course_no);

    @Select("<script>" +
    	    "SELECT c.*, u.name AS professor_name FROM COURSE c " +
    	    "JOIN USERS u ON u.user_no = c.professor_no " +
    	    "WHERE c.semester = #{semester} " +
    	    "<if test='type != null and type != \"\"'> AND c.course_type = #{type}</if>" +
    	    "<if test='credits != null and credits != \"\"'> AND c.credits = #{credits}</if>" +
    	    "<if test='keyword != null and keyword != \"\"'> AND (c.course_name LIKE CONCAT('%', #{keyword}, '%') OR u.name LIKE CONCAT('%', #{keyword}, '%'))</if>" +
    	    "<if test='status != null and status != \"\"'> AND c.status = #{status}</if>" +
    	    " LIMIT #{size} OFFSET #{offset}"+
    	    "</script>")
	public List<Map<String, Object>> getlist(@Param("semester") String semester,
            @Param("type") String type,
            @Param("credits") String credits,
            @Param("keyword") String keyword,
            @Param("status") String status, @Param("offset") int offset, @Param("size") int size);

    @Select("SELECT * FROM COURSE WHERE professor_no=#{userNo} AND semester=#{semester}")
	public List<Course> getMyCourse(@Param("userNo") int userNo, @Param("semester") String semester);

    @Select("SELECT c.*, u.name AS professor_name FROM COURSE c " +
            "JOIN USERS u ON u.user_no = c.professor_no " +
            "WHERE c.course_no IN (SELECT course_no FROM ENROLLMENT WHERE student_no = #{userNo}) " +
            "AND c.semester = #{semester}")
	public List<Map<String, Object>> getMyEnrollment(@Param("userNo") int userNo,@Param("semester") String semester);

    @Select("SELECT * FROM COURSE WHERE course_no = #{value}")
	public Course find(Integer courseNo);

    @Update("UPDATE COURSE SET counts = counts+1 WHERE course_no = #{value}")
	public void addCounts(Integer courseNo);

    @Update("UPDATE COURSE SET counts = counts-1 where course_no = #{value}")
	public void minusCounts(Integer courseNo);

    @Select("<script>" +
    	    "SELECT COUNT(*) FROM COURSE c " +
    	    "JOIN USERS u ON u.user_no = c.professor_no " +
    	    "WHERE c.semester = #{semester} " +
    	    "<if test='type != null and type != \"\"'> AND c.course_type = #{type}</if>" +
    	    "<if test='credits != null and credits != \"\"'> AND c.credits = #{credits}</if>" +
    	    "<if test='keyword != null and keyword != \"\"'> AND (c.course_name LIKE CONCAT('%', #{keyword}, '%') OR u.name LIKE CONCAT('%', #{keyword}, '%'))</if>" +
    	    "<if test='status != null and status != \"\"'> AND c.status = #{status}</if>" +
    	    "</script>")
    	int getCount(@Param("semester") String semester, @Param("type") String type,
    	             @Param("credits") String credits, @Param("keyword") String keyword,
    	             @Param("status") String status);
}
