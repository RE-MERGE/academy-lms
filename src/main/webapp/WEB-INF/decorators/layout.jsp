<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>re-merge LMS | <sitemesh:write property="title"/></title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
  <sitemesh:write property="head"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>

<div class="layout-root">

  <!-- ── 헤더 ── -->
  <div class="header-wrapper">
    <div class="header-topbar"></div>
    <header class="lms-header">

      <!-- 로고 -->
      <a href="${pageContext.request.contextPath}/dashBoard" class="lms-logo-wrap">
        <div class="lms-logo-text">
          <span class="lms-logo-main">re<span>·</span>merge</span>
          <span class="lms-logo-sub">Learning Management System</span>
        </div>
      </a>

      <!-- 우측 유저 영역 -->
      <div class="header-user">

        <span class="header-semester">2026학년도 1학기</span>

        <c:choose>
          <c:when test="${sessionScope.loginUser.role == 'admin'}">
            <span class="user-role-badge role-admin">관리자</span>
          </c:when>
          <c:when test="${sessionScope.loginUser.role == 'professor'}">
            <span class="user-role-badge role-teacher">강사</span>
          </c:when>
          <c:otherwise>
            <span class="user-role-badge role-student">학생</span>
          </c:otherwise>
        </c:choose>

        <div class="header-user-info">
          <span class="user-name">${sessionScope.loginUser.name}</span>
          <span class="user-id">${sessionScope.loginUser.userId}</span>
        </div>

        <div class="avatar"><%--${fn:substring(sessionScope.loginUser.name, 0, 1)}--%></div>

        <a href="${pageContext.request.contextPath}/user/logout" class="btn-logout">로그아웃</a>
      </div>

    </header>
  </div>

  <div class="layout-body">

    <!-- ── 사이드바 ── -->
    <nav class="sidebar">

      <!-- 메인 -->
      <span class="sidebar-section-label">메인</span>

      <a href="${pageContext.request.contextPath}/dashBoard" class="sidebar-item">
        <span class="si-icon">🏠</span>
        <span class="si-label">대시보드</span>
      </a>

      <div class="sidebar-divider"></div>

      <!-- 학습 -->
      <span class="sidebar-section-label">학습</span>

      <a href="${pageContext.request.contextPath}/board/subject" class="sidebar-item">
        <span class="si-icon">📚</span>
        <span class="si-label">전체 과목</span>
      </a>

      <a href="${pageContext.request.contextPath}/user/enrollment" class="sidebar-item">
        <span class="si-icon">🎓</span>
        <span class="si-label">수강신청</span>
      </a>

      <a href="${pageContext.request.contextPath}/board" class="sidebar-item">
        <span class="si-icon">📋</span>
        <span class="si-label">게시판</span>
      </a>

      <div class="sidebar-divider"></div>

      <!-- 계정 -->
      <span class="sidebar-section-label">계정</span>

      <a href="${pageContext.request.contextPath}/user/myPage" class="sidebar-item">
        <span class="si-icon">👤</span>
        <span class="si-label">마이페이지</span>
      </a>

    </nav>

    <!-- ── 페이지 본문 ── -->
    <main class="main-content">
      <sitemesh:write property="body"/>
    </main>

  </div>
</div>

</body>
</html>
