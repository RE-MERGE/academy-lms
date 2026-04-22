package dto.board;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

// 상세
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostDetail {
    private int boardNo;
    private int writerNo;
    private Integer courseNo;
    private String boardType;
    private String title;
    private String content;
    private String writerName;
    private String fileUrl;
    private int views;
    private int isSecret;
    private Date createdAt;
}
