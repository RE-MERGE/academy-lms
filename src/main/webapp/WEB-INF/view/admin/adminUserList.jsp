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
            <button class="filter-btn active" id="btn-all"       onclick="filterRole('all')">전체</button>
            <button class="filter-btn"        id="btn-student"   onclick="filterRole('student')">학생</button>
            <button class="filter-btn"        id="btn-professor" onclick="filterRole('professor')">교수</button>
        </div>

        <div style="display: flex; align-items: center; gap: 8px;">
            <div class="action-bar" style="margin: 0;">
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
            <div class="search-wrap">
                <span style="font-size: 16px; color: #aaa;">🔍</span>
                <input type="text" id="searchInput" placeholder="" onkeyup="searchTable()"/>
                <button onclick="searchTable()">검색</button>
            </div>
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
                    학번 신청일 <span class="sort-icon" id="icon-applyDate">▼</span>
                </th>
            </tr>
        </thead>
        <tbody id="userTableBody">
            <c:forEach var="user" items="${userList}" varStatus="status">
            <tr class="user-row"
                data-role="${user.role}"
                data-status="${user.status}"
                data-name="${user.name}"
                data-student-id="${user.userCode}"
                data-apply-date="${user.createdAt}">

                <td><input type="checkbox" class="row-check" value="${user.userNo}"/></td>
                <td class="cell-no">${(currentPage - 1) * 10 + status.count}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/user/myPage?no=${user.userNo}"
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
                <td>${user.userCode}</td>
                <td style="color: #888; font-size: 13px;">${user.createdAt}</td>
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



</div>
<script>
    /* ── 정렬 상태 관리 ── */
    const sortState = { name: 'none', studentId: 'none', applyDate: 'none' };

    function sortTable(key) {
        const tbody = document.getElementById('userTableBody');
        const rows  = Array.from(tbody.querySelectorAll('tr.user-row'));

        const cur = sortState[key];
        const next = (cur === 'none' || cur === 'desc') ? 'asc' : 'desc';
        sortState[key] = next;

        ['name', 'studentId', 'applyDate'].forEach(function(k) {
            const icon = document.getElementById('icon-' + k);
            if (k === key) icon.textContent = next === 'asc' ? '▼' : '▲';
            else { icon.textContent = '▼'; sortState[k] = 'none'; }
        });

        const attrMap = { name: 'name', studentId: 'userCode', applyDate: 'createdAt' };
        const attr = attrMap[key];

        rows.sort(function(a, b) {
            const valA = a.getAttribute('data-' + attr) || '';
            const valB = b.getAttribute('data-' + attr) || '';
            return next === 'asc' ? valA.localeCompare(valB, 'ko') : valB.localeCompare(valA, 'ko');
        });

        rows.forEach(row => tbody.appendChild(row));
        reNumberRows();
    }

    /* ── 번호 재정렬 ── */
    function reNumberRows() {
        const rows = document.querySelectorAll('#userTableBody tr.user-row');
        let i = 1;
        rows.forEach(function(row) {
            // offsetParent가 있으면 화면에 보이는 요소입니다.
            if (row.offsetParent !== null) {
                const noCell = row.querySelector('.cell-no');
                if (noCell) noCell.textContent = i++;
            }
        });
    }

    /* ── 통합 필터 실행 ── */
    // 현재 선택된 역할(Role)을 전역 변수로 관리합니다.
    let currentActiveRole = 'all'; // 기본값 all로 변경

    function filterRole(role) {
        currentActiveRole = role;
        document.getElementById('btn-all').classList.toggle('active',       role === 'all');
        document.getElementById('btn-student').classList.toggle('active',   role === 'student');
        document.getElementById('btn-professor').classList.toggle('active', role === 'professor');
        applyFilters();
    }

    function applyFilters() {
        const targetRole   = currentActiveRole.toUpperCase();
        const targetStatus = document.getElementById('statusFilter').value;

        document.querySelectorAll('.user-row').forEach(function(row) {
            const rowRole   = row.getAttribute('data-role').trim().toUpperCase();
            const rowStatus = row.getAttribute('data-status');

            const roleMatch   = (targetRole === 'ALL' || rowRole === targetRole);
            const statusMatch = !targetStatus || (rowStatus === targetStatus);

            row.style.setProperty('display', (roleMatch && statusMatch) ? 'table-row' : 'none', 'important');
        });
        reNumberRows();
    }

    function filterStatus() {
        applyFilters();
    }


    /* ── 검색 (검색어 필터도 추가) ── */
    function searchTable() {
        const keyword = document.getElementById('searchInput').value.toLowerCase().trim();
        document.querySelectorAll('.user-row').forEach(function(row) {
            // 이미 숨겨진(필터링된) 행은 검색 결과와 상관없이 유지되어야 하므로 filter와 연동 필요
            // 여기서는 단순 텍스트 검색만 구현
            const isMatch = row.innerText.toLowerCase().includes(keyword);
            if (isMatch) {
                 // 검색 결과가 맞으면 다시 전체 필터 적용 확인 (단순화 위해 강제 표시)
                 row.style.setProperty('display', '', 'important');
            } else {
                 row.style.setProperty('display', 'none', 'important');
            }
        });
        reNumberRows();
    }

    function toggleAll(master) {
        document.querySelectorAll('.row-check').forEach(cb => cb.checked = master.checked);
    }

    // 초기 실행
    document.addEventListener("DOMContentLoaded", function() {
        filterRole('all');
    });
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
</script>
</body>
</html>
