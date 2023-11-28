package kr.co.iot;

import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.iot.common.CommonService;
import kr.co.iot.common.PageVO;
import kr.co.iot.config.Auth;
import kr.co.iot.config.Auth.Role;
import kr.co.iot.member.MemberService;
import kr.co.iot.member.MemberVO;
import kr.co.iot.notice.NoticeService;
import kr.co.iot.notice.NoticeVO;

@Controller
@RequestMapping("/notice")
public class NoticeController {
	@Autowired private NoticeService service;
	@Autowired private CommonService common;
	
	//공지글 새글저장처리 요청
	@RequestMapping("/register") @Auth ( role = Role.ADMIN )
	public String register(NoticeVO vo, MultipartFile file, HttpServletRequest request) {
		//첨부된 파일이 있는 경우
		if( ! file.isEmpty() ) {
			vo.setFilename( file.getOriginalFilename() );
			vo.setFilepath( common.fileUpload(file, "notice", request) );
		}
		//화면에서 입력한 정보를 DB에 신규저장 후 목록화면으로 연결
		service.notice_register(vo);
		return "redirect:list";
	}
	
	
	//공지글 삭제처리 요청
	@RequestMapping({"/delete", "/reply/delete"}) @Auth ( role = Role.USER )
	public String delete(int id, HttpServletRequest request, PageVO page) throws Exception{
		NoticeVO vo = service.notice_info(id);
		//선택한 공지글을 DB에서 삭제한 후 목록화면으로 연결
		if( service.notice_delete(id)==1 ) {
			//첨부파일이 있으면 물리적파일도 삭제
			common.fileDelete( vo.getFilepath(), request );
		}
		return "redirect:list"
				+ "?curPage=" + page.getCurPage()
				+ "&search=" + page.getSearch()
				+ "&keyword=" + URLEncoder.encode( page.getKeyword(), "utf-8" )
				;
	}
	
	//답글저장처리 요청
	@RequestMapping("/reply/register")
	public String reply(PageVO page, NoticeVO vo, MultipartFile file
						, HttpServletRequest request) throws Exception{
		//화면에서 입력한 답글정보를 DB에 신규 저장한 후 목록화면으로 연결
		//첨부된 파일이 있는 경우
		if( ! file.isEmpty() ) {
			vo.setFilename( file.getOriginalFilename() );
			vo.setFilepath( common.fileUpload(file, "notice", request) );
		}
		service.notice_reply_register(vo);
		
		return "redirect:/notice/list"
				+ "?curPage=" + page.getCurPage()
				+ "&search=" + page.getSearch()
				+ "&keyword=" + URLEncoder.encode( page.getKeyword(), "utf-8" )
				;
	}
	
	//답글쓰기 화면 요청
	@RequestMapping("/reply/new")
	public String reply( Model model, int id, PageVO page ) {
		//원글의 정보가 필요하므로 원글정보 조회해와 답글쓰기 화면에 사용할 수 있도록 Model객체에 담기
		model.addAttribute("vo", service.notice_info(id));
		model.addAttribute("page", page);
		return "notice/reply";
	}
	
	
	//공지글 수정저장처리 요청
	@RequestMapping({"/update", "/reply/update"}) @Auth ( role = Role.USER )
	public String update(NoticeVO vo, MultipartFile file, PageVO page
						, HttpServletRequest request) throws Exception {
		//변경전 공지글정보 조회
		NoticeVO before = service.notice_info( vo.getId() );
		if( file.isEmpty() ) {
			//첨부파일 없는 경우: 원래X, 원래O삭제, 원래O그대로 
			if( ! vo.getFilename().isEmpty() ) { //원래O그대로 
				vo.setFilepath( before.getFilepath() );
			}
			
		}else {
			//첨부파일 있는 경우: 원래O바꿔첨부, 원래X새로첨부
			vo.setFilename( file.getOriginalFilename() );
			vo.setFilepath(  common.fileUpload(file, "notice", request) );
		}
		
		//화면에서 변경입력한 정보를 DB에 변경저장후 정보화면으로 연결
		if( service.notice_update(vo)==1 ) {
			if( file.isEmpty() ) {
				//첨부파일 없는 경우: 원래O삭제: 이전파일삭제
				if( vo.getFilename().isEmpty() ) {
					common.fileDelete(before.getFilepath(), request);
				}
				
			}else {
				//첨부파일 있는 경우: 원래O바꿔첨부: 이전파일삭제
				common.fileDelete(before.getFilepath(), request);
			}
		}
		return "redirect:info?id=" + vo.getId() 
						+ "&curPage=" + page.getCurPage()
						+ "&search=" + page.getSearch()
						+ "&keyword=" + URLEncoder.encode( page.getKeyword(), "utf-8" )
						;
	}
	
	
	//공지글 수정화면 요청
	@RequestMapping({"/modify", "/reply/modify"}) @Auth ( role = Role.USER )
	public String modify( int id, Model model, PageVO page ) {
		//해당 공지글정보를  DB 에서 조회해와 수정화면에 출력할 수 있도록  Model객체에 담기
		model.addAttribute("vo", service.notice_info(id) );
		model.addAttribute("page", page);
		return "notice/modify";
	}
	
	
	//공지글 새글쓰기 화면 요청
	@RequestMapping("/new") @Auth ( role = Role.ADMIN )
	public String notice() {
		return "notice/register";
	}
	
	@Autowired private MemberService member;
	@Autowired private BCryptPasswordEncoder pwEncoder;
	
	//첨부파일 다운로드처리 요청
	@ResponseBody @RequestMapping(value="/download", produces="text/html; charset=utf-8")
	public String download( int id, HttpServletRequest request
								, HttpServletResponse response ) throws Exception{
		//선택한 글의 첨부파일을 저장된 위치(서버)에서 가져와 클라이언트에 저장하기
		NoticeVO vo = service.notice_info(id);
		boolean download 
			= common.fileDownload( vo.getFilename(), vo.getFilepath(), request, response);
		if( download ) return null;
		else {
			//다운로드할 파일이 물리적으로 존재하지 않는 경우 처리
			StringBuffer msg = new StringBuffer("<script>");
			msg.append(" alert('다운로드할 파일이 없습니다!!'); history.go(-1) ");
			msg.append("</script>");
			return msg.toString();
		}
	}
	
	
	//선택한 공지글 정보화면 요청
	@RequestMapping({"/info", "/reply/info"})
	public String info(int id, Model model, PageVO page) {
		//조회수증가처리
		service.notice_read(id);
		//선택한 공지글 정보를 DB에서 조회해와 화면에 출력할 수 있도록 Model객체에 담기
		model.addAttribute("page", page);
	 	model.addAttribute("vo",  service.notice_info(id) );
	 	model.addAttribute("crlf", "\r\n"); 
		return "notice/info";
	}
	
	
	//공지글 목록화면 요청
	@RequestMapping("/list")
	public String list(Model model, HttpSession session, PageVO page) {
		//---------------------------------
		//임시로 관리자로 로그인해두기 - 나중에 삭제
//		String userid = "park2023", userpw = "Park2023";
//		String userid = "hong2023", userpw = "Hong2023";
		String userid = "gmy68", userpw = "Chin0316";
		MemberVO user = member.member_info(userid);
		if( user!=null && pwEncoder.matches(userpw, user.getUserpw()) ) {
			//session.setAttribute("loginInfo", user);
		}
		//---------------------------------
		
		session.setAttribute("category", "no");
		//DB에서 공지글목록을 조회해와 화면에 출력할 수 있도록 Model객체에 담기
		//model.addAttribute("list", service.notice_list() ); //전체 목록조회
		model.addAttribute("page", service.notice_list(page)); //페이지처리된 목록조회
		return "notice/list";
	}
	
	
}
