package dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.EnrollmentMapper;

@Repository
public class EnrollmentDao {
	@Autowired
	 private SqlSessionTemplate template;
	 private Class<EnrollmentMapper> cls = EnrollmentMapper.class;
}
