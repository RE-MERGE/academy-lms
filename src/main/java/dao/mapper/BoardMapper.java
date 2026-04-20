package dao.mapper;

import dto.Board;
import org.apache.ibatis.annotations.Insert;

public interface BoardMapper {

    @Insert("insert into BOARD (course_no, writer_no, board_type, title, content, file_url, created_at) values (#{courseNo}, #{writerNo}, #{boardType}, #{title}, #{content}, #{fileUrl}, now())")
    void Insert(Board board);
}
