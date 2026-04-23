package dto.user;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class AdminUserList {

    private int userNo;             // 번호 (PK)
    private String name;            // 이름
    private String email;           // 이메일
    private UserRole role;          // 역할 (STUDENT, PROFESSOR, ADMIN)
    private String status;          // 상태 (예: ACTIVE, PENDING, WITHDRAWAL)
    private String userCode;       // 학번 (또는 사번)
    private LocalDateTime createdAt;  // 가입 신청일 (또는 가입일)
}
