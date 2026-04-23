package dto.user.grade;

import lombok.Data;

@Data
public class AdminAllStudentGrade {

    private String courseName;      // 과목명
    private int total_students;     // 수강 인원
    private int avg_score;         //점수
    private int max_score;         //점수
    private int min_score;         //점수
}
