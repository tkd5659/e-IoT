<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">공지사항 수정</h3>

<form method="post" enctype="multipart/form-data" action="update">
<table class="table tb-row">
<colgroup><col width="180px"><col></colgroup>
<tr><th>제목</th>
	<td><input type="text" value="${fn: escapeXml(vo.title) }"  autofocus class="form-control check-empty" name="title" title="제목"></td>
</tr>
<tr><th>내용</th>
	<td><textarea name="content" 
			class="form-control check-empty" title="내용">${vo.content}</textarea></td>
</tr>
<tr><th>첨부파일</th>
	<td><div class="row">
			<div class="col-auto d-flex gap-4 align-items-center ">
				<label>
					<input type="file" name="file" id="file-single">
					<i role="button" class="fs-3 fa-solid fa-file-circle-plus"></i>
				</label>
				<div class="d-flex gap-3 align-items-center" id="file-attach">
					<span class="file-name">${vo.filename}</span>
					<i class="file-delete ${empty vo.filename ? 'd-none' : ''} fs-3 fa-regular fa-circle-xmark text-danger" role="button"></i>
				</div>
			</div>
		</div>
	</td>
</tr>
</table>
<input type="hidden" name="id" value="${vo.id}">
<input type="hidden" name="filename">
<input type="hidden" name="curPage" value="${page.curPage}">
<input type="hidden" name="search" value="${page.search}">
<input type="hidden" name="keyword" value="${page.keyword}">
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
	$('[name=filename]').val( $('.file-name').text() )
	if( emptyCheck() ){
		singleFileUpload()
		$('form').submit()
	}
})

var singleFile = '';

</script>

</body>
</html>