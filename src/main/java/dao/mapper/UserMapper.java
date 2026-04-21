package dao.mapper;

import dto.user.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface UserMapper {

    @Select("SELECT * FROM USERS")
    List<User> selectAllUsers();

    @Select("SELECT user_id FROM USERS WHERE email = #{userEmail}")
    String selectUserByEmail(String userEmail);

    //특정 회원 조회 (ID 기준)
//    @Select("SELECT * FROM users WHERE userId = #{userId}")
//    User selectUserById(String userId);

    @Insert("INSERT INTO USERS (" +
            "user_code, user_id, password, name, email, phone, " +
            "role, status, profile_img, created_at, last_password_changed, " +
            "last_login, lock_count" +
            ") VALUES (" +
            "#{userCode}, #{userId}, #{password}, #{name}, #{email}, #{phone}, " +
            "#{role}, #{status}, #{profileImg}, #{createdAt}, #{last_password_changed}, " +
            "#{lastLoginAt}, #{lock_count})")
    void join(User user);

    @Select("SELECT password FROM USERS WHERE user_id=#{userId} AND email={email} AND phone={phone}")
    String selectUserPassword(String userId, String email, String phone);

    @Select("SELECT " + "user_no AS userNo, " + "user_code AS userCode, " + "user_id AS userId, " + "password, " + "name, " + "email, " +
            "phone, " + "role, " +  "status, " + "profile_img AS profileImg, " + "last_login AS lastLoginAt, " + // DB는 last_login
            "created_at AS createdAt, " + "lock_count AS lock_count, " + // 객체 필드명이 snake_case면 그대로
            "last_password_changed AS last_password_changed " + "FROM USERS WHERE user_id = #{userId}")
    User selectUser(String userId);

    @Select("SELECT IFNULL(MAX(user_code), 0) FROM USERS")
    int getLastUserCode();

}
