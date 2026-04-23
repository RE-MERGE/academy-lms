package dto.user.grade;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Data
public class AdminAllStudentGrade {

    private String courseName;      // 과목명
    private String courseType;      // 이수 구분 (전공필수 등)
    private int total_students;     // 수강 인원
    private double mid_avg;         // 중간고사 평균
    private double final_avg;       // 기말고사 평균
    private int max_score;          // 전체 최고점
    private int min_score;          // 전체 최저점
}
