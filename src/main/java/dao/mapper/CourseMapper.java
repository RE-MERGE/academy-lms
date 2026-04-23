package dao.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
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

    @Select("SELECT course_no FROM FAVORITE WHERE user_no = #{user_no}")
    List<Integer> getFavoriteCourseNos(int user_no);

    @Insert("INSERT INTO FAVORITE (user_no, course_no) VALUES (#{user_no}, #{course_no})")
    void addFavorite(@Param("user_no") int user_no, @Param("course_no") int course_no);

    @Delete("DELETE FROM FAVORITE WHERE user_no = #{user_no} AND course_no = #{course_no}")
    void removeFavorite(@Param("user_no") int user_no, @Param("course_no") int course_no);

    @Select("SELECT * FROM COURSE WHERE semester = #{value}")
    public List<Course> getlist(String semester);

    @Select("SELECT " +
            "    c.*, " +
            "    u.name AS professor_name " +
            "FROM COURSE c " +
            "JOIN USERS u ON c.professor_no = u.user_no " +
            "WHERE c.semester = #{semester} " +
            "AND c.course_no IN (SELECT course_no FROM ENROLLMENT WHERE student_no = #{userNo})")
    List<Map<String, Object>> getStudentMyCourseMap(@Param("userNo") int userNo, @Param("semester") String semester);

    @Select("SELECT " +
            "    c.*, " +                  // 코스의 모든 정보
            "    u.name AS professor_name " + // 유저 테이블에서 이름을 가져와 별칭 지정
            "FROM COURSE c " +
            "JOIN USERS u ON c.professor_no = u.user_no " +
            "WHERE c.semester = #{semester} " +
            "AND c.course_no IN (SELECT course_no FROM ENROLLMENT WHERE user_no = #{userNo})")
    public List<Course> getMyCourse(@Param("userNo") int userNo, @Param("semester") String semester);

    @Select("SELECT* FROM COURSE WHERE course_no IN (SELECT course_no FROM ENROLLMENT WHERE student_no = #{userNo}) AND semester = #{semester}")
    public List<Course> getMyEnrollment(@Param("userNo") int userNo,@Param("semester") String semester);

    @Select("SELECT * FROM COURSE WHERE course_no = #{value}")
    public Course find(Integer courseNo);


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
}
