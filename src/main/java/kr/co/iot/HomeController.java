package kr.co.iot;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController{
	
	@RequestMapping("/error")
	public String error(HttpSession session, HttpServletRequest request, Model model) {
		session.setAttribute("category", "error");
		
		int code = (Integer)request.getAttribute("javax.servlet.error.status_code");
		model.addAttribute("code", code);
		model.addAttribute("method", request.getMethod() );
	
		if( code==500 ) {
			Throwable exception = (Throwable)request.getAttribute("javax.servlet.error.exception");
			model.addAttribute("error", exception.toString());
		}
		
		return "default/error/" + (code==404 ? 404 : "common");
	}
	
	
	//localhost/iot/hr/list
	//localhost/iot/member/info
	//localhost/iot/notice/list
	//localhost/iot/android/login, localhost/iot/app/login
	@RequestMapping("/app/login")
	public String appLogin() {
		return "android/login";
	}


	
	//시각화 화면요청
	@RequestMapping("/visual/list")
	public String list(HttpSession session) {
		session.setAttribute("category", "vi");
		return "visual/list";
	}
	
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, HttpSession session) {
//		session.setAttribute("category", "");
		session.removeAttribute("category");
		return "home";
	}
	
}
