package kr.co.iot.config;

import java.util.HashMap;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import kr.co.iot.board.BoardCommentVO;
import kr.co.iot.board.BoardVO;
import kr.co.iot.common.PageVO;
import kr.co.iot.member.MemberVO;
import kr.co.iot.notice.NoticeVO;


/*
 Interceptor(preHandle) > Controller > Interceptor(postHandler)  > Interceptor(afterCompletion) 
  
 */
public class AuthInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		String url = request.getServletPath().substring(1);
		System.out.println("Auth> " + url );
		
		//권한인증이 필요하지 않은 경우 바로 실행되게
		HandlerMethod method = (HandlerMethod)handler;
		Auth auth = method.getMethodAnnotation( Auth.class );
		if( auth==null ) return true;
		
		//로그인되어 있지 않으면 로그인화면으로 연결
		HttpSession session = request.getSession();
		MemberVO user = (MemberVO)session.getAttribute("loginInfo"); //로그인한 사용자
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		PageVO page = new PageVO();
		Set<String> keys = request.getParameterMap().keySet();
		for( String key : keys ) {
			switch( key ) {
			case "curPage":
				page.setCurPage(  Integer.parseInt( request.getParameter("curPage") ) ); break;
			case "pageList":
				page.setPageList(  Integer.parseInt( request.getParameter("pageList") ) ); break;
			case "search":
				page.setSearch( request.getParameter("search")  ); break;
			case "keyword":
				page.setKeyword( request.getParameter("keyword")  ); break;
			default: 
				map.put( key, request.getParameter(key) );
			}
		}
		
		map.put("page", page);
		map.put("url", url);
		session.setAttribute("redirect", map);
		
		if( user==null ) {
			if( url.contains("comment") ) {
				return changeURL(url, response, request);
			}else {
				response.sendRedirect( request.getContextPath() + "/member/login" );
				return false;
			}
		}else {
			// 관리자권한요구 + 사용자로그인 - 다른 요청으로 연결
			if( auth.role() == Auth.Role.ADMIN && user.auth() == Auth.Role.USER ) {
				return changeURL(url, response, request);
			}else {
//				// 관리자권한요구 + 관리자로그인 
//				// 사용자권한요구 + 관리자로그인, 사용자권한요구 + 사용자로그인  
//				// - 신규는 바로 실행
				if( url.contains("new") || url.contains("register")) {
					return true;
				}else {
				// - 수정/삭제 : 글의 작성자가 로그인사용자인 경우만  바로 실행
				//                                  그 외는 다른 요청으로 연결 
					if( isUserWriter(user.getUserid(), map, url) ) 
						return true;
					else
						return changeURL(url, response, request);
				}
			}
		}
	}
	
	
	@Autowired @Qualifier("sql_hanul") private SqlSession sql;
	
	//글의 작성자가 로그인사용자인지 확인할 처리
	private boolean isUserWriter( String userid, HashMap<String, Object> map, String url) {
		String category = url.contains("notice") ? "notice" 
							: url.contains("board") ? "board" 
							: url.contains("member") ? "member" 
							: "";
		
		String writer = "";
		//id 가 파라미터로 전달된 경우 해당 id의 글정보를  DB 에서 조회해오기
		boolean idExist = map.get("id") == null || map.get("id").toString().isEmpty() ? false : true;
		if( idExist ) {
			Object info = sql.selectOne(category + ( url.contains("comment") ? ".commentInfo" : ".info"), Integer.parseInt(map.get("id").toString()) );
			
			if( info instanceof NoticeVO ) {
				writer = ((NoticeVO)info).getWriter();
				
			}else if ( info instanceof BoardVO ) {
				writer = ((BoardVO)info).getWriter();
				
			}else if ( info instanceof BoardCommentVO ) {
				writer = ((BoardCommentVO)info).getWriter();
				
			}else if ( info instanceof MemberVO ) {
				writer = ((MemberVO)info).getUserid(); 
			}
		}
		
		return userid.equals(writer);
	}

	//다른 요청으로 연결할 처리
	private boolean changeURL( String url, HttpServletResponse response
								, HttpServletRequest request ) throws Exception{
		// notice/new
		// new, register -> list   modify, update, delete -> info
		url = url.replace("new", "list").replace("register", "list")
				 .replace("modify", "info").replace("update","info").replace("delete", "info");
		
		if( request.getMethod().equals( RequestMethod.GET.name() )) {
			//파라미터가 노출되어 있는 경우
			if( request.getQueryString() != null ) url += "?" + request.getQueryString();
		}
		else if( request.getMethod().equals( RequestMethod.POST.name() )) {
			HttpSession session = request.getSession();
			HashMap<String, Object> map = (HashMap<String, Object>)session.getAttribute("redirect"); 
			map.put("url", url);
			session.setAttribute("redirect", map);
			
			url = "member/auth/url";
		}		
		
		response.sendRedirect( request.getContextPath() + "/" + url); //  iot/notice/list
		return false;
	}
	
}
