<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">고객정보수정</h3>

<form method="post" action="update.cu">
<input type="hidden" name="id" value="${vo.id }">
<table class="table tb-row">
	<colgroup>
		<col width="180px">
		<col>
	</colgroup>
	<tr><th>고객명</th>
		<td>
			<div class="row">
				<div class="col-auto">
					<input type='text' name="name" value="${vo.name }" class="form-control">
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<th>성별</th>
		<td>
			<div class="form-check form-check-inline">
			  <label>
				  <input class="form-check-input" ${vo.gender eq '남' ? 'checked' : ''} type="radio" name="gender" value="남">남
			  </label>
			</div>
			<div class="form-check form-check-inline">
			  <label>
				  <input class="form-check-input" <c:if test="${vo.gender eq '여'}">checked</c:if>  type="radio" name="gender" value="여">여
			  </label>
			</div>
		</td>
	</tr>
	<tr>
		<th>이메일</th>
		<td>
			<div class="row">
				<div class="col-auto">
					<input type='text' value="${vo.email }" name="email" class="form-control">
				</div>
			</div>		
		</td>
	</tr>
	<tr>
		<th>전화번호</th>
		<td>
			<div class="row">
				<div class="col-auto">
					<input type='text' value="${vo.phone }" name="phone" class="form-control">
				</div>
			</div>		
		</td>
	</tr>
</table>
<div class="btn-toolbar gap-2 justify-content-center my-3">
	<button class="btn btn-primary">저장</button>
	<button type="button" onclick="location='info.cu?id=${param.id}'" 
			class="btn btn-outline-primary">취소</button>
</div>
</form>

</body>
</html>












