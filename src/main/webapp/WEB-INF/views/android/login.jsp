<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<input type="text" id="userid">
<input type="password" id="userpw">
<button id="btn-login1">로그인인증 응답</button>
<button id="btn-login2">로그인정보 응답</button>

<script>
$('#btn-login2').click(function(){
	$.ajax({
		type: 'post',
		url: '<c:url value="/app/member/login_user" />',
		data: JSON.stringify( { userid: $('#userid').val(), userpw: $('#userpw').val() } )
	}).done(function(response){
		console.log(response)
	})
})

$('#btn-login1').click(function(){
	$.ajax({
		type: 'post',
		contentType: 'application/json',
		//url: 'member/login_check'		
		url: '<c:url value="/app/member/login_check" />',
		data: JSON.stringify( { userid: $('#userid').val(), userpw: $('#userpw').val() } )
	}).done(function( response ){
		console.log( response )
	})
	
})
</script>

</body>
</html>