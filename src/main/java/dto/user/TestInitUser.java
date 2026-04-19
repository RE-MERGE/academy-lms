package dto.user;

public class TestInitUser {

    public static User createTestUser() {
        User user = new User();
        user.setUserNo(1);
        user.setUserId("student");
        user.setPassword("1234");
        user.setName("테스트학생");
        user.setEmail("test@lms.com");
        user.setPhone("010-1234-5678");
        user.setRole(UserRole.STUDENT);
        return user;
    }

    public static User createTestAdmin() {
        User user = new User();
        user.setUserNo(2);
        user.setUserId("admin");
        user.setPassword("1234");
        user.setName("테스트_관리자");
        user.setEmail("admin@lms.com");
        user.setPhone("010-0000-0000");
        user.setRole(UserRole.ADMIN);
        return user;
    }
}
