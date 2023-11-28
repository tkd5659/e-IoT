package kr.co.iot;

import java.util.Scanner;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import kr.co.iot.member.MemberVO;

@RunWith( SpringJUnit4ClassRunner.class )
@ContextConfiguration(
		locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml" } )
public class IotTest {

	@Autowired @Qualifier("sql_hanul") private SqlSession sql;
	
	private BCryptPasswordEncoder pwEncoder = new BCryptPasswordEncoder();
	
	//비번변경하기
	@Test
	public void reset() {
		Scanner sc = new Scanner(System.in);
		System.out.print("비번변경할 아이디: ");
		String userid = sc.next();
		
		System.out.print("새 비밀번호: ");
		String userpw = pwEncoder.encode( sc.next() );
		
		MemberVO vo = new MemberVO();
		vo.setUserid(userid);
		vo.setUserpw(userpw);
		
		int update = sql.update("member.resetPassword", vo);
		System.out.println( update==1 ? "변경완료" : "변경실패");
		sc.close();
	}
	
	@Test
	public void login() {
		Scanner sc = new Scanner(System.in);
		System.out.print("로그인할 아이디: ");
		String userid = sc.next();
		
		System.out.print("비번: ");
		String userpw = sc.next();
		
		//System.out.println( "암호화된 비번: "+ pwEncoder.encode( userpw ) );
		MemberVO vo = sql.selectOne("member.loginTest", userid);
		if( vo==null ) { //해당 아이디가 없음
			System.out.println("아이디 불일치");
		}else {
			boolean match = pwEncoder.matches( userpw, vo.getUserpw() );
			if( match ) {
				System.out.println( vo.getName() + " 회원 로그인됨 ");
			}else {
				System.out.println("비번 불일치");
			}
		}
		
		sc.close();
	}
	
	@Test
	public void join() {
		//키보드로 이름,아이디,비번,이메일을 입력받아 DB에 저장
		MemberVO vo = new MemberVO();
		Scanner scan = new Scanner(System.in);
		
		System.out.print("이름: ");
		String name = scan.next();
		vo.setName( name );
		
		System.out.print("아이디: ");
		vo.setUserid( scan.next() );
		
		System.out.print("비밀번호: ");
		vo.setUserpw( pwEncoder.encode( scan.next() ) ); //암호화한 비번
		
//		System.out.print("이메일: ");
//		vo.setEmail( scan.next() );
		
		System.out.print("관리자/사용자(A/U): ");		
		vo.setRole( scan.next().toLowerCase().equals("a") 
					?  "ADMIN" : "USER" );
		
		
		scan.close();
		
		int dml = sql.insert("member.joinTest", vo);
		System.out.println( dml == 1 ? "회원가입 성공" : "회원가입 실패");
		
		
	}
	
}
