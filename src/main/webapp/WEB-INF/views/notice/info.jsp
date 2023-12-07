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
<h3 class="my-4">${vo.indent == 0 ? "공지글" : "답글" } 안내</h3>
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
		<c:if test="${ not empty vo.filename }">
		<div class="col-auto gap-3 d-flex align-items-center">
			<span class="file-name">${vo.filename}</span>
			<i role="button" class="file-download fs-3 fa-solid fa-file-arrow-down"></i>
		</div>
		</c:if>
	</td>
</tr>
</table>

<c:set var="params" value="curPage=${page.curPage}&search=${page.search}&keyword=${page.keyword}"/>
<div class="btn-toolbar gap-2 justify-content-center my-3">
	<button class="btn btn-primary" 
			onclick="location='<c:url value="/notice/list?${params}"/>'">공지글목록</button>
	<!-- 로그인한 사용자가 작성한 경우만 수정/삭제 가능 -->
	<c:if test="${loginInfo.userid eq vo.writer }">
	<button class="btn btn-warning" 
			onclick="location='modify?id=${vo.id}&${params}'">정보수정</button>
	<button class="btn btn-danger"
	  		onclick="if( confirm('이 공지글 정말 삭제?') ){ location='delete?id=${vo.id}&${params}' }" >정보삭제</button>
	</c:if>
	<!-- 로그인된 경우는 답글쓰기 가능 -->
	<c:if test="${ ! empty loginInfo }">
	<a class="btn btn-primary" 
			href="<c:url value='/notice/reply/new?id=${vo.id}&${params}'/>">답글쓰기</a>
	</c:if>
	
</div>
<jsp:include page="/WEB-INF/views/include/modal_image.jsp"/>

<script>
//첨부파일 다운로드
$('.file-download').click(function(){
	location = "download?id=${vo.id}";
})

// 첨부된 파일이 이미지이면 미리보기되게하기
$(function(){
	if( isImage("${vo.filename}") ){
		$('.file-name').after(
				"<span class='file-preview'><img src='${vo.filepath}'></span>" )
	}
	
	$('.file-preview img').click(function(){
		if( $('#modal-image').length==1 ){ //이미지띄울 모달이 있으면
			$('#modal-image .modal-body').html( $(this).clone() )
			new bootstrap.Modal(  $('#modal-image') ).show()	
		}
	})
	
})

//모달이미지 배경클릭시 이미지 삭제
$('#modal-image').click(function(){
	if( ! $(this).hasClass("show") ) 
		$('#modal-image .modal-body').empty()
})
</script>


</body>
</html>