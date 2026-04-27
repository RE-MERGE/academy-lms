package dto.user;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class User {

    private int userNo;
    private int userCode;
    private String userId;
    private String password;
    private String name;
    private String email;
    private String phone;
    private UserRole role;
    private UserStatus status;
    private String profileImg;             //이미지 이름
    private LocalDate  lastLoginAt;    //마지막 로그인 날짜
    private LocalDateTime createdAt;      // 회원가입 날짜
    private LocalDate  updatedAt;      // 비밀번호 마지막 변경 시간
    private int lock_count;         //로그인 시도 횟수
    private LocalDate last_password_changed;

    public void updateInfoForAdmin(String name, String email, String phone, String profileName) {
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.profileImg = profileImg;
    }

    public boolean isNaverUser() {
        return userId != null && userId.startsWith(UserConst.NAVER_LOGIN_USER);
    }

    public String getDisplayUserId() {
        return isNaverUser() ? "네이버 로그인 회원입니다." : userId;
    }
}
