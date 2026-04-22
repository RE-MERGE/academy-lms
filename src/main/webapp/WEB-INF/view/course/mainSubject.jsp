<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 과목</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
<style>
    .main-content {
        padding: 0 !important;
    }
</style>
</head>
<body>
<div style="display: flex; height: 100vh;">

    <!-- 과목 사이드바 -->
    <aside class="subject-sidebar">
        <h2 class="subject-sidebar-title">${Course.course_name}</h2>
        <nav class="subject-nav">
            <a href="#" class="subject-nav-item active">🏠 홈</a>
            <a href="#" class="subject-nav-item">📊 성적</a>
            <a href="#" class="subject-nav-item">💬 Q&A</a>
            <a href="#" class="subject-nav-item">👥 학생 리스트</a>
        </nav>
    </aside>

    <!-- 메인 콘텐츠 -->
    <main class="subject-main">
        <!-- 여기에 각 카테고리 내용 -->
    </main>

</div>
</body>
</html>