package dto.user;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class SessionUser implements Serializable {

    private int userNo;          // DB 식별용 (PK)
    private int userCode;     // 학번/사번 (화면 표시용)
    private String userId;       // 아이디
    private String email;        // 이메일
    private String name;         // 이름 (화면 표시용: 'OOO님 환영합니다')
    private UserRole role;       // 권한 확인 (학생/교수/관리자 구분)
    private UserStatus status;       // 상태, 이용 가능한지
    private String profileImg;   // 프로필 이미지 경로 (상단 바 표시용)
}
