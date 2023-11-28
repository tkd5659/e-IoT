package kr.co.iot.notice;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.co.iot.common.PageVO;

@Service
public class NoticeService {
	@Autowired @Qualifier("sql_hanul") private SqlSession sql;
	
	//CRUD
	//신규 공지글 저장
	public int notice_register( NoticeVO vo ) {
		return sql.insert("notice.register", vo);
	}
	//신규 답글 저장
	public int notice_reply_register( NoticeVO vo ) {
		return sql.insert("notice.reply_register", vo);
	}
		
	//공지글목록 조회
	public List<NoticeVO> notice_list() {
		return sql.selectList("notice.list");
	}
	public PageVO notice_list(PageVO page) {
		//데이터행의 건수 조회
		page.setTotalList( sql.selectOne("notice.totalCount", page) );
		//해당 페이지의 글목록 조회
		page.setList( sql.selectList("notice.list", page) );
		return page;
	}
	
	//선택한 공지글 조회
	public NoticeVO notice_info(int id) {
		return sql.selectOne("notice.info", id);
	}
	//조회수증가처리
	public void notice_read(int id) {
		sql.update("notice.read", id);
	}

	//선택한 공지글 변경저장
	public int notice_update(NoticeVO vo) {
		return sql.update("notice.update", vo);
	}
	
	//선택한 공지글 삭제
	public int notice_delete(int id) {
		return sql.delete("notice.delete", id);
	}
}
