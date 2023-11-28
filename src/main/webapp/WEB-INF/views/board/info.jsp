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
<h3 class="my-4">방명록 안내</h3>
<table class="table tb-row">
<colgroup><col width="180px"><col>
		<col width="180px"><col width="180px">
		<col width="100px"><col width="100px">
</colgroup>
<tr><th>제목</th>
	<td colspan="5">${vo.title}</td>
</tr>
<tr><th>작성자</th>
	<td>${vo.name }</td>
	<th>작성일자</th>
	<td>${vo.writedate }</td>
	<th>조회수</th>
	<td>${vo.readcnt }</td>
</tr>
<tr><th>내용</th>
	<td colspan="5">${fn: replace(vo.content, crlf, "<br>") }</td> <!-- 개행처리 -->
</tr>
<tr><th>첨부파일</th>
	<td colspan="5">
	<c:forEach items="${vo.files}" var="file">
		<div class="row">
			<div class="col-auto gap-3 d-flex align-items-center my-1">
				<span class="file-name">${file.filename}</span>
				<i role="button" data-file="${file.id}" class="file-download fs-3 fa-solid fa-file-arrow-down"></i>
			</div>
		</div>
	</c:forEach>
	</td>
</tr>
</table>

<div class="btn-toolbar gap-2 justify-content-center my-3">
	<button class="btn btn-primary" id="btn-list" >방명록 목록</button>
	<!-- 로그인한 사용자가 작성한 경우만 수정/삭제 가능 -->
	<c:if test="${loginInfo.userid eq vo.writer }">
	<button class="btn btn-warning" id="btn-modify">정보수정</button>
	<button class="btn btn-danger" id="btn-delete" >정보삭제</button>
	</c:if>
</div>

<jsp:include page="/WEB-INF/views/include/modal_image.jsp"/>
<jsp:include page="comment.jsp"/>

<form method="post">
<input type="hidden" name="id" value="${vo.id}">
<input type="hidden" name="curPage" value="${page.curPage}">
<input type="hidden" name="search" value="${page.search}">
<input type="hidden" name="keyword" value="${page.keyword}">
<input type="hidden" name="pageList" value="${page.pageList}">
<input type="hidden" name="file">
<input type="hidden" name="url" value="board/info">
</form>



<script>

// 첨부된 파일에 이미지파일이 있는 경우 미리보기태그 넣기
<c:forEach items="${vo.files}" var="file" varStatus="status">
if( isImage( "${file.filename}" ) ){
	$('.file-name').eq(${status.index}).after( "<span class='file-preview'><img src='${file.filepath}'></span>" )
}
</c:forEach>


$('.file-download').click(function(){
	$('[name=file]').val( $(this).data('file') )
	$('form').attr('action', 'download').submit()
})


$('#btn-list, #btn-modify, #btn-delete').click(function(){
	var action = $(this).attr('id')
	action = action.substr( action.indexOf('-')+1 ) 
	if( action=='delete' ){
		if( confirm('이 방명록 글을 삭제하시겠습니까?') ){
			$('form').attr('action', action ).submit()
		}
	}else{
		$('form').attr('action', action ).submit()
	}
})
</script>


</body>
</html>