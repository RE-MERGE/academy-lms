package dto.board;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// 수정
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostUpdate {
    private int boardNo;
    private String title;
    private String content;
    private String fileUrl;      // nullable
    private int isSecret;
}
