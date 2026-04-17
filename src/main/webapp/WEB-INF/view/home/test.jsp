<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>LMS Dashboard</title>

<style>
body {
  margin: 0;
  font-family: 'Noto Sans KR', Arial, sans-serif;
  background: #f5f7fb;
}

.header {
  background: #1e3a8a;
  color: black;
  padding: 15px 30px;
  display: flex;
  justify-content: space-between;
}

.container {
  width: 1200px;
  margin: 20px auto;
}

.card {
  background: white;
  border-radius: 10px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.flex {
  display: flex;
  gap: 20px;
}

.left { flex: 2; }
.right { flex: 1; }

.course {
  border-bottom: 1px solid #eee;
  padding: 10px 0;
}

.progress {
  height: 8px;
  background: #ddd;
  border-radius: 5px;
  margin-top: 5px;
}

.progress div {
  height: 100%;
  background: #3b82f6;
  border-radius: 5px;
}

.quick-menu {
  display: flex;
  justify-content: space-between;
}

.quick-item {
  width: 22%;
  background: #f1f5f9;
  padding: 20px;
  text-align: center;
  border-radius: 10px;
  cursor: pointer;
  transition: 0.2s;
}

.quick-item:hover {
  background: #e2e8f0;
}

/* ===== 팝업 스타일 ===== */
.modal {
  display: none;
  position: fixed;
  z-index: 999;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background: rgba(0,0,0,0.4);
}

.modal-content {
  background: white;
  margin: 10% auto;
  padding: 20px;
  width: 400px;
  border-radius: 10px;
}

.close {
  float: right;
  font-size: 20px;
  cursor: pointer;
}
.sidebar {
  width: 240px;
  background: linear-gradient(#4b6cb7, #182848);
  color: white;
  padding: 20px;
}

.sidebar h2 {
  margin-bottom: 30px;
}

.menu {
  margin-bottom: 20px;
}

.menu-title {
  font-weight: bold;
  margin-bottom: 8px;
}

.menu a {
  display: inline-block;
  margin-right: 10px;
  color: white;
  text-decoration: none;
  font-size: 14px;
}

/* 메인 영역 */
.main {
  flex: 1;
  background: #f5f6f7;
}

/* 상단 헤더 */
.header {
  display: flex;
  justify-content: flex-end;
  padding: 15px 30px;
  background: white;
  border-bottom: 1px solid #ddd;
  font-size: 14px;
}

/* 콘텐츠 영역 */
.content {
  padding: 40px;
}
</style>

<script>
function openPopup() {
  document.getElementById("popup").style.display = "block";
}
function openlec() {
  document.getElementById("openlec").style.display = "block";
	}

function closePopup() {
  document.getElementById("popup").style.display = "none";
}
function closelec() {
	  document.getElementById("openlec").style.display = "none";
	}

</script>

</head>

<body>

<div class="header">
  <div>🎓 단과대학 LMS</div>&emsp;&emsp;
  <div>🔔 <%= "홍길동" %> ▼</div>
</div>
<div style="display:flex;">
  <!-- 사이드바 -->
  <div class="sidebar">
    <h2>re-merge LMS</h2>

    <div class="menu">
      <div class="menu-title">대시보드</div>
      <a href="${pageContext.request.contextPath}/dashboard/student">학생</a>
      <a href="${pageContext.request.contextPath}/dashboard/teacher">강사</a>
      <a href="${pageContext.request.contextPath}/dashboard/admin">관리자</a>
    </div>

    <div class="menu">
      <div class="menu-title">마이페이지</div>
      <a href="#">학생</a>
      <a href="#">강사</a>
      <a href="#">관리자</a>
    </div>

    <div class="menu">
      <div class="menu-title">과목</div>
      <a href="#">학생</a>
      <a href="#">강사</a>
      <a href="#">관리자</a>
    </div>

    <div class="menu">
      <div class="menu-title">게시판</div>
    </div>

    <div class="menu">
      <div class="menu-title">수강</div>
      <a href="#">학생</a>
      <a href="#">강사</a>
      <a href="#">관리자</a>
    </div>
  </div>

  <!-- 메인 -->
  <div class="main">

    <!-- 헤더 -->
    <div class="header">
      <a href="${pageContext.request.contextPath}/user/logout">로그아웃</a>
    </div>
    

<div class="container">

  <div class="card">
    <h3>📢 공지사항</h3>
    <p>[중요] 2026-1학기 수강정정 안내</p>
    <p>2026-1 중간고사 일정 공지</p>
    <p>장학금 신청 기간 안내</p>
  </div>

  <div class="flex">
    <div class="card left">
      <h3>📚 내 강의</h3>

      <div class="course" onclick="openlec()">
        경영학원론 (김교수)
        <div class="progress"><div style="width:60%"></div></div>
      </div>

      <div class="course" onclick="openlec()">
        마케팅개론 (이교수)
        <div class="progress"><div style="width:30%"></div></div>
      </div>

    </div>

    <div class="card right">
      <h3>🗓️ 일정</h3>
      <p>- 과제 제출 D-1</p>
      <p>- 팀플 회의</p>
      <hr>
      <p>- 중간고사 (4/20)</p>
    </div>
  </div>

  <div class="card">
    <h3>⚡ 빠른 메뉴</h3>
    <div class="quick-menu">
      <div class="quick-item" onclick="openPopup()">수강신청</div>
      <div class="quick-item">과제제출</div>
      <div class="quick-item">성적확인</div>
      <div class="quick-item">강의자료</div>
      <div class="quick-item">출석체크</div>
    </div>
  </div>

  <div class="card">
    <h3>📊 학습 현황</h3>
    <p>전체 진도율 45%</p>
    <p>미제출 과제 2건</p>
  </div>

  <div class="card">
    <h3>💬 커뮤니티</h3>
    <p>과제 질문 있습니다...</p>
    <p>시험 범위 어디까지인가요?</p>
  </div>

</div>
 </div>

<!-- ===== 팝업 ===== -->
<div id="popup" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closePopup()">&times;</span>
    <h3>수강 신청</h3>
   	<div class="course">
        경영학원론 (김교수)
        <div>경영학 어쩌고 저쩌고</div>&nbsp;<button>수강신청</button>
      </div>

      <div class="course">
        마케팅개론 (이교수)
        <div>마케팅 어쩌고의 이해</div>&nbsp;<button>수강신청</button>
      </div>
  </div>
</div>
<div id="openlec" class="modal">
	<div class="modal-content">
		<span class="close" onclick="closelec()">&times;</span>
		<div class="course">
        경영학원론 (김교수)
        강의 설명 이것 저것
        </div>
	</div>
</div>

</body>
</html>