package dto.user.mypage;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

@Getter
@AllArgsConstructor
public class TimetableResult {

    private List<TimetableData> cells;
    private int minHour;
    private int maxHour;

}
