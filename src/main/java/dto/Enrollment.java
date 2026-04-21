package dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Enrollment {

    private int enrollmentNo;       // 수강 신청 번호 (PK)
    private int courseNo;           // 강의 관리 번호 (FK)
    private int studentNo;          // 학생 관리 번호 (FK)
    private String status;          // 신청 상태 (APPLIED, PENDING, APPROVED)
    private LocalDateTime enrolledAt; // 수강 신청 날짜
}
