package kr.co.iot.config;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.util.WebUtils;

import kr.co.iot.member.MemberService;
import kr.co.iot.member.MemberVO;

public class RememberInterceptor implements HandlerInterceptor {
	@Autowired private MemberService service;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
//		System.out.println("Remember> " + request.getServletPath());
		
		//세션에 로그인정보가 없으면 쿠키를 사용해 찾아오기
		HttpSession session = request.getSession();
		MemberVO loginInfo = (MemberVO)session.getAttribute("loginInfo");
		if( loginInfo == null ) {
			//브라우저에 저장된 쿠키찾기
			Cookie rememberCookie = WebUtils.getCookie(request, "remember-iot");
			if( rememberCookie != null ) {
				String sessionid = rememberCookie.getValue();
				//DB에 저장된 쿠키의 세션아이디인 회원정보 조회
				loginInfo = service.remember_info(sessionid);
				session.setAttribute("loginInfo", loginInfo);
			}
		}
		
		return true;
	} 
	
	
}
