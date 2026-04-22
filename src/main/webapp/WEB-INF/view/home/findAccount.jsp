<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>re-merge LMS · 계정 찾기</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet"/>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { 
    display: flex; 
    align-items: center; 
    justify-content: center; 
    min-height: 100vh; 
    background: linear-gradient(135deg, #f0f4ff 0%, #e8f0fe 100%); }
    .find-wrap { width: 100%; max-width: 500px; padding: 20px; }
    .card { background: white; border-radius: 16px; padding: 2.5rem; box-shadow: 0 8px 32px rgba(30, 58, 138, 0.1); border: 1px solid rgba(59, 130, 246, 0.1); }
    .find-header { text-align: center; margin-bottom: 2rem; }
    .find-title { font-size: 1.5rem; font-weight: 700; color: #1e3a8a; margin-bottom: 0.4rem; }
    .find-sub { font-size: 0.85rem; color: #888; }
    .tab-group { display: grid; grid-template-columns: 1fr 1fr; gap: 0.4rem; margin-bottom: 1.8rem; background: #f1f5f9; border-radius: 12px; padding: 0.3rem; }
    .tab-btn { padding: 0.65rem; background: transparent; border: none; border-radius: 9px; font-family: 'Noto Sans KR', sans-serif; font-size: 0.85rem; font-weight: 700; color: #888; cursor: pointer; transition: all 0.2s; }
    .tab-btn.active { background: #1e3a8a; color: white; box-shadow: 0 2px 8px rgba(30, 58, 138, 0.3); }
    .tab-panel { display: none; }
    .tab-panel.active { display: block; }
    .field { margin-bottom: 1.1rem; }
.field label {
    display: flex;
    align-items: center;
    gap: .35rem;
    font-size: 0.8rem;
    font-weight: 600;
    color: #444;
    margin-bottom: 0.45rem;
    letter-spacing: 0.02em;
}
.field-icon {
    color: #3b82f6;
    font-size: 0.78rem;
}    .field input { width: 100%; padding: 0.78rem 1rem; border: 1.5px solid #e2e8f0; border-radius: 10px; font-family: 'Noto Sans KR', sans-serif; font-size: 0.95rem; outline: none; transition: border-color 0.2s, box-shadow 0.2s; background: #fafbff; }
    .field input:focus { border-color: #3b82f6; background: white; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.12); }
    .error-msg { color: #e53935 !important; font-size: 0.78rem; margin-top: 0.3rem; display: block; font-weight: 600; }
    .btn-submit { width: 100%; padding: 0.88rem; background: linear-gradient(135deg, #1e3a8a, #2563eb); color: white; border: none; border-radius: 10px; font-family: 'Noto Sans KR', sans-serif; font-size: 0.95rem; font-weight: 700; cursor: pointer; margin-top: 0.8rem; transition: opacity 0.2s, transform 0.15s; box-shadow: 0 4px 14px rgba(30, 58, 138, 0.3); }
    .btn-submit:hover { opacity: 0.9; transform: translateY(-1px); }
    .btn-submit:active { transform: translateY(0); }
    .back-link { display: flex; align-items: center; justify-content: center; gap: 0.3rem; margin-top: 1.4rem; font-size: 0.82rem; color: #888; text-decoration: none; transition: color 0.2s; }
    .back-link:hover { color: #1e3a8a; }
    .divider { height: 1px; background: #f0f0f0; margin: 1.5rem 0 0; }
  </style>
</head>
<body>

<div class="find-wrap">
  <div class="card">

    <div class="find-header">
      <h2 class="find-title">계정 찾기 🔍</h2>
      <p class="find-sub">가입 시 입력한 정보로 계정을 확인하세요</p>
    </div>

    <div class="tab-group">
      <button class="tab-btn ${empty activeTab || activeTab == 'id' ? 'active' : ''}" onclick="switchTab('id')">아이디 찾기</button>
      <button class="tab-btn ${activeTab == 'pw' ? 'active' : ''}" onclick="switchTab('pw')">비밀번호 찾기</button>
    </div>

    <!-- 아이디 찾기 탭 -->
    <div id="panel-id" class="tab-panel ${empty activeTab || activeTab == 'id' ? 'active' : ''}">
      <c:choose>
        <%-- 1. 결과가 있는 경우: 결과 박스만 보여줌 --%>
        <c:when test="${not empty findUserId}">
          <div class="result-box" style="text-align:center; padding: 20px; background: #f8faff; border-radius: 12px; border: 1px dashed #3b82f6; margin-bottom: 1rem;">
            <p style="color: #1e3a8a; font-weight: bold; font-size: 1.1rem;">귀하의 ID입니다.</p>
            <h3 style="margin: 20px 0; color: #2563eb; font-size: 1.4rem; letter-spacing: 0.05em;">${findUserId}</h3>
            <a href="${pageContext.request.contextPath}/user/loginForm" class="btn-submit" style="display:block; text-decoration:none; text-align:center;">로그인하러 가기</a>
          </div>
        </c:when>

        <%-- 2. 결과가 없는 경우: 입력 폼을 보여줌 --%>
        <c:otherwise>
          <form:form action="${pageContext.request.contextPath}/user/findId" method="post" modelAttribute="findIdForm">
            <div class="field">
              <label>이름</label>
              <form:input path="name" placeholder="실명을 입력하세요."/>
              <form:errors path="name" cssClass="error-msg" element="p"/>
            </div>
            <div class="field">
              <label>이메일</label>
              <form:input path="email" placeholder="이메일을 입력하세요."/>
              <form:errors path="email" cssClass="error-msg" element="p"/>
            </div>
            <div class="field">
              <label>연락처</label>
              <form:input path="phone" placeholder="연락처를 입력하세요."/>
              <form:errors path="phone" cssClass="error-msg" element="p"/>
            </div>

            <form:errors path="" cssClass="error-msg" element="p" />

            <button type="submit" class="btn-submit">아이디 찾기</button>

          </form:form>
        </c:otherwise>
      </c:choose>


    </div>



    <!-- 비밀번호 찾기 탭 -->
    <div id="panel-pw" class="tab-panel ${activeTab == 'pw' ? 'active' : ''}">
      <form:form action="${pageContext.request.contextPath}/user/findPw"
                 method="post" modelAttribute="findPwForm">
        <div class="field">
          <label><span class="field-icon">✦</span>아이디</label>
          <form:input path="userId" placeholder="아이디를 입력하세요."/>
          <form:errors path="userId" cssClass="error-msg" element="p"/>
        </div>
        <div class="field">
          <label><span class="field-icon">✦</span>이메일</label>
          <form:input path="email" placeholder="이메일을 입력하세요."/>
          <form:errors path="email" cssClass="error-msg" element="p"/>
        </div>
        <div class="field">
          <label><span class="field-icon">✦</span>연락처</label>
          <form:input path="phone" placeholder="연락처를 입력하세요."/>
          <form:errors path="phone" cssClass="error-msg" element="p"/>
        </div>
        <button type="submit" class="btn-submit">인증 메일 발송</button>
      </form:form>
    </div>


    <div class="divider"></div>
    <a href="${pageContext.request.contextPath}/home/home" class="back-link">
      ← 로그인으로 돌아가기
    </a>

  </div>
</div>

<script>
  function switchTab(tab) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));

    if (tab === 'id') {
      document.querySelectorAll('.tab-btn')[0].classList.add('active');
      document.getElementById('panel-id').classList.add('active');
    } else {
      document.querySelectorAll('.tab-btn')[1].classList.add('active');
      document.getElementById('panel-pw').classList.add('active');
    }

    // 탭 전환 시 에러 메시지 및 입력값 초기화
    document.querySelectorAll('.error-msg').forEach(e => e.style.display = 'none');
    document.querySelectorAll('.field input').forEach(i => i.value = '');
  }
</script>

</body>
</html>