<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
#naver { background: url("<c:url value='/img/naver_login.png'/>") no-repeat center/contain #03c75a; }
#kakao { background: url("<c:url value='/img/kakao_login.png'/>") no-repeat center/contain #FEE500; }
</style>
</head>
<body>

<div class="row justify-content-center align-items-center h-100">
    <div class="col-lg-5">
        <div class="card shadow-lg border-0 rounded-lg px-3 py-5">
            <h3 class="text-center">
            	<a href="<c:url value='/'/>"><img src="<c:url value='/img/hanul.logo.png'/>"></a>
            </h3>
            <div class="card-body">
                <form method="post" action="iotLogin">
                    <div class="form-floating mb-3">
                        <input class="form-control" name="userid" required type="text" placeholder="아이디">
                        <label for="inputUserid">아이디</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input class="form-control" name="userpw" required type="password" placeholder="비밀번호">
                        <label for="inputPassword">비밀번호</label>
                    </div>
                    <div class="form-check mb-3">
                    	<label>
	                        <input class="form-check-input" name="remember" type="checkbox" value="true">
	                        <span>로그인 상태 유지</span>
                    	</label>
                    </div>
                    <button class="btn btn-primary form-control p-3">로그인</button>
                    <hr>
                    <div class="d-flex gap-3">
                    	<input type="button" id="naver" class="form-control border-0 p-3">
                    	<input type="button" id="kakao" class="form-control border-0 p-3">
                    </div>
                    <hr>
                    <div class="d-flex align-items-center justify-content-between mt-4 mb-0">
                        <a class="small" href="join">회원가입</a>
                        <a class="small" href="find">비밀번호찾기</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
$(function(){
	if( ${not empty fail} ){ /* 댓글등록 통해 로그인한 경우 */
		alert("아이디나 비밀번호가 일치하지 않습니다")
	}	
})

$('#naver, #kakao').click(function(){
	location = $(this).attr('id') + 'Login';
})
</script>

</body>
</html>