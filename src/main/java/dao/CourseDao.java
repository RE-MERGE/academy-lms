package dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.CourseMapper;

import dto.Course;

@Repository
public class CourseDao {
	@Autowired
    private SqlSessionTemplate template;
	private Class<CourseMapper> cls = CourseMapper.class;
	public List<Course> list() {
		return template.getMapper(cls).list();
	}
}
