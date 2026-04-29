package dto.user.grade;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MyGradeRow {

    private String courseName; //과목명
    private String courseType; //과목 구분
    private MyGrade midterm;
    private MyGrade finalExam;
    private MyGrade attendance;

}
