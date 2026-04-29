package dto.board;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

// 등록
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostCreate {
    private Integer courseNo;    // nullable
    private String boardType;    // 공지, 자유, Q&A
    private String title;
    private String content;
    private MultipartFile uploadFile;
    private String fileUrl;      // nullable
    private boolean isAnswered;
}