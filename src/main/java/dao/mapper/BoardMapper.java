package dao.mapper;

import dto.Board;
import dto.Course;
import dto.user.User;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

public interface BoardMapper {

    @Insert("insert into BOARD (course_no, writer_no, board_type, title, content, file_url, created_at) values (#{courseNo}, #{writerNo}, #{boardType}, #{title}, #{content}, #{fileUrl}, now())")
    void Insert(Board board);
    
    @Select("select * from COURSE where course_no = #{course_no}")
    Course getCourse(Course course);

    @Select("SELECT USERS.name FROM USERS JOIN COURSE ON USERS.user_no = COURSE.professor_no WHERE COURSE.course_no = #{course_no}")
    String getProfessorName(@Param("course_no") int course_no);
}
