<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">공공데이터</h3>
	
<ul class="nav nav-pills gap-3 justify-content-center mb-3">
  <li class="nav-item" role="button">
    <a class="nav-link active">약국조회</a>
  </li>
  <li class="nav-item" role="button">
    <a class="nav-link">유기동물조회</a>
  </li>
  <li class="nav-item" role="button">
    <a class="nav-link">조회3</a>
  </li>
  <li class="nav-item" role="button">
    <a class="nav-link">조회4</a>
  </li>
</ul>

<div class="row justify-content-between my-3">
	<div class="col-auto d-flex gap-2 animal-top">
		<select class="form-select w-px160" id="upkind"> 
			<option value="">축종 선택</option>
			<option value="417000">개</option>
			<option value="422400">고양이</option>
			<option value="429900">기타</option>
		</select>
	</div>
	<div class="col-auto d-flex gap-2">
		<div class="col-auto">
			<select id="pageList" class="form-select">
				<c:forEach var="i" begin="1" end="5">
				<option value="${i*10}">${i*10}개씩</option>
				</c:forEach>
			</select>
		</div>
	</div>
</div>

<div id="data-list"></div>

<jsp:include page="/WEB-INF/views/include/modal_image.jsp"/>
<!-- <div id="modal-map" style="width:668px; height:700px;"></div> -->

<script type="text/javascript" 
	src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=3n13cy7hca"></script>
<script type="text/javascript" 
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=cdb5e012f31b5abd66e04c6d2450c34d"></script>
<script src="<c:url value='/js/animal.js'/>?<%=new java.util.Date()%>"></script>

<script>
$(function(){
	$("ul.nav-pills li").eq(1).trigger("click")	
})

$(document)
.on( "click", ".pagination a", function(){
	if( ! $(this).hasClass("active") ){
		
		if( $("table.pharmacy").length > 0 ){
			pharmacy_list( $(this).data("page") )
			
		}else if( $("table.animal").length > 0 ){
			animal_list( $(this).data("page") )
			
		}
	}
})
.on( "click", ".map", function(){
	if( $(this).data("x") == "undefined" || $(this).data("y") == "undefined" ){
		alert("위경도가 없어 위치를 표시할 수 없습니다")
	}else{
		//showKakaoMap( $(this) );
 		showNaverMap( $(this) );
	}
})


//네이버지도
function showNaverMap( point ){
	// id: x7bt36i7uw
	// secret: ee7cFmkwFBq7CPegVPA31GRY0BvoKtbtx9pzmBvJ
	$("#modal-image .modal-body").empty()
	
	$("#modal-image").after( `<div id="modal-map" style="width:668px; height:700px;"></div>` );
	var xy = new naver.maps.LatLng( Number(point.data("y")), Number(point.data("x")) );
	
	var map = new naver.maps.Map('modal-map', {
	    center: xy,
	    zoom: 15
	});
/*
	var mapOptions = {
	    center: xy,
	    zoom: 10
	};
	var map = new naver.maps.Map('modal-map', mapOptions);
*/
	
	var marker = new naver.maps.Marker({
	    position: xy,
	    map: map
	});

	var name = point.text()
	var infowindow = new naver.maps.InfoWindow({
	    content: `<div class="fw-bold p-2 text-danger">\${name}</div>` 
	});
	infowindow.open(map, marker);
	
	//모달창에 지도를 띄우도록 modal-map 의 지도를 옮긴다
	$("#modal-image .modal-body").html( $("#modal-map") );
	new bootstrap.Modal( $("#modal-image") ).show()
	
}


//카카오지도
function showKakaoMap( point ){
	//console.log( point.data("x"), point.data("y"), point.text())
	$("#modal-image .modal-body").empty()
	
	$("#modal-image").after( `<div id="modal-map" style="width:668px; height:700px;"></div>` );
	
	var container = document.getElementById('modal-map'); //지도를 담을 영역의 DOM 레퍼런스
	var xy = new kakao.maps.LatLng( Number(point.data("y")), Number(point.data("x")) );
	var options = { //지도를 생성할 때 필요한 기본 옵션
		center: xy, //지도의 중심좌표(위경도)
		level: 4 //지도의 레벨(확대, 축소 정도)
	};

	var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
	
	// 마커를 생성합니다
	var marker = new kakao.maps.Marker({
	    position: xy
	});

	// 마커가 지도 위에 표시되도록 설정합니다
	marker.setMap(map);

	// 인포윈도우를 생성합니다
	var name = point.text()
	var infowindow = new kakao.maps.InfoWindow({
	    position : xy, 
	    content : `<div class="fw-bold p-2 text-danger">\${name}</div>` 
	});
	  
	// 마커 위에 인포윈도우를 표시합니다. 두번째 파라미터인 marker를 넣어주지 않으면 지도 위에 표시됩니다
	infowindow.open(map, marker); 
	
	//모달창에 지도를 띄우도록 modal-map 의 지도를 옮긴다
	$("#modal-image .modal-body").html( $("#modal-map") );
	new bootstrap.Modal( $("#modal-image") ).show()
}

/*  
$("ul.nav-pills li").click(function(){
	$("ul.nav-pills li a").removeClass("active")
	$(this).children("a").addClass("active")
	var idx = $(this).index()
	if( idx == 0 ) 			pharmacy_list()
	else if( idx == 1 ) 	animal_list()
})
*/

function animal_top(){
	$(".animal-top #upkind").addClass("d-none")
	$(".animal-top #sido").remove()	
	$(".animal-top #sigungu").remove()	
	$(".animal-top #shelter").remove()	
	$(".animal-top #kind").remove()	
}

$("ul.nav-pills li").on( { 
	"click": function(){
		$("ul.nav-pills li a").removeClass("active")
		$(this).children("a").addClass("active")
		var idx = $(this).index()
		animal_top()			//유기동물관련 선택태그부분처리
		if( idx == 0 ) 			pharmacy_list( 1 )
		else if( idx == 1 ) 	animal_list( 1 )		
	},
	
	"mouseover": function(){
		$(this).addClass( "shadow" )
	},
	
	"mouseleave": function(){
		$(this).removeClass( "shadow" )
	}
} )


//약국목록 조회
function pharmacy_list( pageNo ){
	$(".pagination").closest("nav").remove();
	
	var table = 
	`<table class="pharmacy table tb-list">
		<colgroup><col width="300px"><col width="160px"><col></colgroup>
		<thead><tr><th>약국명</th><th>전화번호</th><th>주소</th></tr></thead>
		<tbody></tbody>
	</table>
	`;
	$("#data-list").html( table )
	$.ajax({
		url: "<c:url value='/data/pharmacy'/>",
		data: { pageNo: pageNo, rows: page.pageList }
	}).done(function( response ){
		console.log( response.response.body )
		response = response.response.body
		table = '';
		$( response.items.item ).each(function(){
			table += 
			`<tr><td><a class="text-link map" data-x="\${this.XPos}" data-y="\${this.YPos}" >\${this.yadmNm}</a></td>
				 <td>\${this.telno ? this.telno : '-'}</td>
				 <td class="text-start">\${this.addr}</td>
			 </tr>
			`;
		})
		$("#data-list .pharmacy tbody").html( table )
		
		//페이지만들기
		makePage( response.totalCount, pageNo );
	})

}

$("#pageList").change(function(){
	page.pageList = $(this).val();
	pharmacy_list( 1 )
})


var page = { pageList:10,  blockPage:10 }

//페이지만들기
function makePage(  totalList, curPage ){
	page.totalList = totalList;
	page.curPage = curPage;
	page.totalPage = Math.ceil( totalList / page.pageList );
	page.totalBlock = Math.ceil( page.totalPage / page.blockPage );
	page.curBlock = Math.ceil( page.curPage / page.blockPage );
	page.endPage = page.curBlock * page.blockPage;
	page.beginPage = page.endPage - (page.blockPage-1);
	if( page.endPage > page.totalPage ) page.endPage = page.totalPage;
	var prev = page.curBlock == 1 ? "d-none" : "";
	var next = page.curBlock < page.totalBlock ? "" : "d-none";
	
var nav =
`
<nav>
	<ul class="pagination justify-content-center mt-4">
		<li class="page-item \${prev}"><a class="page-link" data-page="1"><i class="fa-solid fa-angles-left"></i></a></li>
		<li class="page-item \${prev}"><a class="page-link" data-page="\${page.beginPage-page.blockPage}"><i class="fa-solid fa-angle-left"></i></a></li>
`;

	for( var no = page.beginPage; no<=page.endPage; no++ ){
nav +=
`			
		<li class="page-item">
		\${ no == page.curPage  
			? `<a class="page-link active" >\${no}</a>`
			: `<a class="page-link" data-page="\${no}">\${no}</a>`
		 }
		</li>
`;				
	}
		
nav += 
`	
		<li class="page-item \${next}"><a class="page-link" data-page="\${page.endPage+1}"><i class="fa-solid fa-angle-right"></i></a></li>
		<li class="page-item \${next}"><a class="page-link" data-page="\${page.totalPage}"><i class="fa-solid fa-angles-right"></i></a></li>
	</ul>
</nav>
`;	

$("#data-list").after( nav )
	
}

</script>
	
</body>
</html>