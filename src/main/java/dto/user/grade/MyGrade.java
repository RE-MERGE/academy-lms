package dto.user.grade;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MyGrade {

    private String courseName; //과목명
    private String courseType; //과목 구분
    private int score;         //점수
    private String examType;   //시험 구분
    private String status;     //수강 상태
}
