package dto.board;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

// 목록
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostList {
    private int rowNum;
    private int boardNo;
    private Integer courseNo;    // null 이면 글로벌 게시판
    private String boardType;
    private String title;
    private String writerName;
    private int views;
    private Date createdAt;
    private String fileUrl;
    private Boolean isAnswered;

    public String getAnswerStatus() {
        // isAnswered가 true이면 "ANSWERED", false(또는 null)이면 "WAITING" 반환
        if (this.isAnswered != null && this.isAnswered) {
            return "ANSWERED";
        }
        return "WAITING";
    }
}
