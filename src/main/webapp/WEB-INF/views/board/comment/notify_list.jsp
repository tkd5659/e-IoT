<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h6 class="dropdown-header py-1">방명록 댓글 알림</h6>
<div class="py-2 px-3 navbar-nav-scroll overflow-auto" >
<c:forEach items="${list}" var="vo" varStatus="s">
	<div class="row">
		<div class="d-flex justify-content-between mb-1">
			<span>${vo.name}</span>
			<span>${vo.writedate}</span>
		</div>
		<span class="fw-bold">${vo.content}</span>
	</div>
	<c:if test="${ ! s.last }"><div class="dropdown-divider"></div></c:if>
</c:forEach>
</div>
 	