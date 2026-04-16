<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>re-merge LMS · 로그인</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css"/>
</head>
<body>

<canvas id="bg-canvas"></canvas>
<div class="bg-mesh"></div>

<div class="page">

  <!-- 왼쪽 브랜드 패널 -->
  <div class="brand-panel">
    <p class="brand-eyebrow">Learning Management System</p>
    <h1 class="brand-logo">re-merge<br/><span>LMS</span></h1>
    <p class="brand-desc">학생, 강사, 관리자가 하나의 플랫폼에서<br/>수업을 열고, 배우고, 성장합니다.</p>
    <div class="brand-dots">
      <span></span><span></span><span></span>
    </div>
  </div>

  <!-- 오른쪽 폼 패널 -->
  <div class="form-panel">
    <div class="card">
      <h2 class="card-title">환영합니다 👋</h2>
      <p class="card-sub">계속하려면 로그인하세요</p>

      <form id="loginForm" action="login.do" method="post" onsubmit="return validateLogin()">

        <div class="field">
          <label for="username">아이디</label>
          <input type="text" id="username" name="username"
                 placeholder="아이디를 입력하세요" autocomplete="username"/>
          <p class="error-msg" id="err-id">아이디를 입력해주세요.</p>
        </div>

        <div class="field">
          <label for="password">비밀번호</label>
          <input type="password" id="password" name="password"
                 placeholder="비밀번호를 입력하세요" autocomplete="current-password"/>
          <p class="error-msg" id="err-pw">비밀번호를 입력해주세요.</p>
        </div>

        <%-- 서버에서 로그인 실패 메시지 전달 시 --%>
        <%
          String loginError = (String) request.getAttribute("loginError");
          if (loginError != null) {
        %>
        <p style="color:#ff6b6b;font-size:.82rem;margin-bottom:.5rem;padding-left:.2rem;">
          <%= loginError %>
        </p>
        <% } %>

        <div class="btn-row">
          <button type="button" class="btn btn-register"
                  onclick="location.href='register.jsp'">회원가입</button>
          <button type="button" class="btn btn-find"
                  onclick="location.href='findAccount'">아이디 / 비밀번호 찾기</button>
        </div>

        <button type="submit" class="btn-login">로그인</button>

      </form>

      <div class="divider">또는</div>

      <button class="btn-naver" onclick="location.href='naverLogin.do'">
        <span class="naver-n">N</span>
        네이버 계정으로 로그인
      </button>

    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/bgParticle.js"></script>
<script>
  /* ── 클라이언트 유효성 검사 ── */
  function validateLogin() {
    let valid = true;

    const id    = document.getElementById('username');
    const pw    = document.getElementById('password');
    const errId = document.getElementById('err-id');
    const errPw = document.getElementById('err-pw');

    if (!id.value.trim()) {
      errId.style.display = 'block';
      id.focus();
      valid = false;
    } else {
      errId.style.display = 'none';
    }

    if (!pw.value.trim()) {
      errPw.style.display = 'block';
      if (valid) pw.focus();
      valid = false;
    } else {
      errPw.style.display = 'none';
    }

    return valid;
  }

  /* Enter 키 제출 */
  document.getElementById('loginForm').addEventListener('keydown', function (e) {
    if (e.key === 'Enter') validateLogin() && this.submit();
  });
</script>

</body>
</html>
