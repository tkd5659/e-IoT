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
				<h5 class="mb-5">죄송합니다.<br>내부적인 오류가 발생했습니다</h5>
				<p>관련 문의사항은 고객센터에 알려주시면 친절하게 안내해 드리겠습니다.</p>
				<p>감사합니다.</p>
				<hr>
				${error}
				<c:if test="${code==405}"><p>${method}방식으로 요청할 수 없습니다</p></c:if>
				<c:if test="${code==400}"><p>파라미터의 타입이 올바르지 않습니다</p></c:if>
            </div>
        </div>
    </div>
</div>

</body>
</html>