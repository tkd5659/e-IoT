<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="modal fade" id="modal-alert" data-bs-backdrop="static"  aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
      	<i class="fs-3 me-3 modal-icon fa-solid fa-circle-exclamation"></i>
        <h1 class="modal-title fs-5"></h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body"></div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary btn-ok" data-bs-dismiss="modal">확인</button>
        <button type="button" class="btn btn-danger">예</button>
      </div>
    </div>
  </div>
</div>