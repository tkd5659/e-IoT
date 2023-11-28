<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${list.totalCount == 0}">
<table class="table tb-list animal">
<tr><td>해당 유기동물이 없습니다</td></tr>
</table>
</c:if>

<c:forEach items="${list.items.item}" var="vo">
<table class="table tb-list animal">
	<colgroup>
		<col width="120px">
		<col width="100px"><col width="60px">
		<col width="70px"><col width="160px">
		<col width="70px"><col width="120px">
		<col width="70px"><col width="160px">
		<col width="110px"><col width="110px">
	</colgroup>
<tr>
	<td rowspan="3" class="px-2 popfile">
		<div class="text-center">
			<img src="${vo.popfile}" style="width:120px; height:120px">
		</div>
	</td>
	<th>성별</th><td>${vo.sexCd}</td>
	<th>나이</th><td>${vo.age}</td>
	<th>체중</th><td>${vo.weight}</td>
	<th>색상</th><td>${vo.colorCd}</td>
	<th>접수일자</th><td>${vo.happenDt}</td>
</tr>
<tr>
	<th>특징</th><td colspan="9" class="text-start">${vo.specialMark}</td>
</tr>
<tr>
	<th>발견장소</th><td colspan="7" class="text-start">${vo.happenPlace}</td>
	<th colspan="2">${vo.processState}</th>
</tr>
<tr>
	<td colspan="2">${vo.careNm}</td>
	<td colspan="7" class="text-start">${vo.careAddr}</td>
	<td colspan="2">${vo.careTel}</td>
</tr>
</table>
</c:forEach>


<script>
makePage( ${list.totalCount}, ${list.pageNo} )
</script>

