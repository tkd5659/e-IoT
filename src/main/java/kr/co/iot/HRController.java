package kr.co.iot;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.iot.hr.EmployeeVO;
import kr.co.iot.hr.HRService;

@Controller @RequestMapping("/hr")
public class HRController {
	@Autowired private HRService service;
	///CRUD
	
	//신규사원등록처리 요청
	@RequestMapping("/insert")
	public String register(EmployeeVO vo) {
		//비지니스로직: 화면에서 입력한 사원정보에 DB에 신규저장
		service.employee_register(vo);
		return "redirect:list" ; //응답화면
	}
	
	
	
	//신규사원등록화면 요청
	@RequestMapping("/register")
	public String register(Model model) {
		//비지니스로직: 사원정보에 배치할 부서, 업무목록 조회
		model.addAttribute("departments", service.hr_departments());
		model.addAttribute("jobs", service.hr_jobs());
		return "hr/register";
	}
	
	//선택한 사원정보삭제처리 요청
	@RequestMapping("/delete")
	public String delete(int id) {
		//비니니스로직: DB에서 선택한 사원정보 삭제
		service.employee_delete(id);
		
		return "redirect:list";//응답화면
	}
	
	
	//선택한 사원정보 수정 저장처리  요청
	@RequestMapping("/update")
	public String update(EmployeeVO vo) {
		//비지니스로직: 화면에서 변경입력한 정보를 DB에 변경저장
		service.employee_update(vo);
		
		return "redirect:info?id=" + vo.getEmployee_id(); //응답화면
	}
	
	//선택한 사원정보 수정화면 요청
	@RequestMapping("/modify")
	public String modify(Model model, int id) {
		//비지니스로직: 선택한 사원정보를 DB에서 조회 -> 화면에 출력할 수 있도록 Model객체에 담기
		model.addAttribute("vo", service.employee_info(id));
		
		//부서와 업무를 선택할 수 있도록 부서,업무목록을 조회
		model.addAttribute("departments", service.hr_departments()); //전체부서목록
		model.addAttribute("jobs", service.hr_jobs()); //전체업무목록
		
		return "hr/modify"; //응답화면
	}
	
	
	//선택한 사원정보화면 요청
	@RequestMapping("/info")
	public String info(int id, Model model) {
		//비지니스로직: DB에서 선택한 사원정보조회 -> 화면에 출력할 수 있도록 Model객체에 담기
		model.addAttribute("vo", service.employee_info(id) );
		return "hr/info"; //응답화면
	}
	
	
	//사원관리-사원목록화면 요청
	//@RequestMapping("/hr/list")
	@RequestMapping("/list")
	public String list(HttpSession session, Model model
						, @RequestParam(defaultValue = "-1" ) int department_id) {
		session.setAttribute("category", "hr");
		
		//비지니스로직
		//: DB에서 사원목록/부서목록을 조회 -> 목록화면에 출력할 수 있도록 Model객체에 담기
		
		model.addAttribute("departments", service.employee_departments() );
		
//		List<EmployeeVO> list = service.employee_list();
//		model.addAttribute("list", list);
		
		model.addAttribute("list", service.employee_list(department_id));
//		model.addAttribute("list", 
//						department_id == -1 ? service.employee_list()
//											: service.employee_list(department_id));
		model.addAttribute("department_id", department_id);
		
		//응답화면
		return "hr/list";
	}
}
