<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
#legend span { display:inline-block;  width: 44px; height: 17px; margin-right:5px; }
input.year { width: 80px; text-align: center; }
</style>
<link rel="stylesheet" href="<c:url value='/css/yearpicker.css'/>">
<script src="<c:url value='/js/yearpicker.js'/>"></script>
</head>
<body>
<h3 class="my-4">사원정보분석</h3>

<ul class="nav nav-tabs">
  <li class="nav-item">
    <a class="nav-link active">부서원수</a>
  </li>
  <li class="nav-item">
    <a class="nav-link">채용인원수</a>
  </li>
  <li class="nav-item">
    <a class="nav-link">Link2</a>
  </li>
  <li class="nav-item">
    <a class="nav-link">Link3</a>
  </li>
</ul>
<div id="tab-content" style="height: 520px">
	<div class="tab text-center mt-3">
		<div class="form-check form-check-inline">
			<label><input class="form-check-input" type="radio" name="chart" value="bar" checked>막대그래프</label>
		</div>	
		<div class="form-check form-check-inline">
			<label><input class="form-check-input" type="radio" name="chart" value="donut">도넛그래프</label>
		</div>	
	</div>
	<div class="tab text-center mt-3">
		<div class="form-check form-check-inline">
			<label><input class="form-check-input" type="checkbox" id="top3" >TOP3부서</label>
		</div>	
		<div class="form-check form-check-inline">
			<label><input class="form-check-input" type="radio" name="unit" value="year" checked>년도별</label>
		</div>	
		<div class="form-check form-check-inline">
			<label><input class="form-check-input" type="radio" name="unit" value="month">월별</label>
		</div>	
		<div class="d-inline-block year-range">
			<div class="d-flex align-items-center">			
				<input type="text" class="form-control year" id="begin">
				<span class="px-1">~</span>
				<input type="text" class="form-control year" id="end">
			</div>
		</div>
	</div>

	<canvas id="chart" class="h-100 m-auto pt-3"></canvas>
</div>


<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-autocolors"></script>
<script>
$("ul.nav-tabs li").on( { 
	"click": function(){
		$("ul.nav-tabs li a").removeClass("active")
		$(this).find("a").addClass("active")
		var idx = $(this).index()
		
		$("#tab-content .tab").addClass("d-none")
		$("#tab-content .tab").eq(idx).removeClass("d-none")
		
		if( idx==0 )		department()
		else if( idx==1 )	hirement()
	},
	"mouseover": function(){
		$(this).addClass("shadow")		
	},
	"mouseleave": function(){
		$(this).removeClass("shadow")		
	},
})

$(function(){
	$("ul.nav-tabs li").eq(1).trigger("click")
})

$("[name=chart]").change(function(){
	department()
})

function initCanvas(){
	$("#legend").remove()
	$("canvas#chart").remove()
	$("#tab-content").append( `<canvas id="chart" class="h-100 m-auto pt-3"></canvas>` )
}

//부서별 사원수 시각화
function department(){
	initCanvas()
	
	//sampleChart()
	$.ajax({
		url: "department"
	}).done(function( response ){
		console.log( response )
		var info = {}
		info.category = [], info.datas = [], info.colors = []
		$(response).each(function(){
			//[120, 190, 30, 50, 20, 30,100]
			//['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange', 'Gray']
			info.category.push( this.DEPARTMENT_NAME ) //x축 표현할 범주(부서명)
			info.datas.push( this.COUNT )  //차트에 표현할 데이터(부서원수)
			info.colors.push( colors[  Math.floor(this.COUNT/10)  ] )
		})
		console.log('info> ', info)
		
		if( $("[name=chart]:checked").val() == "bar" )
			barChart( info )
		else 
			donutChart( info )
		//lineChart( info )
	})
}

function donutChart( info ){
	$("#tab-content").css("height", "600")
	//도넛그래프에 각 데이터에 대한 백분율
	var sum = 0;
	$(info.datas).each(function(){ sum += this })
	info.pct = info.datas.map( function( data ){  return Math.round(data/sum*10000)/100 } )
	console.log( info )
	
	new Chart( $("#chart"), {
		type: 'doughnut',
		data: {
			labels: info.category,
			datasets: [{
				label: "부서원수",
				data: info.datas,
				
			}]
		},
		options: {
			layout: { padding : { top: 30 } },
			plugins: {
				autocolors: { mode: "data" },
				datalabels: { //info.pct[item.dataIndex]
					formatter: function(v, item){ 
						//console.log('item>',item);
						var pct = info.pct[item.dataIndex];
						return `\${v}명\n(\${pct}%)` 
					},
					anchor: 'middle',
				}
				
			},
			cutout: "60%"  //  안쪽 구멍 크기 ( 0: 파이그래프)
		}
	} )
	
}

function lineChart( info ){
	new Chart( $("#chart"), {
		type: "line",
		data: {
			labels: info.category,
			datasets: [ { 
				label: "부서원수",
				data: info.datas,
				borderColor: "#0000ff",
				pointRadius: 5,
				pointBackgroundColor: "#ff0000"
			} ]
		},
		options: {
			layout: { padding: { top:30 } },
			plugins: {
				datalabels : {
					formatter: function(v){ return v + '명' }
				},
				legend: { display: false }
			},
			scales: {
				y: {
					title: { text: "부서별 사원수", display: true }
				}
			}
		}		
	})
}

// 10 미만은 첫번째색, 20 미만은 두번째 색, ...
// 0~9: 0, 10~19: 1, 20~29: 2
function makeLegend(){
	var tag = 
	`<ul class="row d-flex justify-content-center mt-5" id="legend">`;
	
	var no;
	for(no=0; no<=4; no++){
		tag += `<li class="col-auto"><span></span>\${no*10}~\${no*10+9}명</li>`;
	}
	
	tag +=
	`	
		<li class="col-auto"><span></span>${(no+1)*10}명 이상</li>
	</ul>	
	`;
	$("#tab-content").after( tag )
	$("#legend span").each(function(idx){
		$(this).css("background-color", colors[idx])
	})
}

function barChart( info ){
	new Chart( $("#chart"), {
		type: "bar",
		data: {
			labels: info.category,
			datasets:[{
		        label: '부서원수',  //범례
		        data: info.datas,
		        borderWidth: 2,
		        barPercentage : 0.5,
		        backgroundColor: info.colors,
		      }] 
		},
		options: {
			scales:{
				y: {
					title: { text:"부서별 사원수", display: true }
				}
			},
			layout : { 
				padding: { top: 30 }
			},
			plugins: {
				//autocolors: { mode: 'data' }, //각 데이터마다 자동색상 적용
				legend: { display: false },
				datalabels: {
					formatter: function( value ){
						return `\${value}명`;
						//return value + "명";
					}
				}
			}
		}
		
	})
	makeLegend()
}

var colors = [ "#e83d31", "#59e82a", "#025c0f", "#0956b5", "#a806ba", "#fa022c"
			 , "#05fccf", "#cbfc05", "#1b06d1", "#701604", "#45024a", "#0c7ef7"  ]

$("[name=unit], #top3").change(function(){

	if( $("[name=unit]:checked").val()=="year" ){ //년도별 선택한 경우만
		$(".year-range").removeClass("d-none")
	}else{
		$(".year-range").addClass("d-none")
	}
	hirement_chart()
})

//년도 범위의 끝년도 기준: 올해
var thisYear = new Date().getFullYear()
$("#end").yearpicker({
	year: thisYear,
	startYear: thisYear-50 ,  //50년 전
    endYear: thisYear, 
})
$("#begin").yearpicker({
	year: thisYear-9,
	startYear: thisYear-50 ,  //50년 전
    endYear: thisYear, 
})

function hirement_chart(){
	if( $("#top3").prop("checked") )
		hirement_top3()
	else
		hirement()
}

$(document)
.on( "click", ".yearpicker-items", function(){
	if( $("#begin").val() > $("#end").val() )  $("#begin").val(  $("#end").val()  )
	
	hirement_chart()
})


//TOP3부서의 년도별/월별 채용인원수 시각화
function hirement_top3(){
	initCanvas()

	var unit = $("[name=unit]:checked").val()
	
	$.ajax({
		url: "hirement/top3/" + unit,
		data: { begin: $("#begin").val(), end: $("#end").val() }
		
	}).done(function( response ){
		console.log( response )
		var info = {}
		info.category = response.unit, info.datas = [], info.label = []
		, info.type =  unit=="year" ? "bar" : "line"
		, info.title = "상위3위 부서의 " +  (unit=="year" ? "년도별 채용인원수" : "월별 채용인원수");
		
		$(response.list).each( function(idx, item){
			info.label.push( this.DEPARTMENT_NAME )
			var datas = info.category.map( function(data){
				return item[ data ]
			})
			info.datas.push( datas )
		})
		console.log( 'info>', info)		
		top3Chart( info )
	})
}


//상위3위 부서의 년도별/월별 채용인원수 시각화
function top3Chart( info ){
	initCanvas()
	
	//각 부서별 데이터 수집
	var datas = []
	for( var idx=0; idx<info.label.length; idx++ ){
		var department = {}
		department.data = info.datas[idx]
		department.label = info.label[idx]
		department.backgroundColor = colors[idx] //부서별로 색상 구분
		department.borderColor = colors[idx]
		datas.push( department )
	}
	console.log( 'datas> ',datas )
	
	new Chart( $("#chart"), {
		type : info.type,
		data : {
			labels: info.category,
			datasets: datas
		},
		options: {
			layout: { padding: { top: 30, bottom: 20 } },
			plugins: {
				datalabels: {
					formatter: function(v){
						return v==0 ? '' : v+'명'
					}
				},
				legend: { display: true },
			},
			scales: {
				y: { title: { text: info.title, display: true } }
			}
		}
	})
}

//년도별/월별 채용인원수 시각화
function hirement(){
	initCanvas()
	var unit = $("[name=unit]:checked").val()
	
	$.ajax({
		url: "hirement/" + unit,
		data: { begin: $("#begin").val(), end: $("#end").val() }
		
	}).done(function( response ){
		var info = new Object();
		info.datas = new Array(), info.category = [], info.color = [];
		$(response).each(function(){
			info.datas.push( this.COUNT )
			info.category.push( this.UNIT )
			info.color.push( colors[ Math.floor(this.COUNT/10) ] )
		})
		info.title = `\${unit == 'year' ? '년도별' : '월별'} 채용인원수`;
		unitChart( info )
	})
}

function unitChart( info ){
	console.log( info )
	new Chart( $("#chart"), {
		type: "bar",
		data: {
			labels: info.category, //x축에 표현할 라벨
			datasets: [ {
				data: info.datas,  //그래프 그릴 데이터
				barPercentage: 0.5, //막대의 너비
				backgroundColor: info.color //각 막대의 배경색(데이터를 기준)
			} ]
		},
		options: {
			layout: { padding: { top:30 } }, //캔버스내부 위쪽여백 
			plugins: {
				datalabels: {
					formatter: function(v){ return `\${v}명` } //막대위쪽에 데이터표시
				},
				legend: { display: false } //원래 범례 안보이게
			},
			scales: {
				y: { title: { text: info.title, display: true } } //y축에 제목보이게
			}
		}
	} )
	makeLegend()
	
}

Chart.defaults.font.size = 16;
Chart.defaults.set( "plugins.legend", { position: "bottom" } )
Chart.register(ChartDataLabels);
Chart.defaults.set( "plugins.datalabels", { 
		color: "#000",
		font: { weight: "bold" },
		anchor: "end",	//데이터위치
		align: "start",	//앵커를 기준으로 한 위치
		offset: -25,	//얼마나 떨어져있게 할 건지
} )
Chart.register( window['chartjs-plugin-autocolors'] );

function sampleChart(){
	//https://chartjs.org/
	  var ctx = $("#chart") //document.getElementById('chart');

	  new Chart(ctx, {
	    type: 'bar',
	    data: {
	      labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange', 'Gray'], //x축 라벨
	      datasets: [{
	        label: '# of Votes',  //범례
	        data: [120, 190, 30, 50, 20, 30,100], //표현할 데이터값
	        borderWidth: 2
	      }]
	    },
	    options: {
    	 plugins: {
             legend: {
                 labels: {
                     font: {
                         size: 14
                     }
                 }
             }
         },	    	
	      scales: {
	        y: {
	          beginAtZero: false
	        }
	      },
	    }
	  });	
}
</script>

</body>
</html>