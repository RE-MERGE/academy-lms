package dao;

import dao.mapper.BoardMapper;
import dto.EnrollmentStudent;
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

    public int getTotalCount(Integer courseNo, String boardType, String keyword, String searchType, Integer writerNo) {
        return template.getMapper(cls).getTotalCount(courseNo ,boardType, keyword, searchType, writerNo);
    }

    public List<PostList> getList(BoardListRequest dto) {
        return template.getMapper(cls).getList(dto);
    }

    public void viewCount(int boardNo) {
        template.getMapper(cls).viewCount(boardNo);
    }

    public void updateIsAnswered(int boardNo, boolean isAnswered) {
        template.getMapper(cls).updateIsAnswered(boardNo, isAnswered);
    }

    public List<EnrollmentStudent> getStudentList(int courseNo) {
        return template.getMapper(cls).getStudentList(courseNo);
    }

    public void approveEnrollment(int enrollmentNo) {
        template.getMapper(cls).approveEnrollment(enrollmentNo);
    }

    public int checkLike(BoardLike boardLike) {
        return template.getMapper(cls).checkLike(boardLike);
    }

    public void insertLike(BoardLike boardLike) {
        template.getMapper(cls).insertLike(boardLike);
    }

    public void deleteLike(BoardLike boardLike) {
        template.getMapper(cls).deleteLike(boardLike);
    }
}
