<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<div class="row justify-content-center">
    <div class="col-lg-5">
        <div class="card shadow-lg border-0 rounded-lg mt-5">
            <div class="card-header">
            <h3 class="text-center">
            	<a href="<c:url value='/'/>"><img src="<c:url value='/img/hanul.logo.png'/>"></a>
            </h3>
            <h4 class="text-center">비밀번호찾기</h4>
            </div>
            <div class="card-body">
                <form method="post" action="resetPassword">
                    <div class="form-floating mb-3">
                        <input class="form-control" name="userid" required type="text" placeholder="아이디">
                        <label>아이디</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input class="form-control" name="email" required type="text" placeholder="이메일">
                        <label>이메일</label>
                    </div>
                    <button class="btn btn-primary form-control p-2">로그인</button>
                    <div class="d-flex justify-center  gap-3">
                        <button class="btn btn-primary" >확인</a>
                        <a class="btn btn-outline-primary" href="login">취소</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
                        
</body>
</html>