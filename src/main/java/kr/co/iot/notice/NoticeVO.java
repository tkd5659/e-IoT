package kr.co.iot.notice;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class NoticeVO {
	private int id, readcnt, no, rid, root, step, indent;
	private String title, content, writer, name, filepath, filename;
	private Date writedate;
}
