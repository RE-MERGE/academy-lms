package dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.EnrollmentMapper;
import dto.Enrollment;

@Repository
public class EnrollmentDao {
	@Autowired
	 private SqlSessionTemplate template;
	 private Class<EnrollmentMapper> cls = EnrollmentMapper.class;
	 public int existsByStudentAndCourse(int userNo, Integer courseNo) {
		return template.getMapper(cls).existsByStudentAndCourse(userNo, courseNo);
	 }
	 public int count(Integer courseNo) {
		return template.getMapper(cls).count(courseNo);
	 }
	 public int hasTimeConflict(int userNo, Integer courseNo) {
		return template.getMapper(cls).hasTimeConflict(userNo,courseNo);
	 }
	 public void insert(Enrollment enrollment) {
		template.getMapper(cls).insert(enrollment);
		
	 }
	 public void cancel(int userNo, Integer courseNo) {
		template.getMapper(cls).cancel(userNo, courseNo);
		
	 }
}
