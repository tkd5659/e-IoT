package kr.co.iot.board;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import kr.co.iot.common.FileVO;
import kr.co.iot.common.PageVO;

@Service
public class BoardService {
	@Autowired @Qualifier("sql_hanul") private SqlSession sql;
	
	//CRUD
	//댓글 신규 저장
	public int board_comment_register(BoardCommentVO vo) {
		return sql.insert("board.commentRegister", vo);
	}
	//댓글 목록 조회
	public List<BoardCommentVO> board_comment_list( int board_id ) {
		return sql.selectList("board.commentList", board_id);
	}
	// 사용자의 미확인 댓글 목록 조회
	public List<BoardCommentVO> board_comment_notify( String userid ) {
		List<BoardCommentVO> list = sql.selectList("board.commentNotify", userid);
		sql.update("board.commentRead", userid);
		return list;
	}
	// 사용자의 미확인 댓글들을 확인(읽음)처리
	public int board_comment_read( String userid ) {
		return sql.update("board.commentRead", userid);
	}
	
	//댓글 정보 조회
	public BoardCommentVO board_comment_info( int id ) {
		return sql.selectOne("board.commentInfo", id);
	}
	//댓글 변경 저장
	public int board_comment_update(BoardCommentVO vo) {
		return sql.update("board.commentUpdate", vo);
	}
	//댓글 삭제
	public int board_comment_delete(int id) {
		return sql.delete("board.commentDelete", id);
	}
	
	
	
	
	
	//방명록 신규 저장
	public int board_register( BoardVO vo ) {
		int insert = sql.insert("board.register", vo);
		//첨부파일이 있으면 board_file 에 저장
		if( insert == 1 && vo.getFiles() != null ) {
			sql.insert("board.fileRegister", vo);
		}
		return insert;
	}
	//방명록 목록 조회
	public PageVO board_list( PageVO page ) {
		//총건수조회
		page.setTotalList( sql.selectOne("board.totalCount", page) );
		//해당페이지의 목록조회
		page.setList( sql.selectList("board.list", page) );
		return page;
	}
	//선택한 첨부파일정보 조회
	public FileVO board_file_info(int id) {
		return sql.selectOne("board.fileInfo", id);
	}
	//선택한 방명록에 첨부된 파일들목록 조회
	public List<FileVO> board_files_list(int id) {
		return sql.selectList("board.files", id);
	}
	
	//선택한 방명록 글정보 조회
	public BoardVO board_info(int id) {
		BoardVO vo = sql.selectOne("board.info", id);
		vo.setFiles( sql.selectList("board.files", id) );
		return vo;
	}
	//선택한 방명록 글 조회수 증가처리
	public void board_read(int id) {
		sql.update("board.read", id);
	}
	//선택한 방명록 글수정 저장
	public int board_update(BoardVO vo) {
		//첨부파일이 있으면 board_file에 저장
		if( vo.getFiles() != null ) {
			sql.insert("board.fileRegister", vo);
		}
		return sql.update("board.update", vo);
	}
	
	//삭제대상인 첨부파일 삭제
	public int board_files_delete(String remove) {
		return sql.delete("board.fileDelete", remove);
	}
	
	//삭제대상인 첨부파일목록 조회
	public List<FileVO> board_remove_files(String remove) { // 12,14
		return sql.selectList("board.removeFiles", remove);
	}
	
	//선택한 방명록 글 삭제
	public int board_delete(int id) {
		return sql.delete("board.delete", id);
	}
	
}
