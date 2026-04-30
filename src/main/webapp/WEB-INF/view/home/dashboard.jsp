<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


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
      padding: 0;
    }

    /* ── 전체 2열 레이아웃 ── */
    .dashboard-grid {
      display: grid;
      grid-template-columns: 1fr 30%;
      gap: 18px;
      /* start 대신 stretch를 사용하여 두 칼럼의 높이를 맞춥니다 */
      align-items: stretch;
      width: 100%;
    }

    .col-left, .col-right {
      display: flex;
      flex-direction: column;
      gap: 18px;
      justify-content: space-around;
    }

    /* 왼쪽 마지막 섹션(빠른 메뉴)과 오른쪽 마지막 섹션(게시판)이
       남은 공간을 다 차지해서 밑바닥을 맞추게 합니다. */
    .col-left > *:last-child,
    .col-right > *:last-child {
      flex-grow: 1;
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
      display: flex;          /* 플렉스 박스 레이아웃 사용 */
      flex-direction: column; /* 아이콘과 글자를 세로로 나열 */
      align-items: center;    /* 수평 중앙 정렬 */
      justify-content: center; /* 수직 중앙 정렬 */

      background-color: #f8faff; /* 아주 연한 푸른색 계열의 배경 */
      border: 1px solid #e2e8f0;   /* 연한 회색 테두리 */
      border-radius: 12px;         /* 모서리를 둥글게 */

      transition: all 0.2s ease;   /* 마우스를 올렸을 때 부드러운 변화를 위해 */

      /* 기존 스타일 유지 (배경색, 테두리 등) */
      height: 120px;          /* 버튼의 높이가 충분해야 중앙 정렬이 잘 보입니다 */
    }

    .quick-item:hover {
      background-color: #edf2ff;   /* 약간 더 진한 배경색 */
      border-color: #cbd5e1;       /* 약간 더 진한 테두리 */
      transform: translateY(-2px); /* 살짝 위로 떠오르는 효과 */
    }
    .quick-item .qi-icon {
      font-size: 2rem; /* 기존보다 더 큰 값으로 조정해 보세요 (예: 1.5rem, 2rem, 30px 등) */
      margin-bottom: 8px; /* 아이콘과 텍스트 사이의 간격을 줍니다 */
    }

    /* ── 시간표 ── */
    .tt-grid-header {
      display: grid;
      grid-template-columns: 42px repeat(5, 1fr);
      gap: 2px;
      margin-bottom: 3px;
    }

    .tt-day {
      text-align: center;
      font-size: 10px;
      font-weight: 700;
      border-radius: 4px;
      color: #fff;
      background: #1E3A8A;
      height: 28px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .tt-body {
      display: grid;
      grid-template-columns: 42px repeat(5, 1fr);
      gap: 2px;
    }

    .tt-period {
      font-size: 9px;
      color: #888;
      font-weight: 600;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 42px;
      line-height: 1.4;
    }

    .tt-period .p-num { font-size: 10px; font-weight: 700; color: #555; }

    .tt-cell {
      border-radius: 4px;
      font-size: 9px;
      font-weight: 600;
      display: flex;
      align-items: center;
      justify-content: center;
      text-align: center;
      line-height: 1.3;
      padding: 3px 2px;
      min-height: 42px;
    }

    .tt-cell.empty { background: #f1f5f9; }
    .mp-c1 { background: #AEE2FF; color: #0369a1; border: 1.5px solid #0369a1; }
    .mp-c2 { background: #FFCEEE; color: #be185d; border: 1.5px solid #be185d; }
    .mp-c3 { background: #FFF6D2; color: #a16207; border: 1.5px solid #a16207; }
    .mp-c4 { background: #DED9FF; color: #5b21b6; border: 1.5px solid #5b21b6; }
    .mp-c5 { background: #D6FFDE; color: #166534; border: 1.5px solid #166534; }

    .tt-btn {
      display: block; width: 90%; margin-top: 12px; padding: 9px;  margin-left: auto;
      background: #1e3a8a; color: white; font-size: 12px; font-weight: 600;
      border: none; border-radius: 8px; cursor: pointer; text-align: center;
      transition: background 0.15s; font-family: 'Noto Sans KR', sans-serif;
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
    /* 1. 두 컬럼의 높이를 동일하게 맞춤 */
    .dashboard-grid {
      display: grid;
      grid-template-columns: 1fr 30%;
      gap: 18px;
      align-items: stretch; /* stretch로 되어 있어야 두 컬럼 바닥이 맞습니다 */
      width: 100%;
    }

    /* 2. 컬럼 내부의 마지막 카드가 남은 공간을 다 먹도록 설정 */
    .col-left, .col-right {
      display: flex;
      flex-direction: column;
      gap: 18px;
    }

    /* 왼쪽의 빠른 메뉴 카드와 오른쪽의 자유게시판 카드를 지목 */
    /* 만약 구조상 마지막 자식이라면 아래와 같이 쓸 수 있습니다 */
    .col-left > .card:last-child,
    .col-right > .card:last-child {
      flex-grow: 1;
      display: flex;
      flex-direction: column;
    }

    /* 카드 내부의 리스트나 메뉴 컨텐츠도 아래로 늘어나게 하고 싶다면 */
    .col-left > .card:last-child .quick-menu,
    .col-right > .card:last-child .community-list {
      flex-grow: 1;
    }

    /* 카드가 무조건 길어지지 않게 설정 */
    .card {
      background: white;
      border-radius: 10px;
      padding: 20px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    }
  </style>
</head>
<body>

<div class="dashboard-grid">

  <!-- ── 왼쪽 컬럼 ── -->
  <!-- ── 왼쪽 컬럼 ── -->
  <div class="col-left">

    <!-- 공지사항 -->
    <div class="card">
      <h3>📢 공지사항</h3>
      <ul class="notice-list">
        <c:forEach var="notice" items="${noticeListInDashboard}">
          <li>
            <a href="${pageContext.request.contextPath}/board/detail?boardNo=${notice.boardNo}&boardType=NOTICE"
               style="text-decoration: none; color: inherit;">
              <c:if test="${notice.boardType == 'NOTICE'}">
                <span class="badge-important">[공지]</span>
              </c:if>
                ${notice.title}
            </a>
          </li>
        </c:forEach>
        <c:if test="${empty noticeListInDashboard}">
          <li>등록된 공지사항이 없습니다.</li>
        </c:if>
      </ul>
    </div>

    <!-- 내 강의 / 관리자 승인대기 -->
    <c:choose>

      <%-- 학생/교수: 내 강의 --%>
      <c:when test="${sessionUser.role ne 'ADMIN'}">
        <div class="card" style="min-height: 280px; display: flex; flex-direction: column;">
          <h3>📚 내 강의</h3>
          <div class="progress-label" style="margin-bottom: 10px;">2026-1학기 수강 신청 현황</div>
          <div style="flex-grow: 1; display: flex; flex-direction: column; justify-content: flex-start;">
            <c:forEach var="course" items="${courseListDashboard}" varStatus="loop">
              <div class="course"
                   data-name="${course.course_name}"
                   data-prof="${course.professor_name}"
                   data-no="${course.course_no}"
                   data-status="${course.status}"
                   data-startTime="${course.start_time}"
                   data-endTime="${course.end_time}"
                   onclick="openLec(this)">
                <c:choose>
                  <c:when test="${loop.index == 0}"><div class="course-icon" style="background:#eff6ff">📖</div></c:when>
                  <c:when test="${loop.index == 1}"><div class="course-icon" style="background:#fef2f2">💻</div></c:when>
                  <c:when test="${loop.index == 2}"><div class="course-icon" style="background:#f0fdf4">📝</div></c:when>
                  <c:otherwise><div class="course-icon" style="background:#fdfcf0">📚</div></c:otherwise>
                </c:choose>
                <div class="course-info">
                  <div class="course-name">${course.course_name}</div>
                  <div class="course-prof">
                    <c:choose>
                      <c:when test="${sessionUser.role == 'PROFESSOR'}">${sessionUser.name}</c:when>
                      <c:otherwise>${course.professor_name}</c:otherwise>
                    </c:choose>
                    | ${course.day_of_week}요일
                  </div>
                </div>
                <div class="course-pct" style="font-size: 11px;">
                  <c:choose>
                    <c:when test="${course.status == 'PENDING'}">신청</c:when>
                    <c:when test="${course.status == 'APPROVED'}">수강</c:when>
                    <c:otherwise>${course.status}</c:otherwise>
                  </c:choose>
                </div>
              </div>
            </c:forEach>
            <c:if test="${empty courseListDashboard}">
              <div style="text-align: center; color: #9ca3af; padding: 40px 0;">
                <div style="font-size: 24px; margin-bottom: 8px;">📑</div>
                신청된 강의가 없습니다.
              </div>
            </c:if>
          </div>
        </div>
      </c:when>

      <%-- 관리자: 수강신청 승인 대기 목록 --%>
      <c:when test="${sessionUser.role eq 'ADMIN'}">
        <div class="card" style="min-height: 280px; display: flex; flex-direction: column;">
          <h3>⏳ 수강신청 승인 대기
            <a href="${pageContext.request.contextPath}/enrollment/courseEnrollment" style="font-size:11px; color:#888; font-weight:500;">전체보기</a>
          </h3>
          <div style="flex-grow: 1; display: flex; flex-direction: column; justify-content: flex-start;">
            <c:forEach var="pending" items="${pendingEnrollmentList}" varStatus="loop">
              <div class="course">
                <c:choose>
                  <c:when test="${loop.index == 0}"><div class="course-icon" style="background:#fef9ec">📋</div></c:when>
                  <c:when test="${loop.index == 1}"><div class="course-icon" style="background:#fef2f2">📋</div></c:when>
                  <c:when test="${loop.index == 2}"><div class="course-icon" style="background:#f0fdf4">📋</div></c:when>
                  <c:otherwise><div class="course-icon" style="background:#f5f3ff">📋</div></c:otherwise>
                </c:choose>
                <div class="course-info">
                  <a href="${pageContext.request.contextPath}/board/subjectHome?courseNo=${pending.course_no}" style="text-decoration: none; color: inherit;">
                  <div class="course-name" >${pending.course_name}</div>
                  <div class="course-prof">${pending.student_name} · ${pending.day_of_week}요일</div>
                  </a>
                </div>
                <div class="course-pct" style="font-size: 11px; color: #e6a817;">대기</div>
              </div>
            </c:forEach>
            <c:if test="${empty pendingEnrollmentList}">
              <div style="text-align: center; color: #9ca3af; padding: 40px 0;">
                <div style="font-size: 24px; margin-bottom: 8px;">✅</div>
                승인 대기 중인 신청이 없습니다.
              </div>
            </c:if>
          </div>
        </div>
      </c:when>

    </c:choose>

    <!-- 빠른 메뉴 -->
    <div class="card">
      <h3>⚡ 빠른 메뉴</h3>
      <div class="quick-menu">
        <c:choose>
          <c:when test="${sessionUser.role eq 'STUDENT'}">
            <a href="${pageContext.request.contextPath}/enrollment/courseEnrollment" class="quick-item" style="text-decoration: none;">
              <span class="qi-icon">📝</span>수강신청
            </a>
            <a href="${pageContext.request.contextPath}/user/myPage?tab=grade" class="quick-item" style="text-decoration: none;">
              <span class="qi-icon">📊</span>성적확인
            </a>
            <a href="${pageContext.request.contextPath}/course/subject" class="quick-item" style="text-decoration: none;">
              <span class="qi-icon">✅</span>출석체크
            </a>
          </c:when>
          <c:when test="${sessionUser.role eq 'PROFESSOR'}">
            <a href="${pageContext.request.contextPath}/course/courseHome" class="quick-item" style="text-decoration: none;">
              <span class="qi-icon">📚</span>강의관리
            </a>
            <a href="${pageContext.request.contextPath}/board/list?boardType=QNA" class="quick-item" style="text-decoration: none;">
              <span class="qi-icon">❓</span>QnA
            </a>
            <a href="${pageContext.request.contextPath}/board/write?boardType=NOTICE" class="quick-item" style="text-decoration: none;">
              <span class="qi-icon">📢</span>공지등록
            </a>
          </c:when>
          <c:when test="${sessionUser.role eq 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/admin/userList" class="quick-item" style="text-decoration: none;">
              <span class="qi-icon">👥</span>회원관리
            </a>
            <a href="${pageContext.request.contextPath}/admin/adminCourseList" class="quick-item" style="text-decoration: none;">
              <span class="qi-icon">📚</span>강의관리
            </a>
            <a href="${pageContext.request.contextPath}/board/write?boardType=NOTICE" class="quick-item" style="text-decoration: none;">
              <span class="qi-icon">📢</span>공지등록
            </a>
          </c:when>
        </c:choose>
      </div>
    </div>
  </div>

  <!-- ── 오른쪽 컬럼 ── -->
  <div class="col-right">

    <!-- 학생/교수: 개인 시간표 -->
    <c:if test="${sessionUser.role ne 'ADMIN'}">
      <div class="card" id="dashTimetableCard">
        <h3>🗓️ 시간표</h3>
        <div class="tt-grid-header">
          <div></div>
          <div class="tt-day">월</div>
          <div class="tt-day">화</div>
          <div class="tt-day">수</div>
          <div class="tt-day">목</div>
          <div class="tt-day">금</div>
        </div>
        <div class="tt-body" id="dashTimetableBody"></div>
        <button class="tt-btn" onclick="location.href='${pageContext.request.contextPath}/user/myPage'">시간표 전체 보기 →</button>
      </div>
    </c:if>

    <!-- 관리자: 강의실별 시간표 -->
    <c:if test="${sessionUser.role eq 'ADMIN'}">
      <div class="card" id="adminRoomTimetableCard">
        <h3>🏫 강의실별 시간표</h3>
        <div style="margin-bottom: 10px;">
          <select id="roomSelect" onchange="renderRoomTimetable()" style="padding:5px 10px; border:1.5px solid #d0d7f0; border-radius:6px; font-size:13px; outline:none;">
            <c:forEach var="room" items="${roomList}" varStatus="status">
              <option value="${room}" ${status.first ? 'selected' : ''}>${room}</option>
            </c:forEach>
          </select>
        </div>
        <div class="tt-grid-header">
          <div></div>
          <div class="tt-day">월</div>
          <div class="tt-day">화</div>
          <div class="tt-day">수</div>
          <div class="tt-day">목</div>
          <div class="tt-day">금</div>
        </div>
        <div class="tt-body" id="adminTimetableBody"></div>
      </div>
    </c:if>

    <!-- 게시판 -->
    <div class="card">
      <h3>💬 자유게시판 최신글</h3>
      <ul class="community-list">
        <c:forEach var="free" items="${freeListInDashboard}">
          <li>
            <a href="${pageContext.request.contextPath}/board/detail?boardNo=${free.boardNo}&boardType=FREE"
               style="text-decoration: none; color: inherit; display: block;">
                ${free.title}
            </a>
          </li>
        </c:forEach>
        <c:if test="${empty freeListInDashboard}">
          <li>등록된 게시글이 없습니다.</li>
        </c:if>
      </ul>
    </div>
  </div>

</div>


<!-- ── 모달: 강의 상세 ── -->
<div id="courseModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal('courseModal')">&times;</span>
    <h3 id="modalCourseName">강의명</h3>
    <div style="font-size:13px; color:#555; margin-top:8px;">
      <p><span id="modalProfName">교수명</span> 교수님 수업입니다.</p>
      <!-- ⏰ 시간 정보를 표시할 행 추가 -->
      <p>강의 시간: <span id="modalStartTime">course.startTime</span> ~ <span id="modalEndTime">course.endTime</span></p>
    </div>
    <div style="margin-top: 20px; text-align: right;">
      <a id="goToDetailBtn" class="btn-enroll" style="text-decoration: none; display: inline-block;">강의실 입장</a>
      <button type="button" class="btn-enroll" style="background: #ccc;" onclick="closeModal('courseModal')">닫기</button>
    </div>
  </div>
</div>
<script>
  // ── 모달 ──
  function openModal(id) {
    window.location.href = '${pageContext.request.contextPath}/enrollment/courseEnrollment';
  }
  function closeModal(id) {
    document.getElementById(id).classList.remove('open');
  }
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      document.querySelectorAll('.modal.open').forEach(function(modal) {
        modal.classList.remove('open');
      });
    }
  });

  function openLec(el) {
    var name     = el.getAttribute('data-name');
    var prof     = el.getAttribute('data-prof');
    var courseNo = el.getAttribute('data-no');
    var status   = el.getAttribute('data-status');

    var rawStart = el.getAttribute('data-startTime');
    var rawEnd   = el.getAttribute('data-endTime');
    var formatTime = function(raw) {
      if (!raw) return "00:00";
      var timePart = raw.includes('T') ? raw.split('T')[1] : raw;
      return timePart.substring(0, 5);
    };

    document.getElementById("modalCourseName").innerText = name;
    document.getElementById("modalProfName").innerText = prof;
    document.getElementById("modalStartTime").innerText = formatTime(rawStart);
    document.getElementById("modalEndTime").innerText = formatTime(rawEnd);

    var detailBtn = document.getElementById("goToDetailBtn");
    if (status === 'PENDING') {
      detailBtn.style.display = 'none';
    } else {
      detailBtn.style.display = 'inline-block';
      detailBtn.href = "${pageContext.request.contextPath}/board/subjectHome?courseNo=" + courseNo;
    }
    document.getElementById("courseModal").classList.add('open');
  }

  function openAttendance() {
    window.location.href = '${pageContext.request.contextPath}/WEB-INF/views/course/subject';
  }

  // ── 시간표 공통 변수 ──
  var dash_courses = [];
  var DASH_CTX      = '${pageContext.request.contextPath}';
  var DASH_SEMESTER = '2026-1';
  var DASH_ROLE     = '${sessionUser.role}';
  var DASH_COLORS   = ['mp-c1', 'mp-c2', 'mp-c3', 'mp-c4', 'mp-c5'];
  var DASH_DAYS     = ['월', '화', '수', '목', '금'];
  var DASH_DAY_COL  = {'월': 2, '화': 3, '수': 4, '목': 5, '금': 6};

  function dashParseDays(str) {
    return str ? str.split(',').map(function(d){ return d.replace(/요일/, '').trim(); }) : [];
  }
  function dashParseHour(t) {
    return t ? parseInt(t.split(':')[0]) : -1;
  }

  // ── 학생/교수 시간표 렌더링 ──
  function renderDashTimetable() {
    var body = document.getElementById('dashTimetableBody');
    if (!body) return;
    body.innerHTML = '';
    body.style.display = 'grid';

    var minH = 9, maxH = 14;
    if (dash_courses && dash_courses.length > 0) {
      maxH = 18;
      dash_courses.forEach(function(c) {
        var sh = dashParseHour(c.start_time);
        var eh = dashParseHour(c.end_time);
        if (sh > 0 && sh < minH) minH = sh;
        if (eh > 0 && eh > maxH) maxH = eh;
      });
    }

    var colorMap = {};
    dash_courses.forEach(function(c, i) {
      colorMap[c.course_no] = DASH_COLORS[i % DASH_COLORS.length];
    });

    for (var h = minH; h < maxH; h++) {
      var rowIdx = h - minH + 1;
      var timeCell = document.createElement('div');
      timeCell.className = 'tt-period';
      timeCell.style.gridColumn = '1';
      timeCell.style.gridRow = String(rowIdx);
      timeCell.innerHTML =
              '<span class="p-num">' + rowIdx + '교시</span>' +
              '<span style="font-size:9px;color:#aaa;">' + String(h).padStart(2,'0') + ':00</span>';
      body.appendChild(timeCell);

      DASH_DAYS.forEach(function(day, di) {
        var empty = document.createElement('div');
        empty.className = 'tt-cell empty';
        empty.style.gridColumn = String(di + 2);
        empty.style.gridRow = String(rowIdx);
        body.appendChild(empty);
      });
    }

    dash_courses.forEach(function(c) {
      var days = dashParseDays(c.day_of_week);
      var sh = dashParseHour(c.start_time);
      var eh = dashParseHour(c.end_time);
      if (sh < 0 || eh < 0) return;
      var span = eh - sh;
      var rowStart = sh - minH + 1;

      days.forEach(function(day) {
        var colIdx = DASH_DAY_COL[day];
        if (!colIdx) return;
        var cell = document.createElement('div');
        cell.className = 'tt-cell ' + (colorMap[c.course_no] || 'mp-c1');
        cell.style.gridColumn = String(colIdx);
        cell.style.gridRow = rowStart + ' / span ' + span;
        cell.innerHTML = '<span>' + c.course_name + '</span>';
        body.appendChild(cell);
      });
    });
  }

  // ── 관리자 강의실별 시간표 ──
  var ADMIN_ROOM_COURSES = [];
  <c:if test="${sessionUser.role eq 'ADMIN'}">
  ADMIN_ROOM_COURSES = ${adminRoomCoursesJson};
  </c:if>

  function renderRoomTimetable() {
    var selectedRoom = document.getElementById('roomSelect').value;
    var body = document.getElementById('adminTimetableBody');
    if (!body) return;
    body.innerHTML = '';
    if (!selectedRoom) return;

    var courses = ADMIN_ROOM_COURSES.filter(function(c) {
      return c.room_info === selectedRoom;
    });

    var minH = 9, maxH = 18;
    courses.forEach(function(c) {
      var sh = c.start_time ? parseInt(c.start_time.split(':')[0]) : -1;
      var eh = c.end_time   ? parseInt(c.end_time.split(':')[0])   : -1;
      if (sh > 0) minH = Math.min(minH, sh);
      if (eh > 0) maxH = Math.max(maxH, eh);
    });

    var colorMap = {};
    courses.forEach(function(c, i) {
      colorMap[c.course_no] = DASH_COLORS[i % DASH_COLORS.length];
    });

    body.style.display = 'grid';

    for (var h = minH; h < maxH; h++) {
      var rowIdx = h - minH + 1;
      var timeCell = document.createElement('div');
      timeCell.className = 'tt-period';
      timeCell.style.gridColumn = '1';
      timeCell.style.gridRow = String(rowIdx);
      timeCell.innerHTML =
              '<span class="p-num">' + (h - minH + 1) + '교시</span>' +
              '<span style="font-size:9px;color:#aaa;">' + String(h).padStart(2,'0') + ':00</span>';
      body.appendChild(timeCell);

      DASH_DAYS.forEach(function(day, di) {
        var empty = document.createElement('div');
        empty.className = 'tt-cell empty';
        empty.style.gridColumn = String(di + 2);
        empty.style.gridRow = String(rowIdx);
        body.appendChild(empty);
      });
    }

    courses.forEach(function(c) {
      var days = c.day_of_week ? c.day_of_week.split(',').map(function(d){ return d.replace(/요일/, '').trim(); }) : [];
      var sh = c.start_time ? parseInt(c.start_time.split(':')[0]) : -1;
      var eh = c.end_time   ? parseInt(c.end_time.split(':')[0])   : -1;
      if (sh < 0 || eh < 0) return;
      var span = eh - sh;
      var rowStart = sh - minH + 1;

      days.forEach(function(day) {
        var colIdx = DASH_DAY_COL[day];
        if (!colIdx) return;
        var cell = document.createElement('div');
        cell.className = 'tt-cell ' + (colorMap[c.course_no] || 'mp-c1');
        cell.style.gridColumn = String(colIdx);
        cell.style.gridRow = rowStart + ' / span ' + span;
        cell.innerHTML = '<span>' + c.course_name + '</span>';
        body.appendChild(cell);
      });
    });
  }

  // ── DOMContentLoaded (단 한 번만) ──
  window.addEventListener('DOMContentLoaded', function() {

    // 관리자: 강의실 시간표
    if (DASH_ROLE === 'ADMIN') {
      var select = document.getElementById('roomSelect');
      if (select && select.options.length > 0) {
        renderRoomTimetable();
      }
      return;
    }

    // 학생/교수: 개인 시간표 fetch
    var endpoint = (DASH_ROLE === 'PROFESSOR')
            ? DASH_CTX + '/dashboard/my-courses'
            : DASH_CTX + '/enrollment/mine?semester=' + DASH_SEMESTER;

    fetch(endpoint, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
            .then(function(r) {
              if (!r.ok) throw new Error('fetch 실패');
              return r.json();
            })
            .then(function(data) {
              dash_courses = data.courses || data || [];
              renderDashTimetable();
            })
            .catch(function(err) {
              console.error('시간표 로딩 실패:', err);
              dash_courses = [];
              renderDashTimetable();
            });
  });
</script>
</body>
</html>
