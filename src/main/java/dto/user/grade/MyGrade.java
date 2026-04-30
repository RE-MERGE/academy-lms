package dto.user.grade;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MyGrade {

    private int userNo;
    private int courseNo;
    private int enrollmentNo;
    private String courseName; //과목명
    private String courseType; //과목 구분
    private String userCode;  // 학번
    private String name;      // 이름
    private int score;         //점수
    private String examType;   //시험 구분
    private String status;     //수강 상태
    private String alphabet;
    private Integer midterm;
    private Integer finalScore;
    private Integer attendance;
}
