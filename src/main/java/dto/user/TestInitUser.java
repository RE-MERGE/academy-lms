package dto.user;

public class TestInitUser {

    public static User createTestUser() {
        User user = new User();
        user.setUserNo(100);
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
        user.setUserNo(200);
        user.setUserId("admin");
        user.setPassword("1234");
        user.setName("테스트_관리자");
        user.setEmail("admin@lms.com");
        user.setPhone("010-0000-0000");
        user.setRole(UserRole.ADMIN);
        return user;
    }

    public static User createTestProfessor() {
        User user = new User();
        user.setUserNo(200);
        user.setUserId("professor");
        user.setPassword("1234");
        user.setName("테스트_교수");
        user.setEmail("professor@lms.com");
        user.setPhone("010-0000-0000");
        user.setRole(UserRole.PROFESSOR);
        return user;
    }
}
