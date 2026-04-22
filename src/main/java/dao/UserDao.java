package dao;

import dao.mapper.UserMapper;
import dto.user.User;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class UserDao {

    @Autowired
    private SqlSessionTemplate template;
    private Map<String, Object> param = new HashMap<>();
    private Class<UserMapper> cls = UserMapper.class;

    public List<User> selectAllUsers() {
        return template.getMapper(cls).selectAllUsers();
    }

    //ID 기준으로 select
    public String selectUserIdByEmail(String userEmail) {
        return template.getMapper(cls).selectUserByEmail(userEmail);
    }

    public void join(User user) {
        template.getMapper(cls).join(user);
    }

    public String selectUserPassword(String userId, String email, String phone) {
        return template.getMapper(cls).selectUserPassword(userId, email, phone);
    }

    public User selectUser(String userId) {
        return template.getMapper(cls).selectUser(userId);
    }

    public int getLastUserCode() {
        return template.getMapper(cls).getLastUserCode();
    }

    //PW찾기에서 임시비밀번호로 변경하기 위한 메서드
    public void updatePassword(String userId, String tempPassword) {
        template.getMapper(cls).updatePassword(userId, tempPassword);
    }
}
