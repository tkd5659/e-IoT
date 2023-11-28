package kr.co.iot.member;

import kr.co.iot.config.Auth;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class MemberVO {
	private String name, userid, userpw, gender, email, phone, profile
					, post, address, role, social,birth;
	
	//로그인사용자(회원)의 권한반환
	public Auth.Role auth() {
		return role.equals("ADMIN") ? Auth.Role.ADMIN : Auth.Role.USER;
	}
}
