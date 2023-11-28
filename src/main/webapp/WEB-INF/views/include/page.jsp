<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<nav>
	<ul class="pagination justify-content-center mt-4">

		<!-- 처음/이전 -->
		<c:if test="${page.curBlock > 1 }">
			<li class="page-item"><a class="page-link" onclick="page(1)">
					<i class="fa-solid fa-angles-left"></i>
			</a></li>
			<li class="page-item"><a class="page-link"
				onclick="page(${page.beginPage-page.blockPage })"> <i
					class="fa-solid fa-angle-left"></i></a></li>

		</c:if>


		<c:forEach var="no" begin="${page.beginPage  }" end="${page.endPage }">
			<c:if test="${no eq page.curPage}">
				<li class="page-item"><a class="page-link active" href="#">${no}</a></li>
			</c:if>
			<c:if test="${no ne page.curPage}">
				<li class="page-item"><a class="page-link"
					onclick="page(${no})">${no}</a></li>
			</c:if>
		</c:forEach>
		<!-- 다음/마지막 -->
		<c:if test="${page.curBlock < page.totalBlock }">
			<li class="page-item"><a class="page-link"
				onclick="page(${page.endPage+1})"> <i
					class="fa-solid fa-angle-right"></i></a></li>
			<li class="page-item"><a class="page-link"
				onclick="page(${page.totalPage })"> <i
					class="fa-solid fa-angles-right"></i></a></li>

		</c:if>
	</ul>
</nav>
<script>
function page(no ){
	$('[name=curPage]').val( no )
	$('form').submit()
}
</script>