<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">고객목록</h3>

<form method="post" action="list.cu">
<div class="row justify-content-between">
	<div class="col-auto">
		<div class="input-group mb-3">
		  <input type="text" name="name" value="${name }" class="form-control" placeholder="고객명">
		  <button class="btn btn-primary" >
		  	<i class="fa-solid fa-magnifying-glass"></i>
		  </button>
		</div>		
	</div>

	<div class="col-auto">
		<button type="button" class="btn btn-primary" onclick="location='new.cu'">고객등록</button>
	</div>
</div>
</form>

<table class="table tb-list">
<thead><tr><th>고객명</th><th>이메일</th></tr></thead>
<tbody>
	<c:forEach items="${list }" var="vo">
	<tr><td><a class="text-link" href="info.cu?id=${vo.id }">${vo.name }</a></td>
		<td>${vo.email }</td>
	</tr>
	</c:forEach>
</tbody>
</table>

</body>
</html>