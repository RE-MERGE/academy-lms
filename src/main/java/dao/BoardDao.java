package dao;

import dao.mapper.BoardMapper;
import dto.Course;
import dto.board.*;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class BoardDao {
    @Autowired
    private SqlSessionTemplate template;
    private static final Class<BoardMapper> cls = BoardMapper.class;

    public void insertPost(PostCreate board, int writerNo) {
        template.getMapper(cls).InsertPost(board, writerNo);
    }

    public List<PostList> postList(Integer courseNo, String boardType) {
        return template.getMapper(cls).postList(courseNo, boardType);
    }

    public PostDetail postDetail(int boardNo) {
        return template.getMapper(cls).postDetail(boardNo);
    }
    
    
}
