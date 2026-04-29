<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 권한 변수 설정: sessionScope에서 role을 가져옴 --%>
<c:set var="role" value="${sessionScope.sessionUser.role}" />
<c:set var="canEdit" value="${role eq 'ADMIN' or role eq 'PROFESSOR'}" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
<h1 class="page-title">${course.course_name} — 성적 관리</h1>

<c:choose>

    <%-- ══════════════════════════════════════
         [CASE 1] 관리자 / 교수: 성적 입력 폼
    ══════════════════════════════════════ --%>
    <c:when test="${canEdit}">

        <%-- 저장 성공/실패 알림 --%>
        <c:if test="${not empty saveResult}">
            <c:choose>
                <c:when test="${saveResult eq 'ok'}">
                    <div class="notice-badge" style="display:inline-flex; margin-bottom:1rem; background:#f6ffed; color:#52c41a; border:1px solid #b7eb8f;">
                        ✔ 성적이 저장되었습니다.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="notice-badge" style="display:inline-flex; margin-bottom:1rem;">
                        ✖ 저장에 실패했습니다. 다시 시도해주세요.
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/course/saveGradeList" id="gradeForm">
            <input type="hidden" name="course_no" value="${course.course_no}" />

            <div class="board-card">
                <table class="board-table attendance-table">
                    <colgroup>
                        <col style="width:10%">
                        <col style="width:10%">
                        <col style="width:23%">
                        <col style="width:23%">
                        <col style="width:23%">
                        <col style="width:11%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>학번</th>
                            <th>이름</th>
                            <th>중간고사</th>
                            <th>기말고사</th>
                            <th>출석</th>
                            <th>학점</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="student" items="${studentList}" varStatus="vs">
                            <tr data-idx="${vs.index}">
                                <%-- 학생 번호를 hidden으로 전송 --%>
                                <input type="hidden" name="gradeList[${vs.index}].enrollmentNo" value="${student.enrollmentNo}" />
                                <input type="hidden" name="gradeList[${vs.index}].course_no" value="${course.course_no}" />
                                <td class="td-title" style="text-align:center !important;">${student.userCode}</td>

                                <td class="td-title" style="text-align:center !important;">${student.name}</td>

                                <%-- 중간 --%>
                                <td>
                                    <input type="text"
                                           name="gradeList[${vs.index}].midterm"
                                           class="score midterm"
                                           inputmode="numeric"
                                           pattern="[0-9]*"
                                           placeholder="0 ~ 100"
                                           value="${student.midterm}"
                                           maxlength="3" />
                                </td>

                                <%-- 기말 --%>
                                <td>
                                    <input type="text"
                                           name="gradeList[${vs.index}].finalScore"
                                           class="score final"
                                           inputmode="numeric"
                                           pattern="[0-9]*"
                                           placeholder="0 ~ 100"
                                           value="${student.finalScore}"
                                           maxlength="3" />
                                </td>

                                <%-- 출석 --%>
                                <td>
                                    <input type="text"
                                           name="gradeList[${vs.index}].attendance"
                                           class="score attendance"
                                           inputmode="numeric"
                                           pattern="[0-9]*"
                                           placeholder="0 ~ 100"
                                           value="${student.attendance}"
                                           maxlength="3" />
                                </td>

                                <%-- 학점: hidden + 표시용 span --%>
                                <td class="td-no">
                                    <input type="hidden"
                                           name="gradeList[${vs.index}].alphabet"
                                           class="grade-hidden"
                                           value="${student.alphabet}" />
                                    <span class="grade-display badge">
                                        <c:choose>
                                            <c:when test="${not empty student.alphabet}">${student.alphabet}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty studentList}">
                            <tr class="empty-row">
                                <td colspan="5">
                                    <div class="empty-icon">📋</div>
                                    <div class="empty-text">수강 학생이 없습니다.</div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <div class="board-footer">
                <div class="board-footer-left">
                    <span class="td-date">중간 40% + 기말 40% + 출석 20%</span>
                </div>
                <div class="board-footer-right">
                    <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                    <button type="submit" class="btn-submit" onclick="return validateAndSetGrades()">
                        💾 저장
                    </button>
                </div>
            </div>

        </form>

        <style>
        .score {
            width: 80%;
            height: 38px;
            font-size: 15px;
            text-align: center;
            border: 1.5px solid var(--lms-border);
            border-radius: var(--lms-radius-sm);
            background: var(--lms-bg-white);
            color: var(--lms-text-main);
            transition: border-color .18s, box-shadow .18s;
        }
        .score:focus {
            border-color: var(--lms-accent);
            outline: none;
            box-shadow: 0 0 0 3px rgba(37,99,235,.12);
        }
        .grade-display {
            font-weight: 700;
            font-size: 1rem;
            min-width: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 4px 12px;
        }
        .grade-A  { background:#f0fdf4; color:#15803d; border:1px solid #bbf7d0; }
        .grade-B  { background:#eff6ff; color:#1d4ed8; border:1px solid #bfdbfe; }
        .grade-C  { background:#fffbeb; color:#a16207; border:1px solid #fde68a; }
        .grade-D  { background:#fff7ed; color:#c2410c; border:1px solid #fed7aa; }
        .grade-F  { background:#fff1f2; color:#b91c1c; border:1px solid #fecdd3; }
        .attendance-table td { padding: 12px 8px; }
        .attendance-table th { text-align: center; }
        </style>

        <script>
        /* ── 실시간 학점 계산 ── */
        function calcGrade(total) {
            if (total >= 95) return "A+";
            if (total >= 90) return "A";
            if (total >= 85) return "B+";
            if (total >= 80) return "B";
            if (total >= 75) return "C+";
            if (total >= 70) return "C";
            if (total >= 60) return "D";
            return "F";
        }

        function gradeColorClass(g) {
            if (g.startsWith("A")) return "grade-A";
            if (g.startsWith("B")) return "grade-B";
            if (g.startsWith("C")) return "grade-C";
            if (g === "D")         return "grade-D";
            return "grade-F";
        }

        function updateRow(input) {
            /* 숫자 외 문자 제거 + 100 초과 방지 */
            input.value = input.value.replace(/[^0-9]/g, "");
            if (parseInt(input.value) > 100) input.value = 100;

            const row  = input.closest("tr");
            const mid  = parseFloat(row.querySelector(".midterm").value)  || 0;
            const fin  = parseFloat(row.querySelector(".final").value)    || 0;
            const att  = parseFloat(row.querySelector(".attendance").value)|| 0;
            const total = mid * 0.4 + fin * 0.4 + att * 0.2;

            const grade   = calcGrade(total);
            const display = row.querySelector(".grade-display");
            const hidden  = row.querySelector(".grade-hidden");

            display.textContent = grade;
            display.className   = "grade-display badge " + gradeColorClass(grade);
            hidden.value        = grade;
        }

        /* ── 초기화: 기존 값이 있으면 학점 바로 계산 ── */
        document.querySelectorAll("tbody tr[data-idx]").forEach(row => {
            const mid = row.querySelector(".midterm");
            if (mid && mid.value !== "") updateRow(mid);
        });

        /* ── input 이벤트 연결 ── */
        document.querySelectorAll("input.score").forEach(el => {
            el.addEventListener("input", function() { updateRow(this); });
        });

        /* ── 제출 전 검증 + hidden 학점 세팅 ── */
        function validateAndSetGrades() {
            const rows = document.querySelectorAll("tbody tr[data-idx]");
            let valid = true;

            rows.forEach(row => {
                const mid = row.querySelector(".midterm").value.trim();
                const fin = row.querySelector(".final").value.trim();
                const att = row.querySelector(".attendance").value.trim();
                const grd = row.querySelector(".grade-hidden").value;

                if (mid === "" || fin === "" || att === "" || grd === "") {
                    valid = false;
                }
            });

            if (!valid) {
                alert("모든 점수를 입력해주세요!");
                return false;
            }
            return true;
        }
        </script>

    </c:when>

    <%-- ══════════════════════════════════════
      [CASE 2] 학생: 본인 성적 조회 (읽기 전용)
 ══════════════════════════════════════ --%>
    <c:when test="${role eq 'STUDENT'}">

        <%-- 1. 리스트를 뒤져서 본인(userNo=23) 데이터 찾기 --%>
        <c:set var="myInfo" value="${null}" />
        <c:forEach var="s" items="${studentList}">
            <c:if test="${s.userNo eq sessionScope.sessionUser.userNo}">
                <c:set var="myInfo" value="${s}" />
            </c:if>
        </c:forEach>

        <c:choose>
            <%-- 2. 내 데이터(myInfo)가 존재할 때만 출력 --%>
            <c:when test="${not empty myInfo}">
                <div class="stat-grid" style="margin-bottom:1.5rem;">
                    <div class="stat-card">
                        <div class="stat-label">중간고사</div>
                        <div class="stat-value">
                                ${myInfo.midterm} <small>/100</small>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">기말고사</div>
                        <div class="stat-value">
                                ${myInfo.finalScore} <small>/100</small>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">출석</div>
                        <div class="stat-value">
                                ${myInfo.attendance} <small>/100</small>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">최종 학점</div>
                        <div class="stat-value" style="color:var(--lms-accent); font-weight:bold;">
                                ${myInfo.alphabet}
                        </div>
                    </div>
                </div>

                <%-- 상세 테이블 --%>
                <div class="board-card">
                    <table class="board-table">
                        <thead>
                        <tr>
                            <th>중간(40%)</th>
                            <th>기말(40%)</th>
                            <th>출석(20%)</th>
                            <th>총점</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>${myInfo.midterm}점</td>
                            <td>${myInfo.finalScore}점</td>
                            <td>${myInfo.attendance}점</td>
                            <td style="font-weight:bold;">
                                    ${myInfo.midterm * 0.4 + myInfo.finalScore * 0.4 + myInfo.attendance * 0.2}점
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </c:when>

            <%-- 3. 내 데이터가 없을 때 --%>
            <c:otherwise>
                <div class="board-card" style="padding:3rem; text-align:center;">
                    <div class="empty-icon">📋</div>
                    <div class="empty-text">아직 성적이 등록되지 않았습니다.</div>
                </div>
            </c:otherwise>
        </c:choose>
    </c:when>

    <%-- ══════════════════════════════════════
         [CASE 3] 권한 없음 (비정상 접근)
    ══════════════════════════════════════ --%>
    <c:otherwise>
        <div class="board-card" style="padding:3rem; text-align:center;">
            <div class="empty-icon">🚫</div>
            <div class="empty-text" style="font-size:1rem; margin-top:0.5rem;">
                접근 권한이 없습니다.
            </div>
        </div>
    </c:otherwise>

</c:choose>
