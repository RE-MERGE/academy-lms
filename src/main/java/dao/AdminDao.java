package dao;

import dao.mapper.AdminMapper;
import dto.user.AdminUserList;
import dto.user.User;
import dto.user.mypage.UserDetailForAdmin;
import dto.user.mypage.UserEditFormForAdmin;
import dto.user.mypage.AdminCourseList;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class AdminDao {

    @Autowired
    private SqlSessionTemplate template;
    private final Map<String, Object> param = new HashMap<>();
    private final Class<AdminMapper> cls = AdminMapper.class;

    public List<AdminUserList> getAllUserList() {
        return template.getMapper(cls).getAllUserList();
    }

    public List<AdminCourseList> getAllCourseList() {
        return template.getMapper(cls).getAllCourseList();
    }

    public void updateUserStatus(String status, List<Integer> userNos) {
            template.getMapper(cls).updateUserStatus(status, userNos);
    }

    public void updateCourseStatus(String status, List<Integer> courseNos) {
        template.getMapper(cls).updateCourseStatus(status, courseNos);
    }

    public User selectUser(int userNo) {
        return template.getMapper(cls).getSelectUser(userNo);
    }

    public List<AdminUserList> getUserListPaged(int offset, int size, String role) {
        return template.getMapper(cls).getUserListPaged(offset, size, role);
    }

    public int getTotalUserCount(String role) {
        return template.getMapper(cls).getTotalUserCount(role);
    }

    public void updateInfoFormAdmin(int userNo, UserDetailForAdmin userDetailForAdmin) {
         template.getMapper(cls).updateInfoForAdmin(userNo, userDetailForAdmin);
    }
}
