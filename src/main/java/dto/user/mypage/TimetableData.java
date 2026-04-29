package dto.user.mypage;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TimetableData {

    private int courseNo;
    private String courseName;
    private String roomInfo;
    private String dayOfWeek;  // 월,화,수,목,금
    private int rowStart;      // grid-row 시작
    private int rowSpan;       // grid-row span
    private int colIndex;      // grid-column (월=2, 화=3...)
}
