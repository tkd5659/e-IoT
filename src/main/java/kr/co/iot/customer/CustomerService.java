package kr.co.iot.customer;

import java.util.List;

public interface CustomerService {
	//CRUD(Create, Read, Update, Delete)
	void customer_register(CustomerVO vo); //고객정보삽입저장-신규고객등록
	List<CustomerVO> customer_list(); //고객정보조회-목록조회
	List<CustomerVO> customer_list(String name); //고객정보조회-목록조회(이름검색)
	CustomerVO customer_info(int id); //고객정보조회-선택고객정보조회
	void customer_update(CustomerVO vo);//고객정보변경저장
	void customer_delete(int id);//고객정보삭제
}
