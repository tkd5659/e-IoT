<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<div class="row justify-content-center">
    <div class="col-lg-5">
        <div class="card shadow-lg border-0 rounded-lg mt-5">
            <div class="card-header">
            <h3 class="text-center">
            	<a href="<c:url value='/'/>"><img src="<c:url value='/img/hanul.logo.png'/>"></a>
            </h3></div>
            <div class="card-body">
				<h5 class="mb-5">죄송합니다.<br>요청하신 페이지를 찾을 수 없습니다.</h5>
				
				<p>방문하시려는 페이지의 주소가 잘못 입력되었거나,</p>
				<p>페이지의 주소가 변경 혹은 삭제되어 요청하신 페이지를 찾을 수 없습니다.</p>
				<p>입력하신 주소가 정확한지 다시 한번 확인해 주시기 바랍니다.</p>
				<p>관련 문의사항은 고객센터에 알려주시면 친절하게 안내해 드리겠습니다.</p>
				<p>감사합니다.</p>
				
            </div>
        </div>
    </div>
</div>

</body>
</html>