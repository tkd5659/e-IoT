<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<select class="form-select w-px200" id="sigungu">
	<option value="">시군구 선택</option>
	<c:forEach items="${list.items.item}" var="vo">
	<option value="${vo.orgCd}">${vo.orgdownNm}</option>
	</c:forEach>
</select>

<script>
$("#sigungu").change(function(){
	animal_shelter();//보호소조회
	animal_list(1)
})

//보호소조회함수 : 
function animal_shelter(){
	$("#shelter").remove();
	if( $("#sigungu").val()=="" ) return
	
	$.ajax({
		url: "animal/shelter",
		data: { sido: $("#sido").val(), sigungu: $("#sigungu").val() }
	}).done(function( response ){
		$("#sigungu").after( response )
	})
	
}
</script>