package kr.co.iot.customer;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class CustomerServiceImpl implements CustomerService {
	@Autowired private CustomerDAO dao;
	
	@Override
	public void customer_register(CustomerVO vo) {
		dao.customer_register(vo);
	}

	@Override
	public List<CustomerVO> customer_list() {
		List<CustomerVO> list = dao.customer_list();
		return list;
	}

	@Override
	public CustomerVO customer_info(int id) {
		return dao.customer_info(id);
	}

	@Override
	public void customer_update(CustomerVO vo) {
		dao.customer_update(vo);
	}

	@Override
	public void customer_delete(int id) {
		dao.customer_delete(id);
	}

	@Override
	public List<CustomerVO> customer_list(String name) {
		return dao.customer_list(name);
	}

}
