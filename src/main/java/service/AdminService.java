package service;

import dao.AdminDao;
import dto.user.AdminUserList;
import dto.user.User;
import dto.user.mypage.AdminCourseList;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminService {

    private final AdminDao adminDao;

    public AdminService(AdminDao adminDao) {
        this.adminDao = adminDao;
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

    public User getSelectUser(int userNo) {
        return adminDao.getSelectUser(userNo);
    }

    public List<AdminUserList> getUserListPaged(int offset, int size, String role) {
        return adminDao.getUserListPaged(offset, size, role);
    }

    public int getTotalUserCount(String role) {
        return adminDao.getTotalUserCount(role);
    }
}
