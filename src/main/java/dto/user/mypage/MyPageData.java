package dto.user.mypage;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Builder
@Getter
public class MyPageData {
    private List<?> courseList;
    private List<?> gradeList;
}
