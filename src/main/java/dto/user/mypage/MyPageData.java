package dto.user.mypage;

import dto.user.grade.MyGradeRow;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Builder
@Getter
public class MyPageData {
    private List<?> courseList;
    private List<?> gradeList;
    private List<MyGradeRow> gradeRows;
}
