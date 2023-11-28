package kr.co.iot.customer;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

@Repository
//@Component
public class CustomerDAO implements CustomerService {
	@Qualifier("sql_hanul") @Autowired	//@Inject
	private SqlSession sql;
	
	@Override
	public void customer_register(CustomerVO vo) {
		sql.insert("customer.insert", vo);
	}

	@Override
	public List<CustomerVO> customer_list() {
		List<CustomerVO> list = sql.selectList("customer.list");
		return list;
	}

	@Override
	public CustomerVO customer_info(int id) {
//		CustomerVO vo = sql.selectOne("customer.info", id);
//		return vo;
		return sql.selectOne("customer.info", id);
	}

	@Override
	public void customer_update(CustomerVO vo) {
		sql.update("customer.update", vo);
	}

	@Override
	public void customer_delete(int id) {
		sql.delete("customer.delete", id);
	}

	@Override
	public List<CustomerVO> customer_list(String name) {
		return sql.selectList("customer.list", name);
	}

}
