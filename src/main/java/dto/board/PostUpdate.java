package dto.board;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

// 수정
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostUpdate {
    private int boardNo;
    private String title;
    private String content;
    private MultipartFile uploadFile;
    private String fileUrl;      // nullable
    private boolean isAnswered;
}
