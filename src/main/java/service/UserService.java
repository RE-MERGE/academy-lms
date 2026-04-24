package service;

import dao.CourseDao;
import dao.EnrollmentDao;
import dao.UserDao;
import dto.user.SessionUser;
import dto.user.User;
import dto.user.UserRole;
import dto.user.UserStatus;
import dto.user.mypage.MyPageData;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserDao dao;
    private final CourseDao courseDao;
    private final EnrollmentDao enrollmentDao;


    public void join(User user) {
        dao.join(user);
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

}
