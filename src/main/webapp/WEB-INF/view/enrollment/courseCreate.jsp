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
    .legend { display: flex; gap: 1rem; margin-bottom: .7rem; font-size: .75rem; }
    .legend-item { display: flex; align-items: center; gap: .35rem; color: var(--gray-500); }
    .legend-dot { width: 14px; height: 14px; border-radius: 3px; }
    .legend-dot.avail  { background: var(--gray-100); border: 1.5px solid var(--gray-200); }
    .legend-dot.select { background: var(--primary); }
    .legend-dot.block  { background: #fee2e2; border: 1.5px solid #fecdd3; }
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
          <div class="page-title-icon">📝</div>
          강의 개설 신청
        </div>
      </div>

      <div class="form-card">

        <%-- 교수번호 (관리자 전용) --%>
        <c:if test="${sessionUser.role == 'ADMIN'}">
        <div class="form-row">
          <div class="form-label">교수번호</div>
          <div class="form-field">
            <input type="number" class="form-input" id="professorNo" placeholder="교수번호를 입력하세요" style="max-width:200px;">
            <div class="hint">관리자 전용 — 강의를 개설할 교수의 번호를 입력하세요</div>
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
              <select class="form-select" id="semester" style="width:140px;">
                <option value="2026-1">26년 1학기</option>
                <option value="2026-2" selected>26년 2학기</option>
                <option value="2027-1">27년 1학기</option>
                <option value="2027-2">27년 2학기</option>
              </select>
              <span class="inline-label">신청 교실</span>
              <select class="form-select" id="roomInfo" style="width:110px;" onchange="loadBlockedSlots()">
                <option value="101호" selected>101호</option>
                <option value="102호">102호</option>
                <option value="103호">103호</option>
                <option value="104호">104호</option>
                <option value="105호">105호</option>
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
            </div>
            <div class="tt-grid" id="ttGrid"></div>
            <div class="selected-summary" id="selectedSummary">선택된 시간이 없습니다.</div>
            <div class="hint">교실을 변경하면 해당 교실의 사용 중인 시간이 표시됩니다</div>
          </div>
        </div>

        <%-- 하단 버튼 --%>
        <div class="form-actions">
          <button class="btn-submit" onclick="submitForm()">제출</button>
          <button class="btn-cancel" onclick="history.back()">취소</button>
        </div>

      </div><%-- /form-card --%>
    </div>
  </main>
</div>

<script>
var CTX_PATH = '<%=request.getContextPath()%>';

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
var selectedSlots = [];
var blockedSlots  = [];

/* ================================================================
   시간표 그리드 렌더링
================================================================ */
function renderGrid() {
  var grid = document.getElementById('ttGrid');
  grid.innerHTML = '';

  /* 헤더 */
  grid.appendChild(document.createElement('div')).className = 'tt-head';
  DAYS.forEach(function(day) {
    var h = document.createElement('div');
    h.className = 'tt-head';
    h.textContent = day;
    grid.appendChild(h);
  });

  /* 교시 행 */
  PERIODS.forEach(function(period, pIdx) {
    var pCell = document.createElement('div');
    pCell.className = 'tt-period';
    pCell.textContent = period.label;
    grid.appendChild(pCell);

    DAYS.forEach(function(day) {
      var cell = document.createElement('div');
      cell.className = 'tt-cell';
      if (isBlockedSlot(day, pIdx)) {
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
   슬롯 토글
   규칙:
   1. 같은 요일 내에서는 연속된 교시만 선택 가능
   2. 다른 요일은 이미 선택된 교시 범위와 동일해야 함
      예) 월 1~3교시 선택 시 수요일도 1~3교시만 선택 가능
================================================================ */
function toggleSlot(day, pIdx) {
  var idx = selectedSlots.findIndex(function(s) { return s.day === day && s.periodIdx === pIdx; });

  if (idx >= 0) {
    /* 해제 — 해당 요일의 중간 교시 해제 시 연속성 깨지면 막기 */
    var daySlots = selectedSlots.filter(function(s) { return s.day === day; })
                                .map(function(s) { return s.periodIdx; }).sort(function(a,b){return a-b;});
    if (daySlots.length > 1) {
      var minP = daySlots[0], maxP = daySlots[daySlots.length-1];
      if (pIdx !== minP && pIdx !== maxP) {
        alert('연속된 시간 중 중간 교시는 해제할 수 없습니다.\n끝 교시부터 해제하세요.');
        return;
      }
    }
    selectedSlots.splice(idx, 1);

  } else {
    /* 추가 */
    var allSelected = selectedSlots;

    if (allSelected.length === 0) {
      /* 첫 선택 — 자유롭게 */
      selectedSlots.push({ day: day, periodIdx: pIdx });

    } else {
      /* 이미 선택된 교시 범위 파악 */
      var allPIdx = allSelected.map(function(s) { return s.periodIdx; });
      var globalMin = Math.min.apply(null, allPIdx);
      var globalMax = Math.max.apply(null, allPIdx);

      /* 같은 요일 선택 시 — 연속 체크 */
      var daySlots2 = allSelected.filter(function(s) { return s.day === day; })
                                 .map(function(s) { return s.periodIdx; }).sort(function(a,b){return a-b;});

      if (daySlots2.length > 0) {
        var dMin = daySlots2[0], dMax = daySlots2[daySlots2.length-1];
        /* 연속되어야 함: 현재 선택 교시가 기존 범위 바로 앞뒤여야 함 */
        if (pIdx !== dMin - 1 && pIdx !== dMax + 1) {
          alert('같은 요일은 연속된 교시만 선택할 수 있습니다.');
          return;
        }
        /* 다른 요일의 범위와도 일치해야 함 */
        var newMin = Math.min(dMin, pIdx), newMax = Math.max(dMax, pIdx);
        var otherDaySlots = allSelected.filter(function(s) { return s.day !== day; });
        if (otherDaySlots.length > 0) {
          var otherPIdx = otherDaySlots.map(function(s) { return s.periodIdx; });
          var otherMin  = Math.min.apply(null, otherPIdx);
          var otherMax  = Math.max.apply(null, otherPIdx);
          if (newMin !== otherMin || newMax !== otherMax) {
            alert('다른 요일과 같은 시간 범위여야 합니다.\n(' + PERIODS[otherMin].start + '~' + PERIODS[otherMax].end + ')');
            return;
          }
        }

      } else {
        /* 새 요일 추가 시 — 기존 범위와 정확히 일치하는 교시만 허용 */
        if (pIdx < globalMin || pIdx > globalMax) {
          alert('다른 요일은 이미 선택된 시간 범위(' + PERIODS[globalMin].start + '~' + PERIODS[globalMax].end + ')와 같아야 합니다.\n해당 범위의 교시를 선택하세요.');
          return;
        }
        /* 해당 요일에 globalMin~globalMax 전체 채워야 하므로 순서대로 채우게 안내 */
        if (pIdx !== globalMin) {
          alert(PERIODS[globalMin].start + ' 교시부터 순서대로 선택해주세요.');
          return;
        }
      }

      selectedSlots.push({ day: day, periodIdx: pIdx });
    }
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
   선택 요약
================================================================ */
function updateSummary() {
  var el = document.getElementById('selectedSummary');
  if (!selectedSlots.length) { el.innerHTML = '선택된 시간이 없습니다.'; return; }
  var byDay = {};
  selectedSlots.forEach(function(s) {
    if (!byDay[s.day]) byDay[s.day] = [];
    byDay[s.day].push(s.periodIdx);
  });
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
   교실 선택 시 사용 중 슬롯 로드
================================================================ */
function loadBlockedSlots() {
  var room     = document.getElementById('roomInfo').value;
  var semester = document.getElementById('semester').value;
  blockedSlots = [];
  selectedSlots = [];
  if (!room) { renderGrid(); updateSummary(); return; }

  fetch(CTX_PATH + '/enrollment/blocked?room=' + encodeURIComponent(room)
      + '&semester=' + encodeURIComponent(semester), {
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    blockedSlots = [];
    (data || []).forEach(function(course) {
      (course.day_of_week || '').split(',').forEach(function(day) {
        day = day.trim();
        var startStr = (course.start_time || '').substring(0, 5);
        var endStr   = (course.end_time   || '').substring(0, 5);
        PERIODS.forEach(function(p, pIdx) {
          /* start_time 이상 end_time 미만 교시를 전부 막음 */
          if (p.start >= startStr && p.start < endStr) {
            blockedSlots.push({ day: day, periodIdx: pIdx });
          }
        });
      });
    });
    renderGrid();
  })
  .catch(function() { blockedSlots = []; renderGrid(); });
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
   폼 제출
================================================================ */
function submitForm() {
  var courseName = document.getElementById('courseName').value.trim();
  var courseType = document.getElementById('courseType').value;
  var credits    = document.getElementById('credits').value;
  var semester   = document.getElementById('semester').value;
  var roomInfo   = document.getElementById('roomInfo').value;

  if (!courseName)           { alert('강의명을 입력해주세요.'); return; }
  if (!courseType)           { alert('강의 유형을 선택해주세요.'); return; }
  if (!roomInfo)             { alert('강의 교실을 선택해주세요.'); return; }
  if (!selectedSlots.length) { alert('요일 및 시간을 선택해주세요.'); return; }

  var daySet = [];
  DAYS.forEach(function(day) {
    if (selectedSlots.some(function(s) { return s.day === day; })) daySet.push(day);
  });
  var pIdxList  = selectedSlots.map(function(s) { return s.periodIdx; }).sort(function(a,b){return a-b;});
  var startTime = PERIODS[pIdxList[0]].start + ':00';
  var endTime   = PERIODS[pIdxList[pIdxList.length-1]].end + ':00';

  var professorNoEl = document.getElementById('professorNo');
  var professorNo   = professorNoEl ? parseInt(professorNoEl.value) : 0;
  if (professorNoEl && !professorNo) { alert('교수번호를 입력해주세요.'); return; }

  var payload = {
    course_name:   courseName,
    course_type:   courseType,
    credits:       parseInt(credits),
    semester:      semester,
    room_info:     roomInfo,
    day_of_week:   daySet.join(','),
    start_time:    startTime,
    end_time:      endTime,
    max_students:  30,
    status:        'PENDING',
    professor_no:  professorNo
  };

  fetch(CTX_PATH + '/enrollment/create', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
    body: JSON.stringify(payload)
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    if (data.success) { alert('강의 개설 신청이 완료되었습니다.'); location.href = CTX_PATH + '/enrollment/courseEnrollment'; }
    else { alert('오류: ' + (data.message || '신청에 실패했습니다.')); }
  })
  .catch(function() { alert('서버 오류가 발생했습니다.'); });
}

window.addEventListener('DOMContentLoaded', function() { loadBlockedSlots(); });
</script>
</body>
</html>
