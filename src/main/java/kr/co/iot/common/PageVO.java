package kr.co.iot.common;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class PageVO {
	private int totalList; 			//총 목록수 : DB에서 조회
	private int pageList = 10;  	//페이지당 보여질 목록 수
	private int blockPage = 10; 	//블럭당 보여질 페이지의 수
	private int totalPage; 			//총 페이지수
	private int totalBlock;			//총 블록수
	//각 페이지의 끝 목록번호 :  총 목록수 - (페이지번호-1) * 페이지당 보여질 목록수  
	//각 페이지의 시작 목록번호 :  끝 목록번호 - (페이지당 보여질 목록수-1)
	private int beginList, endList, curPage = 1;
	private int curBlock; 		  	// 블록번호 : 페이지번호 / 블록당 보여질 페이지수
	//각 블럭의 끝 페이지번호 : 블록번호 * 블록당 보여질 페이지수
	//각 블럭의 시작 페이지번호 : 끝 페이지번호 - (블럭당 보여질 페이지수-1)
	private int beginPage, endPage;
	private List<Object> list;		//각 페이지의 글목록
	private String search, keyword = "";
	
	public void setTotalList(int totalList) {
		this.totalList = totalList;
		
		//총 페이지수 : 총 목록수 / 페이지당 보여질 목록수 - 나머지있으면 1증가
		totalPage = totalList / pageList;
		if( totalList % pageList > 0 ) ++totalPage;
		//총 블록수 : 총 페이지수 / 블럭당 보여질 페이지수 - 나머지있으면 1증가
		totalBlock = totalPage / blockPage;
		if( totalPage % blockPage > 0 ) ++totalBlock;
		//각 페이지의 끝 목록번호 :  총 목록수 - (페이지번호-1) * 페이지당 보여질 목록수  
		//각 페이지의 시작 목록번호 :  끝 목록번호 - (페이지당 보여질 목록수-1)
		endList = totalList - (curPage-1) * pageList;
		beginList = endList - (pageList-1);
		// 블록번호 : 페이지번호 / 블록당 보여질 페이지수 - 나머지있으면 1증가
		curBlock = curPage / blockPage;
		if( curPage % blockPage > 0 ) ++curBlock;
		//각 블럭의 끝 페이지번호 : 블록번호 * 블록당 보여질 페이지수
		//각 블럭의 시작 페이지번호 : 끝 페이지번호 - (블럭당 보여질 페이지수-1)
		endPage = curBlock * blockPage;
		beginPage = endPage - (blockPage-1);
		//끝 페이지번호가 총 페이지수보다 클 수 없으므로 총 페이지수를 끝 페이지번호로 한다.
		if( endPage > totalPage ) endPage = totalPage;
	}
} 
