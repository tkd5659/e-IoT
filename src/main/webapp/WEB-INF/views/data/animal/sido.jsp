<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<select class="form-select w-px200" id="sido">
	<option value="">시도 선택</option>
	<c:forEach items="${list.items.item}" var="vo">
	<option value="${vo.orgCd}">${vo.orgdownNm}</option>
	</c:forEach>
</select>

<script>
$("#sido").change(function(){
	animal_sigungu()
	animal_list(1) 
})

function animal_sigungu(){
	//기존 시군구태그삭제
	$("#sigungu").remove()
	$("#shelter").remove()
	
	//전체시도(시도선택)인 경우 조회 불필요
	if( $("#sido").val()=="" ) return;
	
	$.ajax({
		url: "animal/sigungu",
		data: { sido: $("#sido").val() }
	}).done(function( response ){
		$("#sido").after( response )
	})
}
</script>