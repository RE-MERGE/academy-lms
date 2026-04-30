package dto.board;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardLike {
    private int likeNo;
    private int boardNo;
    private int userNo;
}
