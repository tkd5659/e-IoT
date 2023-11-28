<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<select class="form-select w-px300" id="kind">
	<option value="">품종 선택</option>
	<c:forEach items="${list.items.item}" var="vo">
	<option value="${vo.kindCd }">${vo.knm }</option>
	</c:forEach>
</select>

<script>
$("#kind").change(function(){
	animal_list(1)
})
</script>