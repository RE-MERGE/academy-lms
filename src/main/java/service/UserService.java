package service;

import dao.CourseDao;
import dao.EnrollmentDao;
import dao.UserDao;
import dto.user.*;
import dto.user.mypage.MyPageData;
import dto.user.mypage.UserDetailForAdmin;
import exception.LoginFailException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserDao dao;
    private final FileService fileService;
    private final CourseDao courseDao;
    private final EnrollmentDao enrollmentDao;
    private final BCryptPasswordEncoder passwordEncoder;

    public void join(User user) {

        dao.join(user);
    }

    public User selectUser(String userId) {
        return dao.selectUser(userId);
    }

    public boolean withdraw(String userId, String password) {

        User dbUser = dao.selectUser(userId);

        if (dbUser != null && passwordEncoder.matches(password, dbUser.getPassword())) {
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

    public MyPageData getMyPageData(UserDetailForAdmin userDetailForAdmin, String semester) {
        int userNo = userDetailForAdmin.getUserNo();
        UserRole role = userDetailForAdmin.getRole();

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

    public void updateStatus(String userId, UserStatus delete) {
        dao.updateStatus(userId, delete);
    }

    public SessionUser login(String userId, String password) {

        User dbUser = dao.selectUser(userId);

        if (dbUser == null) {
            throw new LoginFailException("error.loginFail");
        }

        if (dbUser.getStatus() == UserStatus.LOCKED) {
            throw new LoginFailException("error.status.locked");
        }

        if (!passwordEncoder.matches(password, dbUser.getPassword())) {
            int newCount = dbUser.getLock_count() + 1;

            if (newCount >= 5) {
                dao.updateStatus(userId, UserStatus.LOCKED);
                dao.resetLockCount(userId);
                throw new LoginFailException("error.status.locked");
            }
            dao.updateLockCount(userId, newCount);
            throw new LoginFailException("error.loginFail");
        }

        if (dbUser.getStatus() != UserStatus.ACTIVE) {
            throw new LoginFailException("error.status.notActive");
        }

        dao.resetLockCount(userId);
        return new SessionUser(dbUser);
    }


    private int getUserCode() {

        int currentYear = LocalDate.now().getYear();
        Integer lastUserCode = dao.getLastUserCode();

        if (lastUserCode == null) {
            return currentYear * 10000 + 1;
        }

        int lastYear = lastUserCode / 10000;

        if (currentYear > lastYear) {
            return currentYear * 10000 + 1;
        } else {
            return lastUserCode + 1;
        }

    }

    public User createUser(UserJoinForm userJoinForm) {
        String profileImage = "";

        if (userJoinForm.getProfileImg() != null && !userJoinForm.getProfileImg().isEmpty()) {
            profileImage = fileService.saveProfileImage(userJoinForm.getProfileImg());
        }

        int findUserCode = getUserCode();

        User joinUser = new User();
        joinUser.setUserCode(findUserCode);
        joinUser.setUserId(userJoinForm.getUserId());
        joinUser.setPassword(passwordEncoder.encode(userJoinForm.getPassword()));
        joinUser.setName(userJoinForm.getName());
        joinUser.setEmail(userJoinForm.getEmail());
        joinUser.setPhone(userJoinForm.getPhone());
        joinUser.setRole(UserRole.valueOf(userJoinForm.getRole().toUpperCase()));
        joinUser.setStatus(UserStatus.PENDING);
        joinUser.setProfileImg(profileImage);
        joinUser.setCreatedAt(LocalDateTime.now());
        joinUser.setLast_password_changed(LocalDate.now());
        joinUser.setLock_count(0);
        joinUser.setLastLoginAt(LocalDate.now());
        joinUser.setUpdatedAt(LocalDate.now());

        return joinUser;
    }

    public void updateLastLogin(String userId) {
        dao.updateLastLogin(userId);
    }

    public String getSemester() {

        String year = String.valueOf(LocalDate.now().getYear());
        int month = LocalDate.now().getMonthValue();

        String semester = "-";

        if (month <= 6) {
            month = 1;
        } else {
            month = 2;
        }

        return year += semester += String.valueOf(month);
    }
}
