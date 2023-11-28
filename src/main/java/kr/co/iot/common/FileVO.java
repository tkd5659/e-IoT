package kr.co.iot.common;

import lombok.Getter;
import lombok.Setter;

@Setter @Getter
public class FileVO {
	private int id, parent_id;
	private String filename, filepath;

}
