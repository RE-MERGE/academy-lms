package dto.user.mypage;

import dto.user.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class UserDetailForAdmin {

    private int userNo;          // DB 식별용 (PK)
    private int userCode;        // 학번/사번 (화면 표시용)
    private String userId;       // 아이디
    private UserRole role;       // 권한 확인 (학생/교수/관리자 구분)

    //관리자용
    private UserStatus status;   // 상태, 이용 가능한지
    private LocalDateTime createdAt;      // 가입일
    private LocalDate lastLoginDate;  // 마지막 접속일

    //관리자 변경 가능
    private String currentProfileImg;   // 프로필 이미지 경로 (상단 바 표시용)
    private LocalDate last_password_changed;
    private int lockCount;           // 로그인 실패 횟수 (계정 잠금 해제용)
    private MultipartFile profileImg;

    @NotBlank(message = "{error.required.name}")
    @Pattern(regexp = UserPattern.NAME_PATTERN, message = "{error.input.name}")
    private String name;

    @NotBlank(message = "{error.required.email}")
    @Email(regexp = UserPattern.EMAIL_PATTERN, message = "{error.input.email}")
    private String email;

    @NotBlank(message = "{error.required.phoneNo}")
    @Pattern(regexp = UserPattern.PHONE_PATTERN, message = "{error.input.phone}")
    private String phone;

    public UserDetailForAdmin(User user) {
        this.userNo = user.getUserNo();
        this.userCode = user.getUserCode();
        this.userId = user.isNaverUser() ? user.getDisplayUserId() : user.getUserId();
        this.email = user.getEmail();
        this.phone = user.getPhone();
        this.name = user.getName();
        this.role = user.getRole();
        this.status = user.getStatus();
        this.currentProfileImg = user.getProfileImg();
        this.last_password_changed = user.getLast_password_changed();
        this.createdAt = user.getCreatedAt();
        this.lastLoginDate = user.getLastLoginAt();
        this.lockCount = user.getLock_count();
    }

    public boolean isNaverUser() {
        return userId != null && userId.startsWith(UserConst.NAVER_LOGIN_USER);
    }

    public String getDisplayUserId() {
        return isNaverUser() ? "네이버 로그인 회원입니다." : userId;
    }
}
