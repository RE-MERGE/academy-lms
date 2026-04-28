package dto.board;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardListRequest {
    private Integer courseNo;
    private Integer writerNo;
    private String boardType;
    private String keyword;
    private String searchType;
    private int offset;
    private int pageSize;
}
