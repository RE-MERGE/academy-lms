package dto.user.grade;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MyProfessorGrade {

    private String courseName;    // 과목명
    private String courseType;    // 과목 구분 (전공필수 등)
    private int total_students;   // 수강 인원

    private double mid_avg;       // 중간고사 평균 점수
    private double final_avg;     // 기말고사 평균 점수

    private double avg_score;        // 해당 과목 전체 최고점
    private int max_score;        // 해당 과목 전체 최고점
    private int min_score;        // 해당 과목 전체 최저점
}
