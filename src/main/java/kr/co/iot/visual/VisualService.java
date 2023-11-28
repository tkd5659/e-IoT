package kr.co.iot.visual;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class VisualService {
	@Autowired @Qualifier("sql_hr") private SqlSession sql;
	
	//부서별 사원수 조회
	public List<HashMap<String, Object>> department() {
		return sql.selectList("visual.department");
	}
	
	//TOP3부서의 년도별 채용인원수 조회
	public List<HashMap<String, Object>> hirement_top3_year( HashMap<String, Object> map ) {
		return sql.selectList("visual.hirementTop3Year", map);
	}
	//TOP3부서의 월별 채용인원수 조회
	public List<HashMap<String, Object>> hirement_top3_month() {
		return sql.selectList("visual.hirementTop3Month");
	}
	
	//년도별 채용인원수 조회
	public List<HashMap<String, Object>> hirement_year( HashMap<String, Integer> map) {
		return sql.selectList("visual.hirementYear", map);
	}
	//월별 채용인원수 조회
	public List<HashMap<String, Object>> hirement_month() {
		return sql.selectList("visual.hirementMonth");
	}
	
	
}
