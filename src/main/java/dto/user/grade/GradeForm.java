package dto.user.grade;

import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class GradeForm {
    private int course_no;          // <input name="course_no"> 와 매칭
    private List<GradeRow> gradeList; // <input name="gradeList[i]..."> 와 매칭
}
