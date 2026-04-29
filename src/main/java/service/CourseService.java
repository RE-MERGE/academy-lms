package service;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import dto.user.grade.GradeForm;
import dto.user.grade.GradeRow;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.CourseDao;
import dao.mapper.CourseMapper;
import dto.Attendance;
import dto.Course;
import dto.user.User;

@Service
public class CourseService {
	@Autowired
	private CourseDao coursedao;
	CourseMapper courseMapper;

	public List<Course> list() {
		return coursedao.list();
	}
	
	public Course selectCourse(Integer no) {
    	return coursedao.selectCourse(no);
	}

	public Map<String,Object> insertCourse (Course course) {
		Map<String, Object> result = new HashMap<String, Object>();
		if (coursedao.hasRoomConflict(course) > 0) {
			result.put("success", false);
			result.put("message", "해당 강의실에 시간이 겹치는 강의가 있습니다");
			return result;
		}
		if (coursedao.hasProfessorConflict(course) > 0) {
			result.put("success", false);
			result.put("message", "교수님의 다른 강의와 시간이 겹칩니다.");
			return result;
		}
		 if(coursedao.insertCourse(course)>0) {
			 result.put("success", true);
			 result.put("message", "강의 개설에 성공했습니다");
			 
		 }else {
			 result.put("success", false);
			 result.put("message", "강의 개설에 실패했습니다.");
		 }
		 return result;
	}

	public List<Course> getBlockedCourses(String room, String semester) {
    return coursedao.getBlockedCourses(room, semester);
  }
	public String selectProfessorName(int course_no) {
	    return coursedao.selectProfessorName(course_no);
	}

	public List<Course> selectAllCourses() {
		return coursedao.selectAllCourses();
	}
	
	 public List<Integer> getFavoriteCourseNos(int user_no) {
	        return coursedao.getFavoriteCourseNos(user_no);
	    }

	    public void addFavorite(int user_no, int course_no) {
	        coursedao.addFavorite(user_no, course_no);
	    }

	    public void removeFavorite(int user_no, int course_no) {
	        coursedao.removeFavorite(user_no, course_no);
	    }

		public List<Map<String, Object>> getlist(String semester, String type, String credits, String keyword, String status, int offset, int size) {
			return coursedao.getlist(semester, type, credits, keyword, status, offset, size);
		}

		public List<Course> getMyCourses(int userNo, String semester) {
			return coursedao.getMyCourse(userNo,semester);
		}

		public List<Map<String, Object>> getEnrollments(int userNo, String semester) {
			return coursedao.getEnrollment(userNo,semester);
		}

		public int getCount(String semester, String type, String credits, String keyword, String status) {
			
			return coursedao.getCount(semester,type, credits, keyword,status);
		}

		public List<User> selectStudentList(int userNo) {
			return coursedao.getStudentList(userNo);
		}

		public void saveGrades(List<Map<String, String>> gradeList) {
		    for (Map<String, String> grade : gradeList) {
		    	
		        int user_no = Integer.parseInt(grade.get("user_no"));
		        int course_no = Integer.parseInt(grade.get("course_no"));
		        int enrollment_no = coursedao.getselectEnrollmentNo(user_no, course_no);
		        System.out.println("user_no:유저넘버 " + user_no);
		        System.out.println("course_no: " + course_no);
		        System.out.println("enrollment_no: " + enrollment_no);
		        String alphabet = grade.get("alphabet");
		        
		        String midtermStr = grade.get("midterm");
		        String finalStr = grade.get("final_score");
		        String attendanceStr = grade.get("attendance");

		        // null 또는 빈값이면 저장 건너뜀
		        if (midtermStr == null || midtermStr.isEmpty() ||
		            finalStr == null || finalStr.isEmpty() ||
		            attendanceStr == null || attendanceStr.isEmpty()) {
		            continue;
		        }

		        coursedao.insertMidterm(enrollment_no, Integer.parseInt(grade.get("midterm")), alphabet);
		        coursedao.insertFinal(enrollment_no, Integer.parseInt(grade.get("final_score")), alphabet);
		        coursedao.insertAttendance(enrollment_no, Integer.parseInt(grade.get("attendance")), alphabet);
		    }
		}
		public void updateStatus(List<Integer> courseNos, String status) {
			coursedao.updateStatus(courseNos, status);
			
		}

		public void deleteCourses(List<Integer> courseNos) {
		    coursedao.deleteCourses(courseNos);
		}

		public List<Course> getProfessorBlockedCourses(int professorNo, String semester) {
			return coursedao.getProfessorBlockedCourses(professorNo,semester);
		}

		public Course findByCourseNo(int courseNo) {
			return coursedao.findByCourseNo(courseNo);
		}

		public Map<String, Object> updateCourse(Course course) {
			Map<String, Object> result = new HashMap<String, Object>();
			if (coursedao.hasRoomConflictExcludeSelf(course) > 0) {
				result.put("success", false);
				result.put("message", "해당 강의실에 시간이 겹치는 강의가 있습니다");
				return result;
			}
			if (coursedao.hasProfessorConflictExcludeSelf(course) > 0) {
				result.put("success", false);
				result.put("message", "교수님의 다른 강의와 시간이 겹칩니다.");
				return result;
			}
			 if(coursedao.updateCourse(course)>0) {
				 result.put("success", true);
				 result.put("message", "강의 수정에 성공했습니다");
				 
			 }else {
				 result.put("success", false);
				 result.put("message", "강의 수정에 실패했습니다.");
			 }
			 return result;
		}
		
		public Map<String, Object> selectGradeMap(Integer courseNo, Integer userNo) {
		    List<Map<String, Object>> gradeList = coursedao.getGrade(courseNo, userNo); // coursedao로 통일
		    Map<String, Object> gradeMap = new HashMap<>();
		    for (Map<String, Object> g : gradeList) {
		        gradeMap.put((String) g.get("type"), g);
		    }
		    return gradeMap;
		}

		public List<Attendance> selectAttendance(Integer userNo, Integer courseNo) {
			return coursedao.getAttendanceList(userNo, courseNo);
		}
		
		public void saveAttendance(List<Map<String, String>> attendanceList) {
		    for (Map<String, String> a : attendanceList) {
		    	System.out.println("전체 데이터: " + a);  // ← 추가
		        System.out.println("week 값: " + a.get("week"));  // ← 추가
		        int user_no = Integer.parseInt(a.get("user_no"));
		        int course_no = Integer.parseInt(a.get("course_no"));
		        int week = Integer.parseInt(a.get("week"));           // ← 추가
		        String status = a.get("status");
		        String attendance_date = a.get("attendance_date");
		        int enrollment_no = coursedao.getselectEnrollmentNo(user_no, course_no);
		        coursedao.insertAttendanceRecord(enrollment_no, attendance_date, status, week); // ← week 추가
		    }
		}
	// BoardController 에서 사용!
	public Course getBoardCourse(Integer courseNo) {
		return coursedao.getBoardCourse(courseNo);
	}
	public List<Course> selectCoursesByProfessor(int userNo) {
	    return coursedao.selectCoursesByProfessor(userNo);
	}

	public List<Course> selectCoursesByStudent(int userNo) {
	    return coursedao.selectCoursesByStudent(userNo);
	}

	public Set<Integer> selectFavoriteSet(int userNo) {
	    return new HashSet<>(coursedao.getFavoriteCourseNos(userNo));
	}


	public List<Course> getFavoriteCourses(int userNo) {
		return coursedao.getFavoriteCourse(userNo);
	}

	public List<Course> selectCourseByProfessor(Integer userNo) {
		return coursedao.getCourseByProfessor(userNo);
	}

	public List<Course> selectCourseByStudent(Integer userNo) {
		return coursedao.getCourseByStudent(userNo);
	}

	public boolean isCourseOwner(int userNo, int courseNo) {
		// 1. DB에서 해당 강의의 담당 교수 번호를 조회
		Integer professorNo = coursedao.selectProfessorNoByCourseNo(courseNo);

		// 2. 강의가 존재하고, 담당 교수 번호가 로그인한 유저 번호와 같은지 확인
		return professorNo != null && professorNo == userNo;
	}

	public void saveGradesList(GradeForm form) {
		for (GradeRow row : form.getGradeList()) {
			// 중간고사
			coursedao.upsertGrade(row.getEnrollment_no(), row.getMidterm(), "MIDTERM", row.getAlphabet());
			// 기말고사
			coursedao.upsertGrade(row.getEnrollment_no(), row.getFinal_score(), "FINAL", row.getAlphabet());
			// 출석
			coursedao.upsertGrade(row.getEnrollment_no(), row.getAttendance(), "ATTENDANCE", row.getAlphabet());
		}
	}
}
