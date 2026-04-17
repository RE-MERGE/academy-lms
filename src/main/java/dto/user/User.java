package dto.user;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotBlank;
import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
public class User {

    private int userNo;

    @NotBlank()
    private String userId;
    private String password;
    private String name;
    private String email;
    private String phone;

    private Role role;
    private Status status;

    private String img;             //이미지 이름
    private LocalDateTime lastLoginAt;    //마지막 로그인 날짜
    private LocalDateTime createdAt;      // 회원가입 날짜
    private int lock_count;         //로그인 시도 횟수



}
