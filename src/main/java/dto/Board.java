package dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class Board {
    private int board_no; // 게시판 관리 번호
    private int writer_no; // 작성자 관리 번호
    private int course_no; // 강의 관리 번호
    private String board_type; // 공지, 자유, Q&A
    private String title; // 게시글 제목
    private String content; // 게시글 내용
    private String file_url; // 첨부파일 경로
    private int views; // 조회수
    private int is_secret; // 비밀글 여부 (Q&A)
    private Date created_at; // 게시글 생성 날짜
}
