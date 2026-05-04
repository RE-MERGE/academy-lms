package dao;

import dto.EnrollmentPending;
import dto.user.grade.AdminAllStudentGrade;
import dto.user.grade.MyGrade;
import dto.user.grade.MyProfessorGrade;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.EnrollmentMapper;
import dto.Enrollment;

import java.util.List;
import java.util.Map;

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

    public List<MyGrade> getStudentMyGradeList(int userNo) {
		return template.getMapper(cls).getStudentMyGradeList(userNo);
    }

    public List<MyProfessorGrade> getProfessorMyGradeList(int userNo, String semester) {
        return template.getMapper(cls).getProfessorMyGradeList(userNo, semester);
    }

    public List<AdminAllStudentGrade> getAllStudentGrades() {
		 return template.getMapper(cls).getAllStudentGrades();

    }
    public int getTotalCredits(int userNo, String semester) {
		return template.getMapper(cls).getTotalCredits(userNo, semester);
	}
	// 수강신천 확인 로직
	public boolean isEnrolled(int studentNo, int courseNo) {
		return template.getMapper(cls).isEnrolled(studentNo, courseNo);
	}

	public List<EnrollmentPending> getPendingEnrollmentList() {
		return template.getMapper(cls).getPendingEnrollmentList();
	}

    public int deleteEnrollment(int studentNo, int courseNo) {
		 return template.getMapper(cls).deleteEnrollment(studentNo, courseNo);
    }
}
