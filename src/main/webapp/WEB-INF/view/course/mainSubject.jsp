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
    .subject-nav-item img {
    margin-right: 15px;
	}
	.subject-nav-item {
    display: flex;
    align-items: center;  /* 아이콘이랑 글자 세로 중앙 정렬 */
    gap: 8px;             /* 간격 */
}
	
</style>
</head>
<body>
<input type="hidden" id="mainCourseNo" value="${Course.course_no}"/>
<input type="hidden" id="mainContextPath" value="${pageContext.request.contextPath}"/>
<input type="hidden" id="mainUserRole" value="${sessionScope.sessionUser.role}"/>
<div style="display: flex; height: 100vh;">

    <!-- 과목 사이드바 -->
    <aside class="subject-sidebar">
        <h2 class="subject-sidebar-title">${Course.course_name}</h2>
        <nav class="subject-nav">   
        
            <a href="#" class="subject-nav-item">
            <img src="${pageContext.request.contextPath}/img/icon_home.png" 
            alt="홈 아이콘" width="40px" height="40px">홈</a>
            
            
		        <div class="sidebar-divider"></div>  
		        <!-- 연한 구분순 <hr>  -->

            <a href="#" class="subject-nav-item" onclick="loadContent('score')">
            <img src="${pageContext.request.contextPath}/img/icon_grades.png" 
            alt="성적 아이콘" width="40px" height="40px">성적</a>
       
           
           
            <div class="sidebar-divider"></div> 
            <!-- 연한 구분순 <hr>  -->
            
            
            <a href="#" class="subject-nav-item">
            <img src="${pageContext.request.contextPath}/img/icon_qna.png" 
            alt="QNA" width="40px" height="40px">Q&A</a> 
         
         
          
              <div class="sidebar-divider"></div> 
              <!-- 연한 구분순 <hr>  -->
              
              
            <a href="#" class="subject-nav-item">
            <img src="${pageContext.request.contextPath}/img/icon_studentList.png" 
            alt="학생 아이콘" width="40px" height="40px">학생 리스트</a>
            
            
        </nav>
    </aside>

    <!-- 메인 콘텐츠 -->
    <main class="subject-main" id="mainContent">
    </main>
</div>
<script>
function loadContent(page) {
    const courseNo = document.getElementById("mainCourseNo").value;
    const contextPath = document.getElementById("mainContextPath").value;
    const userRole = document.getElementById("mainUserRole").value;
    if (page === 'score') {
        page = (userRole === 'PROFESSOR' || userRole === 'ADMIN') ? 'profScore' : 'stuScore';
    }
    const urlMap = {
        'profScore': contextPath + '/course/profScore?no=' + courseNo,
        'stuScore' : contextPath + '/course/stuScore?no=' + courseNo,
        'myPage' : contextPath + '/user/myPage',
    };
    fetch(urlMap[page])
    .then(response => response.text())
    .then(html => {
        const main = document.getElementById("mainContent");
        main.innerHTML = html;
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