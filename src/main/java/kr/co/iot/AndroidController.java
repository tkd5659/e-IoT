package kr.co.iot;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.co.iot.common.CommonService;
import kr.co.iot.member.MemberService;
import kr.co.iot.member.MemberVO;

@RestController @RequestMapping("/app")
public class AndroidController {
	@Autowired private MemberService memberService;
	@Autowired private BCryptPasswordEncoder pwEncoder;
	@Autowired private CommonService common;

	@PostMapping( value="/member/login_user"
//				, consumes = "application/json;charset=UTF-8"
				, produces = MediaType.APPLICATION_JSON_VALUE
				)
	public ResponseEntity<MemberVO> login_check(@RequestBody MemberVO dto) {
		MemberVO user = common.loginUser(memberService, dto, pwEncoder);
		return new ResponseEntity<>(user, HttpStatus.OK);
	}
	
	@PostMapping(value = "/member/login_check"
				, consumes = "application/json;charset=UTF-8"
				, produces = MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> login_check(@RequestBody MemberVO dto, HttpSession session) {
		
//		MemberVO user = memberService.member_info(dto.getUserid());
//		boolean result = user==null ? false : true;
//		if( result ) {
//			result = pwEncoder.matches(dto.getUserpw(), user.getUserpw());
//		}
//		String val = result == true ? "success" : "fail";
		String val = common.loginCheck(memberService, dto, pwEncoder);
		return new ResponseEntity<>(val, HttpStatus.OK);
	}
	
	
}
