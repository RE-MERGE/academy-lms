package dao.mapper;

import java.util.List;


import org.apache.ibatis.annotations.Select;

import dto.Course;

public interface CourseMapper {
	@Select("select * from COURSE")
	public List<Course> list();

}
