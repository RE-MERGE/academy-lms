package dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Board {

    private int boardNo;             // 게시판 관리 번호 (AUTO_INCREMENT)
    private Integer courseNo;        // 강의 관리 번호 (nullable)
    private Integer writerNo;        // 작성자 번호
    private String boardType;        // 공지, 자유, Q&A (ENUM)
    private String title;            // 게시글 제목
    private String content;          // 게시글 내용
    private String fileUrl;          // 첨부파일 경로 (nullable)
    private int views;               // 조회수 (기본값 0)
    private int isSecret;            // 비밀글 여부 (기본값 0)
    private LocalDateTime createdAt; // 게시글 생성 일자

}