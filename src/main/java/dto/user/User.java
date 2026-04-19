package dto.user;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class User {

    private int userNo;
    private String userId;
    private String password;
    private String name;
    private String email;
    private String phone;
    private UserRole role;
    private UserStatus status;
    private String profileImg;             //이미지 이름
    private LocalDateTime lastLoginAt;    //마지막 로그인 날짜
    private LocalDateTime createdAt;      // 회원가입 날짜
    private LocalDateTime updatedAt;      // 비밀번호 마지막 변경 시간
    private int lock_count;         //로그인 시도 횟수



}
