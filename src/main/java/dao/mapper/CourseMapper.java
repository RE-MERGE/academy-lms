package dao.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import dto.Course;
import dto.user.User;

public interface CourseMapper {
    @Select("select * from COURSE")
    List<Course> list();

 // curriculum_pdf 추가
    @Insert("INSERT INTO COURSE (professor_no, course_name, course_type, room_info, day_of_week, " +
            "start_time, end_time, max_students, status, semester, credits, curriculum_pdf, created_at) " +
            "VALUES (#{professor_no}, #{course_name}, #{course_type}, #{room_info}, #{day_of_week}, " +
            "#{start_time}, #{end_time}, #{max_students}, #{status}, #{semester}, #{credits}, #{curriculum_pdf}, NOW())")
    public int insertCourse(Course course);

    @Select("SELECT course_no, day_of_week, start_time, end_time FROM COURSE WHERE room_info = #{room} AND semester = #{semester} AND status != 'REJECTED'")
    List<Course> getBlokcedCourse(@Param("room") String room, @Param("semester") String semester);

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
	List<Map<String, Object>> getlist(@Param("semester") String semester,
            @Param("type") String type,
            @Param("credits") String credits,
            @Param("keyword") String keyword,
            @Param("status") String status, @Param("offset") int offset, @Param("size") int size);

    @Select("SELECT " +
            "    c.*, " +
            "    u.name AS professor_name " +
            "FROM COURSE c " +
            "JOIN USERS u ON c.professor_no = u.user_no " +
            "WHERE c.semester = #{semester} " +
            "AND c.course_no IN (SELECT course_no FROM ENROLLMENT WHERE student_no = #{userNo})")
    List<Map<String, Object>> getStudentMyCourseMap(@Param("userNo") int userNo, @Param("semester") String semester);

    @Select("SELECT " +
            "    c.*, " +
            "    u.name AS professor_name " +
            "FROM COURSE c " +
            "JOIN USERS u ON c.professor_no = u.user_no " +
            "WHERE c.semester = #{semester} " +
            "AND c.professor_no = #{userNo}")  // ← ENROLLMENT 서브쿼리 대신 professor_no로 직접 조회
    List<Course> getMyCourse(@Param("userNo") int userNo, @Param("semester") String semester);

    @Select("SELECT* FROM COURSE WHERE course_no IN (SELECT course_no FROM ENROLLMENT WHERE student_no = #{userNo}) AND semester = #{semester}")
    List<Course> getMyEnrollment(@Param("userNo") int userNo,@Param("semester") String semester);

    @Select("""
    SELECT 
        c.course_no,
        c.course_name,
        c.course_type,
        c.room_info,
        c.start_time,
        c.end_time,
        u.name AS professor_name
    FROM COURSE c
    JOIN USERS u ON c.professor_no = u.user_no
    WHERE c.professor_no = #{userNo}
      AND c.semester = #{semester}
    ORDER BY c.start_time ASC
""")
    List<Map<String, Object>> getProfessorMyCourseMap(@Param("userNo") int userNo, @Param("semester") String semester);


    @Select("""
    SELECT 
        c.*, 
        u.name AS professor_name 
    FROM COURSE c
    JOIN USERS u ON c.professor_no = u.user_no
    WHERE c.semester = #{semester}
""")
    List<Map<String, Object>> getListWithProfessorName(String semester);

    @Select("SELECT c.*, u.name AS professor_name FROM COURSE c " +
            "JOIN USERS u ON u.user_no = c.professor_no " +
            "WHERE c.course_no IN (SELECT course_no FROM ENROLLMENT WHERE student_no = #{userNo}) " +
            "AND c.semester = #{semester}")
	List<Map<String, Object>> getEnrollment(@Param("userNo") int userNo,@Param("semester") String semester);

    @Select("SELECT * FROM COURSE WHERE course_no = #{value}")
	Course find(Integer courseNo);

    @Update("UPDATE COURSE SET counts = counts+1 WHERE course_no = #{value}")
	void addCounts(Integer courseNo);

    @Update("UPDATE COURSE SET counts = counts-1 where course_no = #{value}")
	void minusCounts(Integer courseNo);

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

    @Select("SELECT u.user_no AS userNo, u.name, u.user_code AS userCode, u.email " +
            "FROM USERS u " +
            "JOIN ENROLLMENT e ON u.user_no = e.student_no " +
            "WHERE e.course_no = #{no}")
	public List<User> getStudentList(Integer userNo);
    
    @Insert("INSERT INTO GRADE (enrollment_no, score, type, alphabet) " +
            "VALUES (#{enrollment_no}, #{midterm}, 'MIDTERM', #{alphabet}) " +
            "ON DUPLICATE KEY UPDATE score = #{midterm}, alphabet = #{alphabet}")
    void insertMidterm(@Param("enrollment_no") int enrollment_no,
                       @Param("midterm") int midterm,
                       @Param("alphabet") String alphabet);

    @Insert("INSERT INTO GRADE (enrollment_no, score, type, alphabet) " +
            "VALUES (#{enrollment_no}, #{final_score}, 'FINAL', #{alphabet}) " +
            "ON DUPLICATE KEY UPDATE score = #{final_score}, alphabet = #{alphabet}")
    void insertFinal(@Param("enrollment_no") int enrollment_no,
                     @Param("final_score") int final_score,
                     @Param("alphabet") String alphabet);

    @Insert("INSERT INTO GRADE (enrollment_no, score, type, alphabet) " +
            "VALUES (#{enrollment_no}, #{attendance}, 'ATTENDANCE', #{alphabet}) " +
            "ON DUPLICATE KEY UPDATE score = #{attendance}, alphabet = #{alphabet}")
    void insertAttendance(@Param("enrollment_no") int enrollment_no,
                          @Param("attendance") int attendance,
                          @Param("alphabet") String alphabet);
    
    @Select("SELECT enrollment_no FROM ENROLLMENT WHERE student_no = #{user_no} AND course_no = #{course_no}")
	public int getselectEnrollmentNo(@Param("user_no") int user_no, @Param("course_no") int course_no);
    @Update("<script>" +
    	    "UPDATE COURSE SET status = #{status} " +
    	    "WHERE course_no IN " +
    	    "<foreach collection='courseNos' item='no' open='(' separator=',' close=')'>" +
    	    "#{no}" +
    	    "</foreach>" +
    	    "</script>")
    	void updateStatus(@Param("courseNos") List<Integer> courseNos, @Param("status") String status);

    @Delete("<script>DELETE FROM COURSE WHERE course_no IN " +
            "<foreach collection='list' item='no' open='(' separator=',' close=')'>#{no}</foreach>" +
            "</script>")
    void deleteCourses(List<Integer> courseNos);
}
