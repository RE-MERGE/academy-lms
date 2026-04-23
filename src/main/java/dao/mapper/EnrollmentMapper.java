package dao.mapper;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import dto.Enrollment;


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

}
