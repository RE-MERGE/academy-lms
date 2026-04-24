<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>강의 개설 승인 관리</title>
<style>
/* ── 필터 버튼 ── */
.filter-btn {
    padding: 7px 18px;
    border: 1.5px solid #004595;
    border-radius: 6px;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
    background: #fff;
    color: #004595;
    transition: background 0.15s, color 0.15s;
}
.filter-btn.active { background: #e6a817; border-color: #e6a817; color: #fff; }
.filter-btn:hover:not(.active) { background: #eef3fb; }

/* ── 검색 ── */
.search-wrap { display: flex; align-items: center; gap: 6px; }
.search-wrap input {
    padding: 7px 12px;
    border: 1.5px solid #d0d7f0;
    border-radius: 6px;
    font-size: 14px;
    width: 180px;
    outline: none;
}
.search-wrap input:focus { border-color: #004595; }
.search-wrap button {
    padding: 7px 16px;
    background: #e6a817;
    color: #fff;
    border: none;
    border-radius: 6px;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
}
.search-wrap button:hover { background: #c98f10; }

/* ── 테이블 ── */
.course-table {
    width: 100%;
    border-collapse: collapse;
    border-radius: 10px 10px 0 0;
    overflow: hidden;
    table-layout: fixed;
    font-family: sans-serif;
}
.course-table thead { background-color: #004595; color: #fff; }
.course-table th {
    padding: 12px 6px;
    border: 1px solid #003a7d;
    font-size: 13px;
    white-space: nowrap;
}
.course-table th.sortable { cursor: pointer; user-select: none; }
.course-table th.sortable:hover { background-color: #003a7d; }
.sort-icon { margin-left: 3px; font-size: 11px; }

.course-table tbody { text-align: center; background-color: #f8faff; }
.course-table td {
    padding: 10px 6px;
    border: 1px solid #d0d7f0;
    font-size: 13px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.course-table tbody tr:hover { background-color: #eef3fb; }
.course-table th:first-child,
.course-table td:first-child { width: 38px; }

/* ── 상태 뱃지 ── */
.badge { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; }
.badge-APPROVED { color: #004595; }
.badge-PENDING  { color: #27ae60; }
.badge-CANCELED { color: #e74c3c; }
.badge-APPLIED { color: #c0392b; }

/* ── 상태 필터 셀렉트 (헤더 안) ── */
.status-filter-select {
    background: transparent;
    border: 1px solid rgba(255,255,255,0.5);
    color: #fff;
    border-radius: 4px;
    padding: 3px 5px;
    font-size: 12px;
    cursor: pointer;
    outline: none;
    margin-left: 3px;
}
.status-filter-select option { color: #333; background: #fff; }

/* ── 폴더 아이콘 버튼 ── */
.btn-pdf {
    background: none;
    border: none;
    cursor: pointer;
    font-size: 18px;
    padding: 0;
    line-height: 1;
    transition: transform 0.15s;
}
.btn-pdf:hover { transform: scale(1.2); }

/* ── PDF 모달 ── */
.modal-overlay {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.55);
    z-index: 1000;
    justify-content: center;
    align-items: center;
}
.modal-overlay.open { display: flex; }
.modal-box {
    background: #fff;
    border-radius: 12px;
    width: 780px;
    max-width: 95vw;
    max-height: 88vh;
    display: flex;
    flex-direction: column;
    box-shadow: 0 8px 32px rgba(0,0,0,0.25);
    overflow: hidden;
}
.modal-header {
    background: #004595;
    color: #fff;
    padding: 14px 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 16px;
    font-weight: bold;
}
.modal-close {
    background: none;
    border: none;
    color: #fff;
    font-size: 22px;
    cursor: pointer;
    line-height: 1;
}
.modal-close:hover { opacity: 0.7; }
.modal-body { flex: 1; overflow: auto; padding: 0; }
.modal-body iframe { width: 100%; height: 100%; min-height: 600px; border: none; }

/* ── 페이지네이션 ── */
.pagination-wrap {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 4px;
    margin-top: 16px;
}
.pagination-wrap a {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 32px;
    height: 32px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 14px;
    color: #333;
    text-decoration: none;
    cursor: pointer;
}
.pagination-wrap a:hover { background: #eef3fb; border-color: #004595; }
.pagination-wrap a.active { background: #333; color: #fff; border-color: #333; font-weight: bold; }

/* ── 하단 액션 바 ── */
.action-bar {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 8px;
    margin-top: 14px;
    font-family: sans-serif;
}
.action-bar select {
    padding: 8px 14px;
    border-radius: 6px;
    border: 1.5px solid #d0d7f0;
    font-size: 14px;
    cursor: pointer;
    min-width: 130px;
    color: #333;
}
.btn-confirm {
    padding: 8px 20px;
    background: #e6a817;
    color: #fff;
    border: none;
    border-radius: 6px;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
}
.btn-confirm:hover { background: #c98f10; }
.guide-text { font-size: 13px; color: #555; text-decoration: underline; text-underline-offset: 2px; }
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
</head>
<body>

<div style="font-family: sans-serif; padding: 10px 0 20px 0;">

    <h2 style="margin: 0 0 18px 0; color: #004595; font-size: 22px; font-weight: bold;">강의 개설 승인 관리</h2>

    <!-- 상단 컨트롤 바 -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">

        <!-- 왼쪽: 필터 버튼 + 안내 -->
        <div style="display: flex; align-items: center; gap: 8px;">
            <button class="filter-btn active" id="btn-all"     onclick="filterCourseStatus('all')">전체</button>
            <button class="filter-btn"        id="btn-active"  onclick="filterCourseStatus('active')">진행중인 수업</button>
            <button class="filter-btn"        id="btn-pending" onclick="filterCourseStatus('pending')">대기중인 수업</button>
            <span class="guide-text">교수가 개설 신청한 강의를 승인 또는 거절할 수 있습니다.</span>
        </div>

        <!-- 오른쪽: 검색 -->
        <div class="search-wrap">
            <span style="font-size: 16px; color: #aaa;">🔍</span>
            <input type="text" id="searchInput" placeholder="" onkeyup="searchTable()"/>
            <button onclick="searchTable()">검색</button>
        </div>

    </div>

    <!-- 테이블 -->
    <table class="course-table" id="courseTable">
        <thead>
            <tr>
                <th style="width: 3%;"><input type="checkbox" id="checkAll" onclick="toggleAll(this)"/></th>
                          
                <th style="width: 3%;">번호</th>

                <th style="width: 7%;" class="sortable" onclick="sortTable('profName')" id="th-profName">
                    교수이름 <span class="sort-icon" id="icon-profName">▼</span>
                </th>                
                
                <th style="width: 13%;" class="sortable" onclick="sortTable('courseName')" id="th-courseName">
                    강의이름 <span class="sort-icon" id="icon-courseName">▼</span>
                </th>
                
                <th style="width: 4%;">파일</th>
                
                 <th style="width: 5%;">학점</th>
                
                 <th style="width: 9%;">신청강의실</th>
                
                <th style="width: 9%;">시간</th>
                
                <th style="width: 6%;" class="sortable" onclick="sortTable('dayOfWeek')" id="th-dayOfWeek">
                    요일 <span class="sort-icon" id="icon-dayOfWeek">▼</span>
                </th>
                
                <th style="width: 10%;">
                    상태
                    <select class="status-filter-select" id="statusFilter" onchange="filterStatus()">
                        <option value="">전체</option>
                        <option value="APPROVED">승인</option>
                        <option value="PENDING">대기</option>
                        <option value="APPLIED">신청</option>
                        <option value="CANCELED">거절</option>
                    </select>
                </th>
              
                <th style="width: 10%;" class="sortable" onclick="sortTable('applyDate')" id="th-applyDate">
                    개설신청일 <span class="sort-icon" id="icon-applyDate">▼</span>
                </th>
               
                
            </tr>
        </thead>
        <tbody id="courseTableBody">
            <c:forEach var="course" items="${courseList}" varStatus="status">
            <tr class="course-row"
                data-status="${course.status}"
                data-prof-name="${course.prof_name}"
                data-course-name="${course.course_name}"
                data-apply-date="${course.apply_date}"
                data-day-of-week="${course.day_of_week}">
              <td><input type="checkbox" class="row-check" value="${course.course_no}"/></td>
             
                
             <td class="cell-no">${(currentPage - 1) * 10 + status.count}</td>
             
               <td>${course.prof_name}</td>
               
                 <td style="text-align: left; padding-left: 10px;">${course.course_name}</td>
                
                <td>
                    <button class="btn-pdf"
                            onclick="openPdf('${pageContext.request.contextPath}/course/pdf?no=${course.course_no}', '${course.course_name}')"
                            title="강의계획서 보기">📁</button>
                </td>
                
                <td>${course.credits}</td>
                
                <td>${course.classroom}</td>
                
               <td>${course.start_time} ~ ${course.end_time}</td>
               
               <td>${course.day_of_week}</td>
               
                <td>
                    <span class="badge badge-${course.status}">
                        <c:choose>
                            <c:when test="${course.status eq 'APPROVED'}">승인</c:when>
                            <c:when test="${course.status eq 'PENDING'}">대기</c:when>
                            <c:when test="${course.status eq 'APPLIED'}">신청</c:when>
                            <c:when test="${course.status eq 'CANCLED'}">취소</c:when>
                            <c:otherwise>${course.status}</c:otherwise>
                        </c:choose>
                    </span>
                </td>
                           
                <td style="color: #888;">${course.apply_date}</td>
                
          </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <div class="pagination-wrap">
        <c:if test="${currentPage > 1}">
            <a href="?page=${currentPage - 1}">&lt;</a>
        </c:if>
        <c:forEach var="p" begin="1" end="${totalPages}">
            <a href="?page=${p}" class="${p == currentPage ? 'active' : ''}">${p}</a>
        </c:forEach>
        <c:if test="${currentPage < totalPages}">
            <a href="?page=${currentPage + 1}">&gt;</a>
        </c:if>
    </div>

    <!-- 하단 액션 바 -->
    <div class="action-bar">
        <select id="bulkStatus">
            <option value="">상태 선택</option>
            <option value="APPROVED">승인</option>
            <option value="APPLIED">신청</option>
            <option value="PENDING">대기</option>
            <option value="CANCELED">거절</option>
        </select>
        <button class="btn-confirm" onclick="applyBulkStatus()">확인</button>
    </div>

</div>

<!-- PDF 모달 -->
<div class="modal-overlay" id="pdfModal">
    <div class="modal-box">
        <div class="modal-header">
            <span>📄 <span id="modalTitle">강의계획서</span></span>
            <button class="modal-close" onclick="closePdf()">✕</button>
        </div>
        <div class="modal-body">
            <iframe id="pdfFrame" src=""></iframe>
        </div>
    </div>
</div>

<script>
    /* ── PDF 모달 ── */
    function openPdf(url, title) {
        document.getElementById('modalTitle').textContent = title;
        document.getElementById('pdfFrame').src = url;
        document.getElementById('pdfModal').classList.add('open');
    }
    function closePdf() {
        document.getElementById('pdfModal').classList.remove('open');
        document.getElementById('pdfFrame').src = '';
    }
    document.getElementById('pdfModal').addEventListener('click', function(e) {
        if (e.target === this) closePdf();
    });

    /* ── 정렬 ── */
    const sortState = { profName: 'none', courseName: 'none', applyDate: 'none', dayOfWeek: 'none' };
    const attrMap   = { profName: 'prof-name', courseName: 'course-name', applyDate: 'apply-date', dayOfWeek: 'day-of-week' };

    function sortTable(key) {
        const tbody = document.getElementById('courseTableBody');
        const rows  = Array.from(tbody.querySelectorAll('tr.course-row'));
        const cur   = sortState[key];
        const next  = (cur === 'none' || cur === 'desc') ? 'asc' : 'desc';

        Object.keys(sortState).forEach(function(k) {
            sortState[k] = 'none';
            document.getElementById('icon-' + k).textContent = '▼';
        });
        sortState[key] = next;
        document.getElementById('icon-' + key).textContent = next === 'asc' ? '▼' : '▲';

        rows.sort(function(a, b) {
            const valA = a.getAttribute('data-' + attrMap[key]) || '';
            const valB = b.getAttribute('data-' + attrMap[key]) || '';
            const cmp  = valA.localeCompare(valB, 'ko');
            return next === 'asc' ? cmp : -cmp;
        });
        rows.forEach(function(row) { tbody.appendChild(row); });
        reNumberRows();
    }

    /* ── 번호 재계산 ── */
    function reNumberRows() {
        let i = 1;
        document.querySelectorAll('#courseTableBody tr.course-row').forEach(function(row) {
            if (row.style.display !== 'none') row.querySelector('.cell-no').textContent = i++;
        });
    }

    /* ── 상태 필터 (헤더 셀렉트) ── */
    function filterStatus() {
        const val = document.getElementById('statusFilter').value;
        document.querySelectorAll('.course-row').forEach(function(row) {
            row.style.display = (!val || row.getAttribute('data-status') === val) ? '' : 'none';
        });
        reNumberRows();
    }

    /* ── 진행중 / 대기중 필터 버튼 ── */
    function filterCourseStatus(type) {
        document.getElementById('btn-all').classList.toggle('active',     type === 'all');
        document.getElementById('btn-active').classList.toggle('active',  type === 'active');
        document.getElementById('btn-pending').classList.toggle('active', type === 'pending');

        document.querySelectorAll('.course-row').forEach(function(row) {
            const s = row.getAttribute('data-status');
            let show = false;
            if (type === 'all')     show = true;
            if (type === 'active')  show = (s === 'APPROVED');
            if (type === 'pending') show = (s === 'PENDING' || s === 'CANCELED' || s ==='APPLIED');
            row.style.display = show ? '' : 'none';
        });
        reNumberRows();
    }

    /* ── 검색 ── */
    function searchTable() {
        const keyword = document.getElementById('searchInput').value.toLowerCase().trim();
        document.querySelectorAll('.course-row').forEach(function(row) {
            row.style.display = row.innerText.toLowerCase().includes(keyword) ? '' : 'none';
        });
        reNumberRows();
    }

    /* ── 전체 체크박스 ── */
    function toggleAll(master) {
        document.querySelectorAll('.row-check').forEach(function(cb) { cb.checked = master.checked; });
    }

    /* ── 일괄 상태 변경 ── */
    function applyBulkStatus() {
        const status = document.getElementById('bulkStatus').value;
        if (!status) { alert('변경할 상태를 선택해 주세요.'); return; }
        const checked = Array.from(document.querySelectorAll('.row-check:checked')).map(cb => cb.value);
        if (checked.length === 0) { alert('대상 강의를 선택해 주세요.'); return; }
        if (!confirm(checked.length + '개 강의의 상태를 변경하시겠습니까?')) return;

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/updateCourseStatus';

        const inputStatus = document.createElement('input');
        inputStatus.type = 'hidden'; inputStatus.name = 'status'; inputStatus.value = status;
        form.appendChild(inputStatus);

        checked.forEach(function(no) {
            const inp = document.createElement('input');
            inp.type = 'hidden'; inp.name = 'courseNos'; inp.value = no;
            form.appendChild(inp);
        });

        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>
