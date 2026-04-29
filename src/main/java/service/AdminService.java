package service;

import dao.AdminDao;
import dao.UserDao;
import dto.user.AdminUserList;
import dto.user.User;
import dto.user.mypage.MyPageData;
import dto.user.mypage.UserDetailForAdmin;
import dto.user.mypage.AdminCourseList;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.List;

@Service
public class AdminService {

    private final AdminDao adminDao;
    private final UserService userService;
    private final UserDao userDao;
    private final FileService fileService;

    public AdminService(AdminDao adminDao, UserService userService, UserDao userDao, FileService fileService) {
        this.adminDao = adminDao;
        this.userService = userService;
        this.userDao = userDao;
        this.fileService = fileService;
    }

    public List<AdminUserList> getAllUserList() {
        return adminDao.getAllUserList();
    }

    public List<AdminCourseList> getAllCourseList() {
        return adminDao.getAllCourseList();
    }

    public void updateUserStatus(String status, List<Integer> userNos) {
        adminDao.updateUserStatus(status, userNos);
    }

    public void updateCourseStatus(String status, List<Integer> courseNos) {
        adminDao.updateCourseStatus(status, courseNos);
    }

    public User selectUser(int userNo) {
        return adminDao.selectUser(userNo);
    }

    public List<AdminUserList> searchUserListPaged(int offset, int size, String role, String keyword, String searchType) {
        return adminDao.getUserListPaged(offset, size, role, keyword, searchType);
    }

    public int countSearchUsers(String role, String keyword, String searchType) {
        return adminDao.getTotalUserCount(role, keyword, searchType);
    }

    @Transactional
    public void updateUserFormAdmin(int userNo, UserDetailForAdmin userDetailForAdmin) {

        MultipartFile profileImg = userDetailForAdmin.getProfileImg();
        String originalProfileName;

        if (profileImg != null && !profileImg.isEmpty()) {
            originalProfileName = fileService.saveProfileImage(profileImg);
        } else {
            originalProfileName = userDetailForAdmin.getCurrentProfileImg();
        }

        userDetailForAdmin.setCurrentProfileImg(originalProfileName);

        adminDao.updateInfoFormAdmin(userNo, userDetailForAdmin);
    }

    public void resetLockCount(int userNo) {
        adminDao.resetLockCount(userNo);
    }

    public int getTotalAllUserCount() {
        return adminDao.getTotalAllUserCount();
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
