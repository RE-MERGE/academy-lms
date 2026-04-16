<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>
    <sitemesh:write property="title"/>
</title>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: 'Noto Sans KR', sans-serif;
}

/* 전체 레이아웃 */
.layout {
  display: flex;
  height: 100vh;
}

/* 사이드바 */
.sidebar {
  width: 240px;
  background: linear-gradient(#4b6cb7, #182848);
  color: white;
  padding: 20px;
}

.sidebar h2 {
  margin-bottom: 30px;
}

.menu {
  margin-bottom: 20px;
}

.menu-title {
  font-weight: bold;
  margin-bottom: 8px;
}

.menu a {
  display: inline-block;
  margin-right: 10px;
  color: white;
  text-decoration: none;
  font-size: 14px;
}

/* 메인 영역 */
.main {
  flex: 1;
  background: #f5f6f7;
}

/* 상단 헤더 */
.header {
  display: flex;
  justify-content: flex-end;
  padding: 15px 30px;
  background: white;
  border-bottom: 1px solid #ddd;
  font-size: 14px;
}

/* 콘텐츠 영역 */
.content {
  padding: 40px;
}
</style>

<!-- 개별 페이지에서 추가 head 넣을 수 있게 -->
<sitemesh:write property="head"/>

</head>

<body>

<div class="layout">

  <!-- 사이드바 -->
  <div class="sidebar">
    <h2>re-merge LMS</h2>

    <div class="menu">
      <div class="menu-title">대시보드</div>
      <a href="${pageContext.request.contextPath}/dashboard/student">학생</a>
      <a href="${pageContext.request.contextPath}/dashboard/teacher">강사</a>
      <a href="${pageContext.request.contextPath}/dashboard/admin">관리자</a>
    </div>

    <div class="menu">
      <div class="menu-title">마이페이지</div>
      <a href="#">학생</a>
      <a href="#">강사</a>
      <a href="#">관리자</a>
    </div>

    <div class="menu">
      <div class="menu-title">과목</div>
      <a href="#">학생</a>
      <a href="#">강사</a>
      <a href="#">관리자</a>
    </div>

    <div class="menu">
      <div class="menu-title">게시판</div>
    </div>

    <div class="menu">
      <div class="menu-title">수강</div>
      <a href="#">학생</a>
      <a href="#">강사</a>
      <a href="#">관리자</a>
    </div>
  </div>

  <!-- 메인 -->
  <div class="main">

    <!-- 헤더 -->
    <div class="header">
      관리자용 / 강사용 / 학생용 &nbsp;&nbsp; | &nbsp;&nbsp;
      <a href="${pageContext.request.contextPath}/user/logout">로그아웃</a>
    </div>

    <!-- ⭐ 핵심: 여기 바뀜 -->
    <div class="content">
        <sitemesh:write property="body"/>
    </div>

  </div>

</div>

</body>
</html>