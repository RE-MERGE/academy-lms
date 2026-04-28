<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${not empty errorMsg}">
    <script>alert("${errorMsg}");</script>
</c:if>

<%-- URI 추출 후 조건 체크 (사이드바 표시 여부) --%>
<c:set var="uri" value="${requestScope['javax.servlet.forward.request_uri']}"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="showSubjectSidebar" value=
        "${fn:contains(uri, '/board/list_subject') or
           fn:contains(uri, '/course/mainSubject') or
           fn:contains(uri, '/board/subjectHome') or
           fn:contains(uri, '/course/profScore') or
           fn:contains(uri, '/board/list_qna')
           }"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>re-merge LMS | <sitemesh:write property="title"/></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/css/main.css">
    <sitemesh:write property="head"/>
    <style>
        .si-label { margin-left: 15px; }
    </style>
</head>
<body>

<div class="layout-root">
    <div class="header-wrapper">
        <div class="header-topbar"></div>
        <header class="lms-header">
            <a href="${ctx}/home/dashboard" class="lms-logo-wrap">
                <div class="lms-logo-text">
                    <span class="lms-logo-main">re<span>·</span>merge</span>
                    <span class="lms-logo-sub">Learning Management System</span>
                </div>
            </a>

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
                    <span class="user-id">${sessionScope.sessionUser.displayUserId}</span>
                    <span class="user-name">${sessionScope.sessionUser.name}</span>
                </div>
                <a href="${ctx}/user/logout" class="btn-logout">로그아웃</a>
            </div>
        </header>
    </div>

    <div class="layout-body">
        <nav class="sidebar">
            <span class="sidebar-section-label">메인</span>
            <a href="${ctx}/home/dashboard" class="sidebar-item">
                <img src="${ctx}/img/icon_dashboard.png" alt="대시보드" width="50px" height="50px">
                <span class="si-label">대시보드</span>
            </a>
            <div class="sidebar-divider"></div>

            <span class="sidebar-section-label">학습</span>
            <a href="${ctx}/course/home" class="sidebar-item" id="course-menu">
                <img src="${ctx}/img/icon_courses.png" alt="전체과목" width="50px" height="50px">
                <span class="si-label">전체 과목</span>
            </a>
            <a href="${ctx}/enrollment/courseEnrollment" class="sidebar-item">
                <img src="${ctx}/img/icon_enrollment.png" alt="수강신청" width="50px" height="50px">
                <span class="si-label">수강신청</span>
            </a>
            <a href="${ctx}/board/list" class="sidebar-item">
                <img src="${ctx}/img/icon_board.png" alt="게시판" width="50px" height="50px">
                <span class="si-label">게시판</span>
            </a>
            <div class="sidebar-divider"></div>

            <span class="sidebar-section-label">계정</span>
            <a href="${ctx}/user/myPage" class="sidebar-item">
                <img src="${ctx}/img/icon_mypage.png" alt="마이페이지" width="50px" height="50px">
                <span class="si-label">마이페이지</span>
            </a>

            <c:if test="${sessionScope.sessionUser.role == 'ADMIN'}">
                <div class="sidebar-divider"></div>
                <span class="sidebar-section-label">관리자</span>
                <a href="${ctx}/admin/userList" class="sidebar-item">
                    <img src="${ctx}/img/icon_Member Management.png" alt="회원관리" width="50px" height="50px">
                    <span class="si-label">전체 회원 관리</span>
                </a>
                <a href="${ctx}/admin/adminCourseList" class="sidebar-item">
                    <img src="${ctx}/img/icon_Course Management.png" alt="수업관리" width="50px" height="50px">
                    <span class="si-label">전체 수업 관리</span>
                </a>
                <a href="${ctx}/admin/roomTimetable" class="sidebar-item">
                    <img src="${ctx}/img/icon_timetable.png" alt="시간표" width="43px" height="43px">
                    <span class="si-label">전체 시간표 조회</span>
                </a>
            </c:if>
        </nav>

        <div class="flyout" id="course-flyout">
            <h3 class="flyout-title">${course.course_name}</h3>
            <ul class="flyout-list">
                <c:if test="${not empty courseList}">
                    <c:forEach var="courseItem" items="${courseList}">
                        <li class="flyout-item">
                            <a href="${ctx}/board/subjectHome?courseNo=${courseItem.course_no}">
                                    ${courseItem.course_name}
                            </a>
                            <c:set var="isFav" value="false"/>
                            <c:forEach var="fno" items="${favoriteNos}">
                                <c:if test="${fno == courseItem.course_no}"><c:set var="isFav" value="true"/></c:if>
                            </c:forEach>
                            <button class="fav-btn ${isFav ? 'active' : ''}" onclick="toggleFavorite(event, this, ${courseItem.course_no})">
                                    ${isFav ? '★' : '☆'}
                            </button>
                        </li>
                    </c:forEach>
                </c:if>
            </ul>
        </div>

        <c:if test="${showSubjectSidebar}">
            <aside class="subject-sidebar">
                <h2 class="subject-sidebar-title">${course.course_name}</h2>
                <nav class="subject-nav">
                    <a href="${ctx}/board/subjectHome?courseNo=${course.course_no}" class="subject-nav-item active">
                        <img src="${ctx}/img/icon_home.png" alt="홈" width="40px" height="40px">홈</a>
                    <div class="sidebar-divider"></div>
                    <a href="${ctx}/course/profScore" class="subject-nav-item">
                        <img src="${ctx}/img/icon_grades.png" alt="성적" width="40px" height="40px">성적</a>
                    <div class="sidebar-divider"></div>
                    <a href="${ctx}/board/list_qna?boardType=QNA&courseNo=${course.course_no}" class="subject-nav-item">
                        <img src="${ctx}/img/icon_qna.png" alt="QNA" width="40px" height="40px">Q&A</a>
                    <div class="sidebar-divider"></div>
                    <a href="#" class="subject-nav-item">
                        <img src="${ctx}/img/icon_studentList.png" alt="학생" width="40px" height="40px">학생 리스트</a>
                </nav>
            </aside>
        </c:if>

        <main class="main-content">
            <sitemesh:write property="body"/>
        </main>
    </div>
</div>

<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function () {
        const courseMenu = document.getElementById('course-menu');
        const flyout = document.getElementById('course-flyout');
        let hideTimer;

        if(courseMenu && flyout) {
            courseMenu.addEventListener('mouseenter', () => {
                clearTimeout(hideTimer);
                flyout.classList.add('active');
            });

            courseMenu.addEventListener('mouseleave', () => {
                hideTimer = setTimeout(() => {
                    if (!flyout.matches(':hover')) flyout.classList.remove('active');
                }, 500);
            });

            flyout.addEventListener('mouseenter', () => clearTimeout(hideTimer));
            flyout.addEventListener('mouseleave', () => {
                flyout.classList.remove('active');
            });
        }
    });

    function toggleFavorite(event, btn, courseNo) {
        event.preventDefault();
        event.stopPropagation();
        const isFav = btn.classList.contains('active');
        const url = isFav ? '${ctx}/course/remove' : '${ctx}/course/add';

        fetch(url, {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
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
