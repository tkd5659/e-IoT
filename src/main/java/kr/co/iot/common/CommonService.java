package kr.co.iot.common;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.mail.EmailAttachment;
import org.apache.commons.mail.HtmlEmail;
import org.json.JSONObject;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import kr.co.iot.member.MemberService;
import kr.co.iot.member.MemberVO;

@Service
public class CommonService {

	//파일 여러개 첨부(업로드)처리
	public ArrayList<FileVO> fileAttach(String category, MultipartFile files[]
										, HttpServletRequest request ) {
		ArrayList<FileVO> list = null;
		for( MultipartFile file : files ) {
			if( file.isEmpty() ) continue;
			if( list==null ) list = new ArrayList<FileVO>();
			FileVO vo = new FileVO();
			vo.setFilename( file.getOriginalFilename() );
			vo.setFilepath( fileUpload(file, category, request) );
			list.add( vo );
		}
		
		return list;
	}
	
	
	//물리적인 파일삭제처리
	public void fileDelete(String filepath, HttpServletRequest request) {
		if( filepath != null) {
			// http://192.168.0.66:80 -->  d://app 로 변경되어야 함
			filepath = ipToDisc(filepath, request);
			File file = new File( filepath );
			if( file.exists() ) file.delete();
		}
	}
	
	private String ipToDisc( String path, HttpServletRequest request ) {
		String ip = "http://192.168.0.56";
		ip += ":" + request.getServerPort(); //  http://192.168.0.66:80
		// http://192.168.0.66:80 또는 http://localhost:80 -->  d://app 로 변경되어야 함
		path = path	.replace(ip, "d://app")
					.replace("http://localhost:"+ request.getServerPort(), "d://app");
		return path;
	}
	
	//첨부파일 다운로드
	public boolean fileDownload(String filename, String filepath
							, HttpServletRequest request, HttpServletResponse response) 
									throws Exception {
		//파일이 업로드된 위치정보
		//예) http://192.168.0.66:80/upload/notice/2023/10/17/1e1fedde-a39692_화면설계구현-평가지.pdf
		//-> 변경 d://app/upload/notice/2023/10/17/1e1fedde-a39692_화면설계구현-평가지.pdf
		// http://192.168.0.66:80 -->  d://app 로 변경되어야 함
		
//		filepath = "d://app" 
//					+ filepath.substring( filepath.indexOf(  request.getContextPath()  ) );// /iot/upload/notice/2023/10/17/1e1fedde-a39692_화면설계구현-평가지.pdf
		filepath = ipToDisc(filepath, request);
		File file = new File( filepath ); //다운로드할 파일객체
		if( ! file.exists() ) return false;
			
		//다운로드할 파일의 타입 지정
		String mime = request.getSession().getServletContext().getMimeType(filename);
		response.setContentType( mime );
		
		//파일명 한글인 경우 처리
		filename = URLEncoder.encode( filename, "utf-8");
		response.setHeader( "content-disposition" , "attachment; filename=" + filename );
		
		FileCopyUtils.copy( new FileInputStream(file), response.getOutputStream() );
		return true;
	}
	
	//첨부파일 업로드
	public String fileUpload(MultipartFile file, String category, HttpServletRequest request) {
		//업로드할 위치:  D:\Study_Spring\.metadata\.plugins\org.ecli....\wtpwebapps
		//				 \\02_eIot\\resources\\upload\\profile\\2023\\10\\16
		//String path = request.getSession().getServletContext().getRealPath("resources");
		String path = "d://app" + request.getContextPath(); // d://app/iot
		
		// "/upload/profile/2023/10/16";
		String upload = "/upload/" + category 
						+ new SimpleDateFormat("/yyyy/MM/dd").format(new Date());  
		
		path += upload;
		
		//폴더 존재여부 확인후 폴더만들기
		File folder = new File( path );
		if( ! folder.exists() ) folder.mkdirs();
		
		//각 파일에 고유ID 부여하기: adf3rlhkja_abc.jpg
		String filename = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
		try {
			file.transferTo( new File(path, filename) );
		}catch(Exception e) {
		}
		
		
		//다른ip에서 저장된 파일도 보여질수 있도록 localhost는 실제ip로 처리
		String url = appURL(request).replace("localhost", "192.168.0.56");
		return  url + upload + "/" + filename;
	}
	
	
	
	// 웹, 안드로이드, IoT 에서 공통으로 사용할 수 있는 로그인인증된 사용자 정보
	public MemberVO loginUser( MemberService memberService, MemberVO dto, BCryptPasswordEncoder pwEncoder ) {
		MemberVO user = memberService.member_info(dto.getUserid());
		boolean result = user==null ? false : true;
		if( result ) {
			result = pwEncoder.matches(dto.getUserpw(), user.getUserpw());
		}
		return result ? user : null;
	}
	
	// 웹, 안드로이드, IoT 에서 공통으로 사용할 수 있는 로그인인증
	public String loginCheck( MemberService memberService, MemberVO dto, BCryptPasswordEncoder pwEncoder ) {
		MemberVO user = memberService.member_info(dto.getUserid());
		boolean result = user==null ? false : true;
		if( result ) {
			result = pwEncoder.matches(dto.getUserpw(), user.getUserpw());
		}
		return result == true ? "success" : "fail";
	}
	
	public MemberVO loginInfo(HttpSession session) {
		return (MemberVO)session.getAttribute("loginInfo");
	}
	
	public String requestAPI( String apiURL, String property ) {
		String response = "";
	    try {
	        URL url = new URL(apiURL);
	        HttpURLConnection con = (HttpURLConnection)url.openConnection();
	        con.setRequestMethod("GET");
	        con.setRequestProperty("Authorization", property);
	        
	        int responseCode = con.getResponseCode();
	        BufferedReader br;
	        if(responseCode==200) { // 정상 호출
	          br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
	        } else {  // 에러 발생
	          br = new BufferedReader(new InputStreamReader(con.getErrorStream(), "utf-8"));
	        }
	        String inputLine;
	        StringBuffer res = new StringBuffer();
	        while ((inputLine = br.readLine()) != null) {
	          res.append(inputLine);
	        }
	        br.close();
	        response = res.toString();
	        if(responseCode==200) {
	          System.out.println(res.toString());
	        }
	      } catch (Exception e) {
	        System.out.println(e);
	      }		
		
		return response;
	}
	
	public String requestAPI( String apiURL ) {
		String response = "";
		try {
			URL url = new URL(apiURL);
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
			con.setRequestMethod("GET");
			int responseCode = con.getResponseCode();
			BufferedReader br;
			if(responseCode==200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
			} else {  // 에러 발생
				br = new BufferedReader(new InputStreamReader(con.getErrorStream(), "utf-8"));
			}
			String inputLine;
			StringBuffer res = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				res.append(inputLine);
			}
			br.close();
			response = res.toString();
			if(responseCode==200) {
				System.out.println(res.toString());
			}
		} catch (Exception e) {
			System.out.println(e);
		}		
		
		return response;
	}
	
	
	
	
	
	private String EMAIL_ADDRESS = "itstudydev@naver.com";
//	private String EMAIL_ADDRESS = "ojink2@gmail.com";
	
	private void emailServer( HtmlEmail email ) {
		String id = EMAIL_ADDRESS.substring(0, EMAIL_ADDRESS.indexOf("@"));
		String service = EMAIL_ADDRESS.substring( EMAIL_ADDRESS.indexOf("@")+1 );
		//gmail 인 경우 앱비밀번호(16자리), 그 외는 해당 이메일아이디에 대한 비밀번호
		String pw = service.contains("gmail") ? "mkevmvbhdsyzixbn" : "Itstudy10102";
		
		email.setDebug(true);
		email.setCharset("utf-8");
		
		//이메일전송 서버 지정
		email.setHostName("smtp." + service);
		
		//아이디/비번 입력하여 로그인하기: 관리자의 이메일
		email.setAuthentication( id , pw );
		email.setSSLOnConnect(true);
	}
	
	//회원가입축하메일 보내기
	public void sendWelcome( MemberVO vo, HttpServletRequest request ) {
		HtmlEmail email = new HtmlEmail();
		emailServer(email);
		
		try{
			email.setFrom(EMAIL_ADDRESS, "e-IoT 융합SW 관리자");
			email.addTo( vo.getEmail(), vo.getName() );
			email.setSubject("e-IoT 융합SW 가입 축하메시지");
			
			StringBuffer content = new StringBuffer();
			content.append("<html>");
			content.append("<body>");
			content.append("<h3><a target='_blank' href='http://www.hanuledu.co.kr/'>e-IoT 융합SW 과정</a></h3>");
			content.append("<div>e-IoT 융합SW 과정의 가입을 축하합니다</div>");
			content.append("<div>프로젝트까지 마무리 잘 하여 취업에 성공하시길 바랍니다.</div>");
			content.append("<div>첨부된 파일을 확인하신후 등교하세요.</div>");
			content.append("</body>");
			content.append("</html>");
			email.setHtmlMsg( content.toString() );
			
			//가입축하파일 첨부
			String welcomeFile = request.getSession().getServletContext()
									 	.getRealPath( "resources/files/회원가입안내.pdf" );
			EmailAttachment file = new EmailAttachment();
			file.setPath( welcomeFile );
			email.attach( file );  //파일첨부하기
			
			email.send(); //이메일보내기
			
		}catch(Exception e) {
		}
		
	}
	
	//임시비번 이메일로 보내기
	public boolean sendPassword( MemberVO vo, String pw ) {
		boolean send = true;
		
		HtmlEmail email = new HtmlEmail();
		emailServer( email ); //이메일서버에 연결하기
		
		try {
			email.setFrom( EMAIL_ADDRESS, "e-IoT 융합SW 관리자"); //이메일 전송자 지정
			email.addTo( vo.getEmail(), vo.getName() ); //이메일 수신자 지정
			
			//이메일 제목
			email.setSubject( "e-IoT 로그인 임시 비밀번호 발급" );
			
			//이메일 내용
			StringBuffer msg = new StringBuffer();
			msg.append( "<h3>[").append( vo.getName() )
								.append("]님 임시 비밀번호가 발급되었습니다</h3>" );
			
			msg.append("<div>아이디: ").append( vo.getUserid() ).append("</div>");
			msg.append("<div>임시 비밀번호: <strong>").append( pw ).append("</strong></div>");
			msg.append("<hr><div>발급된 임시 비밀번호로 로그인 후 비밀번호를 변경하세요</div>");
			email.setHtmlMsg( msg.toString() );
			
			email.send(); //보내기버튼 클릭
			
		}catch(Exception e) {
			send = false;
		}
		return send;
	}
	
	public String appURL( HttpServletRequest request ) {
		StringBuffer url = new StringBuffer( "http://" );
		url.append( request.getServerName() ).append( ":" ); // http://localhost:
		url.append( request.getServerPort() );  			 // http://localhost:80
		url.append( request.getContextPath() );				 // http://localhost:80/iot
		return url.toString();
	}
	
	public Map<String, Object> requestAPIInfo( String url ) {
		 JSONObject json = new JSONObject( requestAPI( url ) );
		 json = json.getJSONObject( "response" );
		 return json.getJSONObject( "body" ).toMap();
	}
	
}
