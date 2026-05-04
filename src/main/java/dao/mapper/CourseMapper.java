package dao.mapper;

import java.util.List;
import java.util.Map;

import dto.user.grade.MyGrade;
import dto.CourseListInDashboard;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import dto.Attendance;
import dto.Course;
import dto.user.User;

public interface CourseMapper {
    @Select("SELECT * FROM COURSE " +
            "ORDER BY FIELD(course_type, 'MAJOR_REQUIRED', 'MAJOR_ELECTIVE', 'GENERAL_REQUIRED', 'GENERAL_ELECTIVE', 'FREE_ELECTIVE')")
    List<Course> list();

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
            "AND c.course_no IN (SELECT course_no FROM ENROLLMENT WHERE student_no = #{userNo}) " +
            "ORDER BY FIELD(c.course_type, 'MAJOR_REQUIRED', 'MAJOR_ELECTIVE', 'GENERAL_REQUIRED', 'GENERAL_ELECTIVE', 'FREE_ELECTIVE')")
    List<Course> getStudentCourseList(@Param("userNo") int userNo, @Param("semester") String semester);

    @Select("SELECT " +
            "    c.*, " +
            "    u.name AS professor_name " +
            "FROM COURSE c " +
            "JOIN USERS u ON c.professor_no = u.user_no " +
            "WHERE c.semester = #{semester} " +
            "AND c.professor_no = #{userNo} " +
            "ORDER BY FIELD(c.course_type, 'MAJOR_REQUIRED', 'MAJOR_ELECTIVE', 'GENERAL_REQUIRED', 'GENERAL_ELECTIVE', 'FREE_ELECTIVE')")

    List<Course> getMyCourse(@Param("userNo") int userNo, @Param("semester") String semester);

    @Select("SELECT * FROM COURSE WHERE course_no IN (SELECT course_no FROM ENROLLMENT WHERE student_no = #{userNo}) AND semester = #{semester}")
    List<Course> getMyEnrollment(@Param("userNo") int userNo, @Param("semester") String semester);

    @Select("""
    SELECT 
        c.course_no,
        c.course_name,
        c.course_type,
        c.room_info,
        c.day_of_week,
        c.start_time,
        c.end_time,
        u.name AS professor_name
    FROM COURSE c
    JOIN USERS u ON c.professor_no = u.user_no
    WHERE c.professor_no = #{userNo}
      AND c.semester = #{semester}
    ORDER BY c.start_time ASC
""")
    List<Course> getProfessorMyCourseMap(@Param("userNo") int userNo, @Param("semester") String semester);

    @Select("""
    SELECT 
        c.*, 
        u.name AS professor_name 
    FROM COURSE c
    JOIN USERS u ON c.professor_no = u.user_no
    WHERE c.semester = #{semester}
    ORDER BY FIELD(c.course_type, 'MAJOR_REQUIRED', 'MAJOR_ELECTIVE', 'GENERAL_REQUIRED', 'GENERAL_ELECTIVE', 'FREE_ELECTIVE')
""")
    List<Map<String, Object>> getListWithProfessorName(String semester);

    @Select("SELECT c.*, u.name AS professor_name FROM COURSE c " +
            "JOIN USERS u ON u.user_no = c.professor_no " +
            "WHERE c.course_no IN (SELECT course_no FROM ENROLLMENT WHERE student_no = #{userNo}) " +
            "AND c.semester = #{semester}")
	List<Map<String, Object>> getEnrollment(@Param("userNo") int userNo, @Param("semester") String semester);

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

    @Select("SELECT * FROM COURSE "
    		+ "WHERE professor_no = #{professorNo} "
    		+ "  AND semester = #{semester}")
	List<Course> getProfessorBlockedCourses(@Param("professorNo") int professorNo, @Param("semester") String semester);

    @Update("UPDATE COURSE SET " +
            "course_name = #{course_name}, " +
            "course_type = #{course_type}, " +
            "room_info = #{room_info}, " +
            "day_of_week = #{day_of_week}, " +
            "start_time = #{start_time}, " +
            "end_time = #{end_time}, " +
            "max_students = #{max_students}, " +
            "semester = #{semester}, " +
            "credits = #{credits}, " +
            "curriculum_pdf = #{curriculum_pdf}, " +
            "professor_no = #{professor_no} " +  
            "WHERE course_no = #{course_no}")
    public int updateCourse(Course course);
    @Select("select g.type, g.score, g.alphabet from GRADE g join ENROLLMENT e on g.enrollment_no = e.enrollment_no"
    		+ " where e.course_no = #{courseNo} and e.student_no = #{userNo}")
    List<Map<String,Object>> getGrade(@Param("courseNo") Integer courseNo, @Param("userNo") Integer userNo);

    @Select("SELECT a.status, a.week FROM ATTENDANCE a " +
            "JOIN ENROLLMENT e ON a.enrollment_no = e.enrollment_no " +
            "WHERE e.student_no = #{userNo} AND e.course_no = #{courseNo} " +
            "ORDER BY a.week ASC")
    List<Attendance> getAttendance(@Param("userNo") int userNo, @Param("courseNo") int courseNo);

    @Insert("INSERT INTO ATTENDANCE (enrollment_no, attendance_date, status, week) " +
            "VALUES (#{enrollment_no}, #{attendance_date}, #{status}, #{week}) " +
            "ON DUPLICATE KEY UPDATE status = #{status}")
    void insertAttendanceRecord(@Param("enrollment_no") int enrollment_no,
                                 @Param("attendance_date") String attendance_date,
                                 @Param("status") String status,
                                 @Param("week") int week);

    @Select("SELECT * FROM COURSE WHERE course_no=#{value}")
    Course getBoardCourse(Integer courseNo);

    // ↓ 홈 화면용 추가 (학기 구분 없이 전체 조회)
    @Select("SELECT * FROM COURSE WHERE professor_no = #{userNo}")
    List<Course> selectCoursesByProfessor(@Param("userNo") int userNo);

    @Select("SELECT * FROM COURSE WHERE course_no IN (SELECT course_no FROM ENROLLMENT WHERE student_no = #{userNo})")
    List<Course> selectCoursesByStudent(@Param("userNo") int userNo);

    @Select("SELECT * FROM COURSE WHERE course_no IN " +
            "(SELECT course_no FROM ENROLLMENT WHERE student_no = #{userNo} AND status = #{status})")
    List<Course> selectCoursesByStatus(@Param("userNo") int userNo, @Param("status") String status);

    @Select("SELECT c.* " +
            "FROM COURSE c " +
            "JOIN FAVORITE f ON c.course_no = f.course_no " +
            "WHERE f.user_no = #{userNo}")
    List<Course> getFavoriteCourse(int userNo);

    @Select("SELECT COUNT(*) FROM COURSE " +
            "WHERE room_info = #{room_info} " +
            "AND semester = #{semester} " +
            "AND FIND_IN_SET(#{day_of_week}, day_of_week) > 0 " +
            "AND start_time < #{end_time} AND end_time > #{start_time}")
    int hasRoomConflict(Course course);
    
    @Select("SELECT COUNT(*) FROM COURSE " +
            "WHERE professor_no = #{professor_no} " +
            "AND semester = #{semester} " +
            "AND FIND_IN_SET(#{day_of_week}, day_of_week) > 0 " +
            "AND start_time < #{end_time} AND end_time > #{start_time}")
    int hasProfessorConflict(Course course);

    @Select("SELECT COUNT(*) FROM COURSE " +
            "WHERE room_info = #{room_info} " +
            "AND semester = #{semester} " +
            "AND course_no != #{course_no} " +
            "AND FIND_IN_SET(#{day_of_week}, day_of_week) > 0 " +
            "AND start_time < #{end_time} AND end_time > #{start_time}")
    int hasRoomConflictExcludeSelf(Course course);

    @Select("SELECT COUNT(*) FROM COURSE " +
            "WHERE professor_no = #{professor_no} " +
            "AND semester = #{semester} " +
            "AND course_no != #{course_no} " +
            "AND FIND_IN_SET(#{day_of_week}, day_of_week) > 0 " +
            "AND start_time < #{end_time} AND end_time > #{start_time}")
    int hasProfessorConflictExcludeSelf(Course course);

    @Select("select * from COURSE where professor_no = #{userNo}")
	List<Course> getCourseByProfessor(Integer userNo);

    @Select("SELECT c.* FROM COURSE c " +
            "JOIN ENROLLMENT e ON c.course_no = e.course_no " +
            "WHERE e.student_no = #{userNo}")
	List<Course> getCourseByStudent(Integer userNo);

    @Select("SELECT professor_no " +
            "FROM COURSE " +
            "WHERE course_no = #{courseNo}")
    Integer selectProfessorNoByCourseNo(int courseNo);

    @Insert("INSERT INTO GRADE (\n" +
            "        enrollment_no, \n" +
            "        score, \n" +
            "        type, \n" +
            "        alphabet\n" +
            "    ) VALUES (\n" +
            "        #{enrollmentNo}, \n" +
            "        #{score}, \n" +
            "        #{type}, \n" +
            "        #{alphabet}\n" +
            "    )\n" +
            "    ON DUPLICATE KEY UPDATE\n" +
            "        score = #{score},\n" +
            "        alphabet = #{alphabet}")
    void upsertGrade(@Param("enrollmentNo") int enrollmentNo,
                     @Param("score") int score,
                     @Param("type") String type,
                     @Param("alphabet") String alphabet);

    @Select("SELECT " +
            "    e.course_no AS courseNo, " +        // DB 컬럼명 -> DTO 필드명 매핑
            "    u.user_no AS userNo, " +          // DB 컬럼명 -> DTO 필드명 매핑
            "    u.name, " +
            "    u.user_code AS userCode, " +
            "    u.email, " +
            "    e.enrollment_no AS enrollmentNo, " +
            "    MAX(CASE WHEN g.type = 'MIDTERM' THEN g.score END) AS midterm, " +
            "    MAX(CASE WHEN g.type = 'FINAL' THEN g.score END) AS finalScore, " +
            "    MAX(CASE WHEN g.type = 'ATTENDANCE' THEN g.score END) AS attendance, " +
            "    MIN(g.alphabet) AS alphabet " +
            "FROM USERS u " +
            "JOIN ENROLLMENT e ON u.user_no = e.student_no " +
            "LEFT JOIN GRADE g ON e.enrollment_no = g.enrollment_no " +
            "WHERE e.course_no = #{courseNo} " +
            "AND e.status = 'APPROVED' " +
            "GROUP BY e.course_no, u.user_no, e.enrollment_no")
    List<MyGrade> selectStudentList(Integer courseNo);

    @Select("SELECT c.*, u.name AS professor_name " +
            "FROM COURSE c " +
            "JOIN USERS u ON c.professor_no = u.user_no " +
            "WHERE c.course_no = #{courseNo}")
    Course selectCourse(Integer courseNo);


    @Select("SELECT " +
            "    c.course_no, " +
            "    c.course_name, " +
            "    c.start_time, " +
            "    c.end_time, " +
            "    u.name AS professor_name, " +
            "    c.day_of_week, " +
            "    e.status AS status " +
            "FROM ENROLLMENT e " +
            "JOIN COURSE c ON e.course_no = c.course_no " +
            "JOIN USERS u ON c.professor_no = u.user_no " +
            "WHERE e.student_no = #{userNo} " +
            "AND e.status IN ('APPROVED', 'PENDING') " +
            "ORDER BY CASE WHEN e.status = 'APPROVED' THEN 1 ELSE 2 END ASC, e.enrolled_at DESC")
    List<CourseListInDashboard> getMyCourseInDashboard(int userNo);


    @Select("SELECT \n" +
            "    course_no, \n" +
            "    professor_no, \n" +
            "    course_name, \n" +
            "    course_type, \n" +
            "    room_info, \n" +
            "    day_of_week, \n" +
            "    start_time, \n" +
            "    end_time, \n" +
            "    max_students, \n" +
            "    status, \n" +
            "    semester, \n" +
            "    credits,\n" +
            "    created_at\n" +
            "FROM COURSE\n" +
            "WHERE professor_no = #{userNo}  " +
            "ORDER BY created_at DESC " +
            "LIMIT 3 ")
    List<Course> getCourseListWithProfessorInDashboard(int userNo);

    // 전체 강의실 목록 (중복 제거)
    @Select("SELECT DISTINCT room_info FROM COURSE WHERE semester = #{semester} AND room_info IS NOT NULL ORDER BY room_info")
    List<String> getRoomList(@Param("semester") String semester);

    // 전체 강의 (강의실 시간표용)
    @Select("SELECT course_no, course_name, room_info, day_of_week, start_time, end_time FROM COURSE WHERE semester = #{semester} AND status != 'REJECTED'")
    List<Course> getAllCoursesForTimetable(@Param("semester") String semester);
}
