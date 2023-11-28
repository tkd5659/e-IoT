package kr.co.iot.member;

import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class MemberService {
	//CRUD
	@Autowired @Qualifier("sql_hanul") private SqlSession sql;
	
	//로그인상태유지된 세션의 회원정보 조회
	public MemberVO remember_info(String sessionid) {
		return sql.selectOne("member.rememberInfo", sessionid );
	}
	
	//로그인상태유지 정보 삭제
	public int remember_release(HashMap<String, String> map) {
		return sql.delete("member.rememberRelease", map);
	}
	
	//로그인상태유지 정보 저장
	public int remember_login_keep(HashMap<String, String> map) {
		return sql.insert("member.rememberKeep", map);
	}
	
	
	//아이디와 이메일이 일치하는 회원명 조회
	public String member_userid_email( MemberVO vo ) {
		return sql.selectOne("member.useridEmail", vo);
	}
	
	//회원의 비밀번호 변경저장
	public int member_resetPassword( MemberVO vo ) {
		return sql.update("member.resetPassword", vo);
	}
	
	
	//회원가입시 회원정보 신규저장
	public int member_join( MemberVO vo ) {
		return sql.insert("member.join", vo);
	}
	//해당 아이디의 회원정보 조회
	public MemberVO member_info( String userid ) {
		
		return sql.selectOne("member.info", userid);
	}
	//마이페이지(내프로필) 에서 회원정보변경저장
	public int member_update( MemberVO vo ) {
		return sql.update("member.update", vo);
	}
	//회원탈퇴
	public int member_delete( String userid ) {
		return 0;
	}
}
