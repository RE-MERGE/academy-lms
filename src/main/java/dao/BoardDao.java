package dao;

import dao.mapper.BoardMapper;
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

        template.getMapper(cls).insertPost(board, writerNo);
    }

    public PostDetail detailPost(int boardNo) {
        return template.getMapper(cls).detailPost(boardNo);
    }


    public void updatePost(PostUpdate postUpdate) {
        template.getMapper(cls).updatePost(postUpdate);
    }

    public void deletePost(String boardNo) {
        template.getMapper(cls).deletePost(boardNo);
    }

    public int getTotalCount(String boardType, String keyword, String searchType) {
        return template.getMapper(cls).getTotalCount(boardType, keyword, searchType);
    }

    public List<PostList> getList(BoardListRequest dto) {
        return template.getMapper(cls).getList(dto);
    }

    public void viewCount(int boardNo) {
        template.getMapper(cls).viewCount(boardNo);
    }
}
