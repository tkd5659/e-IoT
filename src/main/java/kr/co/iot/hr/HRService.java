package kr.co.iot.hr;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class HRService {
	//CRUD:
	@Autowired @Qualifier("sql_hr") private SqlSession sql;
	
	//우리회사 전체 업무목록조회
	public List<JobVO>  hr_jobs() {
		return sql.selectList("hr.hr_jobs");
	}
	
	//우리회사 전체 부서목록조회
	public List<DepartmentVO> hr_departments() {
		return sql.selectList("hr.hr_departments");
	}
	
	//사원이 소속된 부서목록조회
	public List<DepartmentVO> employee_departments() {
		return sql.selectList("hr.employee_departments");
	}
	
	
	//신규사원등록: 삽입저장
	public void employee_register(EmployeeVO vo) {
		sql.insert("hr.insert", vo);
	}
	
	
	//사원목록조회: 전체
	public List<EmployeeVO> employee_list() {
//		List<EmployeeVO> list = sql.selectList("hr.list");
//		return list;
		return sql.selectList("hr.list");
	}
	//사원목록조회: 선택한 부서에 속한 사원목록
	public List<EmployeeVO> employee_list(int department_id) {
		return sql.selectList("hr.list", department_id);
	}
	
	
	//선택한 사원정보조회
	public EmployeeVO employee_info(int employee_id) {
		return sql.selectOne("hr.info", employee_id);
	}
	//선택한 사원정보 수정저장
	public void employee_update(EmployeeVO vo) {
		sql.update("hr.update", vo);
	}
	//선택한 사원정보 삭제
	public void employee_delete(int employee_id) {
		sql.delete("hr.delete", employee_id);
	}
}
