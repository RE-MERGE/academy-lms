<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>re-merge LMS · 로그인</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet"/>

  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --navy:    #0a1628;
      --blue:    #1a3a6b;
      --mid:     #1e4fa0;
      --accent:  #2e6ae6;
      --bright:  #4d8fff;
      --green:   #22c55e;
      --yellow:  #f4b400;
      --red:     #e53935;
      --white:   #ffffff;
      --text-sub:#a8bbd4;
    }

    html, body {
      height: 100%;
      font-family: 'Noto Sans KR', sans-serif;
      background: var(--navy);
      overflow: hidden;
    }

    /* ── 배경 파티클 캔버스 ── */
    #bg-canvas {
      position: fixed;
      inset: 0;
      pointer-events: none;
      z-index: 0;
    }

    /* ── 메시 그라디언트 배경 ── */
    .bg-mesh {
      position: fixed;
      inset: 0;
      z-index: 0;
      background:
              radial-gradient(ellipse 80% 60% at 20% 20%, rgba(30,79,160,.45) 0%, transparent 60%),
              radial-gradient(ellipse 60% 80% at 80% 80%, rgba(46,106,230,.3) 0%, transparent 55%),
              radial-gradient(ellipse 50% 50% at 50% 50%, rgba(10,22,40,1) 0%, transparent 100%);
    }

    /* ── 레이아웃 ── */
    .page {
      position: relative;
      z-index: 1;
      height: 100vh;
      display: grid;
      grid-template-columns: 1fr 1fr;
    }

    /* ── 왼쪽 브랜드 패널 ── */
    .brand-panel {
      display: flex;
      flex-direction: column;
      justify-content: center;
      padding: 0 5vw 0 8vw;
      animation: slideInLeft .9s cubic-bezier(.16,1,.3,1) both;
    }

    .brand-eyebrow {
      font-size: .72rem;
      letter-spacing: .22em;
      text-transform: uppercase;
      color: var(--bright);
      margin-bottom: 1.4rem;
      opacity: 0;
      animation: fadeUp .7s .3s forwards;
    }

    .brand-logo {
      font-family: 'Syne', sans-serif;
      font-size: clamp(2.8rem, 4.5vw, 4.2rem);
      font-weight: 800;
      color: var(--white);
      line-height: 1.05;
      letter-spacing: -.02em;
      opacity: 0;
      animation: fadeUp .7s .45s forwards;
    }

    .brand-logo span {
      color: var(--bright);
    }

    .brand-desc {
      margin-top: 1.6rem;
      font-size: .95rem;
      line-height: 1.75;
      color: var(--text-sub);
      max-width: 320px;
      opacity: 0;
      animation: fadeUp .7s .6s forwards;
    }

    .brand-dots {
      display: flex;
      gap: .55rem;
      margin-top: 2.4rem;
      opacity: 0;
      animation: fadeUp .7s .75s forwards;
    }

    .brand-dots span {
      width: 8px; height: 8px;
      border-radius: 50%;
      background: var(--accent);
    }
    .brand-dots span:nth-child(2) { background: var(--bright); opacity: .6; }
    .brand-dots span:nth-child(3) { background: var(--bright); opacity: .3; }

    /* ── 오른쪽 폼 패널 ── */
    .form-panel {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem;
    }

    .card {
      width: 100%;
      max-width: 420px;
      background: rgba(255,255,255,.04);
      border: 1px solid rgba(255,255,255,.09);
      border-radius: 24px;
      padding: 2.8rem 2.6rem;
      backdrop-filter: blur(24px);
      box-shadow:
              0 32px 80px rgba(0,0,0,.5),
              0 0 0 1px rgba(77,143,255,.08) inset;
      opacity: 0;
      animation: fadeUp .8s .5s cubic-bezier(.16,1,.3,1) forwards;
    }

    .card-title {
      font-family: 'Syne', sans-serif;
      font-size: 1.5rem;
      font-weight: 700;
      color: var(--white);
      margin-bottom: .4rem;
    }

    .card-sub {
      font-size: .82rem;
      color: var(--text-sub);
      margin-bottom: 2rem;
    }

    /* ── 입력 필드 ── */
    .field {
      margin-bottom: 1.1rem;
    }

    .field label {
      display: block;
      font-size: .78rem;
      font-weight: 500;
      color: var(--text-sub);
      letter-spacing: .06em;
      text-transform: uppercase;
      margin-bottom: .5rem;
    }

    .field input {
      width: 100%;
      padding: .82rem 1.1rem;
      background: rgba(255,255,255,.06);
      border: 1px solid rgba(255,255,255,.1);
      border-radius: 12px;
      color: var(--white);
      font-family: 'Noto Sans KR', sans-serif;
      font-size: .95rem;
      outline: none;
      transition: border-color .2s, background .2s, box-shadow .2s;
    }

    .field input::placeholder { color: rgba(255,255,255,.25); }

    .field input:focus {
      border-color: var(--bright);
      background: rgba(77,143,255,.08);
      box-shadow: 0 0 0 3px rgba(77,143,255,.18);
    }

    /* ── 버튼 그룹 ── */
    .btn-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: .7rem;
      margin-top: .8rem;
    }

    .btn {
      padding: .72rem .6rem;
      border: none;
      border-radius: 10px;
      font-family: 'Noto Sans KR', sans-serif;
      font-size: .82rem;
      font-weight: 700;
      cursor: pointer;
      transition: transform .15s, box-shadow .15s, filter .15s;
      letter-spacing: .02em;
    }

    .btn:hover  { transform: translateY(-2px); filter: brightness(1.1); }
    .btn:active { transform: translateY(0);    filter: brightness(.95); }

    .btn-register {
      background: var(--yellow);
      color: #1a1200;
    }

    .btn-find {
      background: var(--red);
      color: var(--white);
    }

    /* ── 로그인 버튼 (전체 너비) ── */
    .btn-login {
      width: 100%;
      padding: .9rem;
      background: var(--accent);
      color: var(--white);
      border: none;
      border-radius: 12px;
      font-family: 'Syne', sans-serif;
      font-size: 1rem;
      font-weight: 700;
      letter-spacing: .04em;
      cursor: pointer;
      margin-top: 1.2rem;
      transition: transform .15s, box-shadow .15s, background .2s;
      box-shadow: 0 6px 24px rgba(46,106,230,.4);
      position: relative;
      overflow: hidden;
    }

    .btn-login::after {
      content: '';
      position: absolute;
      inset: 0;
      background: linear-gradient(135deg, rgba(255,255,255,.15) 0%, transparent 60%);
      pointer-events: none;
    }

    .btn-login:hover {
      background: var(--bright);
      transform: translateY(-2px);
      box-shadow: 0 10px 32px rgba(77,143,255,.5);
    }

    .btn-login:active { transform: translateY(0); }

    /* ── 네이버 로그인 ── */
    .divider {
      display: flex;
      align-items: center;
      gap: .8rem;
      margin: 1.4rem 0 1.1rem;
      color: rgba(255,255,255,.2);
      font-size: .75rem;
    }

    .divider::before, .divider::after {
      content: '';
      flex: 1;
      height: 1px;
      background: rgba(255,255,255,.1);
    }

    .btn-naver {
      width: 100%;
      padding: .82rem;
      background: #03c75a;
      color: #fff;
      border: none;
      border-radius: 12px;
      font-family: 'Noto Sans KR', sans-serif;
      font-size: .9rem;
      font-weight: 700;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: .55rem;
      transition: transform .15s, filter .15s, box-shadow .15s;
      box-shadow: 0 4px 18px rgba(3,199,90,.3);
    }

    .btn-naver:hover {
      filter: brightness(1.08);
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(3,199,90,.45);
    }

    .naver-n {
      width: 20px; height: 20px;
      background: #fff;
      border-radius: 4px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Syne', sans-serif;
      font-size: .75rem;
      font-weight: 800;
      color: #03c75a;
      flex-shrink: 0;
    }

    /* ── 에러 메시지 ── */
    .error-msg {
      display: block;
      color: #ff6b6b;
      font-size: .78rem;
      margin-top: .4rem;
      padding-left: .2rem;
    }

    /* ── 반응형 ── */
    @media (max-width: 768px) {
      .page { grid-template-columns: 1fr; }
      .brand-panel { display: none; }
      .form-panel { padding: 1.5rem; }
      .card { max-width: 100%; }
    }

    /* ── 애니메이션 ── */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(18px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    @keyframes slideInLeft {
      from { opacity: 0; transform: translateX(-30px); }
      to   { opacity: 1; transform: translateX(0); }
    }
  </style>
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

      <form:form id="loginForm" action="${pageContext.request.contextPath}/user/login" method="post" modelAttribute="loginForm">

          <div class="field">
              <label for="userId">아이디</label>
              <form:input path="userId" id="userId" placeholder="아이디를 입력하세요" autocomplete="username"/>
              <form:errors path="userId" cssClass="error-msg" element="p"/>
          </div>

          <div class="field">
              <label for="password">비밀번호</label>
              <form:password path="password" id="password" placeholder="비밀번호를 입력하세요" autocomplete="current-password"/>
              <form:errors path="password" cssClass="error-msg" element="p"/>
          </div>

          <%-- 서버 로그인 실패 메시지 --%>
          <form:errors path="*" cssClass="error-msg" element="p"/>

          <div class="btn-row">
              <button type="button" class="btn btn-register" onclick="location.href='${pageContext.request.contextPath}/user/joinForm'">회원가입</button>
              <button type="button" class="btn btn-find" onclick="location.href='${pageContext.request.contextPath}/home/findAccount'">아이디 / 비밀번호 찾기</button>
          </div>
          <button type="submit" class="btn-login">로그인</button>

      </form:form>

      <div class="divider">또는</div>

      <button class="btn-naver" onclick="location.href='${pageContext.request.contextPath}/user/naverLogin'">
        <span class="naver-n">N</span>
        네이버 계정으로 로그인
      </button>

    </div>
  </div>
</div>

<script>
  /* ── 파티클 배경 ── */
  (function () {
    const canvas = document.getElementById('bg-canvas');
    const ctx    = canvas.getContext('2d');
    let W, H, particles = [];

    function resize() {
      W = canvas.width  = window.innerWidth;
      H = canvas.height = window.innerHeight;
    }

    function Particle() {
      this.x  = Math.random() * W;
      this.y  = Math.random() * H;
      this.vx = (Math.random() - .5) * .35;
      this.vy = (Math.random() - .5) * .35;
      this.r  = Math.random() * 1.8 + .5;
      this.a  = Math.random() * .4 + .1;
    }

    function init() {
      particles = Array.from({ length: 90 }, () => new Particle());
    }

    function draw() {
      ctx.clearRect(0, 0, W, H);
      particles.forEach(p => {
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(77,143,255,${p.a})`;
        ctx.fill();

        p.x += p.vx;
        p.y += p.vy;
        if (p.x < 0 || p.x > W) p.vx *= -1;
        if (p.y < 0 || p.y > H) p.vy *= -1;
      });

      /* 가까운 파티클끼리 선 연결 */
      for (let i = 0; i < particles.length; i++) {
        for (let j = i + 1; j < particles.length; j++) {
          const dx = particles[i].x - particles[j].x;
          const dy = particles[i].y - particles[j].y;
          const d  = Math.sqrt(dx * dx + dy * dy);
          if (d < 100) {
            ctx.beginPath();
            ctx.moveTo(particles[i].x, particles[i].y);
            ctx.lineTo(particles[j].x, particles[j].y);
            ctx.strokeStyle = `rgba(77,143,255,${.12 * (1 - d / 100)})`;
            ctx.lineWidth   = .5;
            ctx.stroke();
          }
        }
      }

      requestAnimationFrame(draw);
    }

    window.addEventListener('resize', () => { resize(); init(); });
    resize(); init(); draw();
  })();

  /* Enter 키 제출 */
  document.getElementById('loginForm').addEventListener('keydown', function(e) {
    if (e.key === 'Enter') this.submit();
  });
</script>

</body>
</html>
