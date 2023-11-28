package kr.co.iot.board;

import java.sql.Date;
import java.util.List;

import kr.co.iot.common.FileVO;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class BoardVO {
	private int id, readcnt, no, filecnt, commentcnt, notifycnt;
	private String title, content, writer, name;
	private Date writedate;
	private List<FileVO> files;
}
