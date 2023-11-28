<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">방명록 목록</h3>

<form method="post" action="list">
<div class="row justify-content-between">
	<div class="col-auto">
		<div class="input-group">
			<select name="search" class="form-select">
				<option value="S1" ${page.search eq 'S1' ? 'selected' : ''}>전체</option>
				<option value="S2" <c:if test="${page.search eq 'S2' }">selected</c:if> >제목</option>
				<option value="S3" <c:if test="${page.search eq 'S3' }">selected</c:if>>내용</option>
				<option value="S4" ${page.search eq 'S4' ? 'selected' : ''}>작성자</option>
				<option value="S5" ${page.search eq 'S5' ? 'selected' : ''}>제목+내용</option>
			</select>
		
			<input type="text" name="keyword" value="${page.keyword }" class="form-control" 
								placeholder="검색어">
			<button class="btn btn-primary">
				<i class="fa-solid fa-magnifying-glass"></i>
			</button>
		</div>
	</div>
	
	<div class="col-auto d-flex gap-2">
		<div class="col-auto">
			<select name="pageList" class="form-select">
				<c:forEach var="i" begin="1" end="5">
				<option value="${i*10}">${i*10}개씩</option>
				</c:forEach>
			</select>
		</div>
		
		<!-- 로그인되어 있는 경우만 새글쓰기 가능 -->
		<c:if test="${ ! empty loginInfo }">
		<div class="col-auto">
			<a class="btn btn-primary" href="new">새글쓰기</a>
		</div>
		</c:if>
	</div>
</div>
<input type="hidden" name="curPage" value="1">
<input type="hidden" name="id">
</form>

<table class="table tb-list">
<colgroup><col width="100px"><col><col width="120px"><col width="120px"><col width="90px">
</colgroup>
<thead><tr><th>번호</th><th>제목</th><th>작성자</th><th>작성일자</th><th>조회수</th><th>댓글수</th></tr></thead>
<tbody>
	<c:if test="${empty page.list}">
	<tr><td colspan="5">공지글이 없습니다</td></tr>
	</c:if>
	<c:forEach items="${page.list }" var="vo">
	<tr><td>${vo.no}</td>
		<td class="text-start" data-id="${vo.id}">
			<a href="javascript:info(${vo.id})">${vo.title}</a>
			${vo.filecnt eq 0 ? "" : '<i class="fa-solid fa-paperclip"></i>' }
			<c:if test="${  vo.notifycnt > 0 and loginInfo.userid eq vo.writer }">
			<span class="comment-fade">
			<i class="text-danger fa-solid fa-comment-dots fa-fade"></i>
			</span>
			</c:if>
		</td>
		<td>${vo.name }</td>
		<td>${vo.writedate }</td>
		<td>${vo.readcnt }</td>
		<td>${vo.commentcnt }</td>
	</tr>
	</c:forEach>
</tbody>
</table>

<jsp:include page="/WEB-INF/views/include/page.jsp"/>

<script>
$('[name=pageList]').change(function(){
	$('form').submit()
})

$("[name=pageList]").val( ${page.pageList} ).prop("selected", true)

function info( id ){
	$('[name=id]').val( id )
	$('[name=curPage]').val( ${page.curPage} )
	$('form').attr('action', 'info').submit()
}
</script>

</body>
</html>









