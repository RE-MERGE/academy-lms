<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  courseEnrollment.jsp
  ─────────────────────────────────────────────────────────────
  컨트롤러에서 model에 담아야 할 속성:
    user              : User 객체 (role, name, userNo 필드 포함: STUDENT | PROFESSOR | ADMIN)
    ${currentSemester}: 현재 학기 문자열 (예: "2025년 2학기")

  AJAX 엔드포인트:
    GET  /enrollment/list          → 전체 강의 목록 (page, size, type, credits, keyword, status)
    GET  /enrollment/mine          → 내 수강 목록 (STUDENT)
    GET  /enrollment/my-courses    → 내 담당 강의 목록 (PROFESSOR)
    POST /enrollment/apply         → 수강 신청 (STUDENT) → Enrollment INSERT (status=APPLIED)
    POST /enrollment/cancel        → 수강 취소 (STUDENT) → Enrollment DELETE
    POST /admin/course/delete      → 강의 삭제 (ADMIN)   body: { courseNos:[..] }
    POST /admin/course/status      → 상태 변경 (ADMIN)   body: { courseNos:[..], status }
    POST /course/create            → 강의 개설 (PROFESSOR/ADMIN)
                                     body: { courseName, courseType, credits, dayOfWeek,
                                             startTime, endTime, roomInfo, maxStudents,
                                             professorNo, description }
                                     PROFESSOR 개설 → Course.status = PENDING
                                     ADMIN 개설    → Course.status = ACTIVE
    GET  /admin/professor/list     → 교수 목록 (ADMIN 강의개설 모달용)
                                     응답: { professors:[{ professorNo, name },...] }

  Enrollment 흐름:
    수강신청 버튼 클릭
      → hasTimeConflict() 시간 충돌 검사 (충돌 시 요청 차단)
      → POST /enrollment/apply  body: { courseNo }
      → 서버: Enrollment INSERT (studentNo=세션, courseNo, status='APPLIED', enrolledAt=NOW)
      → 응답: { success, message }
      → 성공 시 myCourses / allCourses 재로드
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>수강신청 — re-merge LMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
  <style>
    /* ====================================================
       공통 스타일
       ==================================================== */
    .enroll-page { display: flex; flex-direction: column; height: 100%; }

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
    .role-chip {
      font-size: .68rem;
      font-weight: 700;
      padding: .2rem .6rem;
      border-radius: 999px;
      letter-spacing: .05em;
      margin-left: .4rem;
    }
    .role-chip.student  { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
    .role-chip.professor{ background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
    .role-chip.admin    { background: #fff7ed; color: #b45309; border: 1px solid #fde68a; }

    /* 학점 요약 배너 (STUDENT only) */
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
    .credit-chip .val { font-family: 'DM Serif Display', serif; font-size: 1.1rem; color: var(--gray-900); line-height: 1; }
    .credit-chip .val.primary { color: var(--primary); }
    .credit-chip .val.warn    { color: #ca8a04; }
    .credit-chip-icon { font-size: .95rem; }

    /* 탭 네비게이션 */
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
    .tab-btn.active { color: var(--primary); border-bottom-color: var(--primary); background: var(--primary-pale); }
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

    /* 필터 바 */
    .filter-bar {
      display: flex;
      gap: .6rem;
      align-items: center;
      margin-bottom: .9rem;
      flex-wrap: wrap;
      flex-shrink: 0;
    }
    .filter-label { font-size: .75rem; font-weight: 700; color: var(--gray-500); letter-spacing: .04em; white-space: nowrap; }
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
    .filter-select:focus { outline: none; border-color: var(--primary-light); box-shadow: 0 0 0 3px rgba(59,130,246,.12); }
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
    .filter-search-wrap:focus-within { border-color: var(--primary-light); box-shadow: 0 0 0 3px rgba(59,130,246,.12); }
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

    /* 테이블 래퍼 */
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

    /* 버튼들 */
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
    .btn-enroll.apply  { background: var(--primary); color: var(--white); box-shadow: 0 2px 6px rgba(29,78,216,.2); }
    .btn-enroll.apply:hover { background: var(--primary-mid); transform: translateY(-1px); }
    .btn-enroll.cancel { background: #fff1f2; color: #b91c1c; border: 1px solid #fecdd3; }
    .btn-enroll.cancel:hover { background: #fee2e2; }
    .btn-enroll.full   { background: var(--gray-100); color: var(--gray-400); cursor: not-allowed; border: 1px solid var(--gray-200); }
    .btn-enroll.conflict { background: #fff7ed; color: #b45309; border: 1px solid #fde68a; cursor: not-allowed; }

    /* ADMIN 액션 버튼 */
    .btn-action {
      padding: .32rem .7rem;
      border-radius: var(--radius-sm);
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .75rem;
      font-weight: 700;
      cursor: pointer;
      transition: all .15s;
      white-space: nowrap;
      border: 1.5px solid transparent;
    }
    .btn-action.delete  { background: #fff1f2; color: #b91c1c; border-color: #fecdd3; }
    .btn-action.delete:hover  { background: #fee2e2; }
    .btn-action.status  { background: var(--primary-pale); color: var(--primary); border-color: var(--primary-tint); }
    .btn-action.status:hover  { background: var(--primary-tint); }
    .btn-action:disabled { opacity: .45; cursor: not-allowed; }

    /* 체크박스 */
    .row-check { width: 16px; height: 16px; cursor: pointer; accent-color: var(--primary); }
    .check-header-wrap { display: flex; align-items: center; gap: .4rem; }

    /* ADMIN 일괄 액션 바 */
    .bulk-action-bar {
      display: flex;
      align-items: center;
      gap: .6rem;
      padding: .55rem 1rem;
      background: var(--gray-50);
      border-bottom: 1px solid var(--gray-200);
      flex-shrink: 0;
    }
    .bulk-selected-count {
      font-size: .78rem;
      font-weight: 600;
      color: var(--gray-600);
      margin-right: .4rem;
    }
    .bulk-selected-count span { color: var(--primary); }

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

    /* 상태 배지 */
    .badge {
      display: inline-flex;
      align-items: center;
      font-size: .65rem;
      font-weight: 700;
      padding: .18rem .5rem;
      border-radius: 999px;
      white-space: nowrap;
      letter-spacing: .02em;
    }
    .badge-blue   { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
    .badge-green  { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
    .badge-yellow { background: #fffbeb; color: #a16207; border: 1px solid #fde68a; }
    .badge-gray   { background: var(--gray-100); color: var(--gray-500); border: 1px solid var(--gray-200); }
    .badge-red    { background: #fff1f2; color: #b91c1c; border: 1px solid #fecdd3; }
    .badge-orange { background: #fff7ed; color: #b45309; border: 1px solid #fed7aa; }

    /* 정원 게이지 */
    .capacity-bar { display: flex; align-items: center; gap: .4rem; font-size: .75rem; color: var(--gray-600); }
    .cap-track { flex: 1; height: 4px; background: var(--gray-100); border-radius: 999px; overflow: hidden; min-width: 50px; }
    .cap-fill { height: 100%; border-radius: 999px; background: linear-gradient(90deg, var(--primary-light), var(--primary)); transition: width .3s; }
    .cap-fill.warn { background: linear-gradient(90deg, #f59e0b, #ca8a04); }
    .cap-fill.full { background: linear-gradient(90deg, #ef4444, #dc2626); }

    /* 페이지네이션 */
    .pagination { display: flex; align-items: center; justify-content: center; gap: .3rem; padding: .8rem 1rem; border-top: 1px solid var(--gray-100); flex-shrink: 0; }
    .page-btn {
      width: 30px; height: 30px;
      display: flex; align-items: center; justify-content: center;
      border: 1px solid var(--gray-200);
      border-radius: var(--radius-sm);
      background: var(--white);
      font-size: .78rem; font-weight: 600;
      color: var(--gray-600);
      cursor: pointer;
      transition: all .15s;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
    }
    .page-btn:hover  { background: var(--primary-pale); border-color: var(--primary-tint); color: var(--primary); }
    .page-btn.active { background: var(--primary); border-color: var(--primary); color: var(--white); }
    .page-btn:disabled { opacity: .4; cursor: not-allowed; }

    /* 시간표 */
    .timetable-wrap { background: var(--white); border: 1px solid var(--gray-200); border-radius: var(--radius-lg); box-shadow: var(--shadow-sm); overflow: hidden; flex: 1; display: flex; flex-direction: column; }
    .timetable-header { display: grid; grid-template-columns: 60px repeat(5, 1fr); background: var(--gray-50); border-bottom: 2px solid var(--gray-200); }
    .tt-head-cell { padding: .65rem .5rem; text-align: center; font-size: .72rem; font-weight: 700; letter-spacing: .06em; color: var(--gray-500); }
    .timetable-body { flex: 1; overflow-y: auto; position: relative; }
    .timetable-body::-webkit-scrollbar { width: 4px; }
    .timetable-body::-webkit-scrollbar-thumb { background: var(--gray-200); border-radius: 999px; }
    .tt-row { display: grid; grid-template-columns: 60px repeat(5, 1fr); border-bottom: 1px solid var(--gray-100); min-height: 50px; }
    .tt-row:last-child { border-bottom: none; }
    .tt-time-cell { display: flex; align-items: flex-start; justify-content: center; padding: .55rem .3rem; font-size: .68rem; font-weight: 600; color: var(--gray-400); background: var(--gray-50); border-right: 1px solid var(--gray-200); }
    .tt-cell { border-right: 1px solid var(--gray-100); padding: .3rem; position: relative; }
    .tt-cell:last-child { border-right: none; }
    .tt-course-block { height: 100%; background: var(--primary-pale); border: 1.5px solid var(--primary-tint); border-left: 3.5px solid var(--primary); border-radius: var(--radius-sm); padding: .3rem .45rem; font-size: .7rem; font-weight: 600; color: var(--primary-dark); line-height: 1.35; cursor: default; }
    .tt-course-block.status-approved { background: #eff6ff; border-color: #bfdbfe; border-left-color: #1d4ed8; color: #1e3a8a; }
    .tt-course-block.status-approved .tt-room { color: #3b82f6; }
    .tt-course-block.status-pending  { background: #fffbeb; border-color: #fde68a; border-left-color: #ca8a04; color: #78350f; }
    .tt-course-block.status-pending  .tt-room { color: #d97706; }
    .tt-course-block .tt-room { font-size: .62rem; font-weight: 500; color: var(--primary-light); margin-top: .15rem; }
    .tt-course-block .tt-status { font-size: .58rem; font-weight: 700; margin-top: .15rem; }

    /* 빈 상태 */
    .empty-state { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 3rem; color: var(--gray-400); gap: .75rem; }
    .empty-icon { font-size: 2.5rem; }
    .empty-text { font-size: .88rem; font-weight: 500; }
    .empty-sub  { font-size: .78rem; color: var(--gray-300); }

    /* 로딩 오버레이 */
    .loading-overlay { display: none; position: absolute; inset: 0; background: rgba(255,255,255,.7); backdrop-filter: blur(2px); align-items: center; justify-content: center; z-index: 10; border-radius: var(--radius-lg); }
    .loading-overlay.active { display: flex; }
    .spinner { width: 28px; height: 28px; border: 3px solid var(--primary-tint); border-top-color: var(--primary); border-radius: 50%; animation: spin .65s linear infinite; }
    @keyframes spin { to { transform: rotate(360deg); } }
    @keyframes fadeUp { from { opacity:0; transform:translateY(6px); } to { opacity:1; transform:translateY(0); } }

    /* 강의 개설 버튼 */
    .btn-create-course {
      display: inline-flex;
      align-items: center;
      gap: .45rem;
      padding: .55rem 1.3rem;
      background: linear-gradient(135deg, var(--primary) 0%, var(--primary-mid) 100%);
      color: var(--white);
      border: none;
      border-radius: 999px;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .88rem;
      font-weight: 700;
      cursor: pointer;
      box-shadow: 0 3px 12px rgba(29,78,216,.35);
      transition: all .18s;
      letter-spacing: .01em;
      white-space: nowrap;
      position: relative;
      overflow: hidden;
    }
    .btn-create-course::before {
      content: '';
      position: absolute;
      inset: 0;
      background: rgba(255,255,255,0);
      transition: background .18s;
    }
    .btn-create-course:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(29,78,216,.45);
    }
    .btn-create-course:hover::before { background: rgba(255,255,255,.08); }
    .btn-create-course:active { transform: translateY(0); box-shadow: 0 2px 8px rgba(29,78,216,.3); }
    .btn-create-course .btn-icon {
      font-size: 1rem;
      line-height: 1;
    }

    /* PDF 링크 */
    .pdf-link { display: inline-flex; align-items: center; gap: .25rem; font-size: .72rem; color: var(--primary); text-decoration: none; background: var(--primary-pale); padding: .2rem .5rem; border-radius: var(--radius-sm); border: 1px solid var(--primary-tint); white-space: nowrap; transition: all .14s; }
    .pdf-link:hover { background: var(--primary-tint); }

    /* 모달 */
    .curriculum-modal .modal-content { width: 540px; }
    .curriculum-iframe { width: 100%; height: 420px; border: 1px solid var(--gray-200); border-radius: var(--radius-md); margin-top: .8rem; }

    /* 상태 변경 모달 */
    .status-modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.35); z-index:1000; align-items:center; justify-content:center; }
    .status-modal-overlay.active { display:flex; }
    .status-modal { background:var(--white); border-radius:var(--radius-lg); padding:1.6rem; width:340px; box-shadow:0 8px 32px rgba(0,0,0,.15); }
    .status-modal h3 { font-family:'DM Serif Display',serif; font-size:1.1rem; margin-bottom:1rem; color:var(--gray-900); }
    .status-option-group { display:flex; flex-direction:column; gap:.5rem; margin-bottom:1.2rem; }
    .status-option { display:flex; align-items:center; gap:.55rem; padding:.6rem .8rem; border:1.5px solid var(--gray-200); border-radius:var(--radius-md); cursor:pointer; transition:all .15s; }
    .status-option:hover { border-color:var(--primary-tint); background:var(--primary-pale); }
    .status-option input[type=radio] { accent-color:var(--primary); }
    .status-option label { font-size:.84rem; font-weight:600; cursor:pointer; }
    .status-modal-actions { display:flex; justify-content:flex-end; gap:.6rem; }
    .btn-sm { padding:.38rem .9rem; font-size:.8rem; font-weight:600; border-radius:var(--radius-sm); cursor:pointer; border:none; font-family:'Pretendard','Noto Sans KR',sans-serif; }
    .btn-sm.primary { background:var(--primary); color:var(--white); }
    .btn-sm.gray    { background:var(--gray-100); color:var(--gray-600); border:1px solid var(--gray-200); }
  </style>
</head>
<body>
<div class="layout-root">
  <main class="main-content" style="position:relative; overflow-y:auto;">
    <div class="enroll-page">

      <%-- ====== 페이지 헤더 ====== --%>
      <div class="page-header">
        <div class="page-title">
          <div class="page-title-icon">
            <c:choose>
              <c:when test="${user.role == 'ADMIN'}">&#x1F6E1;</c:when>
              <c:when test="${user.role == 'PROFESSOR'}">&#x1F6E1;</c:when>
              <c:otherwise>&#x1F6E1;</c:otherwise>
            </c:choose>
          </div>
          <c:choose>
            <c:when test="${user.role == 'ADMIN'}">강의 관리</c:when>
            <c:when test="${user.role == 'PROFESSOR'}">강의 현황</c:when>
            <c:otherwise>수강신청</c:otherwise>
          </c:choose>
          <span class="role-chip ${user.role == 'ADMIN' ? 'admin' : user.role == 'PROFESSOR' ? 'professor' : 'student'}">
            ${user.role == 'ADMIN' ? 'ADMIN' : user.role == 'PROFESSOR' ? 'PROFESSOR' : 'STUDENT'}
          </span>
        </div>
        <div style="display:flex; align-items:center; gap:.7rem;">
          <%-- 강의 개설 버튼: PROFESSOR / ADMIN 에게만 표시 --%>
          <c:if test="${user.role == 'PROFESSOR' || user.role == 'ADMIN'}">
            <button class="btn-create-course" onclick="location.href=CTX_PATH+'/enrollment/courseCreate'">
              <span class="btn-icon">✏️</span> 강의 개설
            </button>
          </c:if>
          <span class="semester-chip">${currentSemester}</span>
        </div>
      </div>

      <%-- ====== STUDENT: 학점 요약 배너 ====== --%>
      <c:if test="${user.role == 'STUDENT'}">
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
            신청 기간 <span class="val warn">${enrollmentStart} ~ ${enrollmentEnd}</span>
          </div>
        </div>
      </c:if>

      <%-- ====== 탭 네비게이션 ====== --%>
      <div class="tab-nav">
        <c:choose>
          <%-- STUDENT 탭: 전체강의 / 내 수강목록 / 시간표 --%>
          <c:when test="${user.role == 'STUDENT'}">
            <button class="tab-btn active" data-tab="all">
              📖 전체 강의 <span class="tab-count" id="countAll">0</span>
            </button>
            <button class="tab-btn" data-tab="mine">
              ✅ 내 수강목록 <span class="tab-count" id="countMine">0</span>
            </button>
            <button class="tab-btn" data-tab="timetable">
              🗓 내 시간표
            </button>
          </c:when>

          <%-- PROFESSOR 탭: 전체강의 / 내 강의(status 포함) / 내 강의 시간표(active만) --%>
          <c:when test="${user.role == 'PROFESSOR'}">
            <button class="tab-btn active" data-tab="all">
              📖 전체 강의 <span class="tab-count" id="countAll">0</span>
            </button>
            <button class="tab-btn" data-tab="mine">
              🏫 내 강의 <span class="tab-count" id="countMine">0</span>
            </button>
            <button class="tab-btn" data-tab="timetable">
              🗓 내 강의 시간표
            </button>
          </c:when>

          <%-- ADMIN 탭: 전체 강의 목록(상태 필터) --%>
          <c:when test="${user.role == 'ADMIN'}">
            <button class="tab-btn active" data-tab="all">
              📋 전체 강의 목록 <span class="tab-count" id="countAll">0</span>
            </button>
          </c:when>
        </c:choose>
      </div>

      <%-- ================================================================
           탭 1: 전체 강의 목록 (공통 — 역할별 마지막 컬럼 다름)
           ================================================================ --%>
      <div class="tab-panel active" id="panel-all">
        <div class="filter-bar">
          <span class="filter-label">🔍 필터</span>
          <select class="filter-select" id="filterType" onchange="loadAllCourses(1)">
            <option value="">전체 유형</option>
            <option value="MAJOR_REQUIRED">전공필수</option>
            <option value="MAJOR_ELECTIVE">전공선택</option>
            <option value="GENERAL_REQUIRED">교양필수</option>
            <option value="GENERAL_ELECTIVE">교양선택</option>
            <option value="FREE_ELECTIVE">일반선택</option>
          </select> 
          <select class="filter-select" id="filterCredits" onchange="loadAllCourses(1)">
            <option value="">전체 학점</option>
            <option value="1">1학점</option>
            <option value="2">2학점</option>
            <option value="3">3학점</option>
          </select>

          <%-- ADMIN 전용: 상태 필터 --%>
          <c:if test="${user.role == 'ADMIN'}">
            <select class="filter-select" id="filterStatus" onchange="loadAllCourses(1)">
              <option value="">전체 상태</option>
              <option value="APPROVED">승인(APPROVED)</option>
              <option value="PENDING">대기(PENDING)</option>
            </select>
          </c:if>

          <button class="btn-filter-reset" onclick="resetFilters()">초기화</button>
          <div class="filter-search-wrap">
            <span class="filter-search-icon">🔎</span>
            <input type="text" id="searchKeyword" placeholder="강의명 / 교수명 검색" onkeydown="if(event.key==='Enter'){currentPage=1;loadAllCourses();}">
          </div>
        </div>

        <%-- ADMIN 전용: 일괄 액션 바 --%>
        <c:if test="${user.role == 'ADMIN'}">
          <div class="bulk-action-bar">
            <span class="bulk-selected-count">선택됨 <span id="bulkCount">0</span>건</span>
            <button class="btn-action delete" onclick="bulkDelete()" id="btnBulkDelete" disabled>🗑 강의 삭제</button>
            <button class="btn-action status" onclick="openStatusModal()" id="btnBulkStatus" disabled>⚙ 상태 변경</button>
          </div>
        </c:if>

        <div class="table-wrap" style="position:relative;">
          <div class="loading-overlay" id="loadingAll"><div class="spinner"></div></div>
          <div class="table-scroll">
            <table class="lms-table" id="allCourseTable">
              <thead>
                <tr>
                  <c:if test="${user.role == 'ADMIN'}">
                    <th style="width:38px; text-align:center;">
                      <div class="check-header-wrap">
                        <input type="checkbox" class="row-check" id="checkAll" onchange="toggleAllCheck(this)">
                      </div>
                    </th>
                  </c:if>
                  <th style="width:42px; text-align:center;">번호</th>
                  <th>강의명</th>
                  <th style="width:80px;text-align: center;">유형</th>
                  <th style="width:70px; text-align:center;">학점</th>
                  <th style="width:55px; text-align:center;">요일</th>
                  <th style="width:105px;">시간</th>
                  <th style="width:70px;">강의실</th>
                  <th style="width:140px;">정원</th>
                  <%-- 역할별 마지막 컬럼 --%>
                  <c:choose>
                    <c:when test="${user.role == 'STUDENT'}">
                      <th style="width:85px; text-align:center;">신청/취소</th>
                    </c:when>
                    <c:when test="${user.role == 'PROFESSOR'}">
                      <%-- 교수는 읽기 전용 --%>
                    </c:when>
                    <c:when test="${user.role == 'ADMIN'}">
                      <th style="width:80px; text-align:center;">상태</th>
                      <th style="width:70px; text-align:center;">수정</th>
                    </c:when>
                  </c:choose>
                </tr>
              </thead>
              <tbody id="allCourseBody"></tbody>
            </table>
          </div>
          <div class="pagination" id="allPagination"></div>
        </div>
      </div><%-- /panel-all --%>

      <%-- ================================================================
           탭 2: 내 수강목록 (STUDENT) / 내 강의 (PROFESSOR)
           ================================================================ --%>
      <c:if test="${user.role == 'STUDENT' || user.role == 'PROFESSOR'}">
        <div class="tab-panel" id="panel-mine">
          <div class="table-wrap" style="position:relative;">
            <div class="loading-overlay" id="loadingMine"><div class="spinner"></div></div>
            <div class="table-scroll">
              <table class="lms-table">
                <thead>
                  <tr>
                    <th style="width:42px; text-align:center;">번호</th>
                    <th>강의명</th>
                    <th style="width:80px;text-align: center">유형</th>
                    <th style="width:70px; text-align:center;">학점</th>
                    <th style="width:55px; text-align:center;">요일</th>
                    <th style="width:105px;">시간</th>
                    <th style="width:70px;">강의실</th>
                    <%-- 공통: 상태 배지 --%>
                    <c:if test="${user.role != 'STUDENT'}"><th style="width:90px; text-align:center;">상태</th></c:if>
                    <%-- STUDENT only: 취소 버튼 --%>
                    <c:if test="${user.role == 'STUDENT'}">
                      <th style="width:85px; text-align:center;">취소</th>
                    </c:if>
                    <%-- PROFESSOR only: 수강인원 --%>
                    <c:if test="${user.role == 'PROFESSOR'}">
                      <th style="width:100px; text-align:center;">수강인원</th>
                      <th style="width:110px; text-align:center;">관리</th>
                    </c:if>
                  </tr>
                </thead>
                <tbody id="mineCourseBody"></tbody>
              </table>
            </div>
            <c:if test="${user.role == 'STUDENT'}">
              <div style="padding:.6rem 1rem; border-top:1px solid var(--gray-100); font-size:.78rem; color:var(--gray-500); flex-shrink:0;">
                합계 학점 : <strong id="totalCreditsDisplay" style="color:var(--primary);">0</strong> 학점
              </div>
            </c:if>
          </div>
        </div>
      </c:if>

      <%-- ================================================================
           탭 3: 시간표 (STUDENT: 신청한 강의 / PROFESSOR: ACTIVE 강의만)
           ================================================================ --%>
      <c:if test="${user.role == 'STUDENT' || user.role == 'PROFESSOR'}">
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
            <div class="timetable-body" id="timetableBody"></div>
          </div>
        </div>
      </c:if>

    </div><%-- /enroll-page --%>
  </main>
</div>

<%-- ====== 커리큘럼 모달 ====== --%>
<div class="modal curriculum-modal" id="curriculumModal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">✕</span>
    <h3>📄 수업 커리큘럼</h3>
    <iframe id="curriculumFrame" class="curriculum-iframe" src=""></iframe>
  </div>
</div>

<%-- ====== ADMIN 상태 변경 모달 ====== --%>
<c:if test="${user.role == 'ADMIN'}">
  <div class="status-modal-overlay" id="statusModalOverlay">
    <div class="status-modal">
      <h3>⚙ 강의 상태 변경</h3>
      <div class="status-option-group">
        <label class="status-option">
          <input type="radio" name="statusChoice" value="APPROVED">
          <span>🟢</span>
          <label>승인</label>
        </label>
        <label class="status-option">
          <input type="radio" name="statusChoice" value="PENDING">
          <span>🟡</span>
          <label>대기</label>
        </label>
      </div>
      <div class="status-modal-actions">
        <button class="btn-sm gray" onclick="closeStatusModal()">취소</button>
        <button class="btn-sm primary" onclick="confirmStatusChange()">변경 적용</button>
      </div>
    </div>
  </div>
</c:if>


<script>
/* ================================================================
   전역 설정
   CTX_PATH  : 컨텍스트 경로 (JSP EL → JS 변수로 추출)
   USER_ROLE : 서버에서 내려온 역할 ('STUDENT' | 'PROFESSOR' | 'ADMIN')
================================================================ */
var CTX_PATH  = '<%=request.getContextPath()%>';
var USER_ROLE = '${user.role}';
var CURRENT_SEMESTER = '${currentSemester}';

document.addEventListener('click', function(e) {
  const el = e.target.closest('.pdf-link');
  if (!el) return;
  const semester = el.dataset.semester;
  const pdf = el.dataset.pdf;
  if (pdf) window.open(pdf, '_blank', 'width=800,height=900');
});

let currentPage  = 1;
const PAGE_SIZE  = 10;
let totalPages   = 1;
let enrolledSet  = new Set();   // STUDENT: 신청 courseNo Set
let myCourses    = [];          // STUDENT: 신청목록 / PROFESSOR: 담당강의목록
let selectedNos  = new Set();   // ADMIN: 체크박스 선택된 courseNo Set

/* ================================================================
   탭 전환
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
   전체 강의 목록 로드
   GET /enrollment/list?page=&size=&type=&credits=&keyword=&status=
   응답: { courses:[...], totalCount:N, totalPages:N }
================================================================ */
function loadAllCourses(page) {
  if (page) currentPage = page;
  const type    = document.getElementById('filterType').value;
  const credits = document.getElementById('filterCredits').value;
  const keyword = document.getElementById('searchKeyword').value.trim();
  const status  = USER_ROLE === 'ADMIN'
                    ? (document.getElementById('filterStatus') ? document.getElementById('filterStatus').value : '')
                    : '';

  showLoading('loadingAll', true);
  const params = new URLSearchParams({ page: currentPage, size: PAGE_SIZE, type, credits, keyword, status, semester: CURRENT_SEMESTER });

  fetch(CTX_PATH + '/enrollment/courselist?' + params, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
    .then(r => r.json())
    .then(data => {
      totalPages = data.totalPages || 1;
      document.getElementById('countAll').textContent = data.totalCount || 0;
      renderAllTable(data.courses || []);
      renderPagination(data.totalCount || 0);
    })
    .catch(() => {
      /* 개발용 목업 폴백 — 서버 연동 후 제거 */
      renderAllTable(MOCK_COURSES);
      document.getElementById('countAll').textContent = MOCK_COURSES.length;
      renderPagination(MOCK_COURSES.length);
    })
    .finally(() => showLoading('loadingAll', false));
}

/* ================================================================
   전체 강의 테이블 렌더링 (역할별 분기)
================================================================ */
function renderAllTable(courses) {
  const tbody = document.getElementById('allCourseBody');
  if (!courses.length) {
    const colspan = USER_ROLE === 'ADMIN' ? 11 : USER_ROLE === 'PROFESSOR' ? 8 : 9;
    tbody.innerHTML = `<tr><td colspan="\${colspan}">
      <div class="empty-state">
        <div class="empty-icon">📭</div>
        <div class="empty-text">조건에 맞는 강의가 없습니다</div>
        <div class="empty-sub">필터를 초기화하거나 검색어를 변경해보세요</div>
      </div></td></tr>`;
    return;
  }

  tbody.innerHTML = courses.map((c, i) => {
    const credits      = c.credits != null ? c.credits : 3;
    const enrolledCount = c.counts != null ? c.counts : 0;
    const pct          = c.max_students ? Math.round(enrolledCount / c.max_students * 100) : 0;
    const capClass     = pct >= 100 ? 'full' : pct >= 80 ? 'warn' : '';


    let checkboxCell = '';
    let lastCell = '';

    if (USER_ROLE === 'ADMIN') {
      checkboxCell = `<td style="text-align:center;">
        <input type="checkbox" class="row-check" value="\${c.course_no}"
               onchange="onRowCheck(this, \${c.course_no})">
      </td>`;
      lastCell = `<td style="text-align:center;">\${statusBadgeHtml(c.status)}</td>
        <td style="text-align:center;">
          <button class="btn-action status" onclick="editCourse(\${c.course_no})" title="강의 수정">✏️ 수정</button>
        </td>`;
    } else if (USER_ROLE === 'STUDENT') {
      const applied   = enrolledSet.has(c.course_no);
      const isFull    = pct >= 100;
      const conflict  = !applied && !isFull && hasTimeConflict(c);
      const btnClass  = applied ? 'cancel' : isFull ? 'full' : conflict ? 'conflict' : 'apply';
      const btnText   = applied ? '신청취소' : isFull ? '마감' : conflict ? '수강불가' : '수강신청';
      const btnAction = applied ? `cancelEnroll(\${c.course_no})`
                      : (!isFull && !conflict) ? `applyEnroll(\${c.course_no})` : '';
      lastCell = `<td style="text-align:center;">
        <button class="btn-enroll \${btnClass}" \${!btnAction ? 'disabled' : ''} onclick="\${btnAction}">\${btnText}</button>
      </td>`;
    }
    // PROFESSOR: 마지막 컬럼 없음 (읽기 전용)

    return `<tr>
      \${checkboxCell}
      <td style="text-align:center;color:var(--gray-400);">\${(currentPage-1)*PAGE_SIZE + i + 1}</td>
      <td>
        <div style="font-weight:600;color:var(--gray-900);font-size:.84rem;"
          class="\${c.curriculum_pdf ? 'pdf-link' : ''}"
          data-semester="\${c.semester || ''}"
          data-pdf="\${c.curriculum_pdf || ''}">
          \${escHtml(c.course_name)}
        </div>
        <div style="font-size:.72rem;color:var(--gray-400);margin-top:.1rem;">\${escHtml(c.professor_name || '')}</div>
      </td>
      <td><span class="type-badge \${typeClass(c.course_type)}">\${typeLabel(c.course_type)}</span></td>
      <td style="text-align:center;font-weight:700;color:var(--gray-700);">\${credits}</td>
      <td style="text-align:center;">\${c.day_of_week || '-'}</td>
      <td style="font-size:.78rem;">\${formatTime(c.start_time)} ~ \${formatTime(c.end_time)}</td>
      <td style="font-size:.78rem;color:var(--gray-500);">\${c.room_info || '-'}</td>
      <td>
        <div class="capacity-bar">
          <div class="cap-track"><div class="cap-fill \${capClass}" style="width:\${pct}%"></div></div>
          <span>\${enrolledCount}/\${c.max_students != null ? c.max_students : '-'}</span>
        </div>
      </td>
      \${lastCell}
    </tr>`;
  }).join('');
}

/* ================================================================
   내 수강목록 / 내 강의 로드
   STUDENT  : GET /enrollment/mine           → { courses:[...] }
   PROFESSOR: GET /enrollment/my-courses     → { courses:[...] }  (status 포함)
================================================================ */
function loadMyCourses() {
  showLoading('loadingMine', true);
  const endpoint = USER_ROLE === 'PROFESSOR'
    ? CTX_PATH + '/enrollment/my-courses?semester=' + CURRENT_SEMESTER
    : CTX_PATH + '/enrollment/mine?semester=' + CURRENT_SEMESTER;

  return fetch(endpoint, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
    .then(r => r.json())
    .then(data => {
      myCourses = data.courses || [];
      if (USER_ROLE === 'STUDENT') {
        enrolledSet = new Set(myCourses.map(c => c.course_no));
        updateCreditSummary();
      }
      document.getElementById('countMine').textContent = myCourses.length;
      renderMineTable();
    })
    .catch(() => {
      myCourses = USER_ROLE === 'PROFESSOR' ? MOCK_PROF_COURSES : MOCK_MINE;
      if (USER_ROLE === 'STUDENT') {
        enrolledSet = new Set(myCourses.map(c => c.course_no));
        updateCreditSummary();
      }
      document.getElementById('countMine').textContent = myCourses.length;
      renderMineTable();
    })
    .finally(() => showLoading('loadingMine', false));
}

/* ================================================================
   내 수강목록 테이블 렌더링 (역할별 분기)
================================================================ */
function renderMineTable() {
  const tbody = document.getElementById('mineCourseBody');
  const colspan = USER_ROLE === 'PROFESSOR' ? 9 : 9;
  if (!myCourses.length) {
    tbody.innerHTML = `<tr><td colspan="\${colspan}">
      <div class="empty-state">
        <div class="empty-icon">📋</div>
        <div class="empty-text">\${USER_ROLE == 'PROFESSOR' ? '담당 강의가 없습니다' : '신청한 수강이 없습니다'}</div>
        <div class="empty-sub">\${USER_ROLE == 'PROFESSOR' ? '배정된 강의가 표시됩니다' : '전체 강의 탭에서 수강신청을 해보세요'}</div>
      </div></td></tr>`;
    return;
  }

  tbody.innerHTML = myCourses.map((c, i) => {
    const statusBadge = statusBadgeHtml(c.status);
    let lastCell = '';
    if (USER_ROLE === 'STUDENT') {
      lastCell = `<td style="text-align:center;">
        <button class="btn-enroll cancel" onclick="cancelEnroll(\${c.course_no})">취소</button>
      </td>`;
    } else if (USER_ROLE === 'PROFESSOR') {
      // 교수: 수강인원 표시 + 수정/삭제 버튼
      const enrolled = c.counts != null ? c.counts : 0;
      const max = c.max_students != null ? c.max_students : '-';
      lastCell = '<td style="text-align:center;font-size:.82rem;font-weight:600;color:var(--gray-700);">' + enrolled + ' / ' + max + '</td>'
        + '<td style="text-align:center;">'
        + '<div style="display:flex;align-items:center;justify-content:center;gap:.35rem;">'
        + '<button class="btn-action status" onclick="editCourse(' + c.course_no + ')" title="강의 수정">✏️ 수정</button>'
        + '<button class="btn-action delete" onclick="deleteCourse(' + c.course_no + ')" title="강의 삭제">🗑 삭제</button>'
        + '</div>'
        + '</td>';
    }
    return `<tr>
      <td style="text-align:center;color:var(--gray-400);">\${i+1}</td>
      <td>
        <div style="font-weight:600;color:var(--gray-900);font-size:.84rem;"
          class="\${c.curriculum_pdf ? 'pdf-link' : ''}"
          data-semester="\${c.semester || ''}"
          data-pdf="\${c.curriculum_pdf || ''}">
          \${escHtml(c.course_name)}
        </div>
        <div style="font-size:.72rem;color:var(--gray-400);margin-top:.1rem;">\${escHtml(c.professor_name || '')}</div>
      </td>
      <td><span class="type-badge \${typeClass(c.course_type)}">\${typeLabel(c.course_type)}</span></td>
      <td style="text-align:center;font-weight:700;">\${c.credits != null ? c.credits : 3}</td>
      <td style="text-align:center;">\${c.day_of_week || '-'}</td>
      <td style="font-size:.78rem;">\${formatTime(c.start_time)} ~ \${formatTime(c.end_time)}</td>
      <td style="font-size:.78rem;color:var(--gray-500);">\${c.room_info || '-'}</td>
      \${USER_ROLE === 'STUDENT' ? '' : `<td style="text-align:center;">\${statusBadge}</td>`}
      \${lastCell}
    </tr>`;
  }).join('');
}

/* ================================================================
   학점 요약 업데이트 (STUDENT only)
================================================================ */
function updateCreditSummary() {
  const total = myCourses.reduce((s, c) => s + (c.credits != null ? c.credits : 3), 0);
  document.getElementById('enrolledCredits') && (document.getElementById('enrolledCredits').textContent = total);
  document.getElementById('enrolledCount')   && (document.getElementById('enrolledCount').textContent   = myCourses.length);
  document.getElementById('totalCreditsDisplay') && (document.getElementById('totalCreditsDisplay').textContent = total);
}

/* ================================================================
   시간 충돌 검사 (STUDENT only)
   이미 신청한 myCourses와 요일·시간 겹침 여부 반환
   - 같은 요일에 [sh, eh) ∩ [msh, meh) ≠ ∅ 이면 충돌
================================================================ */
function hasTimeConflict(newCourse) {
  if (USER_ROLE !== 'STUDENT') return false;
  const newDays = parseDays(newCourse.day_of_week);
  const nsh = parseHour(newCourse.start_time);
  const neh = parseHour(newCourse.end_time);
  if (nsh < 0 || neh < 0) return false;

  return myCourses.some(c => {
    if (c.course_no === newCourse.course_no) return false; // 자기 자신 제외
    const mDays = parseDays(c.day_of_week);
    const msh   = parseHour(c.start_time);
    const meh   = parseHour(c.end_time);
    const dayOverlap = newDays.some(d => mDays.includes(d));
    const timeOverlap = nsh < meh && neh > msh;
    return dayOverlap && timeOverlap;
  }); 
}
function parseDays(str) {
  return str ? str.split(',').map(d => d.replace(/요일/, '').trim()) : [];
}
function parseHour(t) {
  return t ? parseInt(t.split(':')[0]) : -1;
}

/* ================================================================
   수강 신청 / 취소 (STUDENT only)
================================================================ */
function applyEnroll(courseNo) {
  if (!confirm('수강신청 하시겠습니까?')) return;
  fetch(CTX_PATH + '/enrollment/apply', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
    body: JSON.stringify({ courseNo })
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      showToast('✅ 수강신청이 완료되었습니다.', 'green');
      loadMyCourses().finally(() => loadAllCourses());
    } else {
      showToast('❌ ' + (data.message || '신청에 실패했습니다.'), 'red');
    }
  })
  .catch(() => showToast('⚠️ 서버 오류가 발생했습니다.', 'red'));
}

/* ================================================================
   PROFESSOR: 강의 수정 / 삭제
================================================================ */
function editCourse(courseNo) {
  location.href = CTX_PATH + '/enrollment/courseUpdate?courseNo=' + courseNo;
}

function deleteCourse(courseNo) {
  const course = myCourses.find(c => c.course_no === courseNo);
  const courseName = course ? course.course_name : '';
  if (!confirm('"' + courseName + '" 강의를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) return;
  fetch(CTX_PATH + '/enrollment/courseDelete', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
    body: JSON.stringify({ courseNos: [courseNo] })
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      showToast('🗑 강의가 삭제되었습니다.', 'red');
      loadMyCourses().finally(() => loadAllCourses());
    } else {
      showToast('❌ ' + (data.message || '삭제에 실패했습니다.'), 'red');
    }
  })
  .catch(() => showToast('⚠️ 서버 오류가 발생했습니다.', 'red'));
}

function cancelEnroll(courseNo) {
  if (!confirm('수강신청을 취소하시겠습니까?')) return;
  fetch(CTX_PATH + '/enrollment/cancel', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
    body: JSON.stringify({ courseNo })
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      showToast('🗑 수강신청이 취소되었습니다.', 'yellow');
      loadMyCourses().finally(() => loadAllCourses());
    } else {
      showToast('❌ ' + (data.message || '취소에 실패했습니다.'), 'red');
    }
  })
  .catch(() => showToast('⚠️ 서버 오류가 발생했습니다.', 'red'));
}

/* ================================================================
   ADMIN: 체크박스 처리
================================================================ */
function toggleAllCheck(masterCb) {
  document.querySelectorAll('#allCourseBody .row-check').forEach(cb => {
    cb.checked = masterCb.checked;
    const no = parseInt(cb.value);
    masterCb.checked ? selectedNos.add(no) : selectedNos.delete(no);
  });
  updateBulkButtons();
}

function onRowCheck(cb, courseNo) {
  cb.checked ? selectedNos.add(courseNo) : selectedNos.delete(courseNo);
  // 전체 체크 상태 동기화
  const allCbs = document.querySelectorAll('#allCourseBody .row-check');
  const allChecked = [...allCbs].every(c => c.checked);
  const masterCb = document.getElementById('checkAll');
  if (masterCb) masterCb.checked = allChecked && allCbs.length > 0;
  updateBulkButtons();
}

function updateBulkButtons() {
  const n = selectedNos.size;
  const el = document.getElementById('bulkCount');
  if (el) el.textContent = n;
  const btnDel  = document.getElementById('btnBulkDelete');
  const btnStat = document.getElementById('btnBulkStatus');
  if (btnDel)  btnDel.disabled  = n === 0;
  if (btnStat) btnStat.disabled = n === 0;
}

/* ================================================================
   ADMIN: 일괄 삭제
   POST /admin/course/delete  body: { courseNos: [...] }
================================================================ */
function bulkDelete() {
  if (selectedNos.size === 0) return;
  if (!confirm(`선택한 \${selectedNos.size}개 강의를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.`)) return;

  fetch(CTX_PATH + '/enrollment/courseDelete', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
    body: JSON.stringify({ courseNos: [...selectedNos] })
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      showToast(`🗑 \${selectedNos.size}개 강의가 삭제되었습니다.`, 'red');
      selectedNos.clear();
      updateBulkButtons();
      loadAllCourses();
    } else {
      showToast('❌ ' + (data.message || '삭제에 실패했습니다.'), 'red');
    }
  })
  .catch(() => showToast('⚠️ 서버 오류가 발생했습니다.', 'red'));
}

/* ================================================================
   ADMIN: 상태 변경 모달
   POST /admin/course/status  body: { courseNos: [...], status: 'ACTIVE'|... }
================================================================ */
function openStatusModal() {
  if (selectedNos.size === 0) return;
  document.getElementById('statusModalOverlay').classList.add('active');
}
function closeStatusModal() {
  document.getElementById('statusModalOverlay').classList.remove('active');
  document.querySelectorAll('input[name="statusChoice"]').forEach(r => r.checked = false);
}
function confirmStatusChange() {
  const chosen = document.querySelector('input[name="statusChoice"]:checked');
  if (!chosen) { showToast('변경할 상태를 선택해주세요.', 'yellow'); return; }

  fetch(CTX_PATH + '/enrollment/status', { 
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
    body: JSON.stringify({ courseNos: [...selectedNos], status: chosen.value })
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      showToast(`✅ \${selectedNos.size}개 강의 상태가 변경되었습니다.`, 'green');
      closeStatusModal();
      selectedNos.clear();
      updateBulkButtons();
      loadAllCourses();
    } else {
      showToast('❌ ' + (data.message || '상태 변경에 실패했습니다.'), 'red');
    }
  })
  .catch(() => showToast('⚠️ 서버 오류가 발생했습니다.', 'red'));
}

/* ================================================================
   시간표 렌더링
   STUDENT  : myCourses 전체 사용
   PROFESSOR: myCourses 중 status === 'ACTIVE'인 강의만 표시
   09:00 ~ 20:00, 월~금
================================================================ */
function renderTimetable() {
  const body = document.getElementById('timetableBody');
  body.innerHTML = '';

  const displayCourses = myCourses;

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

      const course = displayCourses.find(c => {
        const days = parseDays(c.day_of_week);
        if (!days.includes(Object.keys(DAY_IDX)[d])) return false;
        const sh = parseHour(c.start_time);
        const eh = parseHour(c.end_time);
        return sh <= h && h < eh;
      });

      if (course) {
        const block = document.createElement('div');
        const statusClass = { APPROVED: 'status-approved', PENDING: 'status-pending' }[course.status] || '';
        block.className = 'tt-course-block ' + statusClass;
        block.innerHTML = `
          <div>\${escHtml(course.course_name)}</div>
          <div class="tt-room">\${escHtml(course.room_info || '')}</div>`;
        cell.appendChild(block);
      }
      row.appendChild(cell);
    }
    body.appendChild(row);
  }

  if (!displayCourses.length) {
    body.innerHTML = `<div class="empty-state">
      <div class="empty-icon">🗓</div>
      <div class="empty-text">\${USER_ROLE === 'PROFESSOR' ? '담당 강의가 없습니다' : '신청된 수강이 없습니다'}</div>
      <div class="empty-sub">\${USER_ROLE === 'PROFESSOR' ? '배정된 강의가 시간표에 표시됩니다' : '수강신청 후 시간표가 표시됩니다'}</div>
    </div>`;
  }
}

/* ================================================================
   페이지네이션
================================================================ */
function renderPagination(totalCount) {
  const pg = document.getElementById('allPagination');
  totalPages = Math.ceil(totalCount / PAGE_SIZE) || 1;
  let html = `<button class="page-btn" onclick="loadAllCourses(\${currentPage-1})" \${currentPage==1?'disabled':''}>‹</button>`;
  const start = Math.max(1, currentPage - 2);
  const end   = Math.min(totalPages, start + 4);
  for (let p = start; p <= end; p++) {
    html += `<button class="page-btn \${p==currentPage?'active':''}" onclick="loadAllCourses(\${p})">\${p}</button>`;
  }
  html += `<button class="page-btn" onclick="loadAllCourses(\${currentPage+1})" \${currentPage==totalPages?'disabled':''}>›</button>`;
  pg.innerHTML = html;
}

/* ================================================================
   필터 / 검색
================================================================ */
function resetFilters() {
  document.getElementById('filterType').value    = '';
  document.getElementById('filterCredits').value = '';
  document.getElementById('searchKeyword').value = '';
  const fs = document.getElementById('filterStatus');
  if (fs) fs.value = '';
  currentPage = 1;
  loadAllCourses();
}

/* ================================================================
   유틸 함수
================================================================ */
function typeLabel(t) {
  return { MAJOR_REQUIRED:'전공필수', MAJOR_ELECTIVE:'전공선택',
           GENERAL_REQUIRED:'교양필수', GENERAL_ELECTIVE:'교양선택',
           FREE_ELECTIVE:'자율선택' }[t] || t;
}
function typeClass(t) {
  return { MAJOR_REQUIRED:'type-major-req', MAJOR_ELECTIVE:'type-major-elec',
           GENERAL_REQUIRED:'type-gen-req', GENERAL_ELECTIVE:'type-gen-elec',
           FREE_ELECTIVE:'type-free' }[t] || 'type-free';
}
function statusBadgeHtml(s) {
  const map = {
    PENDING:  ['badge-yellow', '대기'],
    APPROVED: ['badge-green',  '승인']
  };
  const [cls, label] = map[s] || ['badge-gray', s || '-'];
  return `<span class="badge \${cls}">\${label}</span>`;
}
function formatTime(t) { return t ? t.substring(0, 5) : '-'; }
function escHtml(s) {
  return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
function showLoading(id, show) {
  const el = document.getElementById(id);
  if (el) el.classList.toggle('active', show);
}
function showToast(msg, color) {
  const colors = { green:'#15803d', red:'#b91c1c', yellow:'#a16207' };
  const t = document.createElement('div');
  t.textContent = msg;
  Object.assign(t.style, {
    position:'fixed', bottom:'1.5rem', right:'1.5rem', zIndex:9999,
    background: color==='green'?'#f0fdf4': color==='red'?'#fff1f2':'#fffbeb',
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
   개발용 목업 데이터 — 서버 연동 후 제거
================================================================ */
const MOCK_COURSES = [
  { course_no:1, course_name:'고급 영어 회화', professor_name:'김영어', course_type:'GENERAL_ELECTIVE',
    credits:3, day_of_week:'월', start_time:'09:00', end_time:'12:00', room_info:'A동 201',
    max_students:30, enrolled:25, status:'ACTIVE', curriculum_pdf:null },
  { course_no:2, course_name:'데이터베이스 설계', professor_name:'이컴공', course_type:'MAJOR_REQUIRED',
    credits:3, day_of_week:'화', start_time:'13:00', end_time:'16:00', room_info:'공학관 305',
    max_students:35, enrolled:35, status:'ACTIVE', curriculum_pdf:null },
  { course_no:3, course_name:'경제학 원론', professor_name:'박경제', course_type:'GENERAL_REQUIRED',
    credits:2, day_of_week:'수', start_time:'10:00', end_time:'12:00', room_info:'본관 102',
    max_students:50, enrolled:30, status:'PENDING', curriculum_pdf:null },
  { course_no:4, course_name:'알고리즘', professor_name:'최알고', course_type:'MAJOR_ELECTIVE',
    credits:3, day_of_week:'목', start_time:'14:00', end_time:'17:00', room_info:'공학관 201',
    max_students:40, enrolled:38, status:'INACTIVE', curriculum_pdf:null },
];
const MOCK_MINE = [
  { course_no:1, course_name:'고급 영어 회화', professor_name:'김영어', course_type:'GENERAL_ELECTIVE',
    credits:3, day_of_week:'월', start_time:'09:00', end_time:'12:00', room_info:'A동 201', status:'APPROVED' },
  { course_no:3, course_name:'경제학 원론', professor_name:'박경제', course_type:'GENERAL_REQUIRED',
    credits:2, day_of_week:'수', start_time:'10:00', end_time:'12:00', room_info:'본관 102', status:'APPLIED' },
];
const MOCK_PROF_COURSES = [
  { course_no:10, course_name:'운영체제', professor_name:'홍길동', course_type:'MAJOR_REQUIRED',
    credits:3, day_of_week:'월,수', start_time:'10:00', end_time:'12:00', room_info:'공학관 401',
    max_students:40, enrolled:32, status:'ACTIVE' },
  { course_no:11, course_name:'컴파일러', professor_name:'홍길동', course_type:'MAJOR_ELECTIVE',
    credits:3, day_of_week:'금', start_time:'13:00', end_time:'16:00', room_info:'공학관 302',
    max_students:30, enrolled:18, status:'PENDING' },
];

/* ================================================================
   초기 로드
   STUDENT  : 내 수강 목록 먼저 → enrolledSet 채운 후 전체 목록 (시간충돌 버튼 정확히 표시)
   PROFESSOR: 전체 목록 + 내 강의 병렬 로드
   ADMIN    : 전체 목록만
================================================================ */
window.addEventListener('DOMContentLoaded', () => {
  if (USER_ROLE === 'STUDENT') {
    // enrolledSet이 채워진 후 전체 목록 로드 → 신청/취소/충돌 버튼 정확히 표시
    loadMyCourses().finally(() => loadAllCourses());
  } else if (USER_ROLE === 'PROFESSOR') {
    loadAllCourses();
    loadMyCourses();
  } else {
    // ADMIN
    loadAllCourses();
  }
});
</script>
</body>
</html>
