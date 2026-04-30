package dao.mapper;

import dto.EnrollmentStudent;
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
            "        b.created_at AS createdAt,\n" +
            "        (SELECT COUNT(*) FROM BOARD_LIKE WHERE board_no = b.board_no) as likeCount " +
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

    @Select("SELECT e.enrollment_no AS enrollmentNo, e.student_no AS studentNo, e.status, " +
            "       u.user_code AS userCode, u.name, u.email, u.phone " +
            "FROM ENROLLMENT e " +
            "JOIN USERS u ON e.student_no = u.user_no " +
            "WHERE e.course_no = #{courseNo} " +
            "ORDER BY e.enrollment_no")
    List<EnrollmentStudent> getStudentList(int courseNo);

    @Update("UPDATE ENROLLMENT SET status = 'APPROVED' WHERE enrollment_no = #{enrollmentNo}")
    void approveEnrollment(int enrollmentNo);

    // 1. 좋아요 여부 확인 (데이터가 있는지 SELECT 해서 개수를 반환)
    @Select("SELECT COUNT(*) FROM BOARD_LIKE WHERE board_no = #{boardNo} AND user_no = #{userNo}")
    int checkLike(BoardLike boardLike);

    // 2. 좋아요 추가 (데이터 삽입)
    @Insert("INSERT INTO BOARD_LIKE (board_no, user_no) VALUES (#{boardNo}, #{userNo})")
    void insertLike(BoardLike boardLike);

    // 3. 좋아요 취소 (데이터 삭제)
    @Delete("DELETE FROM BOARD_LIKE WHERE board_no = #{boardNo} AND user_no = #{userNo}")
    void deleteLike(BoardLike boardLike);
}
