package dao;

import dao.mapper.UserMapper;
import dto.user.User;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository
public class UserDao {

//    @Autowired
//    private SqlSessionTemplate template;
    private Map<String, Object> param = new HashMap<>();
    private Class<UserMapper> cls = UserMapper.class;


    public void join(User user) {
//        template.getMapper(cls).join();
    }

}
