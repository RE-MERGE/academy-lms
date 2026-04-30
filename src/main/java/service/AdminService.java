package service;

import dao.AdminDao;
import dao.UserDao;
import dto.user.AdminUserList;
import dto.user.User;
import dto.user.mypage.MyPageData;
import dto.user.mypage.UserDetailForAdmin;
import dto.user.mypage.AdminCourseList;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final AdminDao adminDao;
    private final UserService userService;
    private final UserDao userDao;
    private final SupabaseStorageService supabaseStorageService;


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

    public List<AdminUserList> searchUserListPaged(int offset, int size, String role, String keyword, String searchType, String status) {
        return adminDao.getUserListPaged(offset, size, role, keyword, searchType, status);
    }

    public int countSearchUsers(String role, String keyword, String searchType, String status) {
        return adminDao.getTotalUserCount(role, keyword, searchType, status);
    }

    @Transactional
    public void updateUserFormAdmin(int userNo, UserDetailForAdmin userDetailForAdmin) {

        MultipartFile profileImg = userDetailForAdmin.getProfileImg();
        String profileImgUrl;

        if (profileImg != null && !profileImg.isEmpty()) {
            try {
                profileImgUrl = supabaseStorageService.uploadImg(profileImg);
            } catch (Exception e) {
                throw new IllegalArgumentException("이미지 업로드에 실패했습니다.");
            }
        } else {
            profileImgUrl = userDetailForAdmin.getCurrentProfileImg();
        }

        userDetailForAdmin.setCurrentProfileImg(profileImgUrl);
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
