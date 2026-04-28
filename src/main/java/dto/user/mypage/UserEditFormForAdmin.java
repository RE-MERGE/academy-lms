package dto.user.mypage;

import dto.user.User;
import dto.user.UserPattern;
import dto.user.UserRole;
import dto.user.UserStatus;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class UserEditFormForAdmin {

    private int userNo;

    // 읽기전용
    private int userCode;
    private String userId;
    private LocalDateTime createdAt;
    private LocalDate lastLoginDate;
    private int lockCount;

    // 수정 가능
    private UserRole role;
    private UserStatus status;
    private String currentProfileImg;
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

    public UserEditFormForAdmin(User user) {
        this.userNo = user.getUserNo();
        this.userCode = user.getUserCode();
        this.userId = user.isNaverUser() ? user.getDisplayUserId() : user.getUserId();
        this.createdAt = user.getCreatedAt();
        this.lastLoginDate = user.getLastLoginAt();
        this.lockCount = user.getLock_count();
        this.role = user.getRole();
        this.status = user.getStatus();
        this.currentProfileImg = user.getProfileImg();
        this.name = user.getName();
        this.email = user.getEmail();
        this.phone = user.getPhone();
    }
}
