package dao;

import dao.mapper.BoardMapper;
import dto.Board;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BoardDao {
    @Autowired
    private SqlSessionTemplate template;
    private static final Class<BoardMapper> cls = BoardMapper.class;


    public void insert(Board board) {
        template.getMapper(cls).Insert(board);
    }
}
