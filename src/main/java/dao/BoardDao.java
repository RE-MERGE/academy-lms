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
    
    public Course selectCourse(int no) {
    	Course param = new Course();
    	param.setCourse_no(no);
    	return template.getMapper(cls).getCourse(param);
    }

    public String selectProfessorName(int course_no) {
        return template.getMapper(cls).getProfessorName(course_no);
    }
    
    public List<Course> selectAllCourses() {
    	return template.getMapper(cls).getAllCourses();
    }

    public void updatePost(PostUpdate postUpdate) {
        template.getMapper(cls).updatePost(postUpdate);
    }
}
