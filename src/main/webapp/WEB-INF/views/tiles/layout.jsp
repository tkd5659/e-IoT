<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>

<c:choose>
	<c:when test="${category eq 'cu'}"><c:set var="title" value="- 고객관리"/></c:when>
	<c:when test="${category eq 'hr'}"><c:set var="title" value="- 사원관리"/></c:when>
	<c:when test="${category eq 'no'}"><c:set var="title" value="- 공지사항"/></c:when>
	<c:when test="${category eq 'bo'}"><c:set var="title" value="- 방명록"/></c:when>
	<c:when test="${category eq 'da'}"><c:set var="title" value="- 공공데이터"/></c:when>
	<c:when test="${category eq 'vi'}"><c:set var="title" value="- 시각화"/></c:when>
	<c:when test="${category eq 'change'}"><c:set var="title" value="- 비밀번호변경"/></c:when>
	<c:when test="${category eq 'join'}"><c:set var="title" value="- 회원가입"/></c:when>
</c:choose>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>e-IoT 융합SW ${title}</title>
    <!-- Favicon-->
    <link rel="icon" type="image/x-icon" href="<c:url value='/img/hanul.ico'/>" />
    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="<c:url value='/css/styles.css'/>?<%=new java.util.Date()%>" rel="stylesheet" />
    <link href="<c:url value='/css/common.css'/>?<%=new java.util.Date()%>" rel="stylesheet" />
    <link rel="stylesheet" 
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
    <script src="<c:url value='/js/common.js'/>?<%=new java.util.Date()%>"></script>
</head>
<body>
    <div class="d-flex" id="wrapper">
        <!-- Sidebar-->
        <div class="border-end bg-white" id="sidebar-wrapper">
            <div class="sidebar-heading border-bottom bg-light">
            	<a href="<c:url value='/'/>">
	            	<img class="me-2"  style="width:20%" src="<c:url value='/img/hanul.logo.png'/>">
	            	<span>e-IoT 융합SW</span>
            	</a>
			</div>
            <div class="list-group list-group-flush">
                <a class="${category eq 'cu'? 'active' : ''} list-group-item list-group-item-action list-group-item-light p-3 ps-4" 
                	href="<c:url value='/list.cu'/>">고객관리</a>
                <a href="<c:url value='/hr/list'/>" 
                class="${category eq 'hr' ? 'active' : ''} list-group-item list-group-item-action list-group-item-light p-3 ps-4">사원관리</a>
                <a href="<c:url value='/notice/list'/>" class="${category eq 'no' ? 'active' : ''} list-group-item list-group-item-action list-group-item-light p-3 ps-4">공지사항</a>
                <a href="<c:url value='/board/list'/>" class="${category eq 'bo' ? 'active' : ''} list-group-item list-group-item-action list-group-item-light p-3 ps-4">방명록</a>
                <a href="<c:url value='/data/list'/>" class="${category eq 'da' ? 'active' : ''} list-group-item list-group-item-action list-group-item-light p-3 ps-4">공공데이터</a>
                <a href="<c:url value='/visual/list'/>" class="${category eq 'vi' ? 'active' : ''} list-group-item list-group-item-action list-group-item-light p-3 ps-4">시각화</a>
            </div>
        </div>
        <!-- Page content wrapper-->
        <div id="page-content-wrapper">
            <!-- Top navigation-->
            <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
                <div class="container-fluid">
                    <button class="btn btn-primary" id="sidebarToggle">Toggle Menu</button>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav ms-auto mt-2 mt-lg-0">
                        
                        <!-- 로그인하지 않은 경우 -->
                        <c:if test="${empty loginInfo}">
                        <li class="nav-item">
                        	<a class="nav-link" href="<c:url value='/member/login'/>" >로그인</a>
                        </li>
                        <li class="nav-item">
                        	<a class="nav-link" href="<c:url value='/member/join'/>" >회원가입</a>
                        </li>
                        </c:if>

                        <!-- 로그인한 경우 -->
                        <!-- 프로필이미지 -->
                        <c:if test="${ not empty loginInfo }">
                        
                        <li class="nav-item dropdown me-5">
				          <a class="nav-link" role="button" id="comment-notify" 
				          	data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
				            <span><i class="fs-4 fa-regular fa-bell"></i></span>
				            <span class="notify"></span>
				          </a>
				          <div class="dropdown-menu dropdown-menu-end" id="dropdown-list">
				          </div>
				        </li>
                        
                        <li class="nav-item">
                        	<c:choose>
                        		<c:when test="${empty loginInfo.profile }">
		                        	<i class="font-profile fa-regular fa-circle-user"></i>
                        		</c:when>
                        		<c:otherwise>
		                        	<img class="profile" src="${loginInfo.profile}">
                        		</c:otherwise>
                        	</c:choose>
                        </li>
                        
                        <li class="nav-item dropdown">
                        	<a class="nav-link dropdown-toggle" href="" data-bs-toggle="dropdown"
                        			 aria-haspopup="true" aria-expanded="false">${loginInfo.name}</a>
                            <div class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            	<c:if test="${ empty loginInfo.social }">
                                <a class="dropdown-item">아이디: ${loginInfo.userid}</a>
                                <a class="dropdown-item" href="">My Page</a>
                                <a class="dropdown-item" href="<c:url value='/member/change'/>">비밀번호 변경</a>
                                <div class="dropdown-divider"></div>
                                </c:if>
                                <a class="dropdown-item" href="<c:url value='/member/logout'/>">로그아웃</a>
                            </div>
						</li>         
						</c:if>               
                        </ul>
                    </div>
                </div>
            </nav>
            <!-- Page content-->
            <div class="container-fluid pt-4">
               <tiles:insertAttribute name="container"/>
            </div>
            
            <footer class="border-top mt-4 py-4 text-center">
            	<div>Copyright &copy; 2023 e-IoT. All rights reserved.</div>
            </footer>
            
        </div>
    </div>
    
<script>
//댓글알림 종 클릭시
$("#comment-notify").click(function(){
	if( $(this).find(".notify").text() != "" ){ //미확인댓글수가 있는 경우만
		$.ajax({
			url: "<c:url value='/board/comment/notify'/>",
			data: { userid : "${loginInfo.userid}" }
		}).done(function( response ){
			$("#dropdown-list").html( response )
			//확인되었으니 수신자에게 전송
			commentSocket.send( `{ receiver: ${loginInfo.userid} }` );
		})
		
	}
})

$("#comment-notify").on("hide.bs.dropdown", function(){
	$("#dropdown-list").empty()
})


$(function(){
	//댓글소켓과 연결하기
	commentSocketConnect()
})

var commentSocket;

function commentSocketConnect(){
	var uri = "ws://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/commentSender";
				//"ws://localhost:8080/abc/commentSender";
	commentSocket = new WebSocket( uri );
	
	//소켓연결시 처리
	commentSocket.onopen = function(){
		$(".notify").removeClass("notify-on").empty();  //댓글수 표현할 곳
		//로그인된 경우 아이디전송
		if( ${!empty loginInfo} ){
			commentSocket.send( `{ receiver: "${loginInfo.userid}" }` )
		}
	}
	
	//메시지수신시 처리
	commentSocket.onmessage = function( e ){
		var data = JSON.parse(e.data )
		console.log('수신메시지> ', data )
		if( data.receiver == "${loginInfo.userid}"  ){
			if( data.comments==0 ){
				$(".notify").removeClass("notify-on").empty();
				$(".comment-fade").remove();
			}else{
				$(".notify").text( data.comments ).addClass("notify-on")
				//현재 방명록 목록화면이라면 해당 방명록글에 깜빡임처리
				//board_id 인 td를 알아야 함
				var _td = $(`td[data-id=\${data.board_id}]`)
				if( _td.find(".comment-fade").length == 0 ){
					_td.append( `<span class="comment-fade">
									<i class="text-danger fa-solid fa-comment-dots fa-fade"></i>
								</span>` )
				}
			}
		}
	}
	
}


</script>
    
    <!-- Bootstrap core JS-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Core theme JS-->
    <script src="<c:url value='/js/scripts.js'/>"></script>
</body>
</html>
