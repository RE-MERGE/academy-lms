package dao.mapper;


import dto.user.AdminUserList;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface AdminMapper {

    @Select("SELECT " +
            "  user_no AS userNo, " +
            "  name AS name, " +
            "  email AS email, " +
            "  role AS role, " +
            "  status AS status, " +
            "  user_code AS userCode, " +
            "  created_at AS createdAt " +
            "FROM USERS " +
            "ORDER BY created_at DESC") // 최신 가입 신청순으로 정렬
    List<AdminUserList> getAllUserList();

}
