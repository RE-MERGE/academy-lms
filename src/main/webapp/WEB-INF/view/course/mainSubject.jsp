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
<input type="hidden" id="mainCourseNo" value="${Course.course_no}"/>
<input type="hidden" id="mainContextPath" value="${pageContext.request.contextPath}"/>
<div style="display: flex; height: 100vh;">

    <!-- 과목 사이드바 -->
    <aside class="subject-sidebar">
        <h2 class="subject-sidebar-title">${Course.course_name}</h2>
        <nav class="subject-nav">
        <br>
            <a href="#" class="subject-nav-item" onclick="loadContent('myPage')">🏠 홈</a><br><hr><br>
            <a href="#" class="subject-nav-item" onclick="loadContent('profScore')">📊 성적</a><br><hr><br>
            <a href="#" class="subject-nav-item">💬 Q&A</a><br><hr><br>
            <a href="#" class="subject-nav-item">👥 학생 리스트</a>
        </nav>
    </aside>

    <!-- 메인 콘텐츠 -->
    <main class="subject-main" id="mainContent">	
    
    </main>

</div>
<script>
function loadContent(page) {
	const courseNo = document.getElementById("mainCourseNo").value;      // ← 추가
    const contextPath = document.getElementById("mainContextPath").value;
	const urlMap = {
        'profScore': contextPath + '/course/profScore?no=' + courseNo,
        'myPage' : contextPath + '/user/myPage',
    };
	
	fetch(urlMap[page])
    .then(response => response.text())
    .then(html => {
        const main = document.getElementById("mainContent");
        main.innerHTML = html;

        // ✅ 불러온 HTML 안의 script 태그 직접 실행
        main.querySelectorAll("script").forEach(oldScript => {
            const newScript = document.createElement("script");
            newScript.textContent = oldScript.textContent;
            document.body.appendChild(newScript);
            oldScript.remove();
        });
    })
    .catch(err => console.error("로딩 실패:", err));
}

</script>
</body>
</html>