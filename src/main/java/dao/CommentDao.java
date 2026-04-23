package dao;

import dao.mapper.CommentMapper;
import dto.board.Comment;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CommentDao {
    @Autowired
    private SqlSessionTemplate template;
    private Class<CommentMapper> cls = CommentMapper.class;

    public List<Comment> selectByBoardNo(int boardNo) {
        return template.getMapper(cls).selectByBoardNo(boardNo);
    }

    public void insertRoot(Comment dto) {
        template.getMapper(cls).insertRoot(dto);
    }

    public void updateRootNo(int commentNo) {
        template.getMapper(cls).updateRootNo(commentNo);
    }

    public void insertReply(Comment dto) {
        template.getMapper(cls).insertReply(dto);
    }

    public int deleteByAdmin(int commentNo) {
        return template.getMapper(cls).deleteByAdmin(commentNo);
    }

    public int deleteByWriter(int commentNo, int requesterNo) {
        return template.getMapper(cls).deleteByWriter(commentNo, requesterNo);
    }
}
