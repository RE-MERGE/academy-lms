<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>강의 수정 — re-merge LMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
  <style>
    .create-page {
      display: flex;
      flex-direction: column; 
      max-width: 900px;
      margin: 0 auto;
    } 
    .page-header { display: flex; align-items: center; margin-bottom: 1.6rem; }
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
    .form-card {
      background: var(--white);
      border: 1px solid var(--gray-200);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-sm);
      overflow: hidden;
    }
    .form-row {
      display: flex;
      align-items: stretch;
      border-bottom: 1px solid var(--gray-100);
    }
    .form-row:last-child { border-bottom: none; }
    .form-label {
      width: 130px;
      min-width: 130px;
      padding: 1rem 1.2rem;
      background: var(--gray-50);
      font-size: .82rem;
      font-weight: 700;
      color: var(--gray-600);
      border-right: 1px solid var(--gray-100);
      display: flex;
      align-items: center;
    }
    .form-field {
      flex: 1;
      padding: .85rem 1.2rem;
      min-width: 0;
    }
    .form-input, .form-select {
      padding: .5rem .8rem;
      border: 1.5px solid var(--gray-200);
      border-radius: var(--radius-md);
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .85rem;
      color: var(--gray-800);
      background: var(--white);
      transition: border-color .16s, box-shadow .16s;
      box-sizing: border-box;
    }
    .form-input:focus, .form-select:focus {
      outline: none;
      border-color: var(--primary-light);
      box-shadow: 0 0 0 3px rgba(59,130,246,.12);
    }
    .form-input { width: 100%; max-width: 400px; }
    .form-select {
      appearance: none; -webkit-appearance: none;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'%3E%3Cpath d='M1 1l4 4 4-4' stroke='%239ca3af' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: right .75rem center;
      padding-right: 2.2rem;
      cursor: pointer;
    }
    .inline-group { display: flex; align-items: center; gap: .8rem; flex-wrap: wrap; }
    .inline-label { font-size: .78rem; font-weight: 700; color: var(--gray-500); white-space: nowrap; }
    .pdf-upload-label {
      display: inline-flex; align-items: center; gap: .4rem;
      padding: .45rem 1rem;
      background: var(--primary-pale);
      border: 1.5px solid var(--primary-tint);
      border-radius: var(--radius-md);
      font-size: .82rem; font-weight: 600; color: var(--primary);
      cursor: pointer; transition: all .16s;
    }
    .pdf-upload-label:hover { background: var(--primary-tint); }
    .pdf-upload-label input { display: none; }
    .pdf-filename { font-size: .8rem; color: var(--gray-400); }
    .pdf-filename.has-file { color: var(--primary); font-weight: 600; }

    /* ── 시간표 ── */
    .tt-grid {
      display: grid;
      grid-template-columns: 56px repeat(5, 1fr);
      gap: 3px;
      width: 100%;
    }
    .tt-head {
      padding: .45rem .2rem;
      text-align: center;
      font-size: .72rem; font-weight: 700;
      color: var(--gray-500); letter-spacing: .05em;
    }
    .tt-period {
      display: flex; align-items: center; justify-content: center;
      background: var(--primary); color: var(--white);
      font-size: .66rem; font-weight: 700;
      border-radius: var(--radius-sm);
    }
    .tt-cell {
      height: 46px;
      border-radius: var(--radius-sm);
      background: var(--gray-100);
      border: 1.5px solid transparent;
      cursor: pointer;
      transition: all .15s;
      position: relative;
    }
    .tt-cell:hover:not(.tt-blocked) { background: var(--primary-pale); border-color: var(--primary-tint); }
    .tt-cell.tt-selected { background: var(--primary); border-color: var(--primary); }
    .tt-cell.tt-selected::after {
      content: '개설';
      position: absolute; inset: 0;
      display: flex; align-items: center; justify-content: center;
      font-size: .62rem; font-weight: 700; color: var(--white);
    }
    .tt-cell.tt-blocked { background: #fee2e2; border-color: #fecdd3; cursor: not-allowed; }
    .tt-cell.tt-blocked::after {
      content: '사용중';
      position: absolute; inset: 0;
      display: flex; align-items: center; justify-content: center;
      font-size: .58rem; font-weight: 700; color: #b91c1c;
    }
    /* 내 강의 시간 충돌 */
    .tt-cell.tt-my-blocked { background: #fef9c3; border-color: #fde68a; cursor: not-allowed; }
    .tt-cell.tt-my-blocked::after {
      content: '내강의';
      position: absolute; inset: 0;
      display: flex; align-items: center; justify-content: center;
      font-size: .58rem; font-weight: 700; color: #92400e;
    }
    .legend { display: flex; gap: 1rem; margin-bottom: .7rem; font-size: .75rem; }
    .legend-item { display: flex; align-items: center; gap: .35rem; color: var(--gray-500); }
    .legend-dot { width: 14px; height: 14px; border-radius: 3px; }
    .legend-dot.avail    { background: var(--gray-100); border: 1.5px solid var(--gray-200); }
    .legend-dot.select   { background: var(--primary); }
    .legend-dot.block    { background: #fee2e2; border: 1.5px solid #fecdd3; }
    .legend-dot.myblock  { background: #fef9c3; border: 1.5px solid #fde68a; }
    .selected-summary { margin-top: .8rem; font-size: .8rem; color: var(--gray-500); min-height: 1.6rem; }
    .selected-summary .tag {
      display: inline-flex;
      background: var(--primary-pale); border: 1px solid var(--primary-tint);
      border-radius: 999px; padding: .15rem .65rem;
      font-size: .75rem; font-weight: 600; color: var(--primary);
      margin: .15rem .2rem 0 0;
    }
    .hint { font-size: .74rem; color: var(--gray-400); margin-top: .35rem; }

    /* 하단 버튼 */
    .form-actions {
      display: flex; justify-content: flex-end; gap: .8rem;
      padding: 1.1rem 1.2rem;
      border-top: 1px solid var(--gray-100);
    }
    .btn-submit {
      padding: .6rem 1.8rem; background: var(--primary); color: var(--white);
      border: none; border-radius: 999px;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .88rem; font-weight: 700; cursor: pointer;
      transition: all .16s; box-shadow: 0 2px 8px rgba(29,78,216,.2);
    }
    .btn-submit:hover { background: var(--primary-mid); transform: translateY(-1px); }
    .btn-submit:disabled { opacity: .5; cursor: not-allowed; transform: none; }
    .btn-delete {
      padding: .6rem 1.8rem; background: #fff1f2; color: #b91c1c;
      border: 1px solid #fecdd3; border-radius: 999px;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .88rem; font-weight: 700; cursor: pointer; transition: all .16s;
    }
    .btn-delete:hover { background: #fee2e2; }
    .btn-cancel {
      padding: .6rem 1.8rem; background: #fff1f2; color: #b91c1c;
      border: 1px solid #fecdd3; border-radius: 999px;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .88rem; font-weight: 700; cursor: pointer; transition: all .16s;
    }
    .btn-cancel:hover { background: #fee2e2; }
  </style>
</head>
<body>
<div class="layout-root">
  <main class="main-content" style="overflow-y:auto;">
    <div class="create-page">

      <div class="page-header">
        <div class="page-title">
          <div class="page-title-icon">✏️</div>
          강의 수정
        </div>
      </div>

      <div class="form-card">

        <%-- 강의 번호 (수정용 hidden) --%>
        <input type="hidden" id="courseNo" value="${param.courseNo}">

        <%-- 교수 사번: ADMIN만 표시 --%>
        <c:if test="${sessionUser.role.toString() == 'ADMIN'}">
          <div class="form-row">
            <div class="form-label">교수 사번</div>
            <div class="form-field">
              <div style="display:flex; align-items:center; gap:.6rem; flex-wrap:wrap;">
                <input type="text" class="form-input" id="userCode" placeholder="교수 사번을 입력하세요" style="max-width:200px;">
                <button type="button" onclick="verifyProfessor()"
                  style="padding:.5rem 1rem; background:var(--primary-pale); border:1.5px solid var(--primary-tint);
                         border-radius:var(--radius-md); font-size:.82rem; font-weight:600; color:var(--primary);
                         cursor:pointer; white-space:nowrap;">🔍 교수 검증</button>
                <span id="professorNameDisplay" style="font-size:.84rem; font-weight:700; color:#15803d; display:none;"></span>
              </div>
              <div class="hint">변경 시 검증 후 해당 교수로 담당 교수가 변경됩니다</div>
            </div>
          </div>
        </c:if>

        <%-- 개설 과목명 --%>
        <div class="form-row">
          <div class="form-label">개설 과목명</div>
          <div class="form-field">
            <input type="text" class="form-input" id="courseName" placeholder="강의명을 입력하세요">
          </div>
        </div>

        <%-- 강의 유형 --%>
        <div class="form-row">
          <div class="form-label">강의 유형</div>
          <div class="form-field">
            <select class="form-select" id="courseType" style="width:200px;">
              <option value="">유형 선택</option>
              <option value="MAJOR_REQUIRED">전공필수</option>
              <option value="MAJOR_ELECTIVE">전공선택</option>
              <option value="GENERAL_REQUIRED">교양필수</option>
              <option value="GENERAL_ELECTIVE">교양선택</option>
              <option value="FREE_ELECTIVE">일반선택</option>
            </select>
          </div>
        </div>

        <%-- 학점 --%>
        <div class="form-row">
          <div class="form-label">학점</div>
          <div class="form-field">
            <select class="form-select" id="credits" style="width:120px;">
              <option value="1">1학점</option>
              <option value="2">2학점</option>
              <option value="3" selected>3학점</option>
            </select>
          </div>
        </div>

        <%-- 강의 내용 (PDF) --%>
        <div class="form-row">
          <div class="form-label">강의 내용</div>
          <div class="form-field">
            <div style="display:flex; align-items:center; gap:.8rem; flex-wrap:wrap;">
              <label class="pdf-upload-label">
                📁 PDF 첨부파일 (강의 커리큘럼)
                <input type="file" id="curriculumPdf" accept=".pdf" onchange="updateFileName(this)">
              </label>
              <span class="pdf-filename" id="pdfFileName">선택된 파일 없음</span>
            </div>
            <div class="hint">강의 커리큘럼 PDF를 첨부해주세요 (선택사항)</div>
          </div>
        </div>

        <%-- 시작 학기 + 신청 교실 --%>
        <div class="form-row">
          <div class="form-label">시작 학기</div>
          <div class="form-field">
            <div class="inline-group">
              <span style="font-size:.88rem; font-weight:700; color:var(--gray-700);">${currentSemester}</span>
              <input type="hidden" id="semester" value="${currentSemester}">
              <span class="inline-label">신청 교실</span>
              <select class="form-select" id="roomInfo" style="width:110px;" onchange="loadBlockedSlots()">
                <option value="101호" selected>101호</option>
                <option value="102호">102호</option>
                <option value="103호">103호</option>
                <option value="201호">201호</option>
                <option value="202호">202호</option>
                <option value="203호">203호</option>
                <option value="301호">301호</option>
                <option value="302호">302호</option>
                <option value="303호">303호</option>
              </select>
            </div>
          </div>
        </div>

        <%-- 요일 및 시간 --%>
        <div class="form-row">
          <div class="form-label" style="align-items:flex-start; padding-top:1rem;">요일 및 시간</div>
          <div class="form-field">
            <div class="legend">
              <div class="legend-item"><div class="legend-dot avail"></div> 선택 가능</div>
              <div class="legend-item"><div class="legend-dot select"></div> 개설 시간</div>
              <div class="legend-item"><div class="legend-dot block"></div> 사용 중</div>
              <div class="legend-item"><div class="legend-dot myblock"></div> 내 강의</div>
            </div>
            <div class="tt-grid" id="ttGrid"></div>
            <div class="selected-summary" id="selectedSummary">선택된 시간이 없습니다.</div>
            <div class="hint">교실을 변경하면 해당 교실의 사용 중인 시간이 표시됩니다</div>
          </div>
        </div>

        <%-- 하단 버튼 --%>
        <div class="form-actions">
          <button class="btn-cancel" onclick="history.back()">취소</button>
          <button class="btn-submit" id="submitBtn" onclick="submitForm()">수정 완료</button>
        </div>

      </div><%-- /form-card --%>
    </div>
  </main>
</div>

<script>
var CTX_PATH = '<%=request.getContextPath()%>';
var COURSE_NO = parseInt('${param.courseNo}') || 0;

var PERIODS = [
  { label:'1교시', start:'09:00', end:'10:00' },
  { label:'2교시', start:'10:00', end:'11:00' },
  { label:'3교시', start:'11:00', end:'12:00' },
  { label:'4교시', start:'12:00', end:'13:00' },
  { label:'5교시', start:'13:00', end:'14:00' },
  { label:'6교시', start:'14:00', end:'15:00' },
  { label:'7교시', start:'15:00', end:'16:00' },
  { label:'8교시', start:'16:00', end:'17:00' },
  { label:'9교시', start:'17:00', end:'18:00' }
];
var DAYS = ['월','화','수','목','금'];
var selectedSlots  = [];
var blockedSlots   = [];
var myBlockedSlots = [];
var originalCourseNo = COURSE_NO;
var professorVerified = false;
var verifiedProfessorNo = 0;
var currentCourseData = null; /* 복원용 강의 데이터 보관 */

/* ================================================================
   기존 강의 데이터 로드 (수정 시 폼 pre-fill)
   GET /enrollment/courseDetail?courseNo=N
   응답: { course_no, course_name, course_type, credits, semester,
           room_info, day_of_week, start_time, end_time, curriculum_pdf, professor_no }
================================================================ */
function loadCourseData() {
  if (!COURSE_NO) { alert('강의 번호가 없습니다.'); history.back(); return; }

  fetch(CTX_PATH + '/enrollment/courseDetail?courseNo=' + COURSE_NO, {
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    console.log('[courseDetail 응답]', JSON.stringify(data)); // 디버그
    var c = data.course || data; /* 서버 응답 구조에 맞게 */

    /* 폼 필드 채우기 */
    if (document.getElementById('courseName'))  document.getElementById('courseName').value  = c.course_name  || '';
    if (document.getElementById('courseType'))  document.getElementById('courseType').value  = c.course_type  || '';
    if (document.getElementById('credits'))     document.getElementById('credits').value     = c.credits      || 3;
    if (document.getElementById('semester'))    document.getElementById('semester').value    = c.semester     || '';
    /* ADMIN: professor_user_code는 data 최상위에 위치 (course 객체 밖) */
    if (document.getElementById('userCode')) {
      console.log('[userCode 세팅]', data.professor_user_code); // 디버그
      document.getElementById('userCode').value = data.professor_user_code || '';
      document.getElementById('userCode').dataset.original = data.professor_user_code || '';
    }

    var roomEl = document.getElementById('roomInfo');
    if (roomEl && c.room_info) {
      roomEl.value = c.room_info;
    }

    /* PDF 파일명 표시 */
    if (c.curriculum_pdf) {
      var el = document.getElementById('pdfFileName');
      el.textContent = c.curriculum_pdf;
      el.classList.add('has-file');
    }

    /* 학기 텍스트 표시 */
    var semesterDisplay = document.querySelector('.inline-group span[style]');
    if (semesterDisplay && c.semester) semesterDisplay.textContent = c.semester;

    currentCourseData = c;

    /* ADMIN: 기존 교수 자동 검증 후 blocked 로드 */
    if (document.getElementById('userCode') && data.professor_user_code) {
      var preCode = data.professor_user_code;
      fetch(CTX_PATH + '/enrollment/professor-verify?userCode=' + encodeURIComponent(preCode), {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
      })
      .then(function(r) { return r.json(); })
      .then(function(vd) {
        if (vd.success) {
          professorVerified = true;
          verifiedProfessorNo = vd.professorNo;
          var nameEl = document.getElementById('professorNameDisplay');
          if (nameEl) {
            var displayText = '✓ ' + vd.name + ' 교수';
            nameEl.textContent = displayText;
            nameEl.style.display = 'inline';
            /* 검증 실패 시 복원을 위해 원본 이름 저장 */
            nameEl.dataset.originalText = displayText;
          }
          /* 검증 실패 시 복원을 위해 원본 교수번호 저장 */
          var codeEl2 = document.getElementById('userCode');
          if (codeEl2) codeEl2.dataset.originalNo = vd.professorNo;
        }
        loadBlockedSlots(function() { restoreSlots(c.day_of_week, c.start_time, c.end_time); });
      })
      .catch(function() {
        loadBlockedSlots(function() { restoreSlots(c.day_of_week, c.start_time, c.end_time); });
      });
    } else {
      loadBlockedSlots(function() { restoreSlots(c.day_of_week, c.start_time, c.end_time); });
    }
  })
  .catch(function() {
    /* 서버 연동 전 개발 환경 — blocked만 로드 */
    loadBlockedSlots();
  });
}

/* ================================================================
   기존 요일/시간 슬롯 복원
================================================================ */
function restoreSlots(dayOfWeek, startTime, endTime) {
  if (!dayOfWeek || !startTime || !endTime) return;
  var day      = dayOfWeek.trim();
  var startStr = startTime.substring(0, 5);
  var endStr   = endTime.substring(0, 5);

  selectedSlots = [];
  PERIODS.forEach(function(p, pIdx) {
    if (p.start >= startStr && p.end <= endStr) {
      selectedSlots.push({ day: day, periodIdx: pIdx });
    }
  });
  renderGrid();
  updateSummary();
}

/* ================================================================
   blocked 슬롯 계산 헬퍼
================================================================ */
function calcBlockedSlots(data) {
  var result = [];
  (data || []).forEach(function(course) {
    /* 자기 자신 강의는 blocked에서 제외 */
    if (course.course_no && course.course_no === originalCourseNo) return;
    (course.day_of_week || '').split(',').forEach(function(day) {
      day = day.trim();
      if (!day) return;
      var startStr = (course.start_time || '').substring(0, 5);
      var endStr   = (course.end_time   || '').substring(0, 5);
      PERIODS.forEach(function(p, pIdx) {
        if (p.start >= startStr && p.end <= endStr) {
          result.push({ day: day, periodIdx: pIdx });
        }
      });
    });
  });
  return result;
}

/* ================================================================
   시간표 그리드 렌더링
================================================================ */
function renderGrid() {
  var grid = document.getElementById('ttGrid');
  grid.innerHTML = '';

  grid.appendChild(document.createElement('div')).className = 'tt-head';
  DAYS.forEach(function(day) {
    var h = document.createElement('div');
    h.className = 'tt-head';
    h.textContent = day;
    grid.appendChild(h);
  });

  PERIODS.forEach(function(period, pIdx) {
    var pCell = document.createElement('div');
    pCell.className = 'tt-period';
    pCell.textContent = period.label;
    grid.appendChild(pCell);

    DAYS.forEach(function(day) {
      var cell = document.createElement('div');
      cell.className = 'tt-cell';
      if (isMyBlockedSlot(day, pIdx)) {
        cell.classList.add('tt-my-blocked');
      } else if (isBlockedSlot(day, pIdx)) {
        cell.classList.add('tt-blocked');
      } else {
        if (isSelectedSlot(day, pIdx)) cell.classList.add('tt-selected');
        cell.addEventListener('click', function() { toggleSlot(day, pIdx); });
      }
      grid.appendChild(cell);
    });
  });
}

/* ================================================================
   슬롯 토글 (courseCreate와 동일 로직)
================================================================ */
function toggleSlot(day, pIdx) {
  var idx = selectedSlots.findIndex(function(s) { return s.day === day && s.periodIdx === pIdx; });

  if (idx >= 0) {
    /* 해제 — 끝 교시(min/max)만 해제 가능 */
    var pIdxList = selectedSlots.map(function(s) { return s.periodIdx; }).sort(function(a,b){return a-b;});
    if (pIdxList.length > 1 && pIdx !== pIdxList[0] && pIdx !== pIdxList[pIdxList.length-1]) {
      alert('연속된 시간 중 중간 교시는 해제할 수 없습니다.\n끝 교시부터 해제하세요.');
      return;
    }
    selectedSlots.splice(idx, 1);

  } else {
    /* 추가 */
    if (selectedSlots.length === 0) {
      /* 첫 선택 */
      if (isMyBlockedSlot(day, pIdx)) { alert('해당 시간에 이미 본인의 강의가 있습니다.'); return; }
      selectedSlots.push({ day: day, periodIdx: pIdx });

    } else {
      /* 같은 요일, 연속 교시만 허용 */
      var selectedDay = selectedSlots[0].day;
      if (day !== selectedDay) {
        alert('요일은 하나만 선택할 수 있습니다.\n다른 요일을 선택하려면 먼저 선택을 초기화하세요.');
        return;
      }
      var pIdxList2 = selectedSlots.map(function(s) { return s.periodIdx; }).sort(function(a,b){return a-b;});
      var dMin = pIdxList2[0], dMax = pIdxList2[pIdxList2.length-1];
      if (pIdx !== dMin - 1 && pIdx !== dMax + 1) {
        alert('연속된 교시만 선택할 수 있습니다.');
        return;
      }
      selectedSlots.push({ day: day, periodIdx: pIdx });
    }
  }
  renderGrid();
  updateSummary();
}

function isSelectedSlot(day, pIdx) { return selectedSlots.some(function(s) { return s.day === day && s.periodIdx === pIdx; }); }
function isBlockedSlot(day, pIdx)   { return blockedSlots.some(function(s) { return s.day === day && s.periodIdx === pIdx; }); }
function isMyBlockedSlot(day, pIdx) { return myBlockedSlots.some(function(s) { return s.day === day && s.periodIdx === pIdx; }); }

/* ================================================================
   선택 요약
================================================================ */
function updateSummary() {
  var el = document.getElementById('selectedSummary');
  if (!selectedSlots.length) { el.innerHTML = '선택된 시간이 없습니다.'; return; }
  var byDay = {};
  selectedSlots.forEach(function(s) { if (!byDay[s.day]) byDay[s.day] = []; byDay[s.day].push(s.periodIdx); });
  var html = '';
  DAYS.forEach(function(day) {
    if (!byDay[day]) return;
    byDay[day].sort().forEach(function(pIdx) {
      html += '<span class="tag">' + day + ' ' + PERIODS[pIdx].start + '~' + PERIODS[pIdx].end + '</span>';
    });
  });
  el.innerHTML = html;
}

/* ================================================================
   교실 blocked 로드 (콜백 지원 — 데이터 복원 순서 보장)
================================================================ */
function loadBlockedSlots(callback) {
  var room     = document.getElementById('roomInfo').value;
  var semester = document.getElementById('semester').value;
  var userCodeEl2 = document.getElementById('userCode');
  /* professor-blocked 조회는 professorNo가 필요하므로,
     ADMIN + 검증 완료 → verifiedProfessorNo(변경된 교수),
     ADMIN + 미검증   → 0 (skip),
     일반 교수 세션   → sessionUser.userNo */
  var professorNo = (userCodeEl2 && verifiedProfessorNo > 0)
    ? verifiedProfessorNo
    : (userCodeEl2 ? 0 : parseInt('${sessionUser.userNo}'));

  blockedSlots   = [];
  myBlockedSlots = [];
  if (!room) { renderGrid(); updateSummary(); if (callback) callback(); return; }

  var roomFetch = fetch(CTX_PATH + '/enrollment/blocked?room=' + encodeURIComponent(room)
      + '&semester=' + encodeURIComponent(semester), {
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  }).then(function(r) { return r.json(); });

  var myFetch = (professorNo > 0)
    ? fetch(CTX_PATH + '/enrollment/professor-blocked?professorNo=' + professorNo
          + '&semester=' + encodeURIComponent(semester), {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
      }).then(function(r) { return r.json(); })
    : Promise.resolve([]);

  Promise.all([roomFetch, myFetch])
    .then(function(results) {
      blockedSlots   = calcBlockedSlots(results[0]);
      myBlockedSlots = calcBlockedSlots(results[1]);
      renderGrid();
      updateSummary();
      if (callback) callback();
    })
    .catch(function() { blockedSlots = []; myBlockedSlots = []; renderGrid(); if (callback) callback(); });
}

/* ================================================================
   교수 검증 (ADMIN only)
================================================================ */
function verifyProfessor() {
  var codeEl = document.getElementById('userCode');
  var nameEl = document.getElementById('professorNameDisplay');
  var userCode = codeEl ? codeEl.value.trim() : '';
  if (!userCode) { alert('교수 사번을 입력하세요.'); return; }

  nameEl.style.display = 'none';
  nameEl.textContent = '';
  professorVerified = false;
  verifiedProfessorNo = 0;

  fetch(CTX_PATH + '/enrollment/professor-verify?userCode=' + encodeURIComponent(userCode), {
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    if (data.success) {
      professorVerified = true;
      verifiedProfessorNo = data.professorNo;
      nameEl.textContent = '✓ ' + data.name + ' 교수';
      nameEl.style.display = 'inline';
      /* 기존 시간 유지하면서 blocked만 갱신 */
      var saved = currentCourseData;
      loadBlockedSlots(function() {
        if (saved) restoreSlots(saved.day_of_week, saved.start_time, saved.end_time);
        else { renderGrid(); updateSummary(); }
      });
    } else {
      codeEl.value = codeEl.dataset.original || '';
      /* 이전 교수 검증 표시 복원 */
      if (nameEl.dataset.originalText) {
        nameEl.textContent = nameEl.dataset.originalText;
        nameEl.style.display = 'inline';
        professorVerified = true;
        verifiedProfessorNo = parseInt(codeEl.dataset.originalNo || '0');
      }
      alert(data.message || '교수 검증에 실패했습니다.');
    }
  })
  .catch(function() { alert('서버 오류가 발생했습니다.'); });
}

/* ================================================================
   파일명 표시
================================================================ */
function updateFileName(input) {
  var el = document.getElementById('pdfFileName');
  if (input.files && input.files[0]) {
    el.textContent = input.files[0].name;
    el.classList.add('has-file');
  } else {
    el.textContent = '선택된 파일 없음';
    el.classList.remove('has-file');
  }
}

/* ================================================================
   강의 삭제
================================================================ */
function deleteCourse() {
  if (!confirm('이 강의를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) return;
  var deleteBtn = document.getElementById('deleteBtn');
  deleteBtn.disabled = true;
  deleteBtn.textContent = '삭제 중...';

  fetch(CTX_PATH + '/enrollment/courseDelete', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
    body: JSON.stringify({ courseNos: [COURSE_NO] })
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    if (data.success) {
      alert('강의가 삭제되었습니다.');
      location.href = CTX_PATH + '/enrollment/courseEnrollment';
    } else {
      alert('오류: ' + (data.message || '삭제에 실패했습니다.'));
      deleteBtn.disabled = false;
      deleteBtn.textContent = '강의 삭제';
    }
  })
  .catch(function() {
    alert('서버 오류가 발생했습니다.');
    deleteBtn.disabled = false;
    deleteBtn.textContent = '강의 삭제';
  });
}

/* ================================================================
   폼 제출 (PUT — 수정)
   제출 직전 blocked 재검증 후 PUT /enrollment/courseUpdate
================================================================ */
function submitForm() {
  var courseName = document.getElementById('courseName').value.trim();
  var courseType = document.getElementById('courseType').value;
  var credits    = document.getElementById('credits').value;
  var semester   = document.getElementById('semester').value;
  var roomInfo   = document.getElementById('roomInfo').value;

  if (!courseName)            { alert('강의명을 입력해주세요.'); return; }
  if (!courseType)            { alert('강의 유형을 선택해주세요.'); return; }
  if (!roomInfo)              { alert('강의 교실을 선택해주세요.'); return; }
  if (!selectedSlots.length)  { alert('요일 및 시간을 선택해주세요.'); return; }

  var daySet = selectedSlots[0].day;  /* 요일 하나 */
  var pIdxList  = selectedSlots.map(function(s) { return s.periodIdx; }).sort(function(a,b){return a-b;});
  var startTime = PERIODS[pIdxList[0]].start + ':00';
  var endTime   = PERIODS[pIdxList[pIdxList.length-1]].end + ':00';

  var userCodeEl = document.getElementById('userCode');
  var userCode   = userCodeEl ? userCodeEl.value.trim() : '';
  if (userCodeEl && !professorVerified) { alert('교수 검증을 먼저 해주세요.'); return; }

  var formData = new FormData();
  formData.append('course_no',    COURSE_NO);
  formData.append('course_name',  courseName);
  formData.append('course_type',  courseType);
  formData.append('credits',      parseInt(credits));
  formData.append('semester',     semester);
  formData.append('room_info',    roomInfo);
  formData.append('day_of_week',  daySet);
  formData.append('start_time',   startTime);
  formData.append('end_time',     endTime);
  formData.append('max_students', 30);
  if (userCodeEl) formData.append('user_code', userCode);

  var pdfFile = document.getElementById('curriculumPdf').files[0];
  if (pdfFile) formData.append('curriculumPdf', pdfFile);

  /* 제출 직전 blocked 재검증 */
  var submitBtn = document.getElementById('submitBtn');
  submitBtn.disabled = true;
  submitBtn.textContent = '검증 중...';

  /* ADMIN은 검증된 교수 번호, 일반 교수는 세션 기준 */
  var professorNo2 = (document.getElementById('userCode') && verifiedProfessorNo > 0)
    ? verifiedProfessorNo
    : parseInt('${sessionUser.userNo}');

  var roomFetch2 = fetch(CTX_PATH + '/enrollment/blocked?room=' + encodeURIComponent(roomInfo)
      + '&semester=' + encodeURIComponent(semester), {
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  }).then(function(r) { return r.json(); });

  var myFetch2 = (professorNo2 > 0)
    ? fetch(CTX_PATH + '/enrollment/professor-blocked?professorNo=' + professorNo2
          + '&semester=' + encodeURIComponent(semester), {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
      }).then(function(r) { return r.json(); })
    : Promise.resolve([]);

  Promise.all([roomFetch2, myFetch2])
  .then(function(results) {
    var freshBlocked   = calcBlockedSlots(results[0]);
    var freshMyBlocked = calcBlockedSlots(results[1]);

    var roomConflict = selectedSlots.some(function(s) {
      return freshBlocked.some(function(b) { return b.day === s.day && b.periodIdx === s.periodIdx; });
    });
    if (roomConflict) {
      alert('선택한 시간에 이미 다른 강의가 배정되었습니다.\n시간표를 새로고침하고 다시 선택해주세요.');
      blockedSlots = freshBlocked; myBlockedSlots = freshMyBlocked;
      selectedSlots = []; renderGrid(); updateSummary();
      submitBtn.disabled = false; submitBtn.textContent = '수정 완료';
      return;
    }

    var myConflict = selectedSlots.some(function(s) {
      return freshMyBlocked.some(function(b) { return b.day === s.day && b.periodIdx === s.periodIdx; });
    });
    if (myConflict) {
      alert('선택한 시간이 본인의 기존 강의 시간과 겹칩니다.\n다른 시간을 선택해주세요.');
      blockedSlots = freshBlocked; myBlockedSlots = freshMyBlocked;
      selectedSlots = []; renderGrid(); updateSummary();
      submitBtn.disabled = false; submitBtn.textContent = '수정 완료';
      return;
    }

    /* 충돌 없음 → 실제 수정 요청 */
    fetch(CTX_PATH + '/enrollment/courseUpdate', {
      method: 'POST',
      headers: { 'X-Requested-With': 'XMLHttpRequest' },
      body: formData
    })
    .then(function(r) { return r.json(); })
    .then(function(res) {
      if (res.success) {
        alert('강의 수정이 완료되었습니다.');
        location.href = CTX_PATH + '/enrollment/courseEnrollment';
      } else {
        alert('오류: ' + (res.message || '수정에 실패했습니다.'));
        submitBtn.disabled = false;
        submitBtn.textContent = '수정 완료';
      }
    })
    .catch(function() {
      alert('서버 오류가 발생했습니다.');
      submitBtn.disabled = false;
      submitBtn.textContent = '수정 완료';
    });
  })
  .catch(function() {
    alert('시간 충돌 검증 중 서버 오류가 발생했습니다.');
    submitBtn.disabled = false;
    submitBtn.textContent = '수정 완료';
  });
}

window.addEventListener('DOMContentLoaded', function() { loadCourseData(); });
</script>
</body>
</html>
