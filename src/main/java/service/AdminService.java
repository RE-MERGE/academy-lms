package service;

import dao.AdminDao;
import dto.user.AdminUserList;
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
}
