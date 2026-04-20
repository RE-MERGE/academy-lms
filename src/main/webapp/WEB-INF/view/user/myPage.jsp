<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지 | LMS 대학교</title>
    <link rel="stylesheet" href="/resources/css/myPage.css">
</head>
<body>

<div class="page-container">
    <div class="page-header">
        <h2 class="page-title">마이페이지</h2>
        <div class="page-breadcrumb">
            <a href="/">Home</a> <span>/</span> MyPage
        </div>
    </div>

    <div class="card profile-main-card">
        <div class="profile-avatar-wrap">
            <img src="${user.profileImg != null ? user.profileImg : '/resources/img/default-avatar.png'}" alt="프로필 사진" class="profile-img-large">
            <span class="badge badge-primary readonly-tag">Readonly</span>
        </div>

        <div class="profile-info-grid">
            <div class="info-row">
                <span class="info-label">이름</span>
                <span class="info-value">${user.name}</span>
            </div>
            <div class="info-row">
                <span class="info-label">학번</span>
                <span class="info-value">
                    ${user.userCode}
                    <small class="join-type">(가입일: <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd"/>)</small>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">아이디</span>
                <span class="info-value">${user.userId}</span>
            </div>
            <div class="info-row">
                <span class="info-label">이메일</span>
                <span class="info-value">${user.email}</span>
            </div>
        </div>
    </div>

    <div class="profile-quick-nav">
        <a href="/course/currentList" class="quick-btn active">
            <span class="si-icon">📚</span> 수강중인 과목
        </a>
        <a href="/grade/checkGrade" class="quick-btn">
            <span class="si-icon">📊</span> 성적 확인
        </a>
        <a href="/schedule/timetable" class="quick-btn">
            <span class="si-icon">📅</span> 시간표
        </a>
    </div>

    <div class="profile-settings-wrap">
        <button class="btn-secondary" onclick="location.href='/user/edit'">회원정보 수정</button>
        <button class="btn-primary" onclick="location.href='/user/changePassword'">비밀번호 변경</button>
    </div>
</div>

</body>
</html>