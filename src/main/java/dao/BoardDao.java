package dao;

import dao.mapper.BoardMapper;
import dto.Board;
import dto.Course;
import dto.user.User;

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
    
    public Course selectCourse(int no) {
    	Course param = new Course();
    	param.setCourse_no(no);
    	return template.getMapper(cls).getCourse(param);
    }

    public String selectProfessorName(int course_no) {
        return template.getMapper(cls).getProfessorName(course_no);
    }
}
