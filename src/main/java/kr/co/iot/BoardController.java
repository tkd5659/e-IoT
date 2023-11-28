package kr.co.iot;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.iot.board.BoardCommentVO;
import kr.co.iot.board.BoardService;
import kr.co.iot.board.BoardVO;
import kr.co.iot.common.CommonService;
import kr.co.iot.common.FileVO;
import kr.co.iot.common.PageVO;
import kr.co.iot.config.Auth;
import kr.co.iot.config.Auth.Role;
import kr.co.iot.member.MemberService;
import kr.co.iot.member.MemberVO;

@Controller
@RequestMapping("/board")
public class BoardController {
	@Autowired private BoardService service;
	@Autowired private MemberService member;
	@Autowired private BCryptPasswordEncoder pwEncoder;
	
	//미확인 댓글목록 조회 요청
	@RequestMapping("/comment/notify")
	public String comment_notify( String userid, Model model ) {
		//미확인 댓글목록 조회 + 미확인 댓글들을 읽음처리 
		model.addAttribute("list",  service.board_comment_notify(userid) );
		
		return "board/comment/notify_list";
	}
	
	
	//댓글삭제 요청
	@ResponseBody @PostMapping("/comment/delete") @Auth ( role = Role.USER )
	public Object comment_delete( int id ) {
		//해당 댓글을 DB에서 삭제한 후 삭제여부를 반환
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("success", service.board_comment_delete(id) == 1 ? true : false);
		return map;
	}
	
	//댓글정보조회 요청
	@ResponseBody @RequestMapping("/comment/info")
	public Object comment_info( int id ) {
		BoardCommentVO vo = service.board_comment_info(id);
		//이 요청은 댓글수정/삭제 요청을 처리하지 못할떄
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("message", "실패ㅠㅠ");
		map.put("success", false);
		return map;
	}
	
	//댓글변경저장 요청
	@ResponseBody @PostMapping("/comment/update") @Auth ( role = Role.USER )
	public Object comment_update(BoardCommentVO vo) {
		//화면에서 입력한 해당 방명록 댓글정보를 DB에 변경저장 후 성공/실패
		HashMap<String, Object> map = new HashMap<String, Object>();
		if( service.board_comment_update(vo)==1 ) {
			map.put("message", "성공^^");
			map.put("content", vo.getContent());
			map.put("success", true);
		}else {
			map.put("success", false);
			map.put("message", "실패ㅠㅠ");			
		}
		return map;
	}

	
	//댓글목록조회 요청
	@RequestMapping("/comment/list/{board_id}")
	public String comment_list(@PathVariable int board_id, Model model ) {
		//해당 방명록의 댓글목록을  DB에서 조회해와 화면에 출력
		model.addAttribute("list", service.board_comment_list(board_id) );
		model.addAttribute("crlf", "\r\n");
		model.addAttribute("lf", "\n");
		return "board/comment/comment_list";
	}
	
	//댓글등록처리 요청
	@ResponseBody @RequestMapping("/comment/register") @Auth ( role = Role.USER )
	public boolean comment_register(BoardCommentVO vo) {
		//화면에서 입력한 댓글정보를  DB에 저장한 후 저장여부 반환
		return service.board_comment_register(vo)== 1 ? true : false;
	}
	
	
	//선택한 방명록 삭제처리 요청
	@RequestMapping("/delete") @Auth ( role = Role.USER )
	public String delete(int id, PageVO page, Model model
						, HttpServletRequest request) {
		//첨부된 파일이 있는 경우: DB삭제+물리적파일 삭제
		List<FileVO> files = service.board_files_list(id);
		
		//선택한 방명록글을 DB에서 삭제한 후 목록화면으로 연결
		if( service.board_delete(id)==1 ) {
			//물리적파일 삭제
			for(FileVO vo : files) {
				common.fileDelete(vo.getFilepath(), request);
			}
		}
		
		//redirect 페이지에서 사용할 page 정보를 Model객체에 담기
		model.addAttribute("page", page);
		model.addAttribute("url", "list");
		return "include/redirect";
		//return "redirect:list";
	}

	
	//선택한 방명록 수정저장처리 요청
	@RequestMapping("/update") @Auth ( role = Role.USER )
	public String update(MultipartFile[] file, HttpServletRequest request
						, BoardVO vo, PageVO page, String remove, Model model) {
		//첨부된 파일이 있는 경우
		vo.setFiles( common.fileAttach("board", file, request) );
		//화면에서 입력한 정보를 DB에 변경저장한 후 정보화면으로 연결
		if( service.board_update(vo)==1 ) {
			//삭제된 파일이 있으면: DB에서 삭제 + 물리적파일 삭제
			if( ! remove.isEmpty() ) {
				//삭제대상인 파일 정보를 조회해두기
				List<FileVO> files = service.board_remove_files(remove);
				if( service.board_files_delete(remove) > 0 ) { // DB에서 삭제
					for(FileVO filevo : files ) {
						common.fileDelete(filevo.getFilepath(), request); //물리적파일 삭제
					}
				}
			}
		}
		
		model.addAttribute("id", vo.getId());
		model.addAttribute("page", page);
		model.addAttribute("url", "info");
		return "include/redirect";
		//return "redirect:info?id=" + vo.getId();
	}
	
	//파일을 읽어들여 binary로 변환해 응답하기
	@ResponseBody @RequestMapping( value="/convertFile"
						, produces= MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public byte[] convert(String file, HttpServletRequest request) throws Exception  {
		//http://192.168.0.49:80/upload/board/2023/10/26/423b33e6-bfe7-4731-96da-5e0cfd9d7c72_pp.jpg
		//d://app/upload/board/....
		//http://192.168.0.49:80/iot/upload/board/2023/10/26/423b33e6-bfe7-4731-96da-5e0cfd9d7c72_pp.jpg
		//d://app/iot/upload/board/....
		file = "d://app" + request.getContextPath() + file.substring( file.indexOf("/upload") );
		//해당 위치의 물리적인 파일을 읽어들여 byte로 변환
		return Files.readAllBytes( Paths.get( file ) );
	}
	
	//선택한 방명록 수정화면 요청
	@RequestMapping("/modify") @Auth ( role = Role.USER )
	public String modify(int id, Model model, PageVO page) {
		//선택한 방명록 글정보를  DB에서 조회해와 수정화면에 출력할 수 있도록 Model객체에 담기
		model.addAttribute( "vo", service.board_info(id) );
		model.addAttribute("page", page);
		return "board/modify";
	}
	
	
	//선택한 첨부파일 다운로드 요청
	@RequestMapping("/download")
	public void download( int file , HttpServletRequest request
								   , HttpServletResponse response) throws Exception{
		//선택한 파일의 정보를 DB에서 조회해와 서버의 물리적영역에 있는 파일을 클라이언트에 다운로드
		FileVO vo = service.board_file_info(file);
		common.fileDownload(vo.getFilename(), vo.getFilepath(), request, response);
	}
	
	
	//선택한 방명록 정보화면 요청
	@RequestMapping("/info")
	public String info(int id, Model model, PageVO page) {
		//조회수증가 처리
		service.board_read(id);
		//선택한 방명록 글정보를 DB에서 조회해와 정보화면에 출력할 수 있도록 Model객체에 담기
		model.addAttribute( "vo", service.board_info(id) );
		model.addAttribute( "crlf", "\r\n" );
		model.addAttribute( "lf", "\n" );
		model.addAttribute( "page", page );
		
		return "board/info";
	}
	
	@Autowired private CommonService common;
	
	//방명록 새글저장처리 요청
	@RequestMapping("/register") @Auth ( role = Role.USER )
	public String register(BoardVO vo, MultipartFile[] file, HttpServletRequest request) {
		//화면에서 입력한 정보를 DB에 신규저장처리 후 목록화면으로 연결
		//첨부된 파일들을 BoardVO의 files에 담기
		vo.setFiles(  common.fileAttach("board", file, request) );
		
		service.board_register(vo);
		return "redirect:list";
	}
	
	
	//방명록 새글쓰기화면 요청
	@RequestMapping("/new") @Auth ( role = Role.USER )
	public String board() {
		return "board/register";
	}
	
	
	//방명록 목록화면 요청
	@RequestMapping("/list")
	public String list(HttpSession session, PageVO page, Model model) {
		//---------------------------------
		//임시로 사용자로 로그인해두기 - 나중에 삭제
//		String userid = "shin2023", userpw = "Shin2023";
//		String userid = "admin2", userpw = "Manager";
//		String userid = "hong2023", userpw = "Hong2023";
		String userid = "park2023", userpw = "Park2023";
		MemberVO user = member.member_info(userid);
		if( user!=null && pwEncoder.matches(userpw, user.getUserpw()) ) {
			//session.setAttribute("loginInfo", user);
		}
		//---------------------------------
		
		session.setAttribute("category", "bo");
		
		model.addAttribute("page", service.board_list(page));
		
		return "board/list";
	}
	
}
