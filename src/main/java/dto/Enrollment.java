package dto;

import lombok.Data;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Data
public class Enrollment {

    private int enrollment_no;       // 수강 신청 번호 (PK)
    private int course_no;           // 강의 관리 번호 (FK)
    private int student_no;          // 학생 관리 번호 (FK)
    private String status;          // 신청 상태 (APPLIED, PENDING, APPROVED)
    @JsonIgnore
    private LocalDateTime enrolled_at; // 수강 신청 날짜
}
