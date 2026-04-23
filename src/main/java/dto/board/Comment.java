package dto.board;

import lombok.Data;
import java.util.Date;
import java.util.List;

@Data
public class Comment {
    private int commentNo;
    private int writerNo;
    private int boardNo;
    private Integer parentNo;   // null = 원댓글
    private Integer rootNo;     // null = 원댓글 (자기 자신이 root)
    private int depth;          // 0=원댓글, 1=대댓글
    private String content;
    private Date createdAt;

    // JOIN 필드
    private String writerName;

    // 서비스 레이어에서 조립 (원댓글 하위 대댓글 목록)
    private List<Comment> replies;
}
