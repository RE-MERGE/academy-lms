<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>강의 개설 신청 — re-merge LMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
  <style>
    /* ====================================================
       강의 개설 신청 폼 전용 스타일
       ==================================================== */
    .create-page {
      display: flex;
      flex-direction: column;
      height: 100%;
      max-width: 860px;
      margin: 0 auto;
    }

    .page-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 1.6rem;
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

    /* 폼 카드 */
    .form-card {
      background: var(--white);
      border: 1px solid var(--gray-200);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-sm);
      overflow: hidden;
    }

    /* 폼 테이블 */
    .form-table {
      width: 100%;
      border-collapse: collapse;
    }
    .form-table tr {
      border-bottom: 1px solid var(--gray-100);
    }
    .form-table tr:last-child {
      border-bottom: none;
    }
    .form-table th {
      width: 130px;
      padding: 1rem 1.2rem;
      background: var(--gray-50);
      font-size: .82rem;
      font-weight: 700;
      color: var(--gray-600);
      text-align: left;
      vertical-align: middle;
      border-right: 1px solid var(--gray-100);
      white-space: nowrap;
    }
    .form-table td {
      padding: .8rem 1.2rem;
      vertical-align: middle;
    }

    /* 입력 요소 공통 */
    .form-input,
    .form-select {
      width: 100%;
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
    .form-input:focus,
    .form-select:focus {
      outline: none;
      border-color: var(--primary-light);
      box-shadow: 0 0 0 3px rgba(59,130,246,.12);
    }
    .form-select {
      appearance: none;
      -webkit-appearance: none;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'%3E%3Cpath d='M1 1l4 4 4-4' stroke='%239ca3af' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: right .75rem center;
      padding-right: 2.2rem;
      cursor: pointer;
    }

    /* 상단 행 (학기, 강의명, 교실) */
    .top-row {
      display: flex;
      align-items: center;
      gap: 1rem;
      flex-wrap: wrap;
    }
    .top-group {
      display: flex;
      align-items: center;
      gap: .5rem;
    }
    .top-label {
      font-size: .78rem;
      font-weight: 700;
      color: var(--gray-500);
      white-space: nowrap;
    }
    .top-group .form-input,
    .top-group .form-select {
      width: auto;
    }

    /* PDF 업로드 */
    .pdf-upload-wrap {
      display: flex;
      align-items: center;
      gap: .8rem;
    }
    .pdf-upload-label {
      display: inline-flex;
      align-items: center;
      gap: .4rem;
      padding: .45rem 1rem;
      background: var(--primary-pale);
      border: 1.5px solid var(--primary-tint);
      border-radius: var(--radius-md);
      font-size: .82rem;
      font-weight: 600;
      color: var(--primary);
      cursor: pointer;
      transition: all .16s;
    }
    .pdf-upload-label:hover { background: var(--primary-tint); }
    .pdf-upload-label input { display: none; }
    .pdf-filename {
      font-size: .8rem;
      color: var(--gray-500);
    }
    .pdf-filename.has-file { color: var(--primary); font-weight: 600; }

    /* 시간표 그리드 */
    .timetable-selector {
      overflow-x: auto;
    }
    .tt-grid {
      display: grid;
      grid-template-columns: 60px repeat(5, minmax(60px, 1fr));
      gap: 3px;
      width: 100%;
    }
    .tt-head {
      padding: .45rem .3rem;
      text-align: center;
      font-size: .72rem;
      font-weight: 700;
      color: var(--gray-500);
      letter-spacing: .05em;
    }
    .tt-period {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: .3rem;
      background: var(--primary);
      color: var(--white);
      font-size: .7rem;
      font-weight: 700;
      border-radius: var(--radius-sm);
      white-space: nowrap;
    }
    .tt-cell {
      height: 44px;
      border-radius: var(--radius-sm);
      background: var(--gray-100);
      border: 1.5px solid transparent;
      cursor: pointer;
      transition: all .15s;
      position: relative;
    }
    .tt-cell:hover:not(.tt-blocked) {
      background: var(--primary-pale);
      border-color: var(--primary-tint);
    }
    .tt-cell.tt-selected {
      background: var(--primary);
      border-color: var(--primary);
    }
    .tt-cell.tt-selected::after {
      content: '개설시간';
      position: absolute;
      inset: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: .6rem;
      font-weight: 700;
      color: var(--white);
    }
    .tt-cell.tt-blocked {
      background: #fee2e2;
      border-color: #fecdd3;
      cursor: not-allowed;
    }
    .tt-cell.tt-blocked::after {
      content: '사용중';
      position: absolute;
      inset: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: .6rem;
      font-weight: 700;
      color: #b91c1c;
    }

    /* 선택된 시간 요약 */
    .selected-summary {
      margin-top: .8rem;
      font-size: .8rem;
      color: var(--gray-600);
    }
    .selected-summary span {
      display: inline-flex;
      align-items: center;
      gap: .3rem;
      background: var(--primary-pale);
      border: 1px solid var(--primary-tint);
      border-radius: 999px;
      padding: .15rem .6rem;
      font-size: .75rem;
      font-weight: 600;
      color: var(--primary);
      margin: .2rem .2rem 0 0;
    }

    /* 하단 버튼 */
    .form-actions {
      display: flex;
      justify-content: flex-end;
      gap: .8rem;
      padding: 1.2rem 1.2rem;
      border-top: 1px solid var(--gray-100);
    }
    .btn-submit {
      padding: .6rem 1.8rem;
      background: var(--primary);
      color: var(--white);
      border: none;
      border-radius: 999px;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .88rem;
      font-weight: 700;
      cursor: pointer;
      transition: all .16s;
      box-shadow: 0 2px 8px rgba(29,78,216,.2);
    }
    .btn-submit:hover { background: var(--primary-mid); transform: translateY(-1px); }
    .btn-cancel {
      padding: .6rem 1.8rem;
      background: #fff1f2;
      color: #b91c1c;
      border: 1px solid #fecdd3;
      border-radius: 999px;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
      font-size: .88rem;
      font-weight: 700;
      cursor: pointer;
      transition: all .16s;
    }
    .btn-cancel:hover { background: #fee2e2; }

    /* 안내 텍스트 */
    .hint {
      font-size: .74rem;
      color: var(--gray-400);
      margin-top: .3rem;
    }
    .legend {
      display: flex;
      gap: 1rem;
      margin-bottom: .6rem;
      font-size: .75rem;
    }
    .legend-item {
      display: flex;
      align-items: center;
      gap: .35rem;
      color: var(--gray-500);
    }
    .legend-dot {
      width: 14px; height: 14px;
      border-radius: 3px;
    }
    .legend-dot.avail  { background: var(--gray-100); border: 1.5px solid var(--gray-200); }
    .legend-dot.select { background: var(--primary); }
    .legend-dot.block  { background: #fee2e2; border: 1.5px solid #fecdd3; }
  </style>
</head>
<body>
<div class="layout-root">
  <main class="main-content" style="overflow-y:auto;">
    <div class="create-page">

      <%-- 페이지 헤더 --%>
      <div class="page-header">
        <div class="page-title">
          <div class="page-title-icon">📝</div>
          강의 개설 신청
        </div>
      </div>

      <%-- 폼 카드 --%>
      <div class="form-card">
        <table class="form-table">

          <%-- 개설 과목명 --%>
          <tr>
            <th>개설 과목명</th>
            <td>
              <input type="text" class="form-input" id="courseName" placeholder="강의명을 입력하세요" style="max-width:400px;">
            </td>
          </tr>

          <%-- 강의 유형 --%>
          <tr>
            <th>강의 유형</th>
            <td>
              <select class="form-select" id="courseType" style="max-width:200px;">
                <option value="">유형 선택</option>
                <option value="MAJOR_REQUIRED">전공필수</option>
                <option value="MAJOR_ELECTIVE">전공선택</option>
                <option value="GENERAL_REQUIRED">교양필수</option>
                <option value="GENERAL_ELECTIVE">교양선택</option>
                <option value="FREE_ELECTIVE">일반선택</option>
              </select>
            </td>
          </tr>

          <%-- 학점 --%>
          <tr>
            <th>학점</th>
            <td>
              <select class="form-select" id="credits" style="max-width:120px;">
                <option value="1">1학점</option>
                <option value="2">2학점</option>
                <option value="3" selected>3학점</option>
              </select>
            </td>
          </tr>

          <%-- 강의 내용 (PDF) --%>
          <tr>
            <th>강의 내용</th>
            <td>
              <div class="pdf-upload-wrap">
                <label class="pdf-upload-label">
                  📁 PDF 첨부파일 (강의 커리큘럼)
                  <input type="file" id="curriculumPdf" accept=".pdf" onchange="updateFileName(this)">
                </label>
                <span class="pdf-filename" id="pdfFileName">선택된 파일 없음</span>
              </div>
              <div class="hint">강의 커리큘럼 PDF를 첨부해주세요 (선택사항)</div>
            </td>
          </tr>

          <%-- 시작 학기 / 강의명 / 교실 --%>
          <tr>
            <th>시작 학기</th>
            <td>
              <div class="top-row">
                <div class="top-group">
                  <select class="form-select" id="semester" style="width:140px;">
                    <option value="2026-1">26년 1학기</option>
                    <option value="2026-2" selected>26년 2학기</option>
                    <option value="2027-1">27년 1학기</option>
                    <option value="2027-2">27년 2학기</option>
                  </select>
                </div>
                <div class="top-group">
                  <span class="top-label">신청 교실</span>
                  <select class="form-select" id="roomInfo" style="width:100px;" onchange="loadBlockedSlots()">
                    <option value="">선택</option>
                    <option value="101호">101호</option>
                    <option value="102호">102호</option>
                    <option value="103호">103호</option>
                    <option value="104호">104호</option>
                    <option value="105호">105호</option>
                  </select>
                </div>
              </div>
            </td>
          </tr>

          <%-- 요일 및 시간 --%>
          <tr>
            <th>요일 및 시간</th>
            <td>
              <%-- 범례 --%>
              <div class="legend">
                <div class="legend-item"><div class="legend-dot avail"></div> 선택 가능</div>
                <div class="legend-item"><div class="legend-dot select"></div> 개설 시간</div>
                <div class="legend-item"><div class="legend-dot block"></div> 사용 중</div>
              </div>

              <%-- 시간표 그리드 --%>
              <div class="timetable-selector">
                <div class="tt-grid" id="ttGrid">
                  <%-- JS로 렌더링 --%>
                </div>
              </div>

              <%-- 선택된 시간 요약 --%>
              <div class="selected-summary" id="selectedSummary">
                선택된 시간이 없습니다.
              </div>
              <div class="hint">교실을 먼저 선택하면 사용 중인 시간이 표시됩니다</div>
            </td>
          </tr>

        </table>

        <%-- 하단 버튼 --%>
        <div class="form-actions">
          <button class="btn-submit" onclick="submitForm()">제출</button>
          <button class="btn-cancel" onclick="history.back()">취소</button>
        </div>
      </div>

    </div>
  </main>
</div>

<script>
var CTX_PATH = '<%=request.getContextPath()%>';

/* ================================================================
   상수
   PERIODS: 교시별 시작/종료 시간 (1교시 09:00~10:00, 1시간 단위)
   DAYS: 요일 목록
================================================================ */
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

/* 선택된 셀: { day: '월', periodIdx: 0 } 형태의 배열 */
var selectedSlots = [];

/* 사용 중인 슬롯 (서버에서 받아옴): { day: '월', periodIdx: 0 } */
var blockedSlots = [];

/* ================================================================
   시간표 그리드 렌더링
================================================================ */
function renderGrid() {
  var grid = document.getElementById('ttGrid');
  grid.innerHTML = '';

  /* 헤더 행 */
  var emptyHead = document.createElement('div');
  emptyHead.className = 'tt-head';
  grid.appendChild(emptyHead);

  DAYS.forEach(function(day) {
    var head = document.createElement('div');
    head.className = 'tt-head';
    head.textContent = day;
    grid.appendChild(head);
  });

  /* 교시별 행 */
  PERIODS.forEach(function(period, pIdx) {
    /* 교시 라벨 */
    var periodCell = document.createElement('div');
    periodCell.className = 'tt-period';
    periodCell.textContent = period.label;
    grid.appendChild(periodCell);

    /* 요일별 셀 */
    DAYS.forEach(function(day) {
      var cell = document.createElement('div');
      cell.className = 'tt-cell';
      cell.dataset.day = day;
      cell.dataset.period = pIdx;

      var isBlocked  = isBlockedSlot(day, pIdx);
      var isSelected = isSelectedSlot(day, pIdx);

      if (isBlocked) {
        cell.classList.add('tt-blocked');
      } else if (isSelected) {
        cell.classList.add('tt-selected');
        cell.addEventListener('click', function() { toggleSlot(day, pIdx); });
      } else {
        cell.addEventListener('click', function() { toggleSlot(day, pIdx); });
      }

      grid.appendChild(cell);
    });
  });
}

/* ================================================================
   슬롯 토글 (선택/해제)
   제약: 요일은 달라도 되지만 교시(시간대)는 동일해야 함
   → 이미 선택된 교시와 다른 교시 클릭 시 경고
================================================================ */
function toggleSlot(day, pIdx) {
  var idx = selectedSlots.findIndex(function(s) { return s.day === day && s.periodIdx === pIdx; });

  if (idx >= 0) {
    /* 선택 해제 */
    selectedSlots.splice(idx, 1);
  } else {
    /* 선택 추가 — 이미 선택된 교시가 있으면 같은 교시만 허용 */
    var existingPIdx = selectedSlots.length > 0 ? selectedSlots[0].periodIdx : -1;
    if (existingPIdx >= 0 && existingPIdx !== pIdx) {
      alert(PERIODS[existingPIdx].start + '~' + PERIODS[existingPIdx].end + ' 교시만 선택할 수 있습니다.\n같은 시간대의 요일만 추가로 선택하세요.');
      return;
    }
    /* 같은 요일 중복 선택 방지 */
    if (selectedSlots.some(function(s) { return s.day === day; })) {
      alert('같은 요일은 중복 선택할 수 없습니다.');
      return;
    }
    selectedSlots.push({ day: day, periodIdx: pIdx });
  }
  renderGrid();
  updateSummary();
}

function isSelectedSlot(day, pIdx) {
  return selectedSlots.some(function(s) { return s.day === day && s.periodIdx === pIdx; });
}
function isBlockedSlot(day, pIdx) {
  return blockedSlots.some(function(s) { return s.day === day && s.periodIdx === pIdx; });
}

/* ================================================================
   선택된 시간 요약 업데이트
================================================================ */
function updateSummary() {
  var summary = document.getElementById('selectedSummary');
  if (!selectedSlots.length) {
    summary.innerHTML = '선택된 시간이 없습니다.';
    return;
  }
  /* 요일별로 묶어서 표시 */
  var byDay = {};
  selectedSlots.forEach(function(s) {
    if (!byDay[s.day]) byDay[s.day] = [];
    byDay[s.day].push(s.periodIdx);
  });
  var html = '';
  DAYS.forEach(function(day) {
    if (!byDay[day]) return;
    byDay[day].sort();
    byDay[day].forEach(function(pIdx) {
      html += '<span>' + day + ' ' + PERIODS[pIdx].start + '~' + PERIODS[pIdx].end + '</span>';
    });
  });
  summary.innerHTML = html;
}

/* ================================================================
   교실 선택 시 사용 중인 슬롯 로드
   엔드포인트: GET /enrollment/blocked?room=101호&semester=2026-2
   응답: [ { day_of_week: '월', start_time: '09:00', end_time: '10:00' }, ... ]
   실패 시 빈 배열로 폴백
================================================================ */
function loadBlockedSlots() {
  var room     = document.getElementById('roomInfo').value;
  var semester = document.getElementById('semester').value;

  blockedSlots = [];
  selectedSlots = [];

  if (!room) { renderGrid(); updateSummary(); return; }

  fetch(CTX_PATH + '/enrollment/blocked?room=' + encodeURIComponent(room) + '&semester=' + encodeURIComponent(semester), {
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    /* 서버 응답을 periodIdx로 변환 */
    blockedSlots = [];
    (data || []).forEach(function(course) {
      var days = (course.day_of_week || '').split(',');
      days.forEach(function(day) {
        day = day.trim();
        PERIODS.forEach(function(p, pIdx) {
          if (course.start_time && course.start_time.substring(0,5) === p.start) {
            blockedSlots.push({ day: day, periodIdx: pIdx });
          }
        });
      });
    });
    renderGrid();
  })
  .catch(function() {
    /* DB 연결 전 또는 오류 시 빈 상태로 */
    blockedSlots = [];
    renderGrid();
  });
}

/* ================================================================
   파일명 업데이트
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
   폼 제출
   선택된 슬롯을 요일(콤마), 시작/종료 시간으로 변환 후 서버 전송
   엔드포인트: POST /enrollment/create
   요청 본문: Course 필드 + multipart (PDF)
   TODO: 실제 파일 업로드는 multipart/form-data 로 변경 필요
================================================================ */
function submitForm() {
  var courseName = document.getElementById('courseName').value.trim();
  var courseType = document.getElementById('courseType').value;
  var credits    = document.getElementById('credits').value;
  var semester   = document.getElementById('semester').value;
  var roomInfo   = document.getElementById('roomInfo').value;

  if (!courseName) { alert('강의명을 입력해주세요.'); return; }
  if (!courseType) { alert('강의 유형을 선택해주세요.'); return; }
  if (!roomInfo)   { alert('강의 교실을 선택해주세요.'); return; }
  if (!selectedSlots.length) { alert('요일 및 시간을 선택해주세요.'); return; }

  /* 요일 추출 (중복 제거, 순서 유지) */
  var daySet = [];
  DAYS.forEach(function(day) {
    if (selectedSlots.some(function(s) { return s.day === day; })) daySet.push(day);
  });

  /* 시작/종료 시간: 선택된 교시 중 가장 이른/늦은 시간 */
  var pIdxList = selectedSlots.map(function(s) { return s.periodIdx; }).sort(function(a,b){return a-b;});
  var startTime = PERIODS[pIdxList[0]].start + ':00';
  var endTime   = PERIODS[pIdxList[pIdxList.length-1]].end + ':00';

  var payload = {
    course_name: courseName,
    course_type: courseType,
    credits:     parseInt(credits),
    semester:    semester,
    room_info:   roomInfo,
    day_of_week: daySet.join(','),
    start_time:  startTime,
    end_time:    endTime,
    max_students: 30,
    status:      'PENDING'
  };

  fetch(CTX_PATH + '/enrollment/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest'
    },
    body: JSON.stringify(payload)
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    if (data.success) {
      alert('강의 개설 신청이 완료되었습니다.');
      history.back();
    } else {
      alert('오류: ' + (data.message || '신청에 실패했습니다.'));
    }
  })
  .catch(function() {
    alert('서버 오류가 발생했습니다.');
  });
}

/* ================================================================
   초기화
================================================================ */
window.addEventListener('DOMContentLoaded', function() {
  renderGrid();
});
</script>
</body>
</html>
