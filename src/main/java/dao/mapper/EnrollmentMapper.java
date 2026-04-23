package dao.mapper;

import dto.user.grade.AdminAllStudentGrade;
import dto.user.grade.MyGrade;
import dto.user.grade.MyProfessorGrade;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import dto.Enrollment;

import java.util.List;
import java.util.Map;


public interface EnrollmentMapper {

	@Select("SELECT COUNT(*) FROM ENROLLMENT WHERE student_no = #{userNo} AND course_no = #{courseNo}")
	int existsByStudentAndCourse(@Param("userNo") int userNo, @Param("courseNo") Integer courseNo);

	@Select("SELECT COUNT(*) FROM ENROLLMENT WHERE course_no = #{value}")
	int count(Integer courseNo);

	@Select("SELECT COUNT(*) FROM ENROLLMENT e JOIN COURSE nc ON nc.course_no = #{courseNo} JOIN COURSE ec "
			+ "ON ec.course_no = e.course_no WHERE e.student_no = #{userNo} AND ec.semester = nc.semester "
			+ "AND EXISTS (SELECT 1 FROM (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) n "
			+ "WHERE n.n <= 1 + LENGTH(nc.day_of_week) - LENGTH(REPLACE(nc.day_of_week, ',', '')) AND "
			+ "FIND_IN_SET(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(nc.day_of_week, ',', n.n), ',', -1)), ec.day_of_week) > 0) "
			+ "AND nc.start_time < ec.end_time AND nc.end_time > ec.start_time")
	int hasTimeConflict(@Param("userNo") int userNo, @Param("courseNo") Integer courseNo);

	@Insert("INSERT INTO ENROLLMENT (course_no,student_no, status, enrolled_at) "
			+"VALUES (#{course_no}, #{student_no}, #{status}, NOW())")
	void insert(Enrollment enrollment);

	@Delete("DELETE FROM ENROLLMENT WHERE student_no = #{userNo} AND course_no = #{courseNo}")
	void cancel(@Param("userNo") int userNo, @Param("courseNo") Integer courseNo);


    @Select("SELECT " +
            "    c.course_name AS courseName, " +
            "    c.course_type AS courseType," +
            "    g.score AS score," +
            "    g.type AS examType " +
            "FROM ENROLLMENT e " +
            "JOIN COURSE c ON e.course_no = c.course_no " +
            "JOIN GRADE g ON e.enrollment_no = g.enrollment_no " +
            "WHERE e.student_no = #{userNo}")
    List<MyGrade> getStudentMyGradeList(int userNo);


	@Select("SELECT " +
			"    c.course_no, " +
			"    c.course_name AS courseName, " +
			"    c.course_type, " +
			"    COUNT(DISTINCT e.student_no) AS total_students, " +
			"    IFNULL(ROUND(AVG(g.score), 1), 0) AS avg_score, " +
			"    IFNULL(MAX(g.score), 0) AS max_score, " +
			"    IFNULL(MIN(g.score), 0) AS min_score " +
			"FROM COURSE c " +
			"LEFT JOIN ENROLLMENT e ON c.course_no = e.course_no " +
			"LEFT JOIN GRADE g ON e.enrollment_no = g.enrollment_no " + // GRADE 테이블 조인 추가
			"WHERE c.professor_no = #{userNo} " +
			"  AND c.semester = #{semester} " +
			"GROUP BY c.course_no, c.course_name, c.course_type " +
			"ORDER BY avg_score DESC")
	List<MyProfessorGrade> getProfessorMyGradeList(@Param("userNo") int userNo, @Param("semester") String semester);

	@Select("""
    SELECT 
        c.course_name AS courseName,
        COUNT(DISTINCT e.enrollment_no) AS total_students,
        ROUND(AVG(g.score), 1) AS avg_score,
        MAX(g.score) AS max_score,
        MIN(g.score) AS min_score
    FROM COURSE c
    LEFT JOIN ENROLLMENT e ON c.course_no = e.course_no
    LEFT JOIN GRADE g ON e.enrollment_no = g.enrollment_no  -- 성적 테이블 조인
    GROUP BY c.course_no, c.course_name
    ORDER BY c.course_name ASC
""")
	List<AdminAllStudentGrade> getAllStudentGrades();


}
