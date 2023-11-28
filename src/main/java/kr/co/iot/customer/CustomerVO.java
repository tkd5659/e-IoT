package kr.co.iot.customer;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class CustomerVO {
	//org.apache.commons.dbcp2.BasicDataSource
	private int id;
	private String name, gender, email, phone;
	//org.mybatis.spring.SqlSessionFactoryBean
	//org.mybatis.spring.SqlSessionTemplate
}
