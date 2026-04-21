package dao.mapper;

import dto.Course;
import dto.board.*;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface BoardMapper {

    @Insert("INSERT INTO BOARD (course_no, writer_no, board_type, title, content, file_url, created_at)" +
            "VALUES (#{board.courseNo}, #{writerNo}, #{board.boardType}, #{board.title}, #{board.content}, #{board.fileUrl}, now())")
    void InsertPost(@Param("board") PostCreate board, @Param("writerNo") int writerNo);

    @Select("""
    <script>
        SELECT b.board_no AS boardNo, b.board_type AS boardType, b.title, b.views, b.is_secret AS isSecret, b.created_at AS createdAt, u.name AS writerName
        FROM BOARD b
        JOIN USERS u ON b.writer_no = u.user_no
        <where>
            <choose>
                <when test="courseNo != null">
                    AND b.course_no = #{courseNo}
                </when>
                <otherwise>
                    AND b.course_no IS NULL
                </otherwise>
            </choose>
            <if test="boardType != null">
                AND b.board_type = #{boardType}
            </if>
        </where>
    </script>
""")
    List<PostList> postList(@Param("courseNo") Integer courseNo, @Param("boardType") String boardType);

    @Select("SELECT  b.board_no AS boardNo,\n" +
            "        b.course_no AS courseNo,\n" +
            "        b.board_type AS boardType,\n" +
            "        b.title,\n" +
            "        b.content,\n" +
            "        u.name AS writerName,\n" +
            "        b.file_url AS fileUrl,\n" +
            "        b.views,\n" +
            "        b.is_secret AS isSecret,\n" +
            "        b.created_at AS createdAt\n" +
            "        FROM BOARD b" +
            "        JOIN USERS u ON b.writer_no = u.user_no" +
            "        WHERE board_no=#{value}")
    PostDetail postDetail(int boardNo);

    @Select("select * from COURSE where course_no = #{course_no}")
    Course getCourse(Course course);

    @Select("SELECT USERS.name FROM USERS JOIN COURSE ON USERS.user_no = COURSE.professor_no WHERE COURSE.course_no = #{course_no}")
    String getProfessorName(@Param("course_no") int course_no);
    
    @Select("select * from COURSE")
    List<Course> getAllCourses();





}

