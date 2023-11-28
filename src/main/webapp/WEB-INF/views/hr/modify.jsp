<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-3">사원정보수정</h3>
<form method="post" action="update">
<input type="hidden" name="employee_id" value="${vo.employee_id}">
<table class="table tb-row">
<colgroup><col width="160px"><col></colgroup>
<tr><th>사번</th>
	<td>${vo.employee_id }</td>
</tr>
<tr><th>사원명</th>
	<td>
		<div class="row">
			<div class="col-auto">
				<input type="text" placeholder="성" class="form-control" name="last_name" value="${vo.last_name }"> 
			</div>
			<div class="col-auto">
				<input type="text" placeholder="명" class="form-control" name="first_name" value="${vo.first_name }">
			</div>
		</div>
	</td>
</tr>
<tr><th>이메일</th>
	<td><div class="row">
			<div class="col-auto">
				<input type="text" class="form-control" name="email" value="${vo.email }">
			</div>
		</div>
	</td>
</tr>
<tr><th>전화번호</th>
	<td><div class="row">
			<div class="col-auto">
				<input type="text" class="form-control" name="phone_number" value="${vo.phone_number }">
			</div>
		</div> 
	</td>
</tr>
<tr><th>급여</th>
	<td><div class="row">
			<div class="col-auto">
				<input type="text" class="form-control" name="salary" value="${vo.salary }">
			</div>
		</div>
	</td>
</tr>
<tr><th>입사일자</th>
	<td><div class="row">
			<div class="col-auto">
				<input type="text" class="form-control date" name="hire_date" value="${vo.hire_date }">
			</div>
		</div>
	</td>
</tr>
<tr><th>부서</th>
	<td><div class="row">
			<div class="col-auto">
			<select name="department_id" class="form-select">
				<option value="-1">소속없음</option>
				<c:forEach items="${departments}" var="d">
				<option value="${d.department_id }"
					<c:if test="${d.department_id eq vo.department_id}">selected</c:if>
					>${d.department_name}</option>
				</c:forEach>
			</select>
			</div>
		</div>
	</td>
</tr>
<tr><th>업무</th>
	<td><div class="row">
			<div class="col-auto">
			<select name="job_id" class="form-select">
				<c:forEach items="${jobs}" var="j">
				<option value="${j.job_id }" ${vo.job_id eq j.job_id ? "selected" : ""} >${j.job_title}</option>
				</c:forEach>
			</select>
			</div>
		</div>
	</td>
</tr>
</table>
</form>

<div class="btn-toolbar gap-2 justify-content-center my-3">
	<button class="btn btn-primary" onclick="$('form').submit()">저장</button>
	<button class="btn btn-outline-primary" onclick="location='info?id=${vo.employee_id}'">취소</button>
</div>

</body>
</html>