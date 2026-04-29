package dao.mapper;

import dto.board.*;
import org.apache.ibatis.annotations.*;

import java.util.List;

public interface BoardMapper {

    @Insert("INSERT INTO BOARD (course_no, writer_no, board_type, title, content, file_url, created_at)" +
            "VALUES (#{board.courseNo}, #{writerNo}, #{board.boardType}, #{board.title}, #{board.content}, #{board.fileUrl}, now())")
    void insertPost(@Param("board") PostCreate board, @Param("writerNo") int writerNo);

    @Select("SELECT  b.board_no AS boardNo,\n" +
            "        b.course_no AS courseNo,\n" +
            "        b.board_type AS boardType,\n" +
            "        b.writer_no AS writerNo,\n" +
            "        b.title,\n" +
            "        b.content,\n" +
            "        u.name AS writerName,\n" +
            "        b.file_url AS fileUrl,\n" +
            "        b.views,\n" +
            "        b.is_answered AS isAnswered,\n" +
            "        b.created_at AS createdAt\n" +
            "        FROM BOARD b" +
            "        JOIN USERS u ON b.writer_no = u.user_no" +
            "        WHERE board_no=#{value}")
    PostDetail detailPost(int boardNo);

    @Update("UPDATE BOARD\n" +
            "       SET title = #{title},\n" +
            "           content = #{content},\n" +
            "           created_at = NOW(), \n" +
            "           file_url = #{fileUrl} \n" +
            "     WHERE board_no = #{boardNo} ")
    void updatePost(PostUpdate postUpdate);

    @Delete("DELETE FROM BOARD WHERE board_no = #{value}")
    void deletePost(String boardNo);

    @Select("""
            <script>
                SELECT b.board_no as boardNo, b.course_no as courseNo, b.board_type as boardType, b.title,
                       b.views, b.is_answered AS isAnswered, b.created_at AS createdAt, b.file_url AS fileUrl,
                       m.name AS writerName
                FROM BOARD b
                JOIN USERS m ON b.writer_no = m.user_no
                WHERE b.board_type = #{boardType}
                <choose>
                    <when test="courseNo != null">
                        AND b.course_no = #{courseNo}
                    </when>
                    <otherwise>
                        AND b.course_no IS NULL
                    </otherwise>
                </choose>
                <if test="keyword != null and keyword != ''">
                    <choose>
                        <when test="searchType == 'title'">
                            AND b.title LIKE CONCAT('%', #{keyword}, '%')
                        </when>
                        <when test="searchType == 'writer'">
                            AND m.name LIKE CONCAT('%', #{keyword}, '%')
                        </when>
                        <otherwise>
                            AND (b.title LIKE CONCAT('%', #{keyword}, '%')
                            OR m.name LIKE CONCAT('%', #{keyword}, '%'))
                        </otherwise>
                    </choose>
                </if>
                <if test="writerNo != null">
                    AND b.writer_no = #{writerNo}
                </if>
                ORDER BY b.created_at DESC
                LIMIT #{pageSize} OFFSET #{offset}
            </script>
            """)
    List<PostList> getList(BoardListRequest dto);

    @Select("""
            <script>
                SELECT COUNT(*) FROM BOARD b
                JOIN USERS m ON b.writer_no = m.user_no
                WHERE b.board_type = #{boardType}
            
                <choose>
                    <when test="courseNo != null">
                        AND b.course_no = #{courseNo}
                    </when>
                    <otherwise>
                        AND b.course_no IS NULL
                    </otherwise>
                </choose>
            
                <if test="keyword != null and keyword != ''">
                    <choose>
                        <when test="searchType == 'title'">
                            AND b.title LIKE CONCAT('%', #{keyword}, '%')
                        </when>
                        <when test="searchType == 'writer'">
                            AND m.name LIKE CONCAT('%', #{keyword}, '%')
                        </when>
                        <otherwise>
                            AND (b.title LIKE CONCAT('%', #{keyword}, '%')
                            OR m.name LIKE CONCAT('%', #{keyword}, '%'))
                        </otherwise>
                    </choose>
                </if>
                <if test="writerNo != null">
                    AND b.writer_no = #{writerNo}
                </if>
            </script>
            """)
    int getTotalCount(@Param("courseNo") Integer courseNo, // courseNo 파라미터 추가
                      @Param("boardType") String boardType,
                      @Param("keyword") String keyword,
                      @Param("searchType") String searchType,
                      @Param("writerNo") Integer writerNo);

    @Update("UPDATE BOARD SET views = views + 1 WHERE board_no = #{value}")
    void viewCount(int boardNo);

    @Update("UPDATE BOARD " +
            "SET is_answered = #{isAnswered} " +
            "WHERE board_no = #{boardNo}")
    void updateIsAnswered(@Param("boardNo") int boardNo,@Param("isAnswered") boolean isAnswered);
}
