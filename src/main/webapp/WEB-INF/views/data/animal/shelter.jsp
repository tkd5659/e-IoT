<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<select class="form-select w-px200" id="shelter">
	<option value="">보호소 선택</option>
	<c:forEach items="${list.items.item}" var="vo">
	<option value="${vo.careRegNo }">${vo.careNm }</option>
	</c:forEach>
</select>

<script>
//보호소 태그 변경시 유기동물조회해오기 
$("#shelter").change(function(){
	animal_list(1) 
})
</script>