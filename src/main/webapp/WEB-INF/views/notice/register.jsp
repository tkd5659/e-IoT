<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">공지글 쓰기</h3>

<form method="post" enctype="multipart/form-data" action="register">
<table class="table tb-row">
<colgroup><col width="180px"><col></colgroup>
<tr><th>제목</th>
	<td><input type="text" autofocus class="form-control check-empty" name="title" title="제목"></td>
</tr>
<tr><th>내용</th>
	<td><textarea name="content" class="form-control check-empty" title="내용"></textarea></td>
</tr>
<tr><th>첨부파일</th>
	<td><div class="row">
			<div class="col-auto d-flex gap-4 align-items-center ">
				<label>
					<input type="file" name="file" id="file-single">
					<i role="button" class="fs-3 fa-solid fa-file-circle-plus"></i>
				</label>
				<div class="d-flex gap-3 align-items-center" id="file-attach">
					<span class="file-name"></span>
					<i class="file-delete d-none fs-3 fa-regular fa-circle-xmark text-danger" role="button"></i>
				</div>
			</div>
		</div>
	</td>
</tr>
</table>
<input type="hidden" name="writer" value="${loginInfo.userid}">
</form>

<div class="btn-toolbar gap-2 justify-content-center my-3">
	<button class="btn btn-primary" id="btn-save">저장</button>
	<button class="btn btn-outline-primary" id="btn-cancel">취소</button>
</div>

<script>
$('#btn-cancel').on('click', function(){
	history.go(-1)	
})

$('#btn-save').click(function(){
	if( emptyCheck() )
		$('form').submit()
})

var singleFile = '';

</script>

</body>
</html>