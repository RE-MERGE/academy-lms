<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>re-merge LMS | <sitemesh:write property="title"/></title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
  <sitemesh:write property="head"/>
</head>
<body>

<div class="layout-root">

  <!-- ── 헤더 ── -->
  <div class="header-wrapper">
    <div class="header-topbar"></div>
    <header class="lms-header">

      <!-- 로고 -->
      <a href="${pageContext.request.contextPath}/home/dashboard" class="lms-logo-wrap">
        <div class="lms-logo-text">
          <span class="lms-logo-main">re<span>·</span>merge</span>
          <span class="lms-logo-sub">Learning Management System</span>
        </div>
      </a>

      <!-- 우측 유저 영역 -->
      <div class="header-user">

        <span class="header-semester">2026학년도 1학기</span>

        <c:choose>
          <c:when test="${sessionScope.sessionUser.role == 'ADMIN'}">
            <span class="user-role-badge role-admin">관리자</span>
          </c:when>
          <c:when test="${sessionScope.sessionUser.role == 'PROFESSOR'}">
            <span class="user-role-badge role-teacher">강사</span>
          </c:when>
          <c:otherwise>
            <span class="user-role-badge role-student">학생</span>
          </c:otherwise>
        </c:choose>

        <div class="avatar">${fn:substring(sessionScope.sessionUser.name, 0, 1)}</div>
        <div class="header-user-info">
          <span class="user-id">${sessionScope.sessionUser.userId}</span>
          <span class="user-name">${sessionScope.sessionUser.name}</span>
        </div>


        <a href="${pageContext.request.contextPath}/user/logout" class="btn-logout">로그아웃</a>
      </div>

    </header>
  </div>

  <div class="layout-body">

    <!-- ── 사이드바 ── -->
    <nav class="sidebar">

<style>
.si-label {
  margin-left: 15px;
}
</style>

      <!-- 메인 -->
      <span class="sidebar-section-label">메인</span>

      <a href="${pageContext.request.contextPath}/home/dashboard" class="sidebar-item" >
         <img src="${pageContext.request.contextPath}/img/icon_dashboard.png" alt="대시보드 아이콘" width="50px" height="50px" >
        <span class="si-label">대시보드</span>
      </a>

      <div class="sidebar-divider"></div>

      <!-- 학습 -->
      <span class="sidebar-section-label">학습</span>

      <a href="${pageContext.request.contextPath}/course/subject" class="sidebar-item"  id="course-menu">
        <img src="${pageContext.request.contextPath}/img/icon_courses.png" alt="전체과목 아이콘" width="50px" height="50px" >
        <span class="si-label">전체 과목</span>
      </a>

      <a href="${pageContext.request.contextPath}/enrollment/courseEnrollment" class="sidebar-item">
      <img src="${pageContext.request.contextPath}/img/icon_enrollment.png" alt="수강신청 아이콘" width="50px" height="50px" >
        <span class="si-label">수강신청</span>
      </a>

      <a href="${pageContext.request.contextPath}/board/list" class="sidebar-item">
        <img src="${pageContext.request.contextPath}/img/icon_board.png" alt="게시판 아이콘" width="50px" height="50px" >
        <span class="si-label">게시판</span>
      </a>

      <div class="sidebar-divider"></div>

      <!-- 계정 -->
      <span class="sidebar-section-label">계정</span>

      <a href="${pageContext.request.contextPath}/user/myPage" class="sidebar-item">
        <img src="${pageContext.request.contextPath}/img/icon_mypage.png" alt="마이페이지 아이콘" width="50px" height="50px" >
        <span class="si-label">마이페이지</span>
      </a>

	<c:if test="${sessionScope.sessionUser.role == 'ADMIN'}">
  		<div class="sidebar-divider"></div>
 	 	<span class="sidebar-section-label">관리자</span>
  	<a href="${pageContext.request.contextPath}/admin/userList" class="sidebar-item">
    	<img src="${pageContext.request.contextPath}/img/icon_Member Management.png" alt="회원관리 아이콘" width="50px" height="50px">
    	<span class="si-label">전체회원관리</span>
  	</a>
  <a href="${pageContext.request.contextPath}/admin/courseList" class="sidebar-item">
    <img src="${pageContext.request.contextPath}/img/icon_Course Management.png" alt="수업관리 아이콘" width="50px" height="50px">
    <span class="si-label">전체수업관리</span>
  </a>
	</c:if>
	
	
 
	

    </nav>
<div class="flyout" id="course-flyout">
	    <h3 class="flyout-title">${course.course_name}</h3>
	    	<ul class="flyout-list">
	        	<c:if test="${not empty courseList}">
	        	<!-- <li class="flyout-list">&nbsp;과목</li>-->
	            	<c:forEach var="course" items="${courseList}">
		                <li class="flyout-item">
        <a href="${pageContext.request.contextPath}/course/mainSubject?no=${course.course_no}">
            ${course.course_name}
        </a>
        <c:set var="isFav" value="false"/>
    <c:forEach var="fno" items="${favoriteNos}">
        <c:if test="${fno == course.course_no}">
            <c:set var="isFav" value="true"/>
        </c:if>
    </c:forEach>
        <button class="fav-btn ${isFav ? 'active' : ''}" onclick="toggleFavorite(event, this, ${course.course_no})">
        ${isFav ? '★' : '☆'}
    </button>
    </li>
	            	</c:forEach>
	        	</c:if>
	   	 	</ul>
		</div>

    <!-- ── 페이지 본문 ── -->
    <main class="main-content">
      <sitemesh:write property="body"/>
    </main>

  </div>
</div>

<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function() {
    const courseMenu = document.getElementById('course-menu');
    const flyout = document.getElementById('course-flyout');
    let hideTimer;

    courseMenu.addEventListener('mouseenter', () => {
        clearTimeout(hideTimer);
        flyout.classList.add('active');
    });

    courseMenu.addEventListener('mouseleave', () => {
        hideTimer = setTimeout(() => {
            if (!flyout.matches(':hover')) flyout.classList.remove('active');
        }, 1000);
    });

    flyout.addEventListener('mouseenter', () => {
        clearTimeout(hideTimer);
    });

    flyout.addEventListener('mouseleave', () => {
        hideTimer = setTimeout(() => {
            flyout.classList.remove('active');
        }, 100);
    });
});

function toggleFavorite(event, btn, courseNo) {
    event.preventDefault();
    event.stopPropagation();
    const isFav = btn.classList.contains('active');
    const contextPath = '<%=request.getContextPath()%>';
    const url = isFav
        ? contextPath + '/course/remove'
        : contextPath + '/course/add';

    fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'course_no=' + courseNo
    })
    .then(res => res.text())
    .then(result => {
        if (result === 'ok') {
            btn.classList.toggle('active');
            btn.textContent = isFav ? '☆' : '★';
        }
    });
}

</script>
</body>
</html>
