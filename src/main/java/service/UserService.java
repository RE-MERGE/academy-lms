package service;

import dao.CourseDao;
import dao.EnrollmentDao;
import dao.UserDao;
import dto.user.*;
import dto.user.mypage.MyPageData;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserDao dao;
    private final CourseDao courseDao;
    private final EnrollmentDao enrollmentDao;

    public void join(User user) {
        dao.join(user);
    }

    public User selectUser(String userId) {
        return dao.selectUser(userId);
    }

    public boolean withdraw(String userId, String password) {

        User dbUser = dao.selectUser(userId);

        if (dbUser != null && password.equals(dbUser.getPassword())) {
            dao.updateStatus(userId, UserStatus.DELETE);
            return true;
        }

        return false;
    }

    public MyPageData getMyPageData(SessionUser sessionUser, String semester) {
        int userNo = sessionUser.getUserNo();
        UserRole role = sessionUser.getRole();

        return switch (role) {
            case STUDENT -> buildStudentData(userNo, semester);
            case PROFESSOR -> buildProfessorData(userNo, semester);
            case ADMIN -> buildAdminData(semester);
        };
    }

    private MyPageData buildStudentData(int userNo, String semester) {
        return MyPageData.builder()
                .courseList(courseDao.getStudentMyCourseMap(userNo, semester))
                .gradeList(enrollmentDao.getStudentMyGradeList(userNo))
                .build();
    }

    private MyPageData buildProfessorData(int userNo, String semester) {
        return MyPageData.builder()
                .courseList(courseDao.getProfessorMyCourseMap(userNo, semester))
                .gradeList(enrollmentDao.getProfessorMyGradeList(userNo, semester))
                .build();    }

    private MyPageData buildAdminData(String semester) {
        return MyPageData.builder()
                .courseList(courseDao.getListWithProfessorName(semester))
                .gradeList(enrollmentDao.getAllStudentGrades())
                .build();
    }

    public void updateStatus(String userId, UserStatus userStatus) {
        dao.updateStatus(userId,userStatus);
    }

    public void resetLockCount(String userId) {
        dao.resetLockCount(userId);

    }

    public void updateLockCount(String userId, int newLockCount) {
        dao.updateLockCount(userId, newLockCount);
    }

    public String selectUserIdByEmail(String email) {
        return dao.selectUserIdByEmail(email);
    }

    public String selectUserPassword(String userId, String email,  String phone) {
        return dao.selectUserPassword(userId, email, phone);
    }

    public void updatePassword(String userId, String tempPassword) {
        dao.updatePassword(userId, tempPassword);
    }

    public void updateProfileImg(String userId, String currentProfileImg) {
        dao.updateProfileImg(userId, currentProfileImg);
    }

    public void updateInfo(UserEditForm userEditForm) {
        dao.updateInfo(userEditForm);
    }

    public Integer getLastUserCode() {
        return dao.getLastUserCode();
    }

	public int getProfNo(int code) {
		return dao.getProfNo(code);
	}
}
