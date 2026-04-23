package dao.mapper;

import dto.board.Comment;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface CommentMapper {

    // 게시글의 댓글 전체 조회 (원댓글 + 대댓글 모두, 정렬: root → depth → commentNo)
    @Select("""
            SELECT
                c.comment_no,
                c.writer_no,
                c.board_no,
                c.parent_no,
                c.root_no,
                c.depth,
                c.content,
                c.created_at,
                u.name AS writer_name
            FROM COMMENT c
            JOIN USERS u ON c.writer_no = u.user_no
            WHERE c.board_no = #{boardNo}
            ORDER BY\s
                IFNULL(c.root_no, c.comment_no) ASC,
                c.depth ASC,
                c.comment_no ASC
            """)
    @Results(id = "commentResultMap", value = {
        @Result(property = "commentNo",  column = "comment_no"),
        @Result(property = "writerNo",   column = "writer_no"),
        @Result(property = "boardNo",    column = "board_no"),
        @Result(property = "parentNo",   column = "parent_no"),
        @Result(property = "rootNo",     column = "root_no"),
        @Result(property = "depth",      column = "depth"),
        @Result(property = "content",    column = "content"),
        @Result(property = "createdAt",  column = "created_at"),
        @Result(property = "writerName", column = "writer_name")
    })
    List<Comment> selectByBoardNo(int boardNo);

    // 원댓글 등록 (root_no는 INSERT 후 별도 UPDATE)
    @Insert("""
        INSERT INTO COMMENT (writer_no, board_no, depth, content, created_at)
        VALUES (#{writerNo}, #{boardNo}, 0, #{content}, NOW())
        """)
    @Options(useGeneratedKeys = true, keyProperty = "commentNo")
    int insertRoot(Comment dto);

    // 원댓글 등록 후 root_no = 자기 자신 PK로 세팅
    @Update("UPDATE COMMENT SET root_no = #{commentNo} WHERE comment_no = #{commentNo}")
    void updateRootNo(int commentNo);

    // 대댓글 등록
    @Insert("""
        INSERT INTO COMMENT (writer_no, board_no, parent_no, root_no, depth, content, created_at)
        VALUES (#{writerNo}, #{boardNo}, #{parentNo}, #{rootNo}, 1, #{content}, NOW())
        """)
    @Options(useGeneratedKeys = true, keyProperty = "commentNo")
    int insertReply(Comment dto);

    // 댓글 삭제 (본인만)
    @Delete("DELETE FROM COMMENT WHERE comment_no = #{commentNo} AND writer_no = #{writerNo}")
    int deleteByWriter(@Param("commentNo") int commentNo, @Param("writerNo") int writerNo);

    // 댓글 삭제 (관리자)
    @Delete("DELETE FROM COMMENT WHERE comment_no = #{value}")
    int deleteByAdmin(int commentNo);
}
