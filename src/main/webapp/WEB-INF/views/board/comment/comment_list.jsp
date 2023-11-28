<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty list}">	
	<div class="py-3 text-center">
		<div class="fs-5">등록된 댓글이 없습니다</div>
		<div>첫번째 댓글을 남겨주세요</div>
	</div>
</c:if>
	
<c:forEach items="${list}" var="vo">
	<c:choose>
		<c:when test="${empty vo.profile}"><c:set var="profile" value='<i class="font-profile fa-regular fa-circle-user"></i>' /></c:when>
		<c:otherwise>
			<c:set var="profile" value="<img class='profile' src='${vo.profile}'>"/>
		</c:otherwise>
	</c:choose>
	<div class="comment w-80 py-3 border-bottom" data-id="${vo.id}">
		<div class="d-flex justify-content-between align-items-center">
			<div class="d-flex align-items-center mb-2">
				<span class="text-secondary me-2">${profile}</span>
				<span>${vo.name} [ ${vo.writedate} ]</span>
			</div>
			
			<c:if test="${vo.writer eq loginInfo.userid}">
			<div>
				<span class="title me-4 d-none">댓글수정 [ <span class="writing">0</span> / 200 ]</span>
				<a class="btn btn-outline-info btn-sm btn-modify-save">수정</a>
				<a class="btn btn-outline-danger btn-sm btn-delete-cancel">삭제</a>
			</div>
			</c:if>
		</div>
		
		<div class="content">${fn: replace(  fn: replace(vo.content, lf, '<br>')  , crlf, '<br>') }</div>
		<div class="d-none hidden"></div>
	</div>
</c:forEach>

<script>
$(".btn-delete-cancel").on("click", function(){
	var _comment = $(this).closest(".comment")
	if( $(this).text()=='취소' )
		infoStatus( _comment ) //정보상태
	else{
		if( confirm( "이 댓글을 삭제하시겠습니까?" ) ){
			$.ajax({
				type: "post",
				url : "<c:url value='/board/comment/delete' />",
				data: { id: _comment.data("id") }
			}).done(function( response ){
				if( response.success )
					_comment.remove()
				else
					alert("댓글이 삭제되지 않았습니다")
			})
		}	
	}
})

//정보상태로 보이게
function infoStatus( _comment ){
	//버튼은 수정/삭제
	_comment.find( ".btn-modify-save" ).removeClass("btn-primary")
	.addClass("btn-outline-info").text( "수정" )
	_comment.find( ".btn-delete-cancel" ).removeClass("btn-secondary")
	.addClass("btn-outline-danger").text( "삭제" )
	
	//textarea안의 값이 content의 텍스트로 보여지게
	var _content = _comment.find(".content");
// 	var content = _content.find("textarea").val().replace( /\n/g, '<br>' )
	var content = _comment.find(".hidden").html().replace( /\n/g, '<br>' )
	_content.html( content )
	_comment.find(".hidden").empty()
}


$(".btn-modify-save").on('click', function(){
	var _comment = $(this).closest(".comment")
	if( $(this).text() == "수정" )
		modifyStatus( _comment ) //변경상태
	else{
		$.ajax({
			type: 'post',
			url: "<c:url value='/board/comment/update' />",
			data: { content: _comment.find("textarea").val(), id: _comment.data("id") }
		}).done(function( response ){
			console.log( response )
			alert("댓글 변경 " +  response.message )
			if( response.success ){
				_comment.find(".hidden").text( response.content )
			}
			infoStatus( _comment )
			//commentList()
		})
	}
})

//변경상태로 보이게
function modifyStatus( _comment ){
	//버튼은 저장/취소
	_comment.find( ".btn-modify-save" ).removeClass("btn-outline-info")
										.addClass("btn-primary").text( "저장" )
	_comment.find( ".btn-delete-cancel" ).removeClass("btn-outline-danger")
										.addClass("btn-secondary").text( "취소" )
			
	var _content = _comment.find(".content")
	var content = _content.html().replace( /<br>/g, '\n' )
	_content.html( `<textarea class="form-control">\${content}</textarea>` )
	
	_comment.find( ".title" ).removeClass("d-none").find(".writing").text( content.length )
	_comment.find( ".hidden" ).html( content )
}

</script>
