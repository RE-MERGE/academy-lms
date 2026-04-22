<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>전체 사용자 목록 조회</title>
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
.user-table {
    width: 100%;
    border-collapse: collapse;
    border-radius: 10px 10px 0 0;
    overflow: hidden;
    table-layout: fixed;
    font-family: sans-serif;
}
.user-table thead { background-color: #004595; color: #fff; }
.user-table th {
    padding: 12px 8px;
    border: 1px solid #003a7d;
    font-size: 14px;
    white-space: nowrap;
}
/* 정렬 가능한 헤더 */
.user-table th.sortable {
    cursor: pointer;
    user-select: none;
}
.user-table th.sortable:hover { background-color: #003a7d; }
.sort-icon { margin-left: 4px; font-size: 11px; }

.user-table tbody { text-align: center; background-color: #f8faff; }
.user-table td {
    padding: 10px 8px;
    border: 1px solid #d0d7f0;
    font-size: 14px;
}
.user-table tbody tr:hover { background-color: #eef3fb; }
.user-table th:first-child,
.user-table td:first-child { width: 38px; }

/* ── 상태 뱃지 ── */
.badge { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; }
.badge-ACTIVE   { color: #004595; }
.badge-INACTIVE { color: #e6a817; }
.badge-LOCKED   { color: #e74c3c; }
.badge-PENDING  { color: #27ae60; }
.badge-DELETE   { color: #c0392b; }

/* ── 상태 필터 셀렉트 (헤더 안) ── */
.status-filter-select {
    background: transparent;
    border: 1px solid rgba(255,255,255,0.5);
    color: #fff;
    border-radius: 4px;
    padding: 3px 6px;
    font-size: 13px;
    cursor: pointer;
    outline: none;
    margin-left: 4px;
}
.status-filter-select option { color: #333; background: #fff; }

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
    min-width: 120px;
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

    <h2 style="margin: 0 0 18px 0; color: #004595; font-size: 22px; font-weight: bold;">전체 학생 목록 조회</h2>

    <!-- 상단 컨트롤 바 -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
        <div style="display: flex; align-items: center; gap: 8px;">
            <button class="filter-btn active" id="btn-student" onclick="filterRole('student')">학생</button>
            <button class="filter-btn" id="btn-professor" onclick="filterRole('professor')">교수</button>
        </div>
        <div class="search-wrap">
            <span style="font-size: 16px; color: #aaa;">🔍</span>
            <input type="text" id="searchInput" placeholder="" onkeyup="searchTable()"/>
            <button onclick="searchTable()">검색</button>
        </div>
    </div>

    <!-- 테이블 -->
    <table class="user-table" id="userTable">
        <thead>
            <tr>
                <th style="width: 3%;"><input type="checkbox" id="checkAll" onclick="toggleAll(this)"/></th>
                
                <th style="width: 3%;">번호</th>

                <!-- 이름 정렬 -->
                <th style="width: 10%;" class="sortable" onclick="sortTable('name')" id="th-name">
                    이름 <span class="sort-icon" id="icon-name">▼</span>
                </th>

                <th style="width: 26%;">이메일</th>
                <th style="width: 8%;">역할</th>

                <!-- 상태 셀렉트 필터 -->
                <th style="width: 11%;">
                    상태
                    <select class="status-filter-select" id="statusFilter" onchange="filterStatus()">
                        <option value="">전체</option>
                        <option value="ACTIVE">정상</option>
                        <option value="INACTIVE">휴먼</option>
                        <option value="LOCKED">정지</option>
                        <option value="PENDING">대기</option>
                        <option value="DELETE">탈퇴</option>
                    </select>
                </th>

                <!-- 학번 정렬 -->
                <th style="width: 10%;" class="sortable" onclick="sortTable('studentId')" id="th-studentId">
                    학번 <span class="sort-icon" id="icon-studentId">▼</span>
                </th>

                <!-- 학번 신청일 정렬 -->
                <th style="width: 13%;" class="sortable" onclick="sortTable('applyDate')" id="th-applyDate">
                    학번 신청 <span class="sort-icon" id="icon-applyDate">▼</span>
                </th>
            </tr>
        </thead>
        <tbody id="userTableBody">
            <c:forEach var="user" items="${userList}" varStatus="status">
            <tr class="user-row"
                data-role="${user.role}"
                data-status="${user.status}"
                data-name="${user.name}"
                data-student-id="${user.student_id}"
                data-apply-date="${user.apply_date}">
                <td><input type="checkbox" class="row-check" value="${user.user_no}"/></td>
                <td class="cell-no">${(currentPage - 1) * 10 + status.count}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/userDetail?no=${user.user_no}"
                       style="color: #004595; text-decoration: underline; cursor: pointer;">
                        ${user.name}
                    </a>
                </td>
                <td>${user.email}</td>
                <td>${user.role eq 'STUDENT' ? '학생' : '교수'}</td>
                <td>
                    <span class="badge badge-${user.status}">
                        <c:choose>
                            <c:when test="${user.status eq 'ACTIVE'}">정상</c:when>
                            <c:when test="${user.status eq 'INACTIVE'}">휴먼</c:when>
                            <c:when test="${user.status eq 'LOCKED'}">정지</c:when>
                            <c:when test="${user.status eq 'PENDING'}">대기</c:when>
                            <c:when test="${user.status eq 'DELETE'}">탈퇴</c:when>
                            <c:otherwise>${user.status}</c:otherwise>
                        </c:choose>
                    </span>
                </td>
                <td>${user.student_id}</td>
                <td style="color: #888; font-size: 13px;">${user.apply_date}</td>
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
            <option value="">🔎 상태 선택</option>
            <option value="ACTIVE">정상</option>
            <option value="INACTIVE">휴먼</option>
            <option value="LOCKED">정지</option>
            <option value="PENDING">대기</option>
            <option value="DELETE">탈퇴</option>
        </select>
        <button class="btn-confirm" onclick="applyBulkStatus()">확인</button>
    </div>

</div>

<script>
    /* ── 정렬 상태 관리 ── */
    // asc: ㄱ→ㅎ / 오름차순, desc: ㅎ→ㄱ / 내림차순
    const sortState = { name: 'none', studentId: 'none', applyDate: 'none' };

    function sortTable(key) {
        const tbody = document.getElementById('userTableBody');
        const rows  = Array.from(tbody.querySelectorAll('tr.user-row'));

        // 방향 결정: none→asc→desc→asc...
        const cur = sortState[key];
        const next = (cur === 'none' || cur === 'desc') ? 'asc' : 'desc';
        sortState[key] = next;

        // 아이콘 업데이트 (다른 컬럼은 초기화)
        ['name', 'studentId', 'applyDate'].forEach(function(k) {
            const icon = document.getElementById('icon-' + k);
            if (k === key) {
                icon.textContent = next === 'asc' ? '▼' : '▲';
            } else {
                icon.textContent = '▼';
                sortState[k] = 'none';
            }
        });

        // 데이터 속성 매핑
        const attrMap = { name: 'name', studentId: 'student-id', applyDate: 'apply-date' };
        const attr = attrMap[key];

        rows.sort(function(a, b) {
            const valA = a.getAttribute('data-' + attr) || '';
            const valB = b.getAttribute('data-' + attr) || '';
            const cmp  = valA.localeCompare(valB, 'ko');
            return next === 'asc' ? cmp : -cmp;
        });

        rows.forEach(function(row) { tbody.appendChild(row); });
        reNumberRows();
    }

    /* ── 번호 재정렬 ── */
    function reNumberRows() {
        const rows = document.querySelectorAll('#userTableBody tr.user-row');
        let i = 1;
        rows.forEach(function(row) {
            if (row.style.display !== 'none') {
                row.querySelector('.cell-no').textContent = i++;
            }
        });
    }

    /* ── 상태 필터 ── */
    function filterStatus() {
        const val = document.getElementById('statusFilter').value;
        document.querySelectorAll('.user-row').forEach(function(row) {
            const match = !val || row.getAttribute('data-status') === val;
            row.style.display = match ? '' : 'none';
        });
        reNumberRows();
    }

    /* ── 역할 필터 버튼 ── */
    function filterRole(role) {
        document.getElementById('btn-student').classList.toggle('active', role === 'student');
        document.getElementById('btn-professor').classList.toggle('active', role === 'professor');
        document.querySelectorAll('.user-row').forEach(function(row) {
            const rowRole = row.getAttribute('data-role');
            row.style.display = (role === 'student' ? rowRole === 'STUDENT' : rowRole === 'PROFESSOR') ? '' : 'none';
        });
        reNumberRows();
    }

    /* ── 검색 ── */
    function searchTable() {
        const keyword = document.getElementById('searchInput').value.toLowerCase().trim();
        document.querySelectorAll('.user-row').forEach(function(row) {
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
        if (checked.length === 0) { alert('대상 사용자를 선택해 주세요.'); return; }
        if (!confirm(checked.length + '명의 상태를 변경하시겠습니까?')) return;

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/user/updateStatus';

        const inputStatus = document.createElement('input');
        inputStatus.type = 'hidden'; inputStatus.name = 'status'; inputStatus.value = status;
        form.appendChild(inputStatus);

        checked.forEach(function(no) {
            const inp = document.createElement('input');
            inp.type = 'hidden'; inp.name = 'userNos'; inp.value = no;
            form.appendChild(inp);
        });

        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>
