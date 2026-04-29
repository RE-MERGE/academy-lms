<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Sitemesh가 <head>에 삽입할 타이틀 --%>
<title>${Course.course_name} - 출결 관리</title>

<%-- Sitemesh가 레이아웃의 <head> 부분에 합칠 스타일 --%>
<style>
    /* 출결 요약 */
    .attendance-summary { text-align: right; padding: 15px 0; font-size: 16px; }
    .count-p { color: #004595; font-weight: bold; }
    .count-l { color: #f39c12; font-weight: bold; }
    .count-a { color: #e74c3c; font-weight: bold; }

    /* 테이블 스타일 */
    .attendance-table {
        width: 100%;
        border-collapse: collapse;
        border-radius: 10px 10px 0 0;
        overflow: hidden;
        table-layout: fixed;
    }
    .attendance-table thead { background-color: #004595; color: white; }
    .attendance-table th { padding: 12px; border: 1px solid #003a7d; }
    .attendance-table tbody { text-align: center; background-color: #f8faff; }
    .attendance-table td { padding: 15px; border: 1px solid #d0d7f0; }

    /* 버튼 스타일 */
    .btn-attendance {
        background-color: #fff;
        color: #4f46e5;
        border: 1.5px solid #4f46e5;
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    .btn-attendance:hover {
        background-color: #4f46e5;
        color: #fff;
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
    }

    /* 모달 스타일 */
    .modern-modal {
        display: none;
        position: fixed;
        top: 0; left: 0;
        width: 100%; height: 100%;
        background: rgba(0,0,0,0.5);
        z-index: 2000; /* 사이드바보다 위에 오도록 조정 */
        justify-content: center;
        align-items: center;
    }
    .modal-container {
        position: relative;
        background-color: #fff;
        width: 700px;
        max-width: 90vw;
        max-height: 80vh;
        overflow-y: auto;
        border-radius: 16px;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        animation: slideDown 0.3s ease-out;
    }
    .modal-header { padding: 20px; border-bottom: 1px solid #f3f4f6; display: flex; justify-content: space-between; align-items: center; }
    .attendance-modal-body { padding: 20px; }
    .modal-footer { padding: 15px 20px; text-align: right; background-color: #f9fafb; border-bottom-left-radius: 16px; border-bottom-right-radius: 16px; }
    .btn-confirm { background-color: #111827; color: white; border: none; padding: 8px 20px; border-radius: 8px; cursor: pointer; }
    .close-btn { font-size: 28px; cursor: pointer; color: #9ca3af; }

    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-20px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>

<%-- 실제 본문 콘텐츠 (레이니지 레이아웃의 body 부분에 들어감) --%>
<c:choose>
    <c:when test="${empty courseList}">
        <div style="text-align: center; padding: 80px; color: #888;">
            <p style="font-size: 20px; font-weight: bold; color: #004595; margin-bottom: 15px;">
                수강 중인 과목이 없습니다.
            </p>
            <a href="${pageContext.request.contextPath}/enrollment/courseEnrollment" 
               style="color: #4f46e5; font-size: 16px; font-weight: bold;">
                수강신청 바로가기 →
            </a>
        </div>
    </c:when>
    <c:otherwise>
<div class="subject-content-wrapper">
    <div style="display: flex; justify-content: space-between; align-items: flex-end; padding: 20px 0; font-family: sans-serif;">
        <div style="flex: 1; text-align: left;">
            <div style="display: flex; align-items: baseline; position: relative;">
                <c:set var="isMyCourse" value="false" />
                <c:forEach var="my" items="${courseList}">
                    <c:if test="${my.course_no == Course.course_no}"><c:set var="isMyCourse" value="true" /></c:if>
                </c:forEach>
                <div id="courseNameDisplay" style="margin: 0; color: #004595; font-size: 28px; cursor: pointer; display: flex; align-items: center;" onclick="toggleDropdown()">
                    <h1 style="margin: 0; color: inherit; font-size: inherit; pointer-events: none;">
                        <c:choose>
                            <c:when test="${isMyCourse}">${Course.course_name}</c:when>
                            <c:otherwise>내 강의 목록 보기</c:otherwise>
                        </c:choose>
                        <span style="font-size: 18px; margin-left: 5px;">▾</span>
                    </h1>
                </div>

                <div id="courseDropdown" style="display: none; position: absolute; top: 110%; left: 0; background: #fff; border: 1px solid #d0d7f0; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.15); z-index: 1000; min-width: 240px;">
                    <c:forEach var="c" items="${courseList}">
                        <c:if test="${(sessionScope.sessionUser.role == 'PROFESSOR' and sessionScope.sessionUser.userNo == c.professor_no) or sessionScope.sessionUser.role == 'STUDENT'}">
                            <div onclick="changeCourse(${c.course_no})" style="padding: 12px 20px; cursor: pointer; background: ${c.course_no == Course.course_no ? '#004595' : '#fff'}; color: ${c.course_no == Course.course_no ? '#fff' : '#333'};">
                                ${c.course_name}
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
            <div style="margin-top: 10px; color: #888; font-size: 13px;">
                <p style="margin: 0;">${Course.course_type} | ${Course.credits}학점</p>
                <p style="margin: 0;">&lt;강의실&gt; ${Course.room_info}</p>
            </div>
        </div>

        <div style="flex: 1; text-align: center;">
            <p style="margin: 0 0 5px 0; color: #888; font-size: 14px;">담당교수</p>
            <h2 style="margin: 0; color: #004595; font-size: 24px;">${profName} 교수님</h2>
        </div>

        <div style="flex: 1; display: flex; justify-content: flex-end;">
            <div style="border: 1px solid #ddd; padding: 15px; background: #fff; min-width: 180px;">
                <p style="margin: 0 0 8px 0; font-weight: bold;">✔ 강의일시</p>
                <p style="margin: 2px 0; font-size: 14px;">${Course.semester}학기 / ${Course.day_of_week}요일</p>
                <p style="margin: 2px 0; font-size: 14px;">${Course.start_time} ~ ${Course.end_time}</p>
            </div>
        </div>
    </div>

    <hr style="border: 0; border-top: 2px solid #ccc; margin: 0;">

    <c:if test="${sessionScope.sessionUser.role == 'STUDENT'}">
        <div class="attendance-summary">
            출석 <span style="color: blue;">${presentCount}</span>회 / 
            지각 <span style="color: orange;">${lateCount}</span>회 / 
            결석 <span style="color: red;">${absentCount}</span>회
        </div>
    </c:if>

    <table class="attendance-table">
        <thead>
            <tr>
                <th style="width: 25%;">날짜</th>
                <th style="width: 45%;">강의시간</th>
                <th style="width: 30%;">출결 상태</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="i" begin="1" end="16">
                <tr>
                    <td>${i}주차 (${Course.day_of_week})</td>
                    <td>${Course.start_time} ~ ${Course.end_time}</td>
                    <td>
                        <c:choose>
                            <c:when test="${sessionScope.sessionUser.role == 'PROFESSOR' or sessionScope.sessionUser.role == 'ADMIN'}">
                                <button type="button" class="btn-attendance" onclick="openModal('modal', ${i})">출석확인</button>
                            </c:when>
                            <c:otherwise>
                                <c:set var="idx" value="${i - 1}"/>
                                <c:choose>
                                    <c:when test="${idx < AttendanceList.size()}">
                                        <c:set var="s" value="${AttendanceList[idx]}"/>
                                        <c:choose>
                                            <c:when test="${s.status == 'PRESENT'}">출석완료</c:when>
                                            <c:when test="${s.status == 'LATE'}">지각</c:when>
                                            <c:when test="${s.status == 'ABSENT'}">결석</c:when>
                                            <c:otherwise>강의 예정</c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>강의 예정</c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
</c:otherwise>
</c:choose>

<div id="modal" class="modern-modal">
    <div class="modal-container">
        <div class="modal-header">
            <h3>출석 현황 상세보기 (<span id="modal-week-display"></span>주차)</h3>
            <span class="close-btn" onclick="closeModal('modal')">&times;</span>
        </div>
        <div class="attendance-modal-body">
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background-color: #004595; color: white;">
                        <th style="padding: 10px;">이름</th>
                        <th style="padding: 10px;">학번</th>
                        <th style="padding: 10px;">출결 상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="student" items="${studentList}">
                        <tr style="text-align: center;">
                            <td style="padding: 12px; border-bottom: 1px solid #eee;">${student.name}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #eee;">${student.userCode}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #eee;">
                                <select class="attendance-select" data-userno="${student.userNo}">
                                    <option value="PRESENT">출석</option>
                                    <option value="LATE">지각</option>
                                    <option value="ABSENT">결석</option>
                                </select>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="modal-footer">
            <button class="btn-confirm" onclick="saveAttendance()">출결 저장</button>
        </div>
    </div>
</div>

<script>
    function toggleDropdown() {
        const dropdown = document.getElementById('courseDropdown');
        dropdown.style.display = dropdown.style.display === 'none' ? 'block' : 'none';
    }

    function changeCourse(course_no) {
        location.href = '${pageContext.request.contextPath}/course/subject?no=' + course_no;
    }

    function openModal(id, week) {
        document.getElementById(id).style.display = "flex";
        document.getElementById("modal-week-display").innerText = week;
        document.getElementById(id).dataset.week = week;
    }

    function closeModal(id) {
        document.getElementById(id).style.display = "none";
    }

    function saveAttendance() {
        const courseNo = "${Course.course_no}";
        const week = document.getElementById("modal").dataset.week;
        const selects = document.querySelectorAll(".attendance-select");
        const attendanceList = [];

        selects.forEach(sel => {
            attendanceList.push({
                user_no: sel.dataset.userno,
                course_no: courseNo,
                week: week,
                status: sel.value,
                attendance_date: new Date().toISOString().split('T')[0]
            });
        });

        fetch("${pageContext.request.contextPath}/course/saveAttendance", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(attendanceList)
        })
        .then(res => res.text())
        .then(result => {
            if (result === "ok") {
                alert("성공적으로 저장되었습니다.");
                closeModal('modal');
            }
        });
    }

    // 드롭다운 외부 클릭 시 닫기
    document.addEventListener('click', function(e) {
    const display = document.getElementById('courseNameDisplay');
    const dropdown = document.getElementById('courseDropdown');
    if (!display.contains(e.target) && !dropdown.contains(e.target)) {
        dropdown.style.display = 'none';
    }
});

window.onclick = function(e) {
    if (e.target.classList.contains('modern-modal')) {
        closeModal('modal');
    }
}
</script>