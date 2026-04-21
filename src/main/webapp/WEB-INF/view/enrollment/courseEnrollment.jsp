<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>수강신청 — re-merge LMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
  <style>
    /* ====================================================
       수강신청 페이지 전용 스타일
       ==================================================== */
    .enroll-page { display: flex; flex-direction: column; height: 100%; }

    /* 페이지 헤더 */
    .page-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 1.4rem;
      flex-shrink: 0;
    }
    .page-title {
      font-family: 'DM Serif Display', serif;
      font-size: 1.5rem;
      font-weight: 400;
      color: var(--gray-900);
      display: flex;
      align-items: center;
      gap: .55rem;
    }
    .page-title-icon {
      width: 36px; height: 36px;
      background: var(--primary-pale);
      border: 1.5px solid var(--primary-tint);
      border-radius: var(--radius-md);
      display: flex; align-items: center; justify-content: center;
      font-size: 1.05rem;
    }
    .semester-chip {
      background: var(--primary);
      color: var(--white);
      font-size: .7rem;
      font-weight: 700;
      padding: .25rem .7rem;
      border-radius: 999px;
      letter-spacing: .04em;
    }

    /* 학점 요약 배너 */
    .credit-summary {
      display: flex;
      gap: .8rem;
      margin-bottom: 1.2rem;
      flex-shrink: 0;
    }
    .credit-chip {
      display: flex;
      align-items: center;
      gap: .45rem;
      background: var(--white);
      border: 1px solid var(--gray-200);
      border-radius: var(--radius-md);
      padding: .5rem .9rem;
      font-size: .8rem;
      font-weight: 500;
      color: var(--gray-600);
      box-shadow: var(--shadow-sm);
    }
    .credit-chip .val {
      font-family: 'DM Serif Display', serif;
      font-size: 1.1rem;
      color: var(--gray-900);
      line-height: 1;
    }
    .credit-chip .val.primary { color: var(--primary); }
    .credit-chip .val.warn    { color: #ca8a04; }
    .credit-chip-icon { font-size: .95rem; }

    /* 탭 내비게이션 */
    .tab-nav {
      display: flex;
      gap: .3rem;
      margin-bottom: 1.2rem;
      border-bottom: 2px solid var(--gray-200);
      flex-shrink: 0;
    }
    .tab-btn {
      display: flex;
      align-items: center;
      gap: .4rem;
      padding: .6rem 1.2rem;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .84rem;
      font-weight: 600;
      color: var(--gray-500);
      background: transparent;
      border: none;
      border-bottom: 2.5px solid transparent;
      margin-bottom: -2px;
      cursor: pointer;
      transition: all .16s;
      border-radius: var(--radius-sm) var(--radius-sm) 0 0;
    }
    .tab-btn:hover { color: var(--primary); background: var(--primary-pale); }
    .tab-btn.active {
      color: var(--primary);
      border-bottom-color: var(--primary);
      background: var(--primary-pale);
    }
    .tab-count {
      font-size: .64rem;
      font-weight: 700;
      background: var(--primary);
      color: var(--white);
      border-radius: 999px;
      padding: .1rem .4rem;
      line-height: 1.5;
    }
    .tab-btn:not(.active) .tab-count { background: var(--gray-300); }

    /* 탭 패널 */
    .tab-panel { display: none; flex: 1; overflow: hidden; flex-direction: column; }
    .tab-panel.active { display: flex; }

    /* ── 필터 바 (전체강의 탭) ── */
    .filter-bar {
      display: flex;
      gap: .6rem;
      align-items: center;
      margin-bottom: .9rem;
      flex-wrap: wrap;
      flex-shrink: 0;
    }
    .filter-label {
      font-size: .75rem;
      font-weight: 700;
      color: var(--gray-500);
      letter-spacing: .04em;
      white-space: nowrap;
    }
    .filter-select {
      padding: .42rem .85rem;
      border: 1.5px solid var(--gray-200);
      border-radius: var(--radius-md);
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .8rem;
      font-weight: 500;
      color: var(--gray-700);
      background: var(--white);
      cursor: pointer;
      transition: border-color .16s;
      appearance: none;
      -webkit-appearance: none;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'%3E%3Cpath d='M1 1l4 4 4-4' stroke='%239ca3af' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: right .65rem center;
      padding-right: 2rem;
    }
    .filter-select:focus {
      outline: none;
      border-color: var(--primary-light);
      box-shadow: 0 0 0 3px rgba(59,130,246,.12);
    }
    .filter-search-wrap {
      display: flex;
      align-items: center;
      gap: .4rem;
      background: var(--white);
      border: 1.5px solid var(--gray-200);
      border-radius: var(--radius-md);
      padding: 0 .75rem;
      transition: border-color .16s;
      margin-left: auto;
    }
    .filter-search-wrap:focus-within {
      border-color: var(--primary-light);
      box-shadow: 0 0 0 3px rgba(59,130,246,.12);
    }
    .filter-search-wrap input {
      border: none;
      outline: none;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .8rem;
      color: var(--gray-700);
      width: 160px;
      padding: .42rem 0;
      background: transparent;
    }
    .filter-search-icon { color: var(--gray-400); font-size: .85rem; }
    .btn-filter-reset {
      padding: .42rem .8rem;
      background: var(--gray-100);
      color: var(--gray-500);
      border: 1.5px solid var(--gray-200);
      border-radius: var(--radius-md);
      font-size: .78rem;
      font-weight: 600;
      cursor: pointer;
      transition: all .16s;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
    }
    .btn-filter-reset:hover { background: var(--gray-200); color: var(--gray-700); }

    /* ── 테이블 래퍼 ── */
    .table-wrap {
      background: var(--white);
      border: 1px solid var(--gray-200);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-sm);
      overflow: hidden;
      flex: 1;
      display: flex;
      flex-direction: column;
    }
    .table-scroll { overflow-y: auto; flex: 1; }
    .table-scroll::-webkit-scrollbar { width: 4px; }
    .table-scroll::-webkit-scrollbar-thumb { background: var(--gray-200); border-radius: 999px; }

    /* 신청/취소 버튼 */
    .btn-enroll {
      padding: .3rem .75rem;
      border: none;
      border-radius: var(--radius-sm);
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .75rem;
      font-weight: 700;
      cursor: pointer;
      transition: all .15s;
      white-space: nowrap;
    }
    .btn-enroll.apply {
      background: var(--primary);
      color: var(--white);
      box-shadow: 0 2px 6px rgba(29,78,216,.2);
    }
    .btn-enroll.apply:hover { background: var(--primary-mid); transform: translateY(-1px); }
    .btn-enroll.cancel {
      background: #fff1f2;
      color: #b91c1c;
      border: 1px solid #fecdd3;
    }
    .btn-enroll.cancel:hover { background: #fee2e2; }
    .btn-enroll.full {
      background: var(--gray-100);
      color: var(--gray-400);
      cursor: not-allowed;
      border: 1px solid var(--gray-200);
    }

    /* PDF 첨부 아이콘 */
    .pdf-link {
      display: inline-flex;
      align-items: center;
      gap: .25rem;
      font-size: .72rem;
      color: var(--primary);
      text-decoration: none;
      background: var(--primary-pale);
      padding: .2rem .5rem;
      border-radius: var(--radius-sm);
      border: 1px solid var(--primary-tint);
      white-space: nowrap;
      transition: all .14s;
    }
    .pdf-link:hover { background: var(--primary-tint); }

    /* 강의 유형 배지 */
    .type-badge {
      display: inline-flex;
      font-size: .63rem;
      font-weight: 700;
      padding: .15rem .45rem;
      border-radius: var(--radius-sm);
      white-space: nowrap;
      letter-spacing: .02em;
    }
    .type-major-req  { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
    .type-major-elec { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
    .type-gen-req    { background: #fffbeb; color: #a16207; border: 1px solid #fde68a; }
    .type-gen-elec   { background: #fdf4ff; color: #7e22ce; border: 1px solid #e9d5ff; }
    .type-free       { background: var(--gray-100); color: var(--gray-600); border: 1px solid var(--gray-200); }

    /* 정원 게이지 */
    .capacity-bar {
      display: flex;
      align-items: center;
      gap: .4rem;
      font-size: .75rem;
      color: var(--gray-600);
    }
    .cap-track {
      flex: 1;
      height: 4px;
      background: var(--gray-100);
      border-radius: 999px;
      overflow: hidden;
      min-width: 50px;
    }
    .cap-fill {
      height: 100%;
      border-radius: 999px;
      background: linear-gradient(90deg, var(--primary-light), var(--primary));
      transition: width .3s;
    }
    .cap-fill.warn { background: linear-gradient(90deg, #f59e0b, #ca8a04); }
    .cap-fill.full { background: linear-gradient(90deg, #ef4444, #dc2626); }

    /* 페이지네이션 */
    .pagination {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: .3rem;
      padding: .8rem 1rem;
      border-top: 1px solid var(--gray-100);
      flex-shrink: 0;
    }
    .page-btn {
      width: 30px; height: 30px;
      display: flex; align-items: center; justify-content: center;
      border: 1px solid var(--gray-200);
      border-radius: var(--radius-sm);
      background: var(--white);
      font-size: .78rem;
      font-weight: 600;
      color: var(--gray-600);
      cursor: pointer;
      transition: all .15s;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
    }
    .page-btn:hover { background: var(--primary-pale); border-color: var(--primary-tint); color: var(--primary); }
    .page-btn.active { background: var(--primary); border-color: var(--primary); color: var(--white); }
    .page-btn:disabled { opacity: .4; cursor: not-allowed; }

    /* ── 시간표 탭 ── */
    .timetable-wrap {
      background: var(--white);
      border: 1px solid var(--gray-200);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-sm);
      overflow: hidden;
      flex: 1;
      display: flex;
      flex-direction: column;
    }
    .timetable-header {
      display: grid;
      grid-template-columns: 60px repeat(5, 1fr);
      background: var(--gray-50);
      border-bottom: 2px solid var(--gray-200);
    }
    .tt-head-cell {
      padding: .65rem .5rem;
      text-align: center;
      font-size: .72rem;
      font-weight: 700;
      letter-spacing: .06em;
      color: var(--gray-500);
      text-transform: uppercase;
    }
    .timetable-body {
      flex: 1;
      overflow-y: auto;
      position: relative;
    }
    .timetable-body::-webkit-scrollbar { width: 4px; }
    .timetable-body::-webkit-scrollbar-thumb { background: var(--gray-200); border-radius: 999px; }
    .tt-row {
      display: grid;
      grid-template-columns: 60px repeat(5, 1fr);
      border-bottom: 1px solid var(--gray-100);
      min-height: 50px;
    }
    .tt-row:last-child { border-bottom: none; }
    .tt-time-cell {
      display: flex;
      align-items: flex-start;
      justify-content: center;
      padding: .55rem .3rem;
      font-size: .68rem;
      font-weight: 600;
      color: var(--gray-400);
      background: var(--gray-50);
      border-right: 1px solid var(--gray-200);
      letter-spacing: -.01em;
    }
    .tt-cell {
      border-right: 1px solid var(--gray-100);
      padding: .3rem;
      position: relative;
    }
    .tt-cell:last-child { border-right: none; }
    .tt-course-block {
      height: 100%;
      background: var(--primary-pale);
      border: 1.5px solid var(--primary-tint);
      border-left: 3.5px solid var(--primary);
      border-radius: var(--radius-sm);
      padding: .3rem .45rem;
      font-size: .7rem;
      font-weight: 600;
      color: var(--primary-dark);
      line-height: 1.35;
      cursor: default;
    }
    .tt-course-block .tt-room {
      font-size: .62rem;
      font-weight: 500;
      color: var(--primary-light);
      margin-top: .15rem;
    }

    /* 빈 상태 */
    .empty-state {
      flex: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 3rem;
      color: var(--gray-400);
      gap: .75rem;
    }
    .empty-icon { font-size: 2.5rem; }
    .empty-text { font-size: .88rem; font-weight: 500; }
    .empty-sub { font-size: .78rem; color: var(--gray-300); }

    /* 로딩 오버레이 */
    .loading-overlay {
      display: none;
      position: absolute;
      inset: 0;
      background: rgba(255,255,255,.7);
      backdrop-filter: blur(2px);
      align-items: center;
      justify-content: center;
      z-index: 10;
      border-radius: var(--radius-lg);
    }
    .loading-overlay.active { display: flex; }
    .spinner {
      width: 28px; height: 28px;
      border: 3px solid var(--primary-tint);
      border-top-color: var(--primary);
      border-radius: 50%;
      animation: spin .65s linear infinite;
    }
    @keyframes spin { to { transform: rotate(360deg); } }

    /* 모달 커리큘럼 */
    .curriculum-modal .modal-content { width: 540px; }
    .curriculum-iframe {
      width: 100%;
      height: 420px;
      border: 1px solid var(--gray-200);
      border-radius: var(--radius-md);
      margin-top: .8rem;
    }
  </style>
</head>
<body>
<div class="layout-root">

    <%-- ====== 메인 콘텐츠 ====== --%>
    <main class="main-content" style="position:relative; overflow-y:auto;">
      <div class="enroll-page">

        <%-- 페이지 헤더 --%>
        <div class="page-header">
          <div class="page-title">
            <div class="page-title-icon">📋</div>
            수강신청
          </div>
          <span class="semester-chip">2025년 2학기</span>
        </div>

        <%--
          [학점 요약 배너]
          - enrolledCredits : JS updateCreditSummary()가 동적으로 채움
          - enrolledCount   : 신청 과목 수
          - 최대 18학점 하드코딩 → 실제 운영 시 서버에서 학생별 최대 학점을 내려줘야 함
        --%>
        <div class="credit-summary">
          <div class="credit-chip">
            <span class="credit-chip-icon">🎓</span>
            신청 학점 <span class="val primary" id="enrolledCredits">0</span> / <span class="val">18</span> 학점
          </div>
          <div class="credit-chip">
            <span class="credit-chip-icon">📚</span>
            신청 과목 <span class="val" id="enrolledCount">0</span> 과목
          </div>
          <div class="credit-chip">
            <span class="credit-chip-icon">⏰</span>
            <%-- TODO: 수강신청 기간도 서버에서 내려받아 동적으로 표시 권장 --%>
            신청 기간 <span class="val warn">2025.08.20 ~ 2025.08.26</span>
          </div>
        </div>

        <%--
          [탭 네비게이션]
          탭 3종: 전체 강의 / 신청한 수강 / 시간표
          - data-tab 속성으로 JS가 패널 ID를 매핑 (panel-{data-tab})
          - countAll / countMine : AJAX 응답 후 JS가 업데이트
        --%>
        <div class="tab-nav">
          <button class="tab-btn active" data-tab="all">
            📖 전체 강의 <span class="tab-count" id="countAll">0</span>
          </button>
          <button class="tab-btn" data-tab="mine">
            ✅ 신청한 수강 <span class="tab-count" id="countMine">0</span>
          </button>
          <button class="tab-btn" data-tab="timetable">
            🗓 시간표
          </button>
        </div>

        <%-- ===== 탭 1 : 전체 강의 ===== --%>
        <div class="tab-panel active" id="panel-all">
          <%--
            [필터 바]
            - filterDept    : 학과 필터 (현재 하드코딩 — 실제 운영 시 서버/AJAX로 목록 동적 생성 권장)
            - filterType    : 강의 유형 필터 (MAJOR_REQUIRED 등 enum 값)
            - filterCredits : 학점 필터 (1/2/3학점)
            - searchKeyword : 강의명·교수명 키워드 검색 (debounce 350ms 적용)
            - 필터 변경 시마다 loadAllCourses() 호출 → 1페이지로 리셋됨
          --%>
          <div class="filter-bar">
            <span class="filter-label">🔍 필터</span>
            <select class="filter-select" id="filterType" onchange="loadAllCourses()">
              <option value="">전체 유형</option>
              <option value="MAJOR_REQUIRED">전공필수</option>
              <option value="MAJOR_ELECTIVE">전공선택</option>
              <option value="GENERAL_REQUIRED">교양필수</option>
              <option value="GENERAL_ELECTIVE">교양선택</option>
              <option value="FREE_ELECTIVE">일반선택</option>
            </select>
            <select class="filter-select" id="filterCredits" onchange="loadAllCourses()">
              <option value="">전체 학점</option>
              <option value="1">1학점</option>
              <option value="2">2학점</option>
              <option value="3">3학점</option>
            </select>
            <button class="btn-filter-reset" onclick="resetFilters()">초기화</button>
            <div class="filter-search-wrap">
              <span class="filter-search-icon">🔎</span>
              <input type="text" id="searchKeyword" placeholder="강의명 / 교수명 검색"
                     oninput="debounceSearch()">
            </div>
          </div>

          <%-- 테이블 --%>
          <div class="table-wrap" style="position:relative;">
            <%-- 로딩 중 스피너 오버레이 — showLoading('loadingAll', true/false)로 제어 --%>
            <div class="loading-overlay" id="loadingAll">
              <div class="spinner"></div>
            </div>
            <div class="table-scroll">
              <%--
                [전체 강의 테이블]
                tbody(allCourseBody)는 AJAX 응답 후 renderAllTable()이 동적으로 채움
                컬럼: 번호 / 강의명(교수) / 유형 / 학점 / 요일 / 시간 / 강의실 / 정원 / 커리큘럼 / 신청버튼
              --%>
              <table class="lms-table" id="allCourseTable">
                <thead>
                  <tr>
                    <th style="width:42px; text-align:center;">번호</th>
                    <th>강의명</th>
                    <th style="width:80px;">유형</th>
                    <th style="width:70px; text-align:center;">학점</th>
                    <th style="width:55px; text-align:center;">요일</th>
                    <th style="width:105px;">시간</th>
                    <th style="width:65px;">강의실</th>
                    <th style="width:140px;">정원</th>
                    <th style="width:60px; text-align:center;">커리큘럼</th>
                    <th style="width:85px; text-align:center;">신청/취소</th>
                  </tr>
                </thead>
                <tbody id="allCourseBody">
                  <%-- AJAX로 채워짐 --%>
                </tbody>
              </table>
            </div>
            <%-- 페이지네이션 버튼 — renderPagination()이 동적 생성 --%>
            <div class="pagination" id="allPagination"></div>
          </div>
        </div>

        <%-- ===== 탭 2 : 내 수강 목록 ===== --%>
        <div class="tab-panel" id="panel-mine">
          <div class="table-wrap" style="position:relative;">
            <div class="loading-overlay" id="loadingMine">
              <div class="spinner"></div>
            </div>
            <div class="table-scroll">
              <%--
                [내 수강 목록 테이블]
                tbody(mineCourseBody)는 loadMyCourses() → renderMineTable()이 채움
                컬럼: 번호 / 강의명(교수) / 유형 / 학점 / 요일 / 시간 / 강의실 / 신청상태 / 취소버튼
                하단에 합계 학점 표시 (totalCreditsDisplay)
              --%>
              <table class="lms-table">
                <thead>
                  <tr>
                    <th style="width:42px; text-align:center;">번호</th>
                    <th>강의명</th>
                    <th style="width:80px;">유형</th>
                    <th style="width:70px; text-align:center;">학점</th>
                    <th style="width:55px; text-align:center;">요일</th>
                    <th style="width:105px;">시간</th>
                    <th style="width:65px;">강의실</th>
                    <th style="width:90px; text-align:center;">신청상태</th>
                    <th style="width:85px; text-align:center;">취소</th>
                  </tr>
                </thead>
                <tbody id="mineCourseBody">
                  <%-- AJAX로 채워짐 --%>
                </tbody>
              </table>
            </div>
            <div style="padding:.6rem 1rem; border-top:1px solid var(--gray-100);
                        font-size:.78rem; color:var(--gray-500); flex-shrink:0;">
              합계 학점 : <strong id="totalCreditsDisplay" style="color:var(--primary);">0</strong> 학점
            </div>
          </div>
        </div>

        <%-- ===== 탭 3 : 시간표 ===== --%>
        <%--
          [시간표 탭]
          renderTimetable()이 myCourses 배열 기반으로 09:00~20:00 그리드를 JS로 렌더링
          day_of_week(요일), start_time/end_time(HH:mm) 필드를 사용하므로
          DB 컬럼명과 반드시 일치해야 함
        --%>
        <div class="tab-panel" id="panel-timetable">
          <div class="timetable-wrap">
            <div class="timetable-header">
              <div class="tt-head-cell">시간</div>
              <div class="tt-head-cell">월</div>
              <div class="tt-head-cell">화</div>
              <div class="tt-head-cell">수</div>
              <div class="tt-head-cell">목</div>
              <div class="tt-head-cell">금</div>
            </div>
            <div class="timetable-body" id="timetableBody">
              <%-- JS로 렌더링 --%>
            </div>
          </div>
        </div>

      </div><%-- /enroll-page --%>
    </main>
  </div>
</div>

<%-- ===== 커리큘럼 모달 ===== --%>
<%--
  curriculum_pdf URL을 iframe에 띄우는 모달
  openModal(url) → iframe.src 세팅 / closeModal() → src 초기화
  TODO: iframe 대신 새 탭으로 여는 방식도 고려 (모바일 호환성)
--%>
<div class="modal curriculum-modal" id="curriculumModal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">✕</span>
    <h3>📄 수업 커리큘럼</h3>
    <iframe id="curriculumFrame" class="curriculum-iframe" src=""></iframe>
  </div>
</div>

<script>
/* EL 충돌 방지: JSP는 이 블록 안의 \${}를 EL로 파싱하므로
   pageContext.request.contextPath 같은 JSP EL은 script 밖에서 변수로 빼서 사용 */
var CTX_PATH = '<%=request.getContextPath()%>';
/* ================================================================
   전역 상태
   - currentPage  : 현재 페이지 번호 (1부터 시작)
   - PAGE_SIZE    : 한 페이지당 표시할 강의 수
   - enrolledSet  : 이미 신청한 course_no 집합 → 신청/취소 버튼 상태 결정에 사용
   - myCourses    : 내 수강 목록 배열 (시간표 렌더링에도 재사용)
   - searchTimer  : debounce용 타이머 ID
================================================================ */
let currentPage   = 1;
const PAGE_SIZE   = 10;
let totalPages    = 1;
let enrolledSet   = new Set();
let myCourses     = [];
let searchTimer   = null;

const DAYS  = ['월','화','수','목','금'];
const HOURS = Array.from({length:12},(_,i)=> `\${i+9}:00`);  // 09:00 ~ 20:00

/* ================================================================
   탭 전환
   - .tab-btn의 data-tab 속성으로 panel-{tab} ID의 패널을 활성화
   - 탭 전환 시 해당 탭 데이터 재로드 (시간표는 이미 로드된 myCourses로 렌더링)
================================================================ */
document.querySelectorAll('.tab-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
    btn.classList.add('active');
    const tab = btn.dataset.tab;
    document.getElementById('panel-' + tab).classList.add('active');

    if (tab === 'all')       loadAllCourses();
    if (tab === 'mine')      loadMyCourses();
    if (tab === 'timetable') renderTimetable();
  });
});

/* ================================================================
   전체 강의 목록 로드 (AJAX)
   엔드포인트: GET /enrollment/list?page=&size=&dept=&type=&credits=&keyword=
   응답 형태: { courses: [...], totalCount: N, totalPages: N }
   실패 시: MOCK_COURSES로 폴백 (DB 연결 전 개발 테스트용)
================================================================ */
function loadAllCourses(page) {
  if (page) currentPage = page;
  const dept    = document.getElementById('filterDept').value;
  const type    = document.getElementById('filterType').value;
  const credits = document.getElementById('filterCredits').value;
  const keyword = document.getElementById('searchKeyword').value.trim();

  showLoading('loadingAll', true);

  const params = new URLSearchParams({
    page:    currentPage,
    size:    PAGE_SIZE,
    dept:    dept,
    type:    type,
    credits: credits,
    keyword: keyword
  });

  fetch(CTX_PATH + '/enrollment/list?' + params, {
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  })
  .then(r => r.json())
  .then(data => {
    totalPages = data.totalPages || 1;
    document.getElementById('countAll').textContent = data.totalCount || 0;
    renderAllTable(data.courses || []);
    renderPagination(data.totalCount || 0);
  })
  .catch(() => {
    /* ⚠️ DB 연결 전 목업 폴백 — 서버 연동 후 이 catch 블록 제거 */
    renderAllTable(MOCK_COURSES);
    document.getElementById('countAll').textContent = MOCK_COURSES.length;
    totalPages = 1;
    renderPagination(MOCK_COURSES.length);
  })
  .finally(() => showLoading('loadingAll', false));
}

/* ================================================================
   전체 강의 테이블 렌더링
   ⚠️ [버그 1 수정] 학점 셀 — 원본: \${empty c.credits ? 3 : c.credits}
      JS 템플릿 리터럴 안에서 EL 문법은 동작하지 않음.
      JS 삼항 연산자로 교체: c.credits != null ? c.credits : 3
   ⚠️ [버그 2 수정] 정원 셀 — 원본: c.enrolled ? 0 : c.enrolled (조건 반전)
      enrolled가 0이면 0 대신 0을 반환하는 의미없는 코드 + 오타(erolled)
      올바른 표현: c.enrolled != null ? c.enrolled : 0
   ⚠️ [버그 3] 커리큘럼 셀 — JS 템플릿 리터럴 안에 JSTL 태그 삽입 불가
      JSTL은 서버에서 한 번만 렌더링되므로 JS가 동적으로 생성하는 행에서는 동작 안 함.
      JS 삼항 연산자로 교체.
================================================================ */
function renderAllTable(courses) {
  const tbody = document.getElementById('allCourseBody');
  if (!courses.length) {
    tbody.innerHTML = `<tr><td colspan="10">
      <div class="empty-state">
        <div class="empty-icon">📭</div>
        <div class="empty-text">조건에 맞는 강의가 없습니다</div>
        <div class="empty-sub">필터를 초기화하거나 검색어를 변경해보세요</div>
      </div>
    </td></tr>`;
    return;
  }
  tbody.innerHTML = courses.map((c, i) => {
    const applied   = enrolledSet.has(c.course_no);
    const pct       = c.max_students ? Math.round(c.enrolled / c.max_students * 100) : 0;
    const isFull    = pct >= 100;
    const capClass  = pct >= 100 ? 'full' : pct >= 80 ? 'warn' : '';
    const btnClass  = applied ? 'cancel' : isFull ? 'full' : 'apply';
    const btnText   = applied ? '신청취소' : isFull ? '마감' : '수강신청';
    const btnAction = applied ? `cancelEnroll(\${c.course_no})` : isFull ? '' : `applyEnroll(\${c.course_no})`;

    /* [버그 1 수정] credits null 처리 — EL 대신 JS 삼항 연산자 사용 */
    const credits = c.credits != null ? c.credits : 3;

    /* [버그 2 수정] enrolled 오타·조건 반전 수정 */
    const enrolledCount = c.enrolled != null ? c.enrolled : 0;

    /* [버그 3 수정] curriculum_pdf 조건부 렌더링 — JSTL 대신 JS 삼항 연산자 사용 */
    const pdfHtml = c.curriculum_pdf
      ? `<a class="pdf-link" href="` + escHtml(c.curriculum_pdf) + `" target="_blank">📄 보기</a>`
      : `<span style="color:var(--gray-300); font-size:.75rem;">-</span>`;

    return `<tr>
      <td style="text-align:center; color:var(--gray-400);">\${(currentPage-1)*PAGE_SIZE + i + 1}</td>
      <td>
        <div style="font-weight:600; color:var(--gray-900); font-size:.84rem;">\${escHtml(c.course_name)}</div>
        <div style="font-size:.72rem; color:var(--gray-400); margin-top:.1rem;">\${escHtml(c.professor_name || '')}</div>
      </td>
      <td><span class="type-badge \${typeClass(c.course_type)}">\${typeLabel(c.course_type)}</span></td>
      <td style="text-align:center; font-weight:700; color:var(--gray-700);">\${credits}</td>
      <td style="text-align:center;">\${c.day_of_week || '-'}</td>
      <td style="font-size:.78rem;">\${formatTime(c.start_time)} ~ \${formatTime(c.end_time)}</td>
      <td style="font-size:.78rem; color:var(--gray-500);">\${c.room_info || '-'}</td>
      <td>
        <div class="capacity-bar">
          <div class="cap-track"><div class="cap-fill \${capClass}" style="width:\${pct}%"></div></div>
          <span>\${enrolledCount}/\${c.max_students != null ? c.max_students : '-'}</span>
        </div>
      </td>
      <td style="text-align:center;">\${pdfHtml}</td>
      <td style="text-align:center;">
        <button class="btn-enroll \${btnClass}" \${!btnAction ? 'disabled' : ''}
                onclick="\${btnAction}">\${btnText}</button>
      </td>
    </tr>`;
  }).join('');
}

/* ================================================================
   내 수강 목록 로드 (AJAX)
   엔드포인트: GET /enrollment/mine
   응답 형태: { courses: [...] }
   - enrolledSet을 갱신하여 전체 강의 탭의 신청/취소 버튼 상태도 반영
   - 실패 시 MOCK_MINE으로 폴백
================================================================ */
function loadMyCourses() {
  showLoading('loadingMine', true);
  fetch(CTX_PATH + '/enrollment/mine', {
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  })
  .then(r => r.json())
  .then(data => {
    myCourses = data.courses || [];
    enrolledSet = new Set(myCourses.map(c => c.course_no));
    updateCreditSummary();
    renderMineTable();
  })
  .catch(() => {
    /* ⚠️ DB 연결 전 목업 폴백 — 서버 연동 후 이 catch 블록 제거 */
    myCourses = MOCK_MINE;
    enrolledSet = new Set(myCourses.map(c => c.course_no));
    updateCreditSummary();
    renderMineTable();
  })
  .finally(() => showLoading('loadingMine', false));
}

/* ================================================================
   내 수강 목록 테이블 렌더링
   statusBadgeHtml()로 신청상태(APPLIED/PENDING/APPROVED) 배지 생성
================================================================ */
function renderMineTable() {
  const tbody = document.getElementById('mineCourseBody');
  if (!myCourses.length) {
    tbody.innerHTML = `<tr><td colspan="9">
      <div class="empty-state">
        <div class="empty-icon">📋</div>
        <div class="empty-text">신청한 수강이 없습니다</div>
        <div class="empty-sub">전체 강의 탭에서 수강신청을 해보세요</div>
      </div>
    </td></tr>`;
    return;
  }
  tbody.innerHTML = myCourses.map((c, i) => {
    const statusBadge = statusBadgeHtml(c.status);
    return `<tr>
      <td style="text-align:center; color:var(--gray-400);">\${i+1}</td>
      <td>
        <div style="font-weight:600; color:var(--gray-900); font-size:.84rem;">\${escHtml(c.course_name)}</div>
        <div style="font-size:.72rem; color:var(--gray-400); margin-top:.1rem;">\${escHtml(c.professor_name || '')}</div>
      </td>
      <td><span class="type-badge \${typeClass(c.course_type)}">\${typeLabel(c.course_type)}</span></td>
      <td style="text-align:center; font-weight:700;">\${c.credits != null ? c.credits : 3}</td>
      <td style="text-align:center;">\${c.day_of_week || '-'}</td>
      <td style="font-size:.78rem;">\${formatTime(c.start_time)} ~ \${formatTime(c.end_time)}</td>
      <td style="font-size:.78rem; color:var(--gray-500);">\${c.room_info || '-'}</td>
      <td style="text-align:center;">\${statusBadge}</td>
      <td style="text-align:center;">
        <button class="btn-enroll cancel" onclick="cancelEnroll(\${c.course_no})">취소</button>
      </td>
    </tr>`;
  }).join('');
}

/* ================================================================
   학점 요약 업데이트
   ⚠️ [버그 4 수정] 원본: c.credits ? 3 : c.credits
      credits가 truthy면 3을 반환 → 항상 3학점으로 잘못 계산됨
      올바른 표현: c.credits != null ? c.credits : 3
================================================================ */
function updateCreditSummary() {
  /* [버그 4 수정] credits 존재 여부 체크 후 합산 */
  const total = myCourses.reduce((s, c) => s + (c.credits != null ? c.credits : 3), 0);
  document.getElementById('enrolledCredits').textContent  = total;
  document.getElementById('enrolledCount').textContent    = myCourses.length;
  document.getElementById('countMine').textContent        = myCourses.length;
  document.getElementById('totalCreditsDisplay').textContent = total;
}

/* ================================================================
   수강 신청 / 취소
   엔드포인트: POST /enrollment/apply | /enrollment/cancel
   요청 본문: { courseNo: N }
   응답 형태: { success: true/false, message: '...' }
   성공 시 목록 재로드, 실패·에러 시 토스트 표시
================================================================ */
function applyEnroll(courseNo) {
  if (!confirm('수강신청 하시겠습니까?')) return;
  fetch(CTX_PATH + '/enrollment/apply', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest'
    },
    body: JSON.stringify({ courseNo })
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      showToast('✅ 수강신청이 완료되었습니다.', 'green');
      loadMyCourses();
      loadAllCourses();
    } else {
      showToast('❌ ' + (data.message || '신청에 실패했습니다.'), 'red');
    }
  })
  .catch(() => showToast('⚠️ 서버 오류가 발생했습니다.', 'red'));
}

function cancelEnroll(courseNo) {
  if (!confirm('수강신청을 취소하시겠습니까?')) return;
  fetch(CTX_PATH + '/enrollment/cancel', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest'
    },
    body: JSON.stringify({ courseNo })
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      showToast('🗑 수강신청이 취소되었습니다.', 'yellow');
      loadMyCourses();
      loadAllCourses();
    } else {
      showToast('❌ ' + (data.message || '취소에 실패했습니다.'), 'red');
    }
  })
  .catch(() => showToast('⚠️ 서버 오류가 발생했습니다.', 'red'));
}

/* ================================================================
   시간표 렌더링
   myCourses 배열 기반으로 09:00~20:00 (12행) × 월~금 (5열) 그리드 생성
   - day_of_week : '월요일' or '월' 형태 모두 처리 (replace로 '요일' 제거)
   - start_time / end_time : 'HH:mm:ss' 또는 'HH:mm' 형태 지원 (parseInt로 시 단위 추출)
   - 강의가 없으면 빈 상태 메시지 표시
================================================================ */
function renderTimetable() {
  const body = document.getElementById('timetableBody');
  body.innerHTML = '';

  const DAY_IDX = {'월':0,'화':1,'수':2,'목':3,'금':4};
  for (let h = 9; h <= 20; h++) {
    const row = document.createElement('div');
    row.className = 'tt-row';

    const timeCell = document.createElement('div');
    timeCell.className = 'tt-time-cell';
    timeCell.textContent = `\${String(h).padStart(2,'0')}:00`;
    row.appendChild(timeCell);

    for (let d = 0; d < 5; d++) {
      const cell = document.createElement('div');
      cell.className = 'tt-cell';

      const course = myCourses.find(c => {
    	  const days = c.day_of_week ? c.day_of_week.split(',').map(d => d.replace(/요일/,'').trim()) : [];
    	  if (!days.includes(Object.keys(DAY_IDX)[d])) return false;
        const sh = c.start_time ? parseInt(c.start_time.split(':')[0]) : -1;
        const eh = c.end_time   ? parseInt(c.end_time.split(':')[0])   : -1;
        return sh <= h && h < eh;
      });

      if (course) {
        const block = document.createElement('div');
        block.className = 'tt-course-block';
        block.innerHTML = `
          <div>\${escHtml(course.course_name)}</div>
          <div class="tt-room">\${escHtml(course.room_info || '')}</div>`;
        cell.appendChild(block);
      }
      row.appendChild(cell);
    }
    body.appendChild(row);
  }

  if (!myCourses.length) {
    body.innerHTML = `<div class="empty-state">
      <div class="empty-icon">🗓</div>
      <div class="empty-text">신청된 수강이 없습니다</div>
      <div class="empty-sub">수강신청 후 시간표가 표시됩니다</div>
    </div>`;
  }
}

/* ================================================================
   페이지네이션
   - 현재 페이지 기준 앞뒤 2페이지씩 최대 5개 버튼 표시
   - 이전/다음 버튼은 첫/마지막 페이지에서 disabled
================================================================ */
function renderPagination(totalCount) {
  const pg = document.getElementById('allPagination');
  totalPages = Math.ceil(totalCount / PAGE_SIZE) || 1;
  let html = `<button class="page-btn" onclick="loadAllCourses(\${currentPage-1})"
                \${currentPage==1 ? 'disabled' : ''}>‹</button>`;
  const start = Math.max(1, currentPage - 2);
  const end   = Math.min(totalPages, start + 4);
  for (let p = start; p <= end; p++) {
    html += `<button class="page-btn \${p==currentPage?'active':''}"
               onclick="loadAllCourses(\${p})">\${p}</button>`;
  }
  html += `<button class="page-btn" onclick="loadAllCourses(\${currentPage+1})"
             \${currentPage==totalPages ? 'disabled' : ''}>›</button>`;
  pg.innerHTML = html;
}

/* ================================================================
   필터 / 검색
   - resetFilters : 모든 필터 초기화 후 1페이지 재로드
   - debounceSearch : 입력 후 350ms 대기 후 검색 (타이핑마다 요청 방지)
================================================================ */
function resetFilters() {
  document.getElementById('filterDept').value    = '';
  document.getElementById('filterType').value    = '';
  document.getElementById('filterCredits').value = '';
  document.getElementById('searchKeyword').value = '';
  currentPage = 1;
  loadAllCourses();
}

function debounceSearch() {
  clearTimeout(searchTimer);
  searchTimer = setTimeout(() => { currentPage = 1; loadAllCourses(); }, 350);
}

/* ================================================================
   유틸 함수
   - typeLabel   : course_type enum → 한글 라벨
   - typeClass   : course_type enum → CSS 클래스명
   - statusBadgeHtml : 신청상태 → 배지 HTML (APPLIED/PENDING/APPROVED)
   - formatTime  : 'HH:mm:ss' → 'HH:mm' (앞 5자리만 추출)
   - escHtml     : XSS 방지용 HTML 이스케이프
   - showLoading : 로딩 오버레이 표시/숨김
================================================================ */
function typeLabel(t) {
  return { MAJOR_REQUIRED:'전공필수', MAJOR_ELECTIVE:'전공선택',
           GENERAL_REQUIRED:'교양필수', GENERAL_ELECTIVE:'교양선택',
           FREE_ELECTIVE:'일반선택' }[t] || t;
}
function typeClass(t) {
  return { MAJOR_REQUIRED:'type-major-req', MAJOR_ELECTIVE:'type-major-elec',
           GENERAL_REQUIRED:'type-gen-req', GENERAL_ELECTIVE:'type-gen-elec',
           FREE_ELECTIVE:'type-free' }[t] || 'type-free';
}
function statusBadgeHtml(s) {
  const map = { APPLIED:['badge-blue','신청'], PENDING:['badge-yellow','대기'], APPROVED:['badge-green','승인'] };
  const [cls, label] = map[s] || ['badge-gray', s];
  return `<span class="badge \${cls}">\${label}</span>`;
}
function formatTime(t) { return t ? t.substring(0,5) : '-'; }
function escHtml(s) {
  return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
function showLoading(id, show) {
  document.getElementById(id).classList.toggle('active', show);
}

/* 토스트 알림 — 하단 우측에 3초간 표시 후 자동 제거 */
function showToast(msg, color) {
  const colors = { green:'#15803d', red:'#b91c1c', yellow:'#a16207' };
  const t = document.createElement('div');
  t.textContent = msg;
  Object.assign(t.style, {
    position:'fixed', bottom:'1.5rem', right:'1.5rem', zIndex:9999,
    background: color === 'green' ? '#f0fdf4' : color === 'red' ? '#fff1f2' : '#fffbeb',
    color: colors[color] || '#374151',
    border: `1px solid \${color==='green'?'#bbf7d0':color==='red'?'#fecdd3':'#fde68a'}`,
    borderRadius:'10px', padding:'.75rem 1.2rem',
    fontSize:'.84rem', fontWeight:'600',
    boxShadow:'0 4px 16px rgba(0,0,0,.08)',
    fontFamily:"'Pretendard','Noto Sans KR',sans-serif",
    animation:'fadeUp .2s ease'
  });
  document.body.appendChild(t);
  setTimeout(() => t.remove(), 3000);
}

function closeModal() {
  document.getElementById('curriculumModal').style.display = 'none';
  document.getElementById('curriculumFrame').src = '';
}

/* ================================================================
   목업 데이터 (개발/테스트용 — 실제 서버 연동 시 제거)
   AJAX 실패 시 catch 블록에서 사용
   MOCK_COURSES : 전체 강의 목록 샘플
   MOCK_MINE    : 내 수강 목록 샘플
================================================================ */
const MOCK_COURSES = [
  { course_no:1, course_name:'고급 영어 회화', professor_name:'김영어', course_type:'GENERAL_ELECTIVE',
    credits:3, day_of_week:'월', start_time:'09:00', end_time:'12:00', room_info:'A동 201',
    max_students:30, enrolled:25, status:'APPROVED', curriculum_pdf:null },
  { course_no:2, course_name:'데이터베이스 설계', professor_name:'이컴공', course_type:'MAJOR_REQUIRED',
    credits:3, day_of_week:'화', start_time:'13:00', end_time:'16:00', room_info:'공학관 305',
    max_students:35, enrolled:35, status:'APPROVED', curriculum_pdf:null },
  { course_no:3, course_name:'경제학 원론', professor_name:'박경제', course_type:'GENERAL_REQUIRED',
    credits:2, day_of_week:'수', start_time:'10:00', end_time:'12:00', room_info:'본관 102',
    max_students:50, enrolled:30, status:'APPROVED', curriculum_pdf:null },
  { course_no:4, course_name:'알고리즘', professor_name:'최알고', course_type:'MAJOR_ELECTIVE',
    credits:3, day_of_week:'목', start_time:'14:00', end_time:'17:00', room_info:'공학관 201',
    max_students:40, enrolled:38, status:'APPROVED', curriculum_pdf:null },
  { course_no:5, course_name:'선형대수학', professor_name:'정수학', course_type:'MAJOR_REQUIRED',
    credits:3, day_of_week:'금', start_time:'09:00', end_time:'12:00', room_info:'이과관 101',
    max_students:45, enrolled:20, status:'APPROVED', curriculum_pdf:null },
];
const MOCK_MINE = [
  { course_no:1, course_name:'고급 영어 회화', professor_name:'김영어', course_type:'GENERAL_ELECTIVE',
    credits:3, day_of_week:'월', start_time:'09:00', end_time:'12:00', room_info:'A동 201', status:'APPROVED' },
  { course_no:3, course_name:'경제학 원론', professor_name:'박경제', course_type:'GENERAL_REQUIRED',
    credits:2, day_of_week:'수', start_time:'10:00', end_time:'12:00', room_info:'본관 102', status:'APPLIED' },
];

/* ================================================================
   초기 로드
   DOMContentLoaded 시 내 수강 목록 먼저 로드 (enrolledSet 채우기)
   → 완료 후 전체 강의 목록 로드 (신청 버튼 상태 정확히 표시)
   ⚠️ 현재 두 fetch가 병렬 실행됨 — enrolledSet이 채워지기 전에
      renderAllTable이 실행될 수 있으므로, 정확한 순서가 필요하면
      loadMyCourses().then(() => loadAllCourses()) 형태로 순차 처리 권장
================================================================ */
window.addEventListener('DOMContentLoaded', () => {
  loadMyCourses();
  loadAllCourses();
});
</script>
</body>
</html>
