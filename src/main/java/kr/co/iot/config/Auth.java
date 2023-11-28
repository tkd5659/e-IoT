package kr.co.iot.config;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target( ElementType.METHOD ) //어디에 적용할것인지
@Retention( RetentionPolicy.RUNTIME ) //유지정책(언제 정보를 얻을수 있는지)
public @interface Auth {
	enum Role { ADMIN, USER }
	Role role();
}
