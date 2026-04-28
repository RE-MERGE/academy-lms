<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>전체 사용자 목록 조회</title>
<style>
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
.user-table th.sortable { cursor: pointer; user-select: none; }
.user-table th.sortable:hover { background-color: #003a7d; }
.sort-icon { margin-left: 4px; font-size: 11px; }
.user-table tbody { text-align: center; background-color: #f8faff; }
.user-table td { padding: 10px 8px; border: 1px solid #d0d7f0; font-size: 14px; }
.user-table tbody tr:hover { background-color: #eef3fb; }
.user-table th:first-child, .user-table td:first-child { width: 38px; }

/* ── 뱃지형 드롭다운 ── */
.status-badge-wrap {
    position: relative;
    display: inline-block;
}
.badge-btn {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
    cursor: pointer;
    border: 1.5px solid transparent;
    background: transparent;
    transition: filter 0.15s;
    user-select: none;
}
.badge-btn:hover { filter: brightness(0.9); }
.badge-btn .arrow { font-size: 9px; opacity: 0.7; }

.badge-ACTIVE   { color: #004595; border-color: #004595; background: #e8f0fb; }
.badge-INACTIVE { color: #e6a817; border-color: #e6a817; background: #fdf5e0; }
.badge-LOCKED   { color: #e74c3c; border-color: #e74c3c; background: #fdecea; }
.badge-PENDING  { color: #27ae60; border-color: #27ae60; background: #e6f7ed; }
.badge-DELETE   { color: #888;    border-color: #bbb;    background: #f0f0f0; }

.status-dropdown {
    display: none;
    position: absolute;
    top: calc(100% + 4px);
    left: 50%;
    transform: translateX(-50%);
    background: #fff;
    border: 1px solid #d0d7f0;
    border-radius: 8px;
    box-shadow: 0 4px 16px rgba(0,0,0,0.13);
    z-index: 999;
    min-width: 100px;
    overflow: hidden;
}
.status-dropdown.open { display: block; }
.status-dropdown-item {
    padding: 8px 16px;
    font-size: 13px;
    font-weight: bold;
    cursor: pointer;
    white-space: nowrap;
    text-align: center;
    transition: background 0.12s;
}
.status-dropdown-item:hover { background: #f0f4fb; }
.status-dropdown-item.opt-ACTIVE   { color: #004595; }
.status-dropdown-item.opt-INACTIVE { color: #e6a817; }
.status-dropdown-item.opt-LOCKED   { color: #e74c3c; }
.status-dropdown-item.opt-PENDING  { color: #27ae60; }
.status-dropdown-item.opt-DELETE   { color: #888;    }

/* ── 헤더 상태 필터 ── */
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

/* ── 일괄 상태변경 바 (하단) ── */
.action-bar {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    padding-right: 5%;
    gap: 8px;
    margin-top: 1px;
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
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
</head>
<body>

<div style="font-family: sans-serif; padding: 10px 0 20px 0;">

    <h2 style="margin: 0 0 18px 0; color: #004595; font-size: 22px; font-weight: bold;">전체 학생 목록 조회</h2>

    <!-- 상단 필터 + 검색 -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
        <div style="display: flex; align-items: center; gap: 8px;">
            <button class="filter-btn" id="btn-all"       onclick="filterRole('all')">전체</button>
            <button class="filter-btn" id="btn-student"   onclick="filterRole('student')">학생</button>
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
                <th style="width: 10%;" class="sortable" onclick="sortTable('name')" id="th-name">
                    이름 <span class="sort-icon" id="icon-name">▼</span>
                </th>
                <th style="width: 26%;">이메일</th>
                <th style="width: 8%;">역할</th>
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
                <th style="width: 10%;" class="sortable" onclick="sortTable('studentId')" id="th-studentId">
                    학번 <span class="sort-icon" id="icon-studentId">▼</span>
                </th>
                <th style="width: 13%;" class="sortable" onclick="sortTable('applyDate')" id="th-applyDate">
                    회원 가입 신청일 <span class="sort-icon" id="icon-applyDate">▼</span>
                </th>
            </tr>
        </thead>
        <tbody id="userTableBody">
            <c:forEach var="user" items="${userList}" varStatus="status">
            <tr class="user-row"
                data-role="${user.role}"
                data-status="${user.status}"
                data-name="${user.name}"
                data-student-id="${user.userNo}"
                data-apply-date="${user.createdAt}">
                <td><input type="checkbox" class="row-check" value="${user.userNo}"/></td>
                <td class="cell-no">${(currentPage - 1) * 10 + status.count}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/userDetail/${user.userNo}"
                       style="color: #004595; text-decoration: underline; cursor: pointer;">
                        ${user.name}
                    </a>
                </td>
                <td>${user.email}</td>
                <td>${user.role eq 'STUDENT' ? '학생' : '교수'}</td>
                <td>
                    <div class="status-badge-wrap">
                        <button class="badge-btn badge-${user.status}"
                                id="badge-${user.userNo}"
                                onclick="toggleDropdown(event, '${user.userNo}')">
                            <c:choose>
                                <c:when test="${user.status eq 'ACTIVE'}">정상</c:when>
                                <c:when test="${user.status eq 'INACTIVE'}">휴먼</c:when>
                                <c:when test="${user.status eq 'LOCKED'}">정지</c:when>
                                <c:when test="${user.status eq 'PENDING'}">대기</c:when>
                                <c:when test="${user.status eq 'DELETE'}">탈퇴</c:when>
                                <c:otherwise>${user.status}</c:otherwise>
                            </c:choose>
                            <span class="arrow">▾</span>
                        </button>
                        <div class="status-dropdown" id="dropdown-${user.userNo}">
                            <div class="status-dropdown-item opt-ACTIVE"   onclick="changeStatus('${user.userNo}', 'ACTIVE')">정상</div>
                            <div class="status-dropdown-item opt-INACTIVE" onclick="changeStatus('${user.userNo}', 'INACTIVE')">휴먼</div>
                            <div class="status-dropdown-item opt-LOCKED"   onclick="changeStatus('${user.userNo}', 'LOCKED')">정지</div>
                            <div class="status-dropdown-item opt-PENDING"  onclick="changeStatus('${user.userNo}', 'PENDING')">대기</div>
                            <div class="status-dropdown-item opt-DELETE"   onclick="changeStatus('${user.userNo}', 'DELETE')">탈퇴</div>
                        </div>
                    </div>
                </td>
                <td>${user.userCode}</td>
                <td class="date-cell" style="color: #888; font-size: 13px;">${user.createdAt}</td>
            </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <div class="pagination-wrap">
        <c:if test="${currentPage > 1}">
            <a href="?page=${currentPage - 1}&role=${currentRole}">&lt;</a>
        </c:if>
        <c:forEach var="p" begin="1" end="${totalPages}">
            <a href="?page=${p}&role=${currentRole}" class="${p == currentPage ? 'active' : ''}">${p}</a>
        </c:forEach>
        <c:if test="${currentPage < totalPages}">
            <a href="?page=${currentPage + 1}&role=${currentRole}">&gt;</a>
        </c:if>
    </div>

    <!-- ── 일괄 상태변경 바 (하단) ── -->
    <div class="action-bar">
        <select id="bulkStatus">
            <option value="">☑️ 체크한 인원 상태 변경</option>
            <option value="ACTIVE">정상</option>
            <option value="INACTIVE">휴먼</option>
            <option value="LOCKED">정지</option>
            <option value="PENDING">대기</option>
            <option value="DELETE">탈퇴</option>
        </select>
        <button class="btn-confirm" onclick="applyBulkStatus()">변경</button>
    </div>

</div>

<script>
    /* ── 정렬 ── */
    const sortState = { name: 'none', studentId: 'none', applyDate: 'none' };

    function sortTable(key) {
        const tbody = document.getElementById('userTableBody');
        const rows  = Array.from(tbody.querySelectorAll('tr.user-row'));
        const cur   = sortState[key];
        const next  = (cur === 'none' || cur === 'desc') ? 'asc' : 'desc';
        sortState[key] = next;

        ['name', 'studentId', 'applyDate'].forEach(function(k) {
            const icon = document.getElementById('icon-' + k);
            if (k === key) icon.textContent = next === 'asc' ? '▼' : '▲';
            else { icon.textContent = '▼'; sortState[k] = 'none'; }
        });

        const attrMap = { name: 'name', studentId: 'student-id', applyDate: 'apply-date' };
        const attr = attrMap[key];

        rows.sort(function(a, b) {
            const valA = a.getAttribute('data-' + attr) || '';
            const valB = b.getAttribute('data-' + attr) || '';
            return next === 'asc' ? valA.localeCompare(valB, 'ko') : valB.localeCompare(valA, 'ko');
        });

        rows.forEach(row => tbody.appendChild(row));
        reNumberRows();
    }

    function reNumberRows() {
        const rows = document.querySelectorAll('#userTableBody tr.user-row');
        let i = 1;
        rows.forEach(function(row) {
            if (getComputedStyle(row).display !== 'none') {
                const noCell = row.querySelector('.cell-no');
                if (noCell) noCell.textContent = i++;
            }
        });
    }

    /* ── 역할 필터 ── */
    function filterRole(role) {
        ['all', 'student', 'professor'].forEach(function(r) {
            document.getElementById('btn-' + r).classList.toggle('active', r === role);
        });
        location.href = '?page=1&role=' + role;
    }

    function applyFilters() {
        const targetRole   = (document.querySelector('.filter-btn.active')?.id.replace('btn-', '') || 'all').toUpperCase();
        const targetStatus = document.getElementById('statusFilter').value;

        document.querySelectorAll('.user-row').forEach(function(row) {
            const rowRole   = row.getAttribute('data-role').trim().toUpperCase();
            const rowStatus = row.getAttribute('data-status');
            const roleMatch   = (targetRole === 'ALL' || rowRole === targetRole);
            const statusMatch = !targetStatus || rowStatus === targetStatus;
            row.style.setProperty('display', (roleMatch && statusMatch) ? 'table-row' : 'none', 'important');
        });
        reNumberRows();
    }

    function filterStatus() { applyFilters(); }

    /* ── 검색 ── */
    function searchTable() {
        const keyword = document.getElementById('searchInput').value.toLowerCase().trim();
        document.querySelectorAll('.user-row').forEach(function(row) {
            const isMatch = row.innerText.toLowerCase().includes(keyword);
            row.style.setProperty('display', isMatch ? '' : 'none', 'important');
        });
        reNumberRows();
    }

    /* ── 전체 체크 ── */
    function toggleAll(master) {
        document.querySelectorAll('.row-check').forEach(cb => cb.checked = master.checked);
    }

    /* ── 뱃지 드롭다운 ── */
    const statusLabel = {
        ACTIVE: '정상', INACTIVE: '휴먼', LOCKED: '정지', PENDING: '대기', DELETE: '탈퇴'
    };

    function toggleDropdown(e, userNo) {
        e.stopPropagation();
        const target = document.getElementById('dropdown-' + userNo);
        const isOpen = target.classList.contains('open');
        document.querySelectorAll('.status-dropdown.open').forEach(el => el.classList.remove('open'));
        if (!isOpen) target.classList.add('open');
    }

    function changeStatus(userNo, newStatus) {
        document.querySelectorAll('.status-dropdown.open').forEach(el => el.classList.remove('open'));

        const row = document.querySelector('tr[data-student-id="' + userNo + '"]');
        const badge = document.getElementById('badge-' + userNo);

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/updateUserStatus';

        const sInput = document.createElement('input');
        sInput.type = 'hidden'; sInput.name = 'status'; sInput.value = newStatus;
        form.appendChild(sInput);

        const nInput = document.createElement('input');
        nInput.type = 'hidden'; nInput.name = 'userNos'; nInput.value = userNo;
        form.appendChild(nInput);

        if (badge) {
            badge.className = 'badge-btn badge-' + newStatus;
            badge.innerHTML = statusLabel[newStatus] + ' <span class="arrow">▾</span>';
        }
        if (row) row.setAttribute('data-status', newStatus);

        document.body.appendChild(form);
        form.submit();
    }

    /* ── 일괄 상태변경 ── */
    function applyBulkStatus() {
        const status = document.getElementById('bulkStatus').value;
        if (!status) { alert('변경할 상태를 선택해 주세요.'); return; }

        const checked = Array.from(document.querySelectorAll('.row-check:checked')).map(cb => cb.value);
        if (checked.length === 0) { alert('대상 회원을 선택해 주세요.'); return; }
        if (!confirm(checked.length + '명의 상태를 변경하시겠습니까?')) return;

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/updateUserStatus';

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

    /* ── 초기화 ── */
    document.addEventListener('DOMContentLoaded', function() {

        // 날짜 형식 변환
        document.querySelectorAll('.date-cell').forEach(function(td) {
            const raw = td.textContent.trim();
            if (raw.includes('T')) {
                const [date, time] = raw.split('T');
                td.textContent = date.replace(/-/g, '.') + ' ' + time.substring(0, 5);
            }
        });

        // 역할 버튼 활성화
        var params = new URLSearchParams(window.location.search);
        var role = params.get('role') || 'all';
        document.getElementById('btn-all').classList.toggle('active', role === 'all');
        document.getElementById('btn-student').classList.toggle('active', role === 'student');
        document.getElementById('btn-professor').classList.toggle('active', role === 'professor');

        // 드롭다운 외부 클릭 시 닫기
        document.addEventListener('click', function() {
            document.querySelectorAll('.status-dropdown.open').forEach(el => el.classList.remove('open'));
        });

    });
</script>
</body>
</html>