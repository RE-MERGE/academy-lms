package dao;

import dao.mapper.AdminMapper;
import dto.user.AdminUserList;
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

}
