package dto.user;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import java.time.LocalDate;

@Getter
@Setter
@ToString
public class UserEditFormForAdmin {

    private int userNo;
    private UserRole role;
    private UserStatus status;

    //현재 보여줄 이미지
    private String currentProfileImg;

    //마이페이지에서 이미지 변경시
    private MultipartFile profileImg;

    private String userId;
    private int userCode;
    private LocalDate createdAt;      // 비밀번호 마지막 변경 시간
    private LocalDate last_password_changed;
    private int lockCount;           // 로그인 실패 횟수 (계정 잠금 해제용)
    private LocalDate last_login;

    @NotBlank(message = "{error.required.name}")
    @Pattern(regexp = UserPattern.NAME_PATTERN, message = "{error.input.name}")
    private String name;

    @NotBlank(message = "{error.required.email}")
    @Email(regexp = UserPattern.EMAIL_PATTERN, message = "{error.input.password}")
    private String email;

    @NotBlank( message = "{error.required.phoneNo}")
    @Pattern(regexp = UserPattern.PHONE_PATTERN, message = "{error.input.phone}")
    private String phone;

    public UserEditFormForAdmin(){}

    public UserEditFormForAdmin(String currentProfileImg, String userId, String name, String email, String phone) {
        this.currentProfileImg = currentProfileImg;
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phone = phone;
    }

    public boolean isNaverUser() {
        return userId != null && userId.startsWith(UserConst.NAVER_LOGIN_USER);
    }

    public String getDisplayUserId() {
        return isNaverUser() ? "네이버 로그인 회원입니다." : userId;
    }
}
