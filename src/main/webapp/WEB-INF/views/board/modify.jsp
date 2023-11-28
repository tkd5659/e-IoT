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
<h3 class="my-4">방명록 수정</h3>

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
	<td><div>
			<label>
				<input type="file" name="file" id="file-multiple" multiple>
				<i role="button" class="fs-3 fa-solid fa-file-circle-plus"></i>
			</label>
		</div>
		
		<div class="form-control py-2 mt-2 file-drag">
			<!-- 첨부파일이 없는 경우 -->
			<c:if test="${empty vo.files}">
				<div class="py-3 text-center">첨부할 파일을 마우스로 끌어 오세요</div>
			</c:if>
			<!-- 첨부된 파일들 --> 
			<c:forEach items="${vo.files}" var="file" varStatus="s">
				<div class="d-flex gap-3 align-items-center file-item my-1" >
					<button class="btn-close small" data-seq="${s.index}"></button>
					<span class="file-name">${file.filename}</span>
				</div>
			</c:forEach>
		</div>
	</td>
</tr>
</table>
<input type="hidden" name="remove" >
<input type="hidden" name="id" value="${vo.id}">
<input type="hidden" name="curPage" value="${page.curPage}">
<input type="hidden" name="search" value="${page.search}">
<input type="hidden" name="keyword" value="${page.keyword}">
</form>

<div class="btn-toolbar gap-2 justify-content-center my-3">
	<button class="btn btn-primary" id="btn-save">저장</button>
	<button class="btn btn-outline-primary" id="btn-cancel">취소</button>
</div>

<script>
var fileList = new FileList();

// 이전에 첨부된 파일목록을 fileList에 담기
<c:forEach items="${vo.files}" var="file">
	fileList.setFile( urlToFile( "${file.filepath}", "${file.filename}" ), ${file.id} )
</c:forEach>
console.log( "files> ", fileList )

$('#btn-cancel').on('click', function(){
	history.go(-1)	
})

$('#btn-save').click(function(){
	if( emptyCheck() ){
		$('[name=remove]').val( fileList.info.removeId )
		//console.log( 'remove> ', $('[name=remove]').val()  )
		multipleFileUpload();
		$('form').submit()
	}
})

</script>

</body>
</html>