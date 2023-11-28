<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="comment-register" class="row justify-content-center my-4">
	<div class="d-none title w-80 mb-2 d-flex justify-content-between align-items-center">
		<span>댓글작성 [ <span class="writing">0</span> / 200 ]</span>
		<a class="btn btn-outline-primary btn-sm d-none" id="btn-register">댓글등록</a>
	</div>
	<!-- 로그인 여부에 따라 입력하거나 로그인하도록 안내 -->
	<div class="comment w-80">
		<div class="form-control text-center py-3 guide">
		 ${empty loginInfo ? "댓글을 입력하려면 여기를 클릭후 로그인하세요" : "댓글을 입력하세요"} 
		</div>
	</div>
</div>

<div id="comment-list" class="row justify-content-center mx-0">
</div>    
    
    
    
<script>
$("#comment-register .comment").click(function(){
	if( ${empty loginInfo} ){
		//로그인 할 것인지 확인창 띄워 연결하기
		if( confirm("로그인 하시겠습니까?") ){
			$("form").attr("action", "<c:url value='/member/login'/>").submit()
		}
	}else{
		//입력할 태그 만들기		
		if( $(this).children(".guide").length==1 ){
			$("#comment-register .title").removeClass("d-none")
			$(this).append("<textarea class='form-control'></textarea>")
			$(this).children('textarea').focus()
			$(this).children(".guide").remove();
		}
	}
})


$(document)
.on( "focusout", "#comment-register textarea", function(){
	//입력된 글자가 없는 경우 초기화
	$(this).val( $(this).val().trim() );
	$("#comment-register .writing").text( $(this).val().length )
	if( $(this).val() == "" ){
		initComment( $(this) );
	}
})
.on( "keyup", "#comment-register textarea", function(){
	var input = $(this).val();
	if( input.length > 200 ){
		alert("최대 200자까지 입력할 수 있습니다")
		input = input.substr(0,200)
		$(this).val( input )
	}
	$("#comment-register .writing").text( input.length )
	//입력된 글자가 있을때만 보이게
	if(  input.length > 0 )	$("#btn-register").removeClass("d-none")
	else					$("#btn-register").addClass("d-none")
})
.on( "keyup", "#comment-list textarea", function(){
	var input = $(this).val();
	if( input.length > 200 ){
		alert("최대 200자까지 입력할 수 있습니다")
		input = input.substr(0,200)
		$(this).val( input )
	}
	$(this).closest(".comment").find(".writing").text( input.length )
})



//등록부분 textarea 초기화
function initComment( _textarea ){
	$("#comment-register .title").addClass("d-none")
	$("#comment-register .writing").text( 0 )
	$("#btn-register").addClass("d-none")
	_textarea.after( 
			`<div class="form-control text-center py-3 guide">
			 ${empty loginInfo ? "댓글을 입력하려면 여기를 클릭후 로그인하세요" : "댓글을 입력하세요"} 
			</div>
			`)
	_textarea.remove()
}


//댓글등록처리
$("#btn-register").click(function(){
	var _textarea = $("#comment-register textarea");
	$.ajax({
		url: "<c:url value='/board/comment/register' />",
		data: { board_id: ${vo.id}, content: _textarea.val(), writer: "${loginInfo.userid}" }
	}).done(function( response ){
		if( response ){
			commentSocket.send( `{ receiver: "${vo.writer}", board_id : ${vo.id} }` )
			
			alert("댓글이 등록되었습니다")
			initComment( _textarea )
			commentList()
		}else{
			alert("댓글이 등록 실패")
		}
	})
})


//댓글목록조회
function commentList(){
	$.ajax({
		url: "<c:url value='/board/comment/list/${vo.id}' />"
	}).done(function( response ){
		//console.log( response )
		$("#comment-list").html( response )
	})
}


commentList(); //화면로딩될때 한번 호출

</script>    