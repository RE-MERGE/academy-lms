package dao.mapper;

import dto.user.User;
import dto.user.UserEditForm;
import dto.user.UserStatus;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

public interface UserMapper {

    @Select("SELECT " +
            "  user_no AS userNo, " +
            "  user_code AS userCode, " +
            "  user_id AS userId, " +
            "  password, " +
            "  name, " +
            "  email, " +
            "  phone, " +
            "  role, " +
            "  status, " +
            "  profile_img AS profileImg, " +
            "  last_login AS lastLoginAt, " +
            "  created_at AS createdAt, " +
            "  lock_count, " +
            "  last_password_changed " +
            "FROM USERS")
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

    @Select("SELECT " + "user_no AS userNo, " + "user_code AS userCode, " + "user_id AS userId, " + "password, " + "name, " + "email, " +
            "phone, " + "role, " +  "status, " + "profile_img AS profileImg, " + "last_login AS lastLoginAt, " + // DB는 last_login
            "created_at AS createdAt, " + "lock_count AS lock_count, " + // 객체 필드명이 snake_case면 그대로
            "last_password_changed AS last_password_changed " + "FROM USERS WHERE user_id = #{userId}")
    User selectUser(String userId);

    @Select("SELECT IFNULL(MAX(user_code), 0) FROM USERS")
    Integer getLastUserCode();

    @Select("SELECT password FROM USERS WHERE user_id=#{userId} AND email=#{email} AND phone=#{phone}")
    String selectUserPassword(@Param("userId") String userId, @Param("email") String email, @Param("phone") String phone);

    @Update("UPDATE USERS SET password = #{tempPassword}, last_password_changed = now()  WHERE user_id = #{userId}")
    void updatePassword(@Param("userId") String userId, @Param("tempPassword") String tempPassword);

    @Update("UPDATE USERS " +
            "SET " +
            "  name = #{name}, " +
            "  email = #{email}, " +
            "  phone = #{phone}, " +
            " profile_img = #{currentProfileImg} " +
            "WHERE user_id = #{userId}")
    void updateInfo(UserEditForm userEditForm);

    @Update("UPDATE USERS " +
            "SET profile_img = #{profileImg} " +
            "WHERE user_id = #{userId}")
    void updateProfileImg(@Param("userId") String userId, @Param("profileImg") String profileImg);

    @Update("UPDATE USERS SET status=#{status} WHERE user_id=#{userId}")
    void updateStatus(@Param("userId") String userId, @Param("status") UserStatus userStatus);

    @Update("UPDATE USERS SET lock_count=0 WHERE user_id = #{userId}")
    void resetLockCount(String userId);

    @Select("SELECT user_no FROM USERS WHERE user_code = #{value} AND ROLE = 'PROFESSOR'")
	Integer getProfNo(int code);

    @Select("SELECT user_code FROM USERS WHERE user_no = #{value}")
	int getUserCode(int professor_no);

    @Update("UPDATE USERS SET lock_count= #{newLockCount} WHERE user_id =#{userId} ")
    void updateLockCount(@Param("userId") String userId, @Param("newLockCount") int newLockCount);

    @Update("UPDATE USERS SET last_login = now() WHERE user_id = #{userId}")
    void updateLastLogin(String userId);

    @Select("SELECT " +
            "  user_no AS userNo, " +
            "  user_code AS userCode, " +
            "  user_id AS userId, " +
            "  password, " +
            "  name, " +
            "  email, " +
            "  phone, " +
            "  role, " +
            "  status, " +
            "  profile_img AS profileImg, " +
            "  last_login AS lastLoginAt, " +
            "  created_at AS createdAt, " +
            "  lock_count, " +
            "  last_password_changed " +
            "FROM USERS " +
            "WHERE user_id=#{naverId}")
            User selectUserByNaverId(String naverId);
}
