<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">공지글 목록</h3>

<form method="post" action="list">
<div class="row justify-content-between">
	<div class="col-auto">
		<div class="input-group">
			<select name="search" class="form-select">
				<option value="all" ${page.search eq 'all' ? 'selected' : ''}>전체</option>
				<option value="title" <c:if test="${page.search eq 'title' }">selected</c:if> >제목</option>
				<option value="content" <c:if test="${page.search eq 'content' }">selected</c:if>>내용</option>
				<option value="writer" ${page.search eq 'writer' ? 'selected' : ''}>작성자</option>
				<option value="tc" ${page.search eq 'tc' ? 'selected' : ''}>제목+내용</option>
			</select>
		
			<input type="text" name="keyword" value="${page.keyword }" class="form-control" 
								placeholder="검색어">
			<button class="btn btn-primary">
				<i class="fa-solid fa-magnifying-glass"></i>
			</button>
		</div>
	</div>
	
	<!-- 관리자로 로그인되어 있는 경우만 새글쓰기 가능 -->
	<c:if test="${loginInfo.role eq 'ADMIN'}">
	<div class="col-auto">
		<a class="btn btn-primary" href="new">새글쓰기</a>
	</div>
	</c:if>
</div>
<input type="hidden" name="curPage" value="1">
</form>

<c:set var="params" value="curPage=${page.curPage}&search=${page.search}&keyword=${page.keyword}"/>
<table class="table tb-list">
<colgroup><col width="100px"><col><col width="120px"><col width="120px"><col width="90px">
</colgroup>
<thead><tr><th>번호</th><th>제목</th><th>작성자</th><th>작성일자</th><th>첨부파일</th></tr></thead>
<tbody>
	<c:if test="${empty page.list}">
	<tr><td colspan="5">공지글이 없습니다</td></tr>
	</c:if>
	<c:forEach items="${page.list }" var="vo">
	<tr><td>${vo.no}</td>
		<td class="text-start">
			<span style="margin-left:${vo.indent*15}px"></span>
			<c:if test="${vo.indent > 0}"><i class="fa-regular fa-comment-dots"></i></c:if>
			
			<a class="text-link" 
				href="<c:if test="${vo.indent > 0}">reply/</c:if>info?id=${vo.id }&${params}">${vo.title }</a></td>
		<td>${vo.name }</td>
		<td>${vo.writedate }</td>
		<td><c:if test="${not empty vo.filename}"><i class="fa-solid fa-paperclip"></i></c:if></td>
	</tr>
	</c:forEach>
</tbody>
</table>

<jsp:include page="/WEB-INF/views/include/page.jsp"/>

</body>
</html>









