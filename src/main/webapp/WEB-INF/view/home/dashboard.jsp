<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>LMS Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
<style>
* { box-sizing: border-box; }

body {
  font-family: 'Noto Sans KR', Arial, sans-serif;
  min-height: 100vh;
  margin: 0;
  padding: 20px;
}

/* ── 전체 2열 레이아웃 ── */
.dashboard-grid {
  display: grid;
  grid-template-columns: 1fr 30%;
  gap: 18px;
  align-items: start;
  width: 100%;
}

.col-left {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.col-right {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

/* ── card (main.css 확장) ── */
.card {
  background: white;
  border-radius: 10px;
  padding: 20px;
  margin-bottom: 0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.card h3 {
  font-size: 14px;
  font-weight: 700;
  color: #1e2235;
  margin: 0 0 14px 0;
}

/* ── 공지사항 ── */
.notice-list {
  list-style: none;
  padding: 0; margin: 0;
}

.notice-list li {
  font-size: 13px;
  color: #444;
  padding: 9px 0;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: color 0.15s;
}

.notice-list li:last-child { border: none; }
.notice-list li:hover { color: #1e3a8a; }

.notice-list li .badge-important {
  color: #e53e3e;
  font-weight: 700;
  margin-right: 2px;
}

/* ── 내 강의 ── */
.progress-label {
  font-size: 12px;
  color: #888;
  margin-bottom: 8px;
}

/* main.css .progress 재사용 */
.progress {
  height: 8px;
  background: #ddd;
  border-radius: 5px;
  margin-top: 0;
  margin-bottom: 16px;
}

.progress div {
  height: 100%;
  background: #3b82f6;
  border-radius: 5px;
}

/* main.css .course 확장 */
.course {
  border-bottom: 1px solid #eee;
  padding: 12px 8px;
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  border-radius: 8px;
  transition: background 0.15s;
}

.course:last-child { border: none; }
.course:hover { background: #f1f5f9; }

.course-icon {
  width: 34px; height: 34px;
  border-radius: 8px;
  display: flex; align-items: center; justify-content: center;
  font-size: 16px;
  flex-shrink: 0;
}

.course-info { flex: 1; }
.course-name { font-size: 13px; font-weight: 600; color: #1e2235; }
.course-prof { font-size: 11px; color: #888; margin-top: 2px; }
.course-pct { font-size: 14px; font-weight: 700; color: #3b82f6; }

/* ── 빠른 메뉴 (main.css 재사용) ── */
.quick-menu {
  display: flex;
  justify-content: space-between;
  gap: 12px;
}

.quick-item {
  flex: 1;
  width: auto;
  background: #f1f5f9;
  padding: 22px 10px 18px;
  text-align: center;
  border-radius: 10px;
  cursor: pointer;
  transition: 0.2s;
  border: none;
  font-family: 'Noto Sans KR', sans-serif;
  font-size: 13px;
  font-weight: 600;
  color: #1e3a8a;
}

.quick-item:hover { background: #e2e8f0; }
.quick-item .qi-icon { font-size: 26px; display: block; margin-bottom: 8px; }

/* ── 시간표 ── */
.tt-grid-header {
  display: grid;
  grid-template-columns: 34px repeat(5, 1fr);
  gap: 3px;
  margin-bottom: 4px;
}

.tt-day {
  text-align: center;
  justify-content: center;
  font-size: 11px;
  font-weight: 700;
  padding: 0;
  border-radius: 6px;
  color: white;
  align-items: center;
  height: 40px;
  display: flex;
  
}

.tt-day.mon, .tt-day.wed, .tt-day.fri { background: #1E3A8A; }
.tt-day.tue, .tt-day.thu { background: #1E3A8A; }

.tt-body { display: flex; flex-direction: column; gap: 3px; }

.tt-row {
  display: grid;
  grid-template-columns: 34px repeat(5, 1fr);
  gap: 3px;
  height: 40px;
}

.tt-period {
  font-size: 10px;
  height: 100%;
  color: #888;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
}

.tt-cell {
  height: 100%;
  min-height: 40px;
  border-radius: 5px;
  font-size: 9px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  line-height: 1.2;
  cursor: pointer;
  transition: opacity 0.15s;
  padding: 2px;
  color: white;
}

.tt-cell:hover { opacity: 0.8; }
.tt-cell.empty { background: #f1f5f9; }
.tt-cell.c1 { background: #3b82f6; }
.tt-cell.c2 { background: #f59f00; }
.tt-cell.c3 { background: #10b981; }

.tt-btn {
  display: block;
  width: 100%;
  margin-top: 12px;
  padding: 9px;
  background: #1e3a8a;
  color: white;
  font-size: 12px;
  font-weight: 600;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  text-align: center;
  transition: background 0.15s;
  font-family: 'Noto Sans KR', sans-serif;
}

.tt-btn:hover { background: #3b82f6; }

/* ── 게시판 ── */
.community-list {
  list-style: none;
  padding: 0; margin: 0;
}

.community-list li {
  font-size: 13px;
  color: #444;
  padding: 9px 0;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: color 0.15s;
}

.community-list li:last-child { border: none; }
.community-list li:hover { color: #1e3a8a; }

/* ── 모달 (main.css 재사용) ── */
.modal {
  display: none;
  position: fixed;
  z-index: 999;
  left: 0; top: 0;
  width: 100%; height: 100%;
  background: rgba(0,0,0,0.4);
  align-items: center;
  justify-content: center;
}

.modal.open { display: flex; }

.modal-content {
  background: white;
  margin: 0 auto;
  padding: 24px;
  width: 420px;
  border-radius: 10px;
  position: relative;
  box-shadow: 0 20px 50px rgba(0,0,0,0.2);
}

.modal-content h3 { font-size: 16px; font-weight: 700; margin-bottom: 16px; }

.close {
  float: right;
  font-size: 20px;
  cursor: pointer;
  color: #888;
  line-height: 1;
}

.modal-course {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 11px 0;
  border-bottom: 1px solid #eee;
}

.modal-course:last-child { border: none; }
.modal-course-name { font-size: 13px; font-weight: 600; }
.modal-course-desc { font-size: 12px; color: #888; margin-top: 2px; }

.btn-enroll {
  background: #1e3a8a;
  color: white;
  border: none;
  border-radius: 7px;
  padding: 6px 14px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.15s;
  font-family: 'Noto Sans KR', sans-serif;
}

.btn-enroll:hover { background: #3b82f6; }
</style>
</head>
<body>

<div class="dashboard-grid">

  <!-- ── 왼쪽 컬럼 ── -->
  <div class="col-left">

    <!-- 공지사항 -->
    <div class="card">
      <h3>📢 공지사항</h3>
      <ul class="notice-list">
        <li><span class="badge-important">[중요]</span> 2026-1학기 수강정정 안내</li>
        <li>2026-1 중간고사 일정 공지</li>
        <li>장학금 신청 기간 안내</li>
      </ul>
    </div>

    <!-- 내 강의 -->
    <div class="card">
      <h3>📚 내 강의</h3>
      <div class="progress-label">2026-1학기 수강 진행 현황</div>
      <div class="progress">
        <div style="width:45%"></div>
      </div>

      <div class="course" onclick="openLec('경영학원론','김교수','경영학의 기초 개념과 원리를 학습합니다.')">
        <div class="course-icon" style="background:#eff6ff">📖</div>
        <div class="course-info">
          <div class="course-name">경영학원론</div>
          <div class="course-prof">김교수</div>
        </div>
        <div class="course-pct">60%</div>
      </div>

      <div class="course" onclick="openLec('마케팅개론','이교수','마케팅의 기초 이론과 실제 사례를 다룹니다.')">
        <div class="course-icon" style="background:#fffbeb">📊</div>
        <div class="course-info">
          <div class="course-name">마케팅개론</div>
          <div class="course-prof">이교수</div>
        </div>
        <div class="course-pct">30%</div>
      </div>

      <div class="course" onclick="openLec('경영정보시스템','박교수','IT와 경영의 융합을 학습합니다.')">
        <div class="course-icon" style="background:#ecfdf5">💻</div>
        <div class="course-info">
          <div class="course-name">경영정보시스템</div>
          <div class="course-prof">박교수</div>
        </div>
        <div class="course-pct">80%</div>
      </div>
    </div>

    <!-- 빠른 메뉴 -->
    <div class="card">
      <h3>⚡ 빠른 메뉴</h3>
      <div class="quick-menu">
        <button class="quick-item" onclick="openModal('enroll')">
          <span class="qi-icon">📝</span>수강신청
        </button>
        <button class="quick-item">
          <span class="qi-icon">📊</span>성적확인
        </button>
        <button class="quick-item">
          <span class="qi-icon" onclick="openAttendance()">✅</span>출석체크
        </button>
      </div>
    </div>

  </div><!-- /col-left -->

  <!-- ── 오른쪽 컬럼 ── -->
  <div class="col-right">

    <!-- 시간표 -->
    <div class="card">
      <h3>🗓️ 시간표</h3>
      <div class="tt-grid-header">
        <div></div>
        <div class="tt-day mon">월</div>
        <div class="tt-day tue">화</div>
        <div class="tt-day wed">수</div>
        <div class="tt-day thu">목</div>
        <div class="tt-day fri">금</div>
      </div>
      <div class="tt-body">
        <div class="tt-row">
          <div class="tt-period">1교시</div>
          <div class="tt-cell c1">경영학원론</div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell c1">경영학원론</div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
        </div>
        <div class="tt-row">
          <div class="tt-period">2교시</div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell c2">마케팅개론</div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell c2">마케팅개론</div>
          <div class="tt-cell empty"></div>
        </div>
        <div class="tt-row">
          <div class="tt-period">3교시</div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell c3">경영정보시스템</div>
        </div>
        <div class="tt-row">
          <div class="tt-period">4교시</div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell c3">경영정보시스템</div>
        </div>
        <div class="tt-row">
          <div class="tt-period">5교시</div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
        </div>
        <div class="tt-row">
          <div class="tt-period">6교시</div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
        </div>
        <div class="tt-row">
          <div class="tt-period">7교시</div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
        </div>
        <div class="tt-row">
          <div class="tt-period">8교시</div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
        </div>
        <div class="tt-row">
          <div class="tt-period">9교시</div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
          <div class="tt-cell empty"></div>
        </div>
      </div>
      <button class="tt-btn">시간표 전체 보기 →</button>
    </div>

    <!-- 게시판 -->
    <div class="card">
      <h3>💬 게시판</h3>
      <ul class="community-list">
        <li>과제 질문 있습니다...</li>
        <li>시험 범위 어디까지인가요?</li>
        <li>팀플 구하는데 연락 주세요</li>
      </ul>
    </div>

  </div><!-- /col-right -->

</div><!-- /dashboard-grid -->

<!-- ── 모달: 수강신청 ── -->
<div id="modal-enroll" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal('enroll')">&times;</span>
    <h3>📝 수강 신청</h3>
    <div class="modal-course">
      <div>
        <div class="modal-course-name">경영학원론 (김교수)</div>
        <div class="modal-course-desc">경영학 어쩌고 저쩌고</div>
      </div>
      <button class="btn-enroll">수강신청</button>
    </div>
    <div class="modal-course">
      <div>
        <div class="modal-course-name">마케팅개론 (이교수)</div>
        <div class="modal-course-desc">마케팅 어쩌고의 이해</div>
      </div>
      <button class="btn-enroll">수강신청</button>
    </div>
    <div class="modal-course">
      <div>
        <div class="modal-course-name">경영정보시스템 (박교수)</div>
        <div class="modal-course-desc">IT와 경영의 융합</div>
      </div>
      <button class="btn-enroll">수강신청</button>
    </div>
  </div>
</div>

<!-- ── 모달: 강의 상세 ── -->
<div id="modal-lec" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal('lec')">&times;</span>
    <h3 id="lec-title">강의 상세</h3>
    <div id="lec-body" style="font-size:13px; color:#555; margin-top:8px;"></div>
  </div>
</div>

<script>
  function openModal(id) {
    document.getElementById('modal-' + id).classList.add('open');
  }
  function closeModal(id) {
    document.getElementById('modal-' + id).classList.remove('open');
  }
  function openLec(name, prof, desc) {
    document.getElementById('lec-title').textContent = name + ' (' + prof + ')';
    document.getElementById('lec-body').textContent = desc;
    document.getElementById('modal-lec').classList.add('open');
  }
  document.querySelectorAll('.modal').forEach(m => {
    m.addEventListener('click', e => { if (e.target === m) m.classList.remove('open'); });
  });
  
  function openAttendance() {
	    window.location.href = '<%=request.getContextPath()%>/course/subject';
	}
</script>

</body>
</html>
