package kr.co.iot;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import kr.co.iot.common.CommonService;

@Controller @RequestMapping("/data")
public class DataController {
	private String key 
	= "FPgj2NXbJw46TcGkmAfZEiYFDbxilys7KLjk3KaB7AfeJE00ZhPNM0M8unwbsI69fSmT8SNfVEimE6ZZ2U14hA%3D%3D"; 
	
	@Autowired private CommonService common;
	
	private String animalURL = "http://apis.data.go.kr/1543061/abandonmentPublicSrvc/";
	
	//유기동물 시도조회 요청
	//@ResponseBody 
	@RequestMapping("/animal/sido")
	public Object animal_sido(Model model) {
		StringBuffer url = new StringBuffer( animalURL );
		url.append( "sido?serviceKey=" ).append( key );
		url.append( "&_type=json" );
		url.append( "&numOfRows=50" );
//		return new Gson().fromJson( common.requestAPI(url.toString())
//				,  new TypeToken< HashMap<String, Object> >() {}.getType() );
		
		model.addAttribute("list", common.requestAPIInfo( url.toString() ) );
		return "data/animal/sido";
	}
	
	//유기동물 보호소조회 요청
	@RequestMapping( "/animal/shelter" )
	public String animal_shelter(String sido, String sigungu, Model model) {
		StringBuffer url = new StringBuffer( animalURL );
		url.append( "shelter?serviceKey=" ).append( key )
		   .append( "&_type=json" )
		   .append( "&upr_cd=" ).append(sido )
		   .append( "&org_cd=" ).append(sigungu )
		;
		model.addAttribute("list", common.requestAPIInfo( url.toString() ) );
		return "data/animal/shelter";
	}
	
	//유기동물 품종조회 요청
	@RequestMapping("/animal/kind")
	public String animal_kind(String upkind, Model model) {
		StringBuffer url = new StringBuffer( animalURL );
		url
		.append( "kind?serviceKey=" ).append( key )
		.append( "&up_kind_cd=" ).append( upkind )
		.append( "&_type=json" );
		model.addAttribute("list", common.requestAPIInfo( url.toString() ));
		
		return "data/animal/kind";
	}
	
	//유기동물 시군구조회 요청
	@RequestMapping( "/animal/sigungu" )
	public String animal_sigungu(String sido, Model model) {
		StringBuffer url = new StringBuffer( animalURL );
		url
		.append( "sigungu?serviceKey=" ).append( key )
		.append( "&_type=json" )
		.append( "&upr_cd=" ).append( sido );
		
		model.addAttribute("list", common.requestAPIInfo( url.toString() ) );
		return "data/animal/sigungu";
	}
	
	
	//유기동물 목록조회 요청
	//@ResponseBody 
	@RequestMapping("/animal/list")
	//public Object animal_list( int pageNo, int rows, Model model ) {
	public Object animal_list( @RequestBody HashMap<String, Object> map, Model model ) {
		//http://apis.data.go.kr/1543061/abandonmentPublicSrvc/abandonmentPublic?serviceKey=FPgj2NXbJw46TcGkmAfZEiYFDbxilys7KLjk3KaB7AfeJE00ZhPNM0M8unwbsI69fSmT8SNfVEimE6ZZ2U14hA%3D%3D
		StringBuffer url = new StringBuffer( animalURL );
		url.append( "abandonmentPublic?serviceKey=" ).append( key );
		url.append( "&_type=json" );
		url.append( "&pageNo=").append( map.get("pageNo"));
		url.append( "&numOfRows=").append( map.get("rows"));
		url.append( "&upr_cd=").append( map.get("sido"));
		url.append( "&org_cd=").append( map.get("sigungu"));
		url.append( "&care_reg_no=").append( map.get("shelter"));
		url.append( "&upkind=").append( map.get("upkind"));
		url.append( "&kind=").append( map.get("kind"));
//		return new Gson().fromJson( common.requestAPI( url.toString() )
//									, new TypeToken< HashMap<String, Object>  >() {}.getType() );
		
		//조회해온 정보를 animal_list.jsp에 출력할 수 있도록 Model객체에 담기
		model.addAttribute("list", common.requestAPIInfo( url.toString() ) );
		return "data/animal/animal_list";
	}
	
	//약국정보조회 요청
	@ResponseBody @RequestMapping("/pharmacy")
	public Object pharmacy_list( int pageNo, int rows ) {
		//https://apis.data.go.kr/B551182/pharmacyInfoService/getParmacyBasisList?_type=json&ServiceKey=FPgj2NXbJw46TcGkmAfZEiYFDbxilys7KLjk3KaB7AfeJE00ZhPNM0M8unwbsI69fSmT8SNfVEimE6ZZ2U14hA%3D%3D
		StringBuffer url 
		= new StringBuffer( "https://apis.data.go.kr/B551182/pharmacyInfoService/getParmacyBasisList" );
		url.append( "?ServiceKey=" ).append( key );
		url.append("&_type=json");
		url.append("&pageNo=").append( pageNo );
		url.append("&numOfRows=").append( rows );
		
		//return common.requestAPI( url.toString() );
		return new Gson().fromJson( common.requestAPI( url.toString() )
									, new TypeToken< HashMap<String, Object> >(){}.getType() );
	}
	
	//공공데이터목록 화면 요청
	@RequestMapping("/list")
	public String list(HttpSession session) {
		session.setAttribute("category", "da");
		return "data/list";
	}
	
}
