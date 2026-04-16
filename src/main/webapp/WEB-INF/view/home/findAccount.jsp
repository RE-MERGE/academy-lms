<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>re-merge LMS · 계정 찾기</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css"/>
</head>
<body>

<canvas id="bg-canvas"></canvas>
<div class="bg-mesh"></div>

<%-- 서버 응답 변수 --%>
<%
  /* ── 아이디 찾기 결과 ── */
  String foundId    = (String) request.getAttribute("foundId");      // 찾은 아이디 (마스킹 권장)
  String idFindErr  = (String) request.getAttribute("idFindError");  // 실패 메시지

  /* ── 비밀번호 찾기 결과 ── */
  String pwFindMsg  = (String) request.getAttribute("pwFindMsg");    // 임시PW 발급 or 재설정 링크 안내
  String pwFindErr  = (String) request.getAttribute("pwFindError");  // 실패 메시지

  /* 탭 유지: 서버 처리 후 어떤 탭으로 돌아올지 */
  String activeTab  = (String) request.getAttribute("activeTab");    // "id" | "pw"
  if (activeTab == null) activeTab = "id";
%>

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

      <h2 class="card-title">계정 찾기 🔍</h2>
      <p class="card-sub">가입 시 입력한 정보로 계정을 확인하세요</p>

      <!-- ── 탭 ── -->
      <div class="tab-group" role="tablist">
        <button class="tab-btn <%="id".equals(activeTab) ? "active" : ""%>"
                id="tab-id-btn" role="tab" aria-controls="panel-id"
                onclick="switchTab('id')">아이디 찾기</button>
        <button class="tab-btn <%="pw".equals(activeTab) ? "active" : ""%>"
                id="tab-pw-btn" role="tab" aria-controls="panel-pw"
                onclick="switchTab('pw')">비밀번호 찾기</button>
      </div>

      <!-- ════════════════════════════════════
           TAB 1 : 아이디 찾기
           ════════════════════════════════════ -->
      <div id="panel-id" class="tab-panel <%="id".equals(activeTab) ? "active" : ""%>"
           role="tabpanel">

        <form id="findIdForm" action="findId.do" method="post"
              onsubmit="return validateFindId()">
          <input type="hidden" name="activeTab" value="id"/>

          <div class="field">
            <label for="fi-name">이름</label>
            <input type="text" id="fi-name" name="name"
                   placeholder="가입 시 입력한 이름" autocomplete="name"/>
            <p class="error-msg" id="err-fi-name">이름을 입력해주세요.</p>
          </div>

          <div class="field">
            <label for="fi-email">이메일</label>
            <input type="email" id="fi-email" name="email"
                   placeholder="가입 시 입력한 이메일" autocomplete="email"/>
            <p class="error-msg" id="err-fi-email">올바른 이메일을 입력해주세요.</p>
          </div>

          <button type="submit" class="btn-submit">아이디 찾기</button>
        </form>

        <!-- 서버 결과 -->
        <%
          if (foundId != null) {
        %>
        <div class="result-box" style="display:block;">
          🎉 회원님의 아이디는 <strong><%= foundId %></strong> 입니다.
        </div>
        <% } else if (idFindErr != null) { %>
        <div class="result-box error" style="display:block;">
          ⚠ <%= idFindErr %>
        </div>
        <% } %>

      </div><!-- /panel-id -->


      <!-- ════════════════════════════════════
           TAB 2 : 비밀번호 찾기
           ════════════════════════════════════ -->
      <div id="panel-pw" class="tab-panel <%="pw".equals(activeTab) ? "active" : ""%>"
           role="tabpanel">

        <form id="findPwForm" action="findPw.do" method="post"
              onsubmit="return validateFindPw()">
          <input type="hidden" name="activeTab" value="pw"/>

          <div class="field">
            <label for="fp-id">아이디</label>
            <input type="text" id="fp-id" name="username"
                   placeholder="가입 시 사용한 아이디" autocomplete="username"/>
            <p class="error-msg" id="err-fp-id">아이디를 입력해주세요.</p>
          </div>

          <div class="field">
            <label for="fp-name">이름</label>
            <input type="text" id="fp-name" name="name"
                   placeholder="가입 시 입력한 이름" autocomplete="name"/>
            <p class="error-msg" id="err-fp-name">이름을 입력해주세요.</p>
          </div>

          <div class="field">
            <label for="fp-email">이메일</label>
            <input type="email" id="fp-email" name="email"
                   placeholder="가입 시 입력한 이메일" autocomplete="email"/>
            <p class="error-msg" id="err-fp-email">올바른 이메일을 입력해주세요.</p>
          </div>

          <button type="submit" class="btn-submit">인증 메일 발송</button>
        </form>

        <!-- 서버 결과 -->
        <%
          if (pwFindMsg != null) {
        %>
        <div class="result-box" style="display:block;">
          ✉ <%= pwFindMsg %>
        </div>
        <% } else if (pwFindErr != null) { %>
        <div class="result-box error" style="display:block;">
          ⚠ <%= pwFindErr %>
        </div>
        <% } %>

        <!-- ── 비밀번호 직접 재설정 섹션 (토큰 검증 후 서버에서 show=true 전달 시 표시) ── -->
        <%
          String showReset = (String) request.getAttribute("showReset"); // "true"
          String resetToken = (String) request.getAttribute("resetToken");
          if ("true".equals(showReset)) {
        %>
        <div class="pw-reset-section" style="display:block;">
          <form id="resetPwForm" action="resetPw.do" method="post"
                onsubmit="return validateResetPw()">
            <input type="hidden" name="token" value="<%= resetToken != null ? resetToken : "" %>"/>

            <div class="field">
              <label for="rp-new">새 비밀번호</label>
              <input type="password" id="rp-new" name="newPassword"
                     placeholder="새 비밀번호 (8자 이상)"/>
              <p class="error-msg" id="err-rp-new">비밀번호는 8자 이상이어야 합니다.</p>
            </div>

            <div class="field">
              <label for="rp-confirm">비밀번호 확인</label>
              <input type="password" id="rp-confirm" name="confirmPassword"
                     placeholder="비밀번호를 다시 입력하세요"/>
              <p class="error-msg" id="err-rp-confirm">비밀번호가 일치하지 않습니다.</p>
            </div>

            <button type="submit" class="btn-submit">비밀번호 변경</button>
          </form>
        </div>
        <% } %>

      </div><!-- /panel-pw -->

      <!-- 뒤로가기 -->
      <a href="login" class="back-link">
        &#8592; 로그인으로 돌아가기
      </a>

    </div><!-- /card -->
  </div><!-- /form-panel -->

</div><!-- /page -->

<script src="${pageContext.request.contextPath}/js/bgParticle.js"></script>
<script>
  /* ── 탭 전환 ── */
  function switchTab(tab) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));

    document.getElementById('tab-' + tab + '-btn').classList.add('active');
    document.getElementById('panel-' + tab).classList.add('active');
  }

  /* ── 아이디 찾기 유효성 ── */
  function validateFindId() {
    let valid = true;

    const name  = document.getElementById('fi-name');
    const email = document.getElementById('fi-email');
    const errN  = document.getElementById('err-fi-name');
    const errE  = document.getElementById('err-fi-email');

    if (!name.value.trim()) {
      errN.style.display = 'block'; name.focus(); valid = false;
    } else { errN.style.display = 'none'; }

    const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRe.test(email.value.trim())) {
      errE.style.display = 'block'; if (valid) email.focus(); valid = false;
    } else { errE.style.display = 'none'; }

    return valid;
  }

  /* ── 비밀번호 찾기 유효성 ── */
  function validateFindPw() {
    let valid = true;

    const uid   = document.getElementById('fp-id');
    const name  = document.getElementById('fp-name');
    const email = document.getElementById('fp-email');
    const errU  = document.getElementById('err-fp-id');
    const errN  = document.getElementById('err-fp-name');
    const errE  = document.getElementById('err-fp-email');

    if (!uid.value.trim()) {
      errU.style.display = 'block'; uid.focus(); valid = false;
    } else { errU.style.display = 'none'; }

    if (!name.value.trim()) {
      errN.style.display = 'block'; if (valid) name.focus(); valid = false;
    } else { errN.style.display = 'none'; }

    const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRe.test(email.value.trim())) {
      errE.style.display = 'block'; if (valid) email.focus(); valid = false;
    } else { errE.style.display = 'none'; }

    return valid;
  }

  /* ── 비밀번호 재설정 유효성 ── */
  function validateResetPw() {
    let valid = true;

    const newPw  = document.getElementById('rp-new');
    const confPw = document.getElementById('rp-confirm');
    const errN   = document.getElementById('err-rp-new');
    const errC   = document.getElementById('err-rp-confirm');

    if (newPw.value.trim().length < 8) {
      errN.style.display = 'block'; newPw.focus(); valid = false;
    } else { errN.style.display = 'none'; }

    if (newPw.value !== confPw.value) {
      errC.style.display = 'block'; if (valid) confPw.focus(); valid = false;
    } else { errC.style.display = 'none'; }

    return valid;
  }
</script>

</body>
</html>
