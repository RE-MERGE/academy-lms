package dto.user.grade;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MyProfessorGrade {

    private String courseName; //과목명
    private String courseType; //과목 구분
    private int total_students; //과목 구분
    private int avg_score;         //점수
    private int max_score;         //점수
    private int min_score;         //점수
}
