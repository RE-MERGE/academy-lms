package service;

import dao.AdminDao;
import dao.UserDao;
import dto.user.AdminUserList;
import dto.user.User;
import dto.user.UserEditForm;
import dto.user.UserEditFormForAdmin;
import dto.user.mypage.AdminCourseList;
import dto.user.mypage.UserDetailForAdmin;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

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

    public List<AdminUserList> getUserListPaged(int offset, int size, String role) {
        return adminDao.getUserListPaged(offset, size, role);
    }

    public int getTotalUserCount(String role) {
        return adminDao.getTotalUserCount(role);
    }

    @Transactional
    public void updateUserFormAdmin(int userNo, UserEditFormForAdmin userEditFormForAdmin) {

        MultipartFile profileImg = userEditFormForAdmin.getProfileImg();
        String originalProfileName;

        if (profileImg != null || !profileImg.isEmpty()) {
            originalProfileName = fileService.saveProfileImage(profileImg);
        } else {
            originalProfileName = userEditFormForAdmin.getCurrentProfileImg();
        }

        User targetUser = adminDao.selectUser(userNo);

        targetUser.updateInfoForAdmin(
                userEditFormForAdmin.getName(),
                userEditFormForAdmin.getEmail(),
                userEditFormForAdmin.getPhone(),
                originalProfileName
        );

        userEditFormForAdmin.setCurrentProfileImg(originalProfileName);
        userEditFormForAdmin.setUserId(targetUser.getUserId());

        adminDao.updateInfoFormAdmin(userNo, userEditFormForAdmin);
    }
}
