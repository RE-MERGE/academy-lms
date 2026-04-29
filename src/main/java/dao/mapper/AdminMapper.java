package dao.mapper;


import dto.user.AdminUserList;
import dto.user.User;
import dto.user.mypage.UserDetailForAdmin;
import dto.user.mypage.AdminCourseList;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

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

    @Select("SELECT " +
            "  c.course_no, " +
            "  c.course_name, " +
            "  c.course_type, " +
            "  c.room_info AS classroom, " +
            "  c.day_of_week, " +
            "  c.start_time, " +
            "  c.end_time, " +
            "  c.credits, " +
            "  c.max_students, " +
            "  c.status AS status, " +
            "  c.created_at AS apply_date, " +
            "  c.semester, " +
            "  c.curriculum_pdf, " +
            "  u.name AS prof_name, " +
            "  u.user_code AS course_code " +
            "FROM COURSE c " +
            "JOIN USERS u ON c.professor_no = u.user_no " +
            "ORDER BY c.created_at DESC")
    List<AdminCourseList> getAllCourseList();

    @Update("<script>" +
            "UPDATE USERS SET status = #{status} " +
            "WHERE user_no IN " +
            "<foreach collection='userNos' item='no' open='(' separator=',' close=')'>" +
            "#{no}" +
            "</foreach>" +
            "</script>")
    void updateUserStatus(@Param("status") String status, @Param("userNos") List<Integer> userNos);

    @Update("<script>" +
            "UPDATE COURSE SET status = #{status} " +
            "WHERE course_no IN " +
            "<foreach collection='courseNos' item='no' open='(' separator=',' close=')'>" +
            "#{no}" +
            "</foreach>" +
            "</script>")
    void updateCourseStatus(@Param("status") String status, @Param("courseNos") List<Integer> courseNos);

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
            "FROM USERS WHERE user_no = #{userNo}")
    User getSelectUser(int userNo);

    @Select("<script>" +
            "SELECT user_no AS userNo, name, email, role, status, user_code AS userCode, created_at AS createdAt " +
            "FROM USERS " +
            "WHERE 1=1 " +
            "<choose>" +
            "  <when test=\"role != null and role == 'admin'\">AND role = 'ADMIN' </when>" +
            "  <when test=\"role != null and role == 'student'\">AND role = 'STUDENT' </when>" +
            "  <when test=\"role != null and role == 'professor'\">AND role = 'PROFESSOR' </when>" +
            "</choose>" +
            "<if test=\"keyword != null and keyword != ''\">" +
            "  <choose>" +
            "    <when test=\"searchType == 'name'\">AND name LIKE CONCAT('%', #{keyword}, '%') </when>" +
            "    <when test=\"searchType == 'email'\">AND email LIKE CONCAT('%', #{keyword}, '%') </when>" +
            "    <when test=\"searchType == 'userCode'\">AND user_code LIKE CONCAT('%', #{keyword}, '%') </when>" +
            "    <when test=\"searchType == 'nameEmail'\">AND (name LIKE CONCAT('%', #{keyword}, '%') OR email LIKE CONCAT('%', #{keyword}, '%')) </when>" +
            "    <otherwise>AND (name LIKE CONCAT('%', #{keyword}, '%') OR email LIKE CONCAT('%', #{keyword}, '%') OR user_code LIKE CONCAT('%', #{keyword}, '%')) </otherwise>" +
            "  </choose>" +
            "</if>" +
            "ORDER BY created_at DESC " +
            "LIMIT #{size} OFFSET #{offset}" +
            "</script>")
    List<AdminUserList> getUserListPaged(@Param("offset") int offset, @Param("size") int size, @Param("role") String role, @Param("keyword") String keyword, @Param("searchType") String searchType);

    @Select("<script>" +
            "SELECT COUNT(*) FROM USERS " +
            "WHERE role != 'ADMIN' " +
            "<if test=\"role != null and role != 'all'\">AND role = #{role} </if>" +
            "<if test=\"keyword != null and keyword != ''\">" +
            "  <choose>" +
            "    <when test=\"searchType == 'name'\">AND name LIKE CONCAT('%', #{keyword}, '%') </when>" +
            "    <when test=\"searchType == 'email'\">AND email LIKE CONCAT('%', #{keyword}, '%') </when>" +
            "    <when test=\"searchType == 'userCode'\">AND user_code LIKE CONCAT('%', #{keyword}, '%') </when>" +
            "    <when test=\"searchType == 'nameEmail'\">AND (name LIKE CONCAT('%', #{keyword}, '%') OR email LIKE CONCAT('%', #{keyword}, '%')) </when>" +
            "    <otherwise>AND (name LIKE CONCAT('%', #{keyword}, '%') OR email LIKE CONCAT('%', #{keyword}, '%') OR user_code LIKE CONCAT('%', #{keyword}, '%')) </otherwise>" +
            "  </choose>" +
            "</if>" +
            "</script>")
    int getTotalUserCount(@Param("role") String role, @Param("keyword") String keyword, @Param("searchType") String searchType);

    @Update({
            "UPDATE USERS " +
            "SET name = #{userDetail.name}," +
            "    email = #{userDetail.email}," +
            "    phone = #{userDetail.phone}," +
            "    role = #{userDetail.role}," +
            "    status = #{userDetail.status}," +
            "    profile_img = #{userDetail.currentProfileImg} " + // 서비스에서 새 파일명 또는 기존명을 currentProfileImg에 세팅했다고 가정
            "WHERE user_no = #{userNo}"
    })
    void updateInfoForAdmin(@Param("userNo") int userNo, @Param("userDetail") UserDetailForAdmin userDetailForAdmin);

    @Update("UPDATE USERS SET lock_count = 0 WHERE user_no = #{userNo}")
    void resetLockCount(int userNo);

    @Select("SELECT COUNT(*) FROM USERS")
    int getTotalAllUserCount();

}
