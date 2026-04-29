package dto.user.grade;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GradeRow {
    private int enrollmentNo; // 학생+과목을 잇는 수강번호
    private int midterm;      // 중간고사 점수
    private int final_score;  // 기말고사 점수 (JSP name과 일치)
    private int attendance;   // 출석 점수
    private String alphabet;  // 학점 (A+, B 등)
}