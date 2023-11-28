<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
table th span { color:#dc3545; margin-right: 5px }
</style>
</head>
<body>
<h3 class="my-3">회원가입</h3>
<div class="text-danger">* 는 필수입력항목입니다</div>

<!-- 첨부파일업로드하기 
1. form의 전송방식 : post
2. form의 enctype속성: enctype="multipart/form-data"
-->
<form method="post" action="register" enctype="multipart/form-data">
<table class="table tb-row">
<colgroup><col width="160px"><col></colgroup>
<tr><th><span>*</span>성명</th>
	<td><div class="row">
			<div class="col-auto">
				<input type="text" name="name" class="form-control" autofocus >
			</div>
		</div>
	</td>
</tr>
<tr><th><span>*</span>아이디</th>
	<td><div class="row input-check">
			<div class="col-auto">
				<input type="text" name="userid" class="form-control check-item" title="아이디">
			</div>
			<div class="col-auto">
				<a class="btn btn-primary btn-sm" id="btn-userid">
					<i class="fa-regular fa-circle-check"></i>
					<span>중복확인</span>	
				</a>
			</div>
			
			<div class="col-auto">아이디는 영문소문자나 숫자 5자~10자</div>
			<div class="desc"></div>
		</div>
	</td>
</tr>
<tr><th><span>*</span>비밀번호</th>
	<td><div class="row input-check">
			<div class="col-auto">
				<input type="password" name="userpw" class="form-control check-item" title="비밀번호">
			</div>
			<div class="col-auto">비밀번호는 영문 대/소문자,숫자 조합 5자~10자</div>
			<div class="desc"></div>
		</div>
	</td>
</tr>
<tr><th><span>*</span>비밀번호 확인</th>
	<td><div class="row input-check">
			<div class="col-auto">
				<input type="password" name="userpw_ck" class="form-control check-item" title="비밀번호확인">
			</div>
			<div class="desc"></div>
		</div>
	</td>
</tr>
<tr><th><span>*</span>이메일</th>
	<td><div class="row input-check">
			<div class="col-auto">
				<input type="text" name="email" class="form-control check-item" title="이메일">
			</div>
			<div class="desc"></div>
		</div>
	</td>
</tr>
<tr><th><span>*</span>성별</th>
	<td><div class="form-check form-check-inline">
			<label><input class="form-check-input" type="radio" name="gender" value="남">남</label>
		</div>
		<div class="form-check form-check-inline">
			<label><input class="form-check-input" type="radio" name="gender" checked value="여">여</label>
		</div>
	</td>
</tr>
<tr><th>프로필이미지</th>
	<td><div class="row">
			<div class="col-auto d-flex gap-3 align-items-center">
				<label>
					<a class="btn btn-primary btn-sm">
						<i class="fs-5 fa-regular fa-address-card"></i>
						<span>프로필</span>
					</a>
					<input type="file" name="file" id="file-single" class="image-only form-control" accept="image/*">
				</label>
				<!-- 선택한 프로필이미지가 보여질 부분 -->
				<div class="d-flex gap-2 align-items-center" id="file-attach">
					<span class="file-preview"></span>
					<i class="file-delete d-none fs-3 fa-regular fa-circle-xmark text-danger" role="button"></i>
				</div>
				
			</div>
		</div>
	</td>
</tr>
<tr><th>생년월일</th>
	<td><div class="row">
			<div class="col-auto d-flex align-items-center">
				<input type="text" name="birth" class="date form-control">
				<i role="button" class="date-delete text-danger fs-4 fa-solid fa-calendar-xmark"></i>
			</div>
		</div>
	</td>
</tr>
<tr><th>전화번호</th>
	<td><div class="row">
			<div class="col-auto">
				<input type="text" name="phone" class="form-control">
			</div>
		</div>
	</td>
</tr>
<tr><th>주소</th>
	<td><div class="row align-items-center">
			<div class="col-auto pe-0">
				<a class="btn btn-primary btn-sm" id="btn-post">
					<i class="fa-solid fa-magnifying-glass"></i>
					<span>주소찾기</span>
				</a>
			</div>
			<div class="col-auto">
				<input type="text" name="post" readonly class="text-center w-px80 form-control">
			</div>
		</div>
	
		<div class="row mt-2">
			<div class="col-xl-7">
				<input type="text" readonly name="address" class="form-control">
			</div>
			<div class="col-xl-7">
				<input type="text" name="address" class="form-control">
			</div>
		</div>
	</td>
</tr>
</table>
</form>

<div class="btn-toolbar gap-2 justify-content-center my-3">
	<button class="btn btn-primary" id="btn-join">회원가입</button>
	<button class="px-4 btn btn-outline-primary" onclick="history.go(-1)" >취소</button>
</div>


<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="<c:url value='/js/member.js'/>?<%=new java.util.Date() %>"></script>
<script>
var singleFile = ''; //첨부파일정보를 담아둘 변수

//회원가입시 유효성등 확인
$('#btn-join').click(function(){
	console.log('singleFile> ', singleFile);
	singleFileUpload()
	
	if( $('[name=name]').val()=='' ){
		alert('성명을 입력하세요!');
		$('[name=name]').focus()
	}
	//아이디,비번,비번확인,이메일 유효성/중복확인여부 확인
	var _id = $('[name=userid]') 
	//중복확인 한 경우: 이미 사용중이면 회원가입불가
	if( _id.hasClass('checked-item') ){
		if( _id.closest('.input-check').find('.desc').hasClass('text-danger')  ){
			alert("회원가입 불가\n아이디 " + member.userid.unusable.desc )
			_id.focus()
			return
		}
	}else{
	//중복확인 하지 않은 경우: 입력이 유효한지 확인
		if( invalidStatus( _id ) ) return;
		else{
			alert("회원가입 불가\n아이디 " + member.userid.valid.desc )
			_id.focus()
			return;
		}
	}
	
	if( invalidStatus( $('[name=userpw]') ) ) return;
	if( invalidStatus( $('[name=userpw_ck]') ) ) return;
	if( invalidStatus( $('[name=email]') ) ) return;
	
	$('form').submit()
})

//각 태그의 유효성확인
function invalidStatus( tag ){
	var status = member.tagStatus( tag );
	if( status.is )	return false;
	else{
		alert("회원가입 불가\n" + tag.attr('title') + ' '+ status.desc)
		tag.focus()
		return true;
	}
}


//아이디중복확인
$('#btn-userid').on('click', function(){
	useridCheck()
})

function useridCheck(){
	var _id = $('[name=userid]');
	//이미 중복확인 한 경우 다시 확인 불필요
	if( _id.hasClass('checked-item') ) return; 
	
	//유효한 입력이 아니면 유효성 확인
	var status = member.tagStatus( _id );
	if( status.is ){
		//DB에 해당 아이디 존재여부 확인
		$.ajax({
			url: 'useridCheck',
			data: { userid: _id.val() }
		}).done(function( response ){
			console.log(response)
			status = response ? member.userid.usable : member.userid.unusable;
			member.descStatus( _id, status )
			_id.addClass('checked-item') //중복확인함 지정
		})
		
	}else{
		alert("아이디 중복확인 불필요!\n" + status.desc)
		_id.focus()
	}
}

$('.check-item').keyup(function(e){
	if( $(this).attr('name')=="userid"  && e.keyCode==13 ) //아이디입력후 엔터시 중복확인하기
		useridCheck()
	else{
		$(this).removeClass('checked-item') //중복확인함 제거
		member.showStatus( $(this) )  //키보드입력상태를 화면에 출력
	}
})


$(function(){
	//12세 이상만 생일날짜 선택하게
	var today = new Date();
	var endDay 
	= new Date( today.getFullYear()-12, today.getMonth(), today.getDate()-1 );
	
	$('[name=birth]').datepicker( 'option', 'maxDate', endDay );
	
	$('.date').on('change', function(){
	//$('.date').change(function(){
		$(this).next('.date-delete').css('display', 'inline')
	})
	
})


//전화번호 형태 만들어주기
$('[name=phone]').keyup(function(){
	toPhone( $(this) );
})



//생년월일 날짜 삭제하기
$('.date + .date-delete').click(function(){
	$(this).prev('.date').val('');
	$(this).css('display', 'none')
})


//우편번호찾기로 주소입력
$('#btn-post').click(function(){
	new daum.Postcode({
        oncomplete: function( data ) {
        	console.log( data )
        	$('[name=post]').val( data.zonecode );
        	//도로명주소(R)/지번주소(J)
        	var address = data.userSelectedType == 'R' 
        					? data.roadAddress : data.jibunAddress;
        	if( data.buildingName !='' ) address += " ("+data.buildingName+")";
        	
        	$('[name=address]:eq(0)').val( address );
//         	$('[name=address]').eq(0).val( address );
        }
    }).open();
})










</script>

</body>
</html>