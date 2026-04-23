package service;

import dao.AdminDao;
import dto.user.AdminUserList;
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

}
