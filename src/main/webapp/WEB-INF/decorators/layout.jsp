<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>LMS Dashboard<sitemesh:write property="title"/></title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">

  <script>
    function openPopup() {
      document.getElementById("popup").style.display = "block";
    }
    function openlec() {
      document.getElementById("openlec").style.display = "block";
    }

    function closePopup() {
      document.getElementById("popup").style.display = "none";
    }
    function closelec() {
      document.getElementById("openlec").style.display = "none";
    }
  </script>
</head>
<body>
  <sitemesh:write property="head"/>
<div class="header">
  <div>🎓 단과대학 LMS</div>&emsp;&emsp;
  <div>🔔 <%= "홍길동" %> ▼</div>
</div>
<div style="display:flex;">
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
  <sitemesh:write property="body"/>
</div>

</body>
</html>
