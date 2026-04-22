<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>성적 관리</title>
<style>
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
.grade-table {
    width: 100%;
    border-collapse: collapse;
    border-radius: 10px 10px 0 0;
    overflow: hidden;
    table-layout: fixed;
    font-family: sans-serif;
}
.grade-table thead { background-color: #004595; color: #fff; }
.grade-table th {
    padding: 12px 8px;
    border: 1px solid #003a7d;
    font-size: 14px;
    white-space: nowrap;
    text-align: center;
}
.grade-table th.sortable { cursor: pointer; user-select: none; }
.grade-table th.sortable:hover { background-color: #003a7d; }
.sort-icon { margin-left: 3px; font-size: 11px; }

.grade-table tbody { text-align: center; background-color: #f8faff; }
.grade-table td {
    padding: 10px 8px;
    border: 1px solid #d0d7f0;
    font-size: 14px;
    text-align: center;
}
.grade-table tbody tr:hover { background-color: #eef3fb; }

/* ── 점수 입력칸 ── */
.score-input {
    width: 70px;
    padding: 5px 8px;
    border: 1.5px solid #d0d7f0;
    border-radius: 6px;
    font-size: 14px;
    text-align: center;
    background: #fff;
    outline: none;
    transition: border-color .15s;
}
.score-input:focus { border-color: #004595; background: #eef3fb; }
.score-input:disabled {
    background: transparent;
    border-color: transparent;
    color: #333;
    cursor: default;
}

/* ── 학점 뱃지 ── */
.grade-badge {
    display: inline-block;
    padding: 3px 12px;
    border-radius: 12px;
    font-size: 13px;
    font-weight: bold;
    min-width: 40px;
}
.grade-A  { color: #004595; }
.grade-B  { color: #27ae60; }
.grade-C  { color: #e6a817; }
.grade-D  { color: #e74c3c; }
.grade-F  { color: #c0392b; }

/* ── 버튼 ── */
.btn-edit {
    padding: 6px 16px;
    background: #c8d8f0;
    color: #004595;
    border: none;
    border-radius: 6px;
    font-size: 13px;
    font-weight: bold;
    cursor: pointer;
    transition: background .15s;
}
.btn-edit:hover { background: #aac0e8; }

.btn-save {
    padding: 6px 16px;
    background: #004595;
    color: #fff;
    border: none;
    border-radius: 6px;
    font-size: 13px;
    font-weight: bold;
    cursor: pointer;
    display: none;
    transition: background .15s;
}
.btn-save:hover { background: #003a7d; }

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
.btn-complete {
    padding: 10px 32px;
    background: #e6a817;
    color: #fff;
    border: none;
    border-radius: 6px;
    font-size: 15px;
    font-weight: bold;
    cursor: pointer;
    transition: background .15s;
}
.btn-complete:hover { background: #c98f10; }

.btn-edit-all {
    padding: 10px 32px;
    background: #c8d8f0;
    color: #004595;
    border: none;
    border-radius: 6px;
    font-size: 15px;
    font-weight: bold;
    cursor: pointer;
    transition: background .15s;
}
.btn-edit-all:hover { background: #aac0e8; }

.guide-text { font-size: 13px; color: #555; text-decoration: underline; text-underline-offset: 2px; }
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
</head>
<body>

<div style="font-family: sans-serif; padding: 10px 0 20px 0;">

    <h2 style="margin: 0 0 18px 0; color: #004595; font-size: 22px; font-weight: bold;">성적 관리</h2>

    <!-- 상단 컨트롤 바 -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
        <span class="guide-text">학생의 중간·기말·출석 점수를 입력하면 총점과 학점이 자동 계산됩니다.</span>
        <div class="search-wrap">
            <span style="font-size: 16px; color: #aaa;">🔍</span>
            <input type="text" id="searchInput" placeholder="" onkeyup="searchTable()"/>
            <button onclick="searchTable()">검색</button>
        </div>
    </div>

    <!-- 테이블 -->
    <table class="grade-table" id="gradeTable">
        <thead>
            <tr>
                <th style="width: 14%;" class="sortable" onclick="sortTable('name')" id="th-name">
                    학생 <span class="sort-icon" id="icon-name">▼</span>
                </th>
                <th style="width: 10%;">학번</th>
                <th style="width: 12%;" class="sortable" onclick="sortTable('midterm')" id="th-midterm">
                    중간 <span class="sort-icon" id="icon-midterm">▼</span>
                </th>
                <th style="width: 12%;" class="sortable" onclick="sortTable('final')" id="th-final">
                    기말 <span class="sort-icon" id="icon-final">▼</span>
                </th>
                <th style="width: 12%;" class="sortable" onclick="sortTable('attend')" id="th-attend">
                    출석 <span class="sort-icon" id="icon-attend">▼</span>
                </th>
                <th style="width: 12%;" class="sortable" onclick="sortTable('total')" id="th-total">
                    총점 <span class="sort-icon" id="icon-total">▼</span>
                </th>
                <th style="width: 12%;">학점</th>
                <th style="width: 10%;">수정</th>
            </tr>
        </thead>
        <tbody id="gradeTableBody">
            <c:forEach var="student" items="${studentList}" varStatus="status">
            <tr class="grade-row"
                data-no="${status.count}"
                data-name="${student.name}"
                data-student-id="${student.student_id}"
                data-midterm="${student.midterm}"
                data-final="${student.final_score}"
                data-attend="${student.attend}"
                data-total="${student.total}"
                data-grade-no="${student.grade_no}">

                <td>${student.name}</td>
                <td style="color: #888; font-size: 13px;">${student.student_id}</td>

                <!-- 중간 -->
                <td>
                    <input type="number" class="score-input input-midterm"
                           value="${student.midterm}" min="0" max="100" disabled
                           onchange="calcTotal(this)"/>
                </td>

                <!-- 기말 -->
                <td>
                    <input type="number" class="score-input input-final"
                           value="${student.final_score}" min="0" max="100" disabled
                           onchange="calcTotal(this)"/>
                </td>

                <!-- 출석 -->
                <td>
                    <input type="number" class="score-input input-attend"
                           value="${student.attend}" min="0" max="100" disabled
                           onchange="calcTotal(this)"/>
                </td>

                <!-- 총점 (자동계산) -->
                <td class="cell-total">${student.total}</td>

                <!-- 학점 (자동계산) -->
                <td class="cell-grade">
                    <span class="grade-badge ${student.total >= 90 ? 'grade-A' :
                                               student.total >= 80 ? 'grade-B' :
                                               student.total >= 70 ? 'grade-C' :
                                               student.total >= 60 ? 'grade-D' : 'grade-F'}">
                        ${student.total >= 90 ? 'A' :
                          student.total >= 80 ? 'B' :
                          student.total >= 70 ? 'C' :
                          student.total >= 60 ? 'D' : 'F'}
                    </span>
                </td>

                <!-- 수정 버튼 -->
                <td>
                    <button class="btn-edit"  onclick="toggleEdit(this, true)">수정</button>
                    <button class="btn-save"  onclick="saveRow(this)">저장</button>
                </td>
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
        <button class="btn-edit-all" onclick="editAll()">수정</button>
        <button class="btn-complete" onclick="completeAll()">완료</button>
    </div>

</div>

<script>
    /* ── 총점 자동 계산 ── */
    function calcTotal(input) {
        const row     = input.closest('tr');
        const midterm = parseFloat(row.querySelector('.input-midterm').value) || 0;
        const final_  = parseFloat(row.querySelector('.input-final').value)   || 0;
        const attend  = parseFloat(row.querySelector('.input-attend').value)  || 0;
        const total   = midterm + final_ + attend;

        row.querySelector('.cell-total').textContent = total;

        // 학점 계산
        let grade = 'F', cls = 'grade-F';
        if      (total >= 90) { grade = 'A'; cls = 'grade-A'; }
        else if (total >= 80) { grade = 'B'; cls = 'grade-B'; }
        else if (total >= 70) { grade = 'C'; cls = 'grade-C'; }
        else if (total >= 60) { grade = 'D'; cls = 'grade-D'; }

        const badge = row.querySelector('.cell-grade .grade-badge');
        badge.textContent = grade;
        badge.className = 'grade-badge ' + cls;
    }

    /* ── 행 수정 토글 ── */
    function toggleEdit(btn, editing) {
        const row = btn.closest('tr');
        row.querySelectorAll('.score-input').forEach(function(inp) {
            inp.disabled = !editing;
        });
        row.querySelector('.btn-edit').style.display = editing ? 'none'  : 'inline-block';
        row.querySelector('.btn-save').style.display = editing ? 'inline-block' : 'none';
    }

    /* ── 행 저장 ── */
    function saveRow(btn) {
        const row     = btn.closest('tr');
        const gradeNo = row.getAttribute('data-grade-no');
        const midterm = row.querySelector('.input-midterm').value;
        const final_  = row.querySelector('.input-final').value;
        const attend  = row.querySelector('.input-attend').value;
        const total   = row.querySelector('.cell-total').textContent;
        const grade   = row.querySelector('.cell-grade .grade-badge').textContent;

        fetch('${pageContext.request.contextPath}/grade/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ gradeNo, midterm, final: final_, attend, total, grade })
        })
        .then(function(res) {
            if (res.ok) {
                toggleEdit(btn, false);
                alert('저장되었습니다.');
            } else {
                alert('저장 실패. 다시 시도해주세요.');
            }
        })
        .catch(function() { alert('서버 오류가 발생했습니다.'); });
    }

    /* ── 전체 수정 모드 ── */
    function editAll() {
        document.querySelectorAll('.grade-row').forEach(function(row) {
            row.querySelectorAll('.score-input').forEach(function(inp) { inp.disabled = false; });
            row.querySelector('.btn-edit').style.display = 'none';
            row.querySelector('.btn-save').style.display = 'inline-block';
        });
    }

    /* ── 전체 완료 (일괄 저장) ── */
    function completeAll() {
        if (!confirm('모든 성적을 저장하시겠습니까?')) return;

        const dataList = [];
        document.querySelectorAll('.grade-row').forEach(function(row) {
            dataList.push({
                gradeNo : row.getAttribute('data-grade-no'),
                midterm : row.querySelector('.input-midterm').value,
                final   : row.querySelector('.input-final').value,
                attend  : row.querySelector('.input-attend').value,
                total   : row.querySelector('.cell-total').textContent,
                grade   : row.querySelector('.cell-grade .grade-badge').textContent
            });
        });

        fetch('${pageContext.request.contextPath}/grade/updateAll', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(dataList)
        })
        .then(function(res) {
            if (res.ok) {
                // 전체 입력칸 다시 비활성화
                document.querySelectorAll('.grade-row').forEach(function(row) {
                    row.querySelectorAll('.score-input').forEach(function(inp) { inp.disabled = true; });
                    row.querySelector('.btn-edit').style.display = 'inline-block';
                    row.querySelector('.btn-save').style.display = 'none';
                });
                alert('전체 성적이 저장되었습니다.');
            } else {
                alert('저장 실패. 다시 시도해주세요.');
            }
        })
        .catch(function() { alert('서버 오류가 발생했습니다.'); });
    }

    /* ── 정렬 ── */
    const sortState = { name: 'none', midterm: 'none', final: 'none', attend: 'none', total: 'none' };
    const attrMap   = { name: 'name', midterm: 'midterm', final: 'final', attend: 'attend', total: 'total' };

    function sortTable(key) {
        const tbody = document.getElementById('gradeTableBody');
        const rows  = Array.from(tbody.querySelectorAll('tr.grade-row'));
        const cur   = sortState[key];
        const next  = (cur === 'none' || cur === 'desc') ? 'asc' : 'desc';

        Object.keys(sortState).forEach(function(k) {
            sortState[k] = 'none';
            const el = document.getElementById('icon-' + k);
            if (el) el.textContent = '▼';
        });
        sortState[key] = next;
        document.getElementById('icon-' + key).textContent = next === 'asc' ? '▼' : '▲';

        rows.sort(function(a, b) {
            const valA = a.getAttribute('data-' + attrMap[key]) || '';
            const valB = b.getAttribute('data-' + attrMap[key]) || '';
            const numA = parseFloat(valA), numB = parseFloat(valB);
            if (!isNaN(numA) && !isNaN(numB)) {
                return next === 'asc' ? numA - numB : numB - numA;
            }
            return next === 'asc' ? valA.localeCompare(valB, 'ko') : valB.localeCompare(valA, 'ko');
        });
        rows.forEach(function(row) { tbody.appendChild(row); });
    }

    /* ── 검색 ── */
    function searchTable() {
        const keyword = document.getElementById('searchInput').value.toLowerCase().trim();
        document.querySelectorAll('.grade-row').forEach(function(row) {
            row.style.display = row.innerText.toLowerCase().includes(keyword) ? '' : 'none';
        });
    }
</script>
</body>
</html>
