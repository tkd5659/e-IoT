package kr.co.iot;

import java.util.HashMap;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;

import kr.co.iot.common.CommonService;
import kr.co.iot.common.PageVO;
import kr.co.iot.member.MemberService;
import kr.co.iot.member.MemberVO;


//@RestController <= @Controller + @ResponseBody
@Controller @RequestMapping("/member")
public class MemberController {
	@Autowired private MemberService service;
	@Autowired private BCryptPasswordEncoder pwEncoder;
	@Autowired private CommonService common;
	
	
//url: http://localhost:80
//callback url: http://localhost:80/iot/member/naverCallback
	private String NAVER_ID = "sZLlWam2nwpEME3qNCHz";
	private String NAVER_SECRET = "F0QGFbtmSv";
	private String KAKAO_ID = "b593c090ebd4ec6cb8d068c6cbcfdfe3";
	
	
	//회원가입화면요청
	@RequestMapping("/join")
	public String join(HttpSession session) {
		session.setAttribute("category", "join");
		return "member/join";
	}
	
	
	
	//카카오로그인처리
	@RequestMapping("/kakaoLogin")
	public String kakao(HttpServletRequest request) {
		
		//https://kauth.kakao.com/oauth/authorize?response_type=code
		//&client_id=${REST_API_KEY}
		//&redirect_uri=${REDIRECT_URI}
		StringBuffer url 
			= new StringBuffer("https://kauth.kakao.com/oauth/authorize?response_type=code");
		url.append("&client_id=").append(KAKAO_ID);
		url.append("&redirect_uri=")
			.append( common.appURL(request) ).append("/member/kakaoCallback");
		
		return "redirect:" + url.toString();
	}
	
	@RequestMapping("/kakaoCallback")
	public String kakaoCallback(String code, HttpSession session, Model model) {
		if( code == null ) return "redirect:/";
		
//		curl -v -X POST "https://kauth.kakao.com/oauth/token" \
//		 -d "grant_type=authorization_code" \
//		 -d "client_id=${REST_API_KEY}" \
//		 -d "code=${AUTHORIZE_CODE}"
		StringBuffer url 
			= new StringBuffer("https://kauth.kakao.com/oauth/token?grant_type=authorization_code");
		url.append("&client_id=").append(KAKAO_ID)
		   .append("&code=").append(code);
		JSONObject json = new JSONObject( common.requestAPI( url.toString() ) );
		
		String type = json.getString("token_type");
		String token = json.getString("access_token");
		
		url = new StringBuffer("https://kapi.kakao.com/v2/user/me");
		json = new JSONObject( common.requestAPI(url.toString(), type + " " + token) );
		if( ! json.isEmpty() ) {
			MemberVO vo = new MemberVO();
			vo.setSocial("K");
			
			vo.setUserid( json.get("id").toString() );
			//나머지는 kakao_account 에 json형태로 있음
			json = json.getJSONObject("kakao_account");
			
			vo.setName( hasKey(json, "name", "무명씨") );
			vo.setEmail( hasKey(json, "email") );
			vo.setGender( hasKey(json, "gender", "male").equals("male") ? "남" : "여" ); //female/male ->여/남
			vo.setPhone( hasKey(json, "phone_number"));
			
			json = json.getJSONObject("profile");
			//nickname 이 있으면 nickname을 이름으로 하자
			if( ! hasKey(json, "nickname").isEmpty() ) {
				vo.setName( hasKey(json, "nickname", "무명씨") );
			}
			vo.setProfile( hasKey(json, "profile_image_url"));
			
			//카카오로그인 정보가 DB에 있는지 여부를 확인후 insert/update
			if( service.member_info( vo.getUserid() ) == null  ) {
				service.member_join(vo);
			}else {
				service.member_update(vo);
			}
			
			//로그인정보를 세션에 담기
			session.setAttribute("loginInfo", vo);
		}
		
		//return "redirect:/";
		return redirectURL(session, model);
	}
	
	private String hasKey( JSONObject json, String key, String value ) {
		return json.has( key ) ?  json.getString(key) : value;
	}
	private String hasKey( JSONObject json, String key ) {
		return json.has( key ) ?  json.getString(key) : "";
	}
	
	
	
	
	
	//네이버로그인처리
	@RequestMapping("/naverLogin")
	public String naver( HttpServletRequest request, HttpSession session ) {
		
		//https://nid.naver.com/oauth2.0/authorize?response_type=code
		//&client_id=CLIENT_ID
		//&state=STATE_STRING
		//&redirect_uri=CALLBACK_URL
		
		String state = UUID.randomUUID().toString();
		session.setAttribute("state", state);
		
		StringBuffer url 
			= new StringBuffer("https://nid.naver.com/oauth2.0/authorize?response_type=code");
		url.append("&client_id=").append( NAVER_ID );
		url.append("&state=").append( state );
		url.append("&redirect_uri=").append( common.appURL(request) ).append("/member/naverCallback");
		return "redirect:" +  url.toString();
	}
	
	@RequestMapping("/naverCallback")
	public String naverCallback(String code, String state, HttpSession session, Model model) {
		String storedState = (String)session.getAttribute("state");
		//성공시 code가 있다
		if( code==null || !storedState.equals(state) ) return "redirect:/";
		
		//https://nid.naver.com/oauth2.0/token?grant_type=authorization_code
		//&client_id=jyvqXeaVOVmV
		//&client_secret=527300A0_COq1_XV33cf
		//&code=EIc5bFrl4RibFls1
		//&state=9kgsGTfH4j7IyAkg
		
		//접근토큰발급 요청하기
		StringBuffer url 
			= new StringBuffer("https://nid.naver.com/oauth2.0/token?grant_type=authorization_code");
		url .append("&client_id=").append(NAVER_ID)
			.append("&client_secret=").append(NAVER_SECRET)
			.append("&code=").append( code )
			.append("&state=").append( state );
		String response = common.requestAPI( url.toString() );
		JSONObject json = new JSONObject( response );
		String token = json.getString("access_token");
		String type = json.getString("token_type");
		
		//접근 토큰을 이용하여 프로필 API 호출하기
//		curl  -XGET "https://openapi.naver.com/v1/nid/me" \
//	      -H "Authorization: Bearer AAAAPIuf0L+qfDkMABQ3IJ8heq2mlw71DojBj3oc2Z6OxMQESVSrtR0dbvsiQbPbP1/cxva23n7mQShtfK4pchdk/rc="
		url = new StringBuffer( "https://openapi.naver.com/v1/nid/me" );
		json = new JSONObject( common.requestAPI(url.toString(), type + " " + token) );
		
		//API호출결과코드가 정상("00")이면 프로필정보에 접근
		if( json.getString("resultcode").equals("00") ) {
			json = json.getJSONObject("response");
			
			//네이버프로필정보를 사이트 사용자정보로 관리하도록 MemberVO에 담기
			MemberVO vo = new MemberVO();
			vo.setSocial( "N" );
			vo.setUserid( json.getString("id")  );
			vo.setName( json.getString("name") );
			vo.setEmail( json.getString("email") );
			vo.setPhone( json.getString("mobile") );
			vo.setProfile( json.getString("profile_image") );
			vo.setGender( json.getString("gender").equals("F") ? "여" : "남" ); //- F: 여성,- M: 남성,- U: 확인불가
			
			//네이버로그인이 처음이면 insert 아니면 update
			if( service.member_info( vo.getUserid() )==null ) {
				service.member_join(vo);
			}else {
				service.member_update(vo);
			}
			
			session.setAttribute("loginInfo", vo);
		}
//		return "redirect:/";
		return redirectURL(session, model);
	}
	
	
	//비밀번호 변경화면 요청
	@RequestMapping("/change")
	public String change( HttpSession session ) {
		session.setAttribute("category", "change");
		//로그인되어 있지 않으면 로그인화면으로 연결
		MemberVO vo = (MemberVO)session.getAttribute("loginInfo");
		if( vo==null ) 	return "redirect:login";
		else 			return "member/change";
	}
	
	
	//새 비밀번호로 변경처리 요청
	@ResponseBody @RequestMapping("/updatePassword")
	public boolean updatePassword( MemberVO vo ) {
		//화면에서 입력한 새 비번을 암호화
		vo.setUserpw(  pwEncoder.encode( vo.getUserpw() ) );
		return service.member_resetPassword(vo) == 1 ? true : false; 
	}
	
	
	
	//현재비밀번호 일치여부 확인
	@ResponseBody @RequestMapping("/confirm")
	public int confirm( String userpw, HttpSession session ) {
		//화면에서 입력한 현재비번이 DB에 있는 비번과 같은지 확인
		MemberVO vo = (MemberVO)session.getAttribute("loginInfo");
		if( vo==null ) return -1;
		vo = service.member_info( vo.getUserid() );
		return pwEncoder.matches(userpw, vo.getUserpw() ) ? 0 : 1;
	}
	
	//비밀번호 재발급처리 요청
	@ResponseBody
	@RequestMapping(value="/resetPassword", produces="text/html; charset=utf-8")
	public String reset( MemberVO vo ) {
		//화면에서 입력한 아이디와 이메일이 일치하는 회원에게 임시 비번을 발급해주기
		vo.setName( service.member_userid_email(vo) );
		
		StringBuffer msg = new StringBuffer("<script>");
		if( vo.getName()==null ) {
			msg.append("alert('아이디나 이메일이 맞지 않습니다. \\n확인하세요!'); ");
			msg.append("location='find' ");
		}else {
			//:임시 비번을 생성한 후 회원정보의 비번에 변경저장, 임시버번을 이메일로 알려주기
			String pw = UUID.randomUUID().toString();	//ad34af3-afda32-afq3sreraf
			pw = pw.substring( pw.lastIndexOf("-")+1 ); //afq3sreraf
			pw = "I"+pw.substring(0, 9);
			vo.setUserpw( pwEncoder.encode(pw) );       //암호화된 afq3sreraf 임시비번
			
			if( service.member_resetPassword(vo)==1 
					&& common.sendPassword(vo, pw) ) {
				msg.append( "alert('임시 비밀번호가 발급되었습니다. \\n이메일을 확인하세요'); " );
				msg.append( "location='login'" ); //발급된 임시 비번으로 로그인하도록 로그인화면 연결
				
			}else {
				msg.append("alert('임시 비밀번호 발급 실패ㅠㅠ'); history.go(-1) ");				
			}
			
		}
		
		msg.append("</script>");
		return msg.toString();
	}
	
	
	//비밀번호찾기 화면 요청
	@RequestMapping("/find")
	public String find(HttpSession session) {
		session.setAttribute("category", "find");
		return "default/member/find";
	}
	
	//회원가입처리 요청
	@ResponseBody @RequestMapping(value="/register", produces= "text/html; charset=utf-8" )
	public String join(MemberVO vo,  MultipartFile file,  HttpServletRequest request) {
		
		//첨부파일이 있는 경우
		if( ! file.isEmpty() ) {
			vo.setProfile( common.fileUpload(file, "profile", request) );
		}
		
		
		//화면에서 입력한 회원정보를 DB에 신규저장 후 가입성공여부 알리기
		vo.setUserpw( pwEncoder.encode( vo.getUserpw() ) );  //입력비번을 암호화하여 담기
		
		StringBuffer msg = new StringBuffer("<script>");
		
		if( service.member_join(vo)==1 ) {
			common.sendWelcome(vo, request);  //회원가입축하메일전송
			
			msg.append("alert('회원가입을 축하합니다^^ \\n축하메일을 보냈으니 확인하세요~'); location='")
					.append( common.appURL(request) )
					.append("' ");
		}else {
			msg.append("alert('회원가입 실패ㅠㅠ'); history.go(-1) ");
		}
		msg.append("</script>");
		return msg.toString();
	}
	
	
	//아이디 중복확인처리 요청
	@ResponseBody @RequestMapping("/useridCheck")
	public boolean useridCheck( String userid ) {
		//입력한 아이디인 회원정보가 DB에 존재하는지 확인: true(사용가능아이디), false(이미사용중아이디)
		return service.member_info( userid )==null ? true : false;
	}
	
	
	//로그아웃처리 요청
	@RequestMapping("/logout")
	public String logout(HttpSession session, HttpServletResponse response
						, HttpServletRequest request) {
		//MemberVO login = (MemberVO) session.getAttribute("loginInfo");
		MemberVO login = common.loginInfo(session);
		String social = login.getSocial(); //iot: null, naver:N, kakao:K
		
		//세션의 로그인정보 삭제
		session.removeAttribute("loginInfo");
		
		//로그인유지 쿠키 삭제
		Cookie rememberCookie = WebUtils.getCookie(request, "remember-iot");
		if( rememberCookie != null ) {
			rememberCookie.setMaxAge(0);
			rememberCookie.setPath( request.getContextPath() );
			response.addCookie(rememberCookie);
			
			//DB에서 쿠키의 세션아이디인 정보 삭제
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("userid", login.getUserid());
			map.put("sessionid", rememberCookie.getValue());
			service.remember_release(map);
		}
		
		//카카오로그인한 경우 카카오계정도 함께 로그아웃되게 처리
		if( social !=null  && social.equals("K") ) {
			//curl -v -X GET "https://kauth.kakao.com/oauth/logout
			//?client_id=${YOUR_REST_API_KEY}
			//&logout_redirect_uri=${YOUR_LOGOUT_REDIRECT_URI}"
			
			StringBuffer url = new StringBuffer("https://kauth.kakao.com/oauth/logout");
			url.append("?client_id=").append(KAKAO_ID)
			   .append("&logout_redirect_uri=").append( common.appURL(request) );
			return "redirect:"+ url.toString();
		}else
			return "redirect:/";
	}
	
	
	//로그인처리 요청
	//@ResponseBody 
	@RequestMapping(value="/iotLogin"
							, produces="text/html; charset=utf-8")
	public String login(HttpSession session, HttpServletRequest request, HttpServletResponse response
						, RedirectAttributes redirect
						, @RequestParam(defaultValue = "false") boolean remember
						, MemberVO vo, Model model) {
//							, String userid, String userpw) {
		//비지니스로직: 화면에 입력한 아이디/비번과 일치하는 회원정보를 DB에서 조회하기
		//로그인회원정보를 session 에 담기
		
		//화면에서 입력한 아이디의 정보를 DB에서 조회하기
		/*
		boolean match = false;
		MemberVO vo = service.member_info(userid);
		if( vo != null ) {
			//해당 아이디의 정보가 있는 경우 입력한 비번과 암호화된 비번의 일치여부 확인
			match = pwEncoder.matches( userpw, vo.getUserpw() );
		}
		*/
		//공통 로그인 적용
		vo = common.loginUser(service, vo, pwEncoder);
		boolean match = vo==null ? false : true ;
		
		if( match ) {
			//로그인유지체크한 경우
			if( remember ) {
				//세션아이디를 가진 쿠키를 생성하기
				Cookie rememberCookie = new Cookie("remember-iot", session.getId());
				rememberCookie.setMaxAge( 60*60*24*365 );
				rememberCookie.setPath( request.getContextPath() );
				response.addCookie( rememberCookie );
				
				//DB에 저장
				HashMap<String, String> map = new HashMap<String, String>();
				map.put( "userid", vo.getUserid() );
				map.put( "sessionid", session.getId() );
				service.remember_login_keep(map);
			}
			
			//로그인된 경우
			session.setAttribute("loginInfo", vo); //세션에 로그인된 회원정보 담기
			//웰컴페이지로 연결
			return redirectURL(session, model);
			
		}else {
			//로그인 안된 경우
			redirect.addFlashAttribute("fail", true);
			return "redirect:login";
		}
	}
	
	
	public String login(HttpSession session, HttpServletRequest request, Model model
							, MemberVO vo) {
//							, String userid, String userpw) {
		//비지니스로직: 화면에 입력한 아이디/비번과 일치하는 회원정보를 DB에서 조회하기
		//로그인회원정보를 session 에 담기
		
		//화면에서 입력한 아이디의 정보를 DB에서 조회하기
		/*
		boolean match = false;
		MemberVO vo = service.member_info(userid);
		if( vo != null ) {
			//해당 아이디의 정보가 있는 경우 입력한 비번과 암호화된 비번의 일치여부 확인
			match = pwEncoder.matches( userpw, vo.getUserpw() );
		}
		*/
		//공통 로그인 적용
		vo = common.loginUser(service, vo, pwEncoder);
		boolean match = vo==null ? false : true ;
		
		StringBuffer msg = new StringBuffer("<script>");
		if( match ) {
			//로그인된 경우
			session.setAttribute("loginInfo", vo); //세션에 로그인된 회원정보 담기
			//웰컴페이지로 연결
			msg.append( "location='" ).append( common.appURL(request) ).append( "' " );
			
		}else {
			//로그인 안된 경우
			msg.append("alert('아이디나 비밀번호가 일치하지 않습니다!'); location='login' ");
//		msg.append("alert('아이디나 비밀번호가 일치하지 않습니다!'); history.go(-1)");
			
		}
		
		msg.append("</script>");
		return msg.toString();
	}

	
	@RequestMapping("/auth/url")
	private String redirectURL(HttpSession session, Model model) {
		if( session.getAttribute("redirect") == null ) {
			return "redirect:/";
		}else {
			HashMap<String, Object> map = (HashMap<String, Object>)session.getAttribute("redirect");
			model.addAttribute("id", map.get("id"));
			model.addAttribute("url", map.get("url"));
			model.addAttribute("page", map.get("page"));
			session.removeAttribute("redirect");
			
			//댓글수정/삭제는 @ResponseBody 로 데이터를 ajax쪽으로 응답해야 하므로 
			//form태그 서브밋되지 않고 redirect 페이지의 텍스트가 응답된다
			// board/commment/info로 redirect 되게 한다.
			if( map.get("url").toString().contains("comment") ) {
				return "redirect:/" + map.get("url");
			}else			
				return "include/redirect";
		}
	}
	
	
	//로그인화면 요청
	@RequestMapping("/login")
	public String login(HttpSession session, PageVO page, String id, String url) {
		if( url != null ) {
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("page", page);
			map.put("id", id);
			map.put("url", url);
			session.setAttribute("redirect", map);
		}
		
		session.setAttribute("category", "login");
		return "default/member/login";
	}
}
