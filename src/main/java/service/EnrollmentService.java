package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.CourseDao;
import dao.EnrollmentDao;
import dto.Course;
import dto.Enrollment;

@Service
public class EnrollmentService {
	@Autowired
	private EnrollmentDao enrollmentDao;
	@Autowired
	private CourseDao courseDao;

	public void apply(int userNo, Integer courseNo) {
		if (enrollmentDao.existsByStudentAndCourse(userNo, courseNo) > 0)
	        throw new IllegalStateException("이미 신청한 강의입니다.");

	    Course course = courseDao.findByCourseNo(courseNo);
	    if (course == null)
	        throw new IllegalStateException("존재하지 않는 강의입니다.");
	    if (course.getCounts() >= course.getMax_students())
	        throw new IllegalStateException("정원이 초과된 강의입니다.");

	    if (enrollmentDao.hasTimeConflict(userNo, courseNo) > 0)
	        throw new IllegalStateException("시간표가 겹치는 강의가 있습니다.");

	    Enrollment enrollment = new Enrollment();
	    enrollment.setCourse_no(courseNo);
	    enrollment.setStudent_no(userNo);
	    enrollment.setStatus("APPLIED");
	    enrollmentDao.insert(enrollment); 
	    courseDao.addCounts(courseNo);
	}

	public void cancel(int userNo, Integer courseNo) {
		enrollmentDao.cancel(userNo,courseNo);
		courseDao.minusCounts(courseNo);
		
	}
}
