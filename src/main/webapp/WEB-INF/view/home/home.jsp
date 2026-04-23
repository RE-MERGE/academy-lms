<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>re-merge LMS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;800;900&family=Syne:wght@700;800&display=swap" rel="stylesheet"/><style>
/* ── login.jsp 기존 디자인 스타일 ── */
* { box-sizing: border-box; margin: 0; padding: 0; }
html, body { width: 100%; height: 100%; overflow: hidden; font-family: 'Pretendard', 'Noto Sans KR', sans-serif; }

.bg {
  position: fixed; inset: 0; z-index: 0;
  background-image: url('${pageContext.request.contextPath}/img/background.png');
  background-size: cover; background-position: center center;
}

.layout {
  position: relative; z-index: 1;
  width: 100vw; height: 100vh;
  display: grid; grid-template-columns: 1fr 580px;
}

.left { display: flex; flex-direction: column; justify-content: center; padding: 0 32px 0 160px; }
.left::after {
  content: ''; position: absolute; inset: 0;
  background: linear-gradient(to left, rgba(255,255,255,0) 0%, rgba(255,255,255,0.1) 30%, rgba(255,255,255,0.4) 60%, rgba(255,255,255,0.85) 120%);
  z-index: 0;
}
.left > * { position: relative; z-index: 1; }

.eyebrow { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; opacity: 0; animation: rise 0.6s ease forwards; animation-delay: 0.1s; }
.eyebrow-line { width: 28px; height: 1.5px; background: #1C4BC9; }
.eyebrow span { font-size: 10.5px; font-weight: 500; letter-spacing: 0.24em; text-transform: uppercase; color: #FFA729; text-shadow: 0 0 40px rgba(255, 255, 255, 0.6); }

.title { font-family: 'Playfair Display', serif; font-size: clamp(72px, 8.5vw, 116px); font-weight: 900; line-height: 0.88; letter-spacing: -3px; color: #ffffff; text-shadow: 0 2px 6px rgba(0,0,0,0.65), 0 6px 32px rgba(0,0,0,0.45), 0 14px 72px rgba(0,0,0,0.22); opacity: 0; animation: rise 0.7s ease forwards; animation-delay: 0.2s; }
.title em { font-style: italic; color: #1C4BC9; display: block; text-shadow: 0 2px 6px rgba(255,255,255, 0.45), 0 6px 32px rgba(255,255,255, 0.15); }

.sep { width: 48px; height: 3px; background: #2563EB; margin: 24px 0 20px; border-radius: 2px; opacity: 0; animation: rise 0.6s ease forwards; animation-delay: 0.35s; }
.desc { font-size: 15px; font-weight: 400; color: #000; line-height: 2.0; max-width: 360px; text-shadow: 0 1px 6px rgba(255,255,255,1), 0 3px 20px rgba(255,255,255,0.1); opacity: 0; animation: rise 0.6s ease forwards; animation-delay: 0.45s; }
.dots { display: flex; gap: 8px; margin-top: 32px; opacity: 0; animation: rise 0.6s ease forwards; animation-delay: 0.55s; }
.dots span { display: block; width: 8px; height: 8px; border-radius: 50%; background: rgba(255,255,255,0.4); }
.dots span:first-child { width: 26px; border-radius: 4px; background: #1695DB; }

.right { display: flex; align-items: center; justify-content: center; padding: 14px 28px 14px 0; }
.card { 
width: 100%; 
background: rgba(255,255,255,0.82); 
border: 1px solid rgba(255,255,255,0.92); 
border-radius: 20px; 
padding: 40px 52px 52px; 
backdrop-filter: blur(32px) saturate(1.8); 
box-shadow: 0 24px 72px rgba(15,23,42,0.14), 0 4px 20px rgba(15,23,42,0.08); 
opacity: 0; 
animation: rise 0.8s ease forwards; 
animation-delay: 0.15s; 
overflow: hidden;
}
.card-topline {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;

  height: 3px;
  background: linear-gradient(to right, #2563eb, #93c5fd, transparent);

  border-radius: 20px 20px 0 0;
  margin: 0; /* 👈 기존 음수 margin 제거 */
}
  .card-title {
  /* 1. 이미 불러오신 Noto Sans KR을 사용 (Pretendard 차단 대비) */
  font-family: 'Noto Sans KR', sans-serif !important;
  
  /* 2. 폰트 크기를 다시 지정 (이게 빠져서 안 두꺼워 보일 수 있습니다) */
  font-size: 36px !important; 
  
  /* 3. 두께를 가장 두꺼운 900으로 설정 */
  font-weight: 600 !important;
  
  color: #0f172a; 
  margin-bottom: 12px; 
  letter-spacing: -1px;
  display: block;
  
  /* 4. 글자를 더 선명하게 만드는 효과 */
  -webkit-font-smoothing: antialiased;
}


.card-sub { 
font-size: 17px; 
color: #64748b; 
margin-bottom: 30px; }

.field { margin-bottom: 18px; }
.field label { display: block; font-size: 12px; font-weight: 600; letter-spacing: 0.16em; text-transform: uppercase; color: #64748b; margin-bottom: 8px; }
.field input { width: 100%; padding: 16px 18px; background: rgba(248,250,252,0.9); border: 1.5px solid #e2e8f0; border-radius: 10px; font-size: 17px; color: #0f172a; outline: none; transition: all 0.2s; }
.field input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.12); background: #fff; }

.aux-row { display: flex; gap: 8px; margin: 10px 0 20px; }
.aux-btn { flex: 1; padding: 14px 8px; border: 1.5px solid #e2e8f0; border-radius: 10px; font-size: 17px; font-weight: 500; background: #FF3B15; color: #ffffff; cursor: pointer; transition: all 0.15s; }
.aux-btn2 { flex: 1; padding: 14px 8px; border: 1.5px solid #e2e8f0; border-radius: 10px; font-size: 17px; font-weight: 500; background: #FFC821; color: #ffffff; cursor: pointer; transition: all 0.15s; }

.btn-login { 
width: 100%; 
padding: 18px; 
background: #2563eb; 
border: none; 
border-radius: 10px; font-size: 18px; font-weight: 600; color: #fff; cursor: pointer; margin-bottom: 2px; transition: all 0.15s; box-shadow: 0 4px 16px rgba(37,99,235,0.35); }

.btn-login:hover { background: #1d4ed8; box-shadow: 0 6px 24px rgba(37,99,235,0.5); }

.or-row { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; font-size: 10px; color: #cbd5e1; text-transform: uppercase; }
.or-row::before, .or-row::after { content: ''; flex: 1; height: 1px; background: #e2e8f0; }

.btn-naver { width: 100%; padding: 17px; background: #03c75a; border: none; border-radius: 10px; font-size: 17px; font-weight: 500; color: #fff; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 10px; transition: opacity 0.15s; }
.naver-n { width: 26px; height: 26px; background: #fff; border-radius: 5px; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 900; color: #03c75a; }

.error-msg { color: #ff6b6b; font-size: 0.8rem; margin-top: 4px; display: block; }

@keyframes rise { from { opacity: 0; transform: translateY(14px); } to { opacity: 1; transform: translateY(0); } }
</style>
</head>
<body>
<div class="bg"></div>
<div class="layout">

  <div class="left">
    <div class="eyebrow">
      <div class="eyebrow-line"></div>
      <span>Learning Management System</span>
    </div>
    <div class="title">re-merge<em>LMS</em></div>
    <div class="sep"></div>
    <p class="desc">미래를 밝히는 에너지, 세상을 바꾸는 인재를 키웁니다.<br>신재생에너지 분야 최고의 전문 인력을 양성하는 <br>국내 유일의 특성화 대학교입니다.</p>
    <div class="dots"><span></span><span></span><span></span></div>
  </div>

  <div class="right">
    <div class="card">
      <div class="card-topline"></div>
      <div class="card-title">환영합니다</div>
      <div class="card-sub">계속하려면 로그인하세요</div>

      <form:form id="loginForm" action="${pageContext.request.contextPath}/user/login" method="post" modelAttribute="loginForm">
            <input type="hidden" name="redirectURL" value="${pageContext.request.getParameter('redirectURL')}"/>          <div class="field">
              <label for="userId">아이디</label>
              <form:input path="userId" id="userId" placeholder="아이디를 입력하세요" autocomplete="username"/>
              <form:errors path="userId" cssClass="error-msg" element="p"/>
          </div>
          <div class="field">
              <label for="password">비밀번호</label>
              <form:password path="password" id="password" placeholder="비밀번호를 입력하세요" autocomplete="current-password"/>
              <form:errors path="password" cssClass="error-msg" element="p"/>
          </div>

          <form:errors path="" cssClass="error-msg" element="p" />

 <button type="submit" class="btn-login">로그인</button>

          <div class="aux-row">
            <button type="button" class="aux-btn2" onclick="location.href='${pageContext.request.contextPath}/user/joinForm'">회원가입</button>
            <button type="button" class="aux-btn" onclick="location.href='${pageContext.request.contextPath}/home/findAccount'">아이디 / 비밀번호 찾기</button>
          </div>

     
      </form:form>

      <div class="or-row">또는</div>

      <button type="button" class="btn-naver" onclick="location.href='${pageContext.request.contextPath}/user/naverLogin'">
        <div class="naver-n">N</div>
        네이버 계정으로 로그인
      </button>
    </div>
  </div>

</div>

<script>
  /* Enter 키 제출 기능 통합 */
  document.getElementById('loginForm').addEventListener('keydown', function(e) {
    if (e.key === 'Enter') {
      e.preventDefault();
      this.submit();
    }
  });

  const msg = "${msg}";
      if (msg) {
          alert(msg);
      }

</script>
</body>
</html>