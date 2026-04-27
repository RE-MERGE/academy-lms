package dto.user.mypage;

import dto.user.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class UserDetailForAdmin {

    private int userNo;          // DB 식별용 (PK)
    private int userCode;        // 학번/사번 (화면 표시용)
    private String userId;       // 아이디
    private UserRole role;       // 권한 확인 (학생/교수/관리자 구분)
    private UserStatus status;       // 상태, 이용 가능한지
    private String profileImg;   // 프로필 이미지 경로 (상단 바 표시용)
    private LocalDate last_password_changed;
    private String email;        // 이메일
    private String phone;
    private String name;

    //관리자용
    private LocalDateTime createdAt;      // 가입일
    private LocalDate lastLoginDate;  // 마지막 접속일
    private int lockCount;           // 로그인 실패 횟수 (계정 잠금 해제용)

    public UserDetailForAdmin(User user) {
        this.userNo = user.getUserNo();
        this.userCode = user.getUserCode();
        this.userId = user.getUserId();
        this.email = user.getEmail();
        this.phone = user.getPhone();
        this.name = user.getName();
        this.role = user.getRole();
        this.status = user.getStatus();
        this.profileImg = user.getProfileImg();
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
