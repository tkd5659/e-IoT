<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 class="my-4">비밀번호 변경</h3>

<table class="table tb-row">
<colgroup><col width="160px"><col></colgroup>
<tr><th>현재 비밀번호</th>
	<td>
		<div class="row">
			<div class="col-auto">
				<input type='password' class="form-control" name="currentPw">
			</div>
		</div>
	</td>
</tr>
<tr><th>새 비밀번호</th>
	<td>
		<div class="row input-check align-items-center">
			<div class="col-auto">
				<input type='password' class="form-control check-item" 
												title="새 비밀번호" name="userpw">
			</div>
			<div class="col-auto desc text-danger"></div>
			<div class="mt-2">비밀번호는 영문 대/소문자, 숫자 조합 5자~10자</div>
		</div>	
	</td>
</tr>
<tr><th>새 비밀번호 확인</th>
	<td>
		<div class="row input-check">
			<div class="col-auto">
				<input type='password' class="form-control check-item" 
												title="새 비밀번호확인" name="userpw_ck">
			</div>
			<div class="col-auto desc text-danger"></div>
		</div>
	
	</td>
</tr>
</table>

<div class="btn-toolbar gap-2 justify-content-center my-3">
	<button class="btn btn-primary" id="btn-save">변경</button>
</div>

<jsp:include page="/WEB-INF/views/include/modal_alert.jsp"/>

<script src="<c:url value='/js/member.js'/>"></script>
<script>

$(function(){
	modalAlert(  'warning', '비밀번호변경', "비밀번호를 변경 성공" )
	new bootstrap.Modal( '#modal-alert' ).show();
	
	
})

// $('#btn-save').click(function(){
$('#btn-save').on('click', function(){
	if( tagIsValid() ){
		//현재 비밀번호 확인	
		$.ajax({
			url: 'confirm',
			data: { userpw: $('[name=currentPw]').val() },
			success: function( response ){
				//console.log( response )
				//로그인되어 있지 않으면 로그인화면으로 연결
				if( response==-1 ) location = 'login'
				else if( response==1 ){
				//현재 비밀번호를 잘못 입력한 경우
					alert('현재 비밀번호가 올바르지 않습니다!')
					$('[name=currentPw]').focus()
					$('[name=currentPw]').val('')
				}else{
					//현재 비밀번호와 새 비밀번호가 같은 경우
					if( $('[name=currentPw]').val()==$('[name=userpw]').val() ){
						alert('현재 비밀번호와 새 비밀번호가 같습니다!')
						$('[name=userpw]').focus()
					}else
						resetPassword()
				}
			},error: function(){}
		})	
	}
})

//비밀번호변경성공시 웰컴페이지로 연결
$('#modal-alert .btn-ok').click(function(){
	if( $(this).hasClass('btn-success') )
		
	location = "<c:url value='/'/>";
	})



//새 비밀번호로 변경하기
function resetPassword(){
	$.ajax({
		url: 'updatePassword',
		data: { userid: "${loginInfo.userid}", userpw: $("[name=userpw]").val() }
	}).done(function( response ){
		if( response ){
			//alert('비밀번호 변경되었습니다')
			modalAlert( 'success', '비밀번호변경', "비밀번호가 변경되었습니다.")
		}else{
			//alert('비밀번호 변경 실패!')
			modalAlert('warning', '비밀번호변경', "비밀번호를 변경 실패!")
		}
		new bootstrap.Modal( '#modal-alert' ).show()	
			
	}).fail(function(){})
}

//태그의 입력상태 확인
function tagIsValid(){
	var ok = true;	

	if( $('[name=currentPw]').val()=='' ){
		alert('현재 비밀번호를 입력하세요!')
		$('[name=currentPw]').focus()
		ok = false;
	}else{
		$('.check-item').each(function(){
			//비밀번호/비밀번호확인의 입력상태확인	
			var status = member.tagStatus( $(this) )
			if( ! status.is ){
				alert('비밀번호 변경 불가!\n[' + $(this).attr('title') + '] '+ status.desc )
				$(this).focus()
				ok = false
				return ok;
			}
		
		})
	}
	return ok;
}

//키보드입력할때마다 상태 보여지게
$('.check-item').keyup( function(){
	member.showStatus( $(this) )

} )

</script>
</body>
</html>