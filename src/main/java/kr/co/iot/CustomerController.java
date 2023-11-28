package kr.co.iot;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.iot.customer.CustomerServiceImpl;
import kr.co.iot.customer.CustomerVO;

@Controller
public class CustomerController {
	@Autowired private CustomerServiceImpl service;
	
	//해당고객정보 삭제처리
	@RequestMapping("/delete.cu")
	public String delete(int id) {
		//비지니스로직:DB에서 해당 고객정보 삭제
		service.customer_delete(id);
		//응답화면
		return "redirect:list.cu";
	}
	
	
	
	//고객정보 수정저장처리 요청
	//입력정보를 받아서 처리하는 경우는 POST로 하자
	//@RequestMapping(value="/update.cu") <- X 
	//@RequestMapping(value="/update.cu", method=RequestMethod.POST) <- O
	@PostMapping("/update.cu")
	public String update(CustomerVO vo) {
		//비지니스로직: 
		//1. 화면에서 입력한 정보를 수집해
		//2. DB에 변경저장
		service.customer_update(vo);
		
		//응답화면
		return "redirect:info.cu?id="+vo.getId();
	}
	
	//선택한 고객정보수정화면 요청
	@RequestMapping("/modify.cu")
	public String modify(int id, Model model) {
		//비지니스로직: 
		//1.선택한 고객의정보를 DB에서 조회해와
		CustomerVO vo = service.customer_info(id);
		//2.수정화면에 출력할 수 있도록 Model객체에 담기
		model.addAttribute("vo", vo);
		
		//응답화면
		return "customer/modify";
	}
	
	
	//선택한 고객정보화면 요청
	//@RequestMapping(value = "/info.cu"/* , method=RequestMethod.GET */)
	//@GetMapping : @RequestMapping + method=RequestMethod.GET
	//@PostMapping : @RequestMapping + method=RequestMethod.POST
	@GetMapping( "/info.cu" )  
	public String info( int id, Model model ) {
		//비지니스로직
		//1.선택한 고객의 정보를 DB에서 조회해와 
		CustomerVO vo = service.customer_info( id );
		//2.화면에 출력할 수 있도록 Model객체에 담기
		model.addAttribute("vo", vo);
		return "customer/info";
	}
	
	
	//신규고객정보 저장처리 요청
	@RequestMapping("/register.cu")
	public String register(CustomerVO vo) {
		//비지니스로직: 화면에서 입력한 정보를 DB에 신규저장
		service.customer_register(vo);
		
		//응답화면:고객목록 - redirect
		return "redirect:list.cu";
	}
	
	
	//신규고객입력화면 요청
	@RequestMapping("/new.cu")
	public String register() {
		return "customer/register";
	}
	
	
	//고객관리-고객목록화면 요청
	@RequestMapping("/list.cu")
	public String list(HttpSession session, Model model, String name) {
		session.setAttribute("category", "cu");
		//비지니스로직
		//1.DB에서 데이터조회해오기
		List<CustomerVO> list 
		=  name==null 
				? service.customer_list()
				: service.customer_list(name);
		
		
		//2.응답화면에 출력할 수 있도록 Model객체에 담기
		model.addAttribute("list", list);
		model.addAttribute("name", name);
		
		//화면응답
		return "customer/list";
	}
}
