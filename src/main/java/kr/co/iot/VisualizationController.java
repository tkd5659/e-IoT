package kr.co.iot;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.co.iot.visual.VisualService;


@RestController   //@Controller + @ResponseBody
@RequestMapping("/visual")
public class VisualizationController {
	
	@Autowired private VisualService service;
	
	//TOP3부서의 년도별/월별 채용인원원수 조회 요청
	@RequestMapping("/hirement/top3/year")
	public Object hirement_top3_year( int begin, int end ) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("begin", begin);
		map.put("end", end);
		
//		2001  "2001년", 2002 "2002년", 2003 "2003년"
		String range = "";
		for(int year=begin; year<= end; year++) {
			range +=  ( range.isEmpty() ? "" : ", ") +  year + " \"" + year + "년\" ";
		}
		map.put("range", range);
		
		List<HashMap<String, Object>> list= service.hirement_top3_year(map);
		Object[] keys = list.get(0).keySet().toArray();
		Arrays.sort( keys );
		keys = Arrays.copyOfRange(keys, 0, keys.length-1);
		
		map.put("list", list);
		map.put("unit", keys);
		
		return map;
	}
	@RequestMapping("/hirement/top3/month")
	public Object hirement_top3_month() {
		//원래데이터, 월정보		
		List<HashMap<String, Object>> list= service.hirement_top3_month();
		Object[] keys = list.get(0).keySet().toArray();
		Arrays.sort( keys );
		keys = Arrays.copyOfRange(keys, 0, keys.length-1);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		map.put("unit", keys);
		
		return map;
	}
	
	//년도별/월별 채용인원원수 조회 요청
	@RequestMapping("/hirement/year")
	public Object hirement_year( int begin, int end) {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("begin", begin);
		map.put("end", end);
		return service.hirement_year( map );
	}
	
	//년도별/월별 채용인원원수 조회 요청
	@RequestMapping("/hirement/month")
	public Object hirement_month() {
		return service.hirement_month();
	}
	
	//부서별 사원수 조회 요청
	//@ResponseBody 
	@RequestMapping("/department")
	public Object department() {
		return service.department();
	}

}
