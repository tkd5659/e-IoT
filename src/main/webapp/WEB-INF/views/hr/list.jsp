<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-3">사원목록</h3>

<form method="post" action="list">
<div class="row justify-content-between">
	<div class="col-auto d-flex align-items-center">
		<label class="me-2">부서명</label>
		<select name="department_id" class="form-select col" onchange="submit()">
			<option value="-1">전체</option>
			<c:forEach items="${departments}" var="d">
			<option ${d.department_id eq department_id ? 'selected': ''} 
				value="${d.department_id}">${d.department_name }</option>
			</c:forEach>
		</select>
	</div>
	<div class="col-auto">
<!-- 		<button type="button" onclick="location='register'" class="btn btn-primary">사원등록</button> -->
		<a class="btn btn-primary" href="register">사원등록</a>
	</div>
</div>
</form>

<table class="table tb-list">
<colgroup>
	<col width="100px">
	<col width="200px">
	<col width="250px">
	<col>
	<col width="120px">
</colgroup>
<thead>
	<tr><th>사번</th>
		<th>사원명</th>
		<th>부서</th>
		<th>업무</th>
		<th>입사일자</th>
	</tr>
</thead>
<tbody>
	<c:forEach items="${list }" var="vo">
	<tr><td>${vo.employee_id }</td>
<%-- 		<td>${vo.last_name } ${vo.first_name }</td> --%>
		<td><a class="text-link" href="info?id=${vo.employee_id }">${vo.name }</a></td>
		<td>${vo.department_name }</td>
		<td>${vo.job_title }</td>
		<td>${vo.hire_date }</td>
	</tr>
	</c:forEach>
</tbody>
</table>


</body>
</html>






