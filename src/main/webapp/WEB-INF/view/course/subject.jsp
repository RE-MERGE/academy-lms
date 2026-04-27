<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>과목</title>
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

.custom-modal {
    display: none; 
    position: fixed; 
    z-index: 1000; 
    left: 0; top: 0;
    width: 100%; height: 100%;
    background-color: rgba(0,0,0,0.5);
}
/* 모달 박스 */
.modal-content {
    background-color: #fff;
    margin: 15% auto;
    padding: 20px;
    width: 50%;
    border-radius: 8px;
}
	/* 닫기 버튼 */
.close-btn {
    float: right;
    font-size: 24px;
    cursor: pointer;
}
.btn-attendance {
    background-color: #fff;
    color: #4f46e5; /* 세련된 인디고 블루 */
    border: 1.5px solid #4f46e5;
    padding: 6px 14px;
    border-radius: 20px; /* 둥근 캡슐 형태 */
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

/* 모달 배경 (Overlay) */
.modern-modal {
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.5);
    z-index: 1000;
    justify-content: center;
    align-items: center;
}

/* 모달 컨테이너 */
.modal-container {
    position: relative;
    background-color: #fff;
    margin: 5% auto;
    padding: 0;
    width: 700px;        /* 400px → 700px */
    max-width: 90vw;     /* 화면 너비 90% 초과 방지 */
    max-height: 80vh;    /* 높이 제한 */
    overflow-y: auto;    /* 내용 많으면 스크롤 */
    border-radius: 16px;
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    animation: slideDown 0.3s ease-out;
}

/* 헤더, 바디, 푸터 */
.modal-header {
    padding: 20px;
    border-bottom: 1px solid #f3f4f6;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.modal-header h3 { margin: 0; font-size: 18px; color: #111827; }

.modal-body { padding: 20px; color: #4b5563; }

.modal-footer {
    padding: 15px 20px;
    text-align: right;
    background-color: #f9fafb;
    border-bottom-left-radius: 16px;
    border-bottom-right-radius: 16px;
}

/* 확인 버튼 */
.btn-confirm {
    background-color: #111827;
    color: white;
    border: none;
    padding: 8px 20px;
    border-radius: 8px;
    cursor: pointer;
}

/* 닫기 애니메이션 */
@keyframes slideDown {
    from { opacity: 0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
}

/* 닫기 버튼 (X) */
.close-btn { font-size: 28px; cursor: pointer; color: #9ca3af; }
.close-btn:hover { color: #111827; }
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
</head>
<body>
<div style="display: flex; justify-content: space-between; align-items: flex-end; padding: 20px 0; font-family: sans-serif;">
    
    <div style="flex: 1; text-align: left;">
        <div style="display: flex; align-items: baseline; position: relative;">
    <h1 id="courseNameDisplay" 
        style="margin: 0; color: #004595; font-size: 28px; cursor: pointer;" 
        onclick="toggleDropdown()">
        ${Course.course_name} <span style="font-size: 18px;">▾</span>
    </h1>
    
    <!-- 커스텀 드롭다운 -->
    <div id="courseDropdown" style="
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        background: #fff;
        border: 1px solid #d0d7f0;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        z-index: 999;
        min-width: 220px;
        overflow: hidden;
    ">
        <c:forEach var="c" items="${courseList}">
            <div onclick="changeCourse(${c.course_no})" style="
                padding: 12px 20px;
                font-size: 16px;
                cursor: pointer;
                color: ${c.course_no == Course.course_no ? '#fff' : '#333'};
                background: ${c.course_no == Course.course_no ? '#004595' : '#fff'};
                font-weight: ${c.course_no == Course.course_no ? 'bold' : 'normal'};
            "
            onmouseover="if(${c.course_no} !== ${Course.course_no}) this.style.background='#f0f5ff'"
            onmouseout="if(${c.course_no} !== ${Course.course_no}) this.style.background='#fff'"
            >
                ${c.course_name}
            </div>
        </c:forEach>
    </div>

    <span style="margin-left: 10px; color: #666;">${Course.credits}학점</span>
</div>
        <div style="margin-top: 10px; color: #888; font-size: 13px; line-height: 1.5;">
            <p style="margin: 0;">${Course.course_type }</p>
            <p style="margin: 0;">&lt;강의실&gt; ${Course.room_info} </p>
        </div>
    </div>

    <div style="flex: 1; text-align: center;">
        <p style="margin: 0 0 5px 0; color: #888; font-size: 14px;">담당교수</p>
        <h2 style="margin: 0; color: #004595; font-size: 24px;">${profName} <span style="color: #333; font-size: 20px; font-weight: normal;">교수님</span></h2>
    </div>

    <div style="flex: 1; display: flex; justify-content: flex-end;">
        <div style="border: 1px solid #ddd; padding: 15px; background: #fff; box-shadow: 2px 2px 5px rgba(0,0,0,0.05); min-width: 180px;">
            <p style="margin: 0 0 8px 0; font-weight: bold; display: flex; align-items: center;">
                <span style="background: #333; color: #fff; border-radius: 50%; width: 18px; height: 18px; display: inline-flex; justify-content: center; align-items: center; font-size: 10px; margin-right: 5px;">✔</span>
                강의일시
            </p>
            <p style="margin: 2px 0; font-size: 14px;">${Course.semester}학기</p>
            <p style="margin: 2px 0; font-size: 14px;">${Course.day_of_week}요일 ${Course.start_time} ~ ${Course.end_time}</p>
        </div>
    </div>
</div>

<hr style="border: 0; border-top: 2px solid #ccc; margin: 0;">

<c:if test="${sessionScope.sessionUser.role == 'STUDENT'}">
<div style="text-align: right; padding: 15px 0; font-size: 16px;">
    출석 <span style="color: blue; font-weight: bold;">${presentCount}</span>회 / 
    지각 <span style="color: orange; font-weight: bold;">${lateCount}</span>회 / 
    결석 <span style="color: red; font-weight: bold;">${absentCount}</span>회
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
	        <td class="cell-date">
	            <div class="week-label">${i}주차</div>
	            <div class="date-label">${Course.day_of_week}요일</div>
	        </td>
	        <td class="cell-time">
	            ${Course.start_time} ~ ${Course.end_time}
	        </td>
	<c:choose>
    <c:when test="${sessionScope.sessionUser.role == 'PROFESSOR' or sessionScope.sessionUser.role == 'ADMIN'}">
        <%-- 교수용 --%>
        <td>
            <button type="button" class="btn-attendance" 
		        data-week="${i}"
		        onclick="openModal('modal', this.getAttribute('data-week'))">
		   		<i class="fas fa-check-circle"></i> 출석확인
			</button>
        </td>
    </c:when>
    <c:otherwise>
        <%-- 학생용 --%>
        <td class="cell-status">
        <c:set var="idx" value="${i - 1}"/>
            <c:if test="${idx < AttendanceList.size()}">
            <c:set var="s" value="${AttendanceList[idx]}"/>
                <c:choose>
                    <c:when test="${s.status == 'PRESENT'}">출석완료</c:when>
                    <c:when test="${s.status == 'LATE'}">지각</c:when>
                    <c:when test="${s.status == 'ABSENT'}">결석</c:when>
                    <c:otherwise>강의 예정</c:otherwise>
                </c:choose>
                </c:if>
                <c:if test="${idx >= AttendanceList.size()}">
                        강의 예정
                </c:if>
        </td>
    </c:otherwise>
</c:choose>
</tr>
</c:forEach>
</tbody>
</table>
<div id="modal" class="modern-modal">
    <div class="modal-container">
        <div class="modal-header">
            <h3>출석 현황 상세보기</h3>
            <span class="close-btn" onclick="closeModal('modal')">&times;</span>
        </div>
        <div class="modal-body">
    <table style="width: 100%; border-collapse: collapse;">
        <thead>
            <tr style="background-color: #004595; color: white;">
                <th style="padding: 10px; border: 1px solid #003a7d;">이름</th>
                <th style="padding: 10px; border: 1px solid #003a7d;">학번</th>
                <th style="padding: 10px; border: 1px solid #003a7d;">이메일</th>
                <th style="padding: 10px; border: 1px solid #003a7d;">출결 상태</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="student" items="${studentList}">
                <tr style="text-align: center; background-color: #f8faff;">
                    <td style="padding: 12px; border: 1px solid #d0d7f0;">${student.name}</td>
                    <td style="padding: 12px; border: 1px solid #d0d7f0;">${student.userCode}</td>
                    <td style="padding: 12px; border: 1px solid #d0d7f0;">${student.email}</td>
                    <td style="padding: 12px; border: 1px solid #d0d7f0;">
                        <select class="attendance-select" data-userno="${student.userNo}" 
                        style="padding: 6px 12px; border-radius: 6px; border: 1px solid #d0d7f0;">
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
            <button class="btn-confirm" onclick="saveAttendance()">확인</button>
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

    // 외부 클릭시 닫기
    document.addEventListener('click', function(e) {
        const display = document.getElementById('courseNameDisplay');
        const dropdown = document.getElementById('courseDropdown');
        if (!display.contains(e.target) && !dropdown.contains(e.target)) {
            dropdown.style.display = 'none';
        }
    });
    
    document.addEventListener('DOMContentLoaded', function() {
    	updateCounts();
    });
    
    function updateCounts() {
        let present = 0, late = 0, absent = 0;
        document.querySelectorAll('.attendance-select').forEach(function(select) {
            if (select.value === 'PRESENT') present++;
            else if (select.value === 'LATE') late++;
            else if (select.value === 'ABSENT') absent++;
        });
        document.getElementById('count-present').textContent = present;
        document.getElementById('count-late').textContent = late;
        document.getElementById('count-absent').textContent = absent;
    }
    
    function openModal(id, week) {
        document.getElementById(id).dataset.week = week;
        document.getElementById(id).style.display = "flex";
        document.body.style.overflow = "hidden";
        document.querySelectorAll('.attendance-select').forEach(function(select) {
            select.addEventListener('change', updateCounts);
        });
        updateCounts();  // 모달 열릴 때 초기 카운트
    }

    function closeModal(id) {
        document.getElementById(id).style.display = "none";
        document.body.style.overflow = "auto";
    }

    window.onclick = function(event) {
        if (event.target.className === 'modern-modal') {
            event.target.style.display = "none";
            document.body.style.overflow = "auto";
        }
    }
    
    function saveAttendance() {
        const courseNo = "${Course.course_no}";
        const contextPath = "${pageContext.request.contextPath}";
        const today = new Date().toISOString().split('T')[0];
        const week = document.getElementById("modal").dataset.week;
        const rows = document.querySelectorAll(".attendance-select");
        const attendanceList = [];

        rows.forEach(function(select) {  // ← 화살표 함수 대신 일반 함수
            const item = {
                user_no: select.dataset.userno,
                course_no: courseNo,
                attendance_date: today,
                week: week,
                status: select.value
            };
            attendanceList.push(item);
        });

        fetch(contextPath + "/course/saveAttendance", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(attendanceList)
        })
        .then(res => res.text())
        .then(result => {
            if (result === "ok") {
                alert("출결 저장 완료!");
                closeModal('modal');
            } else {
                alert("저장 실패!");
            }
        })
        .catch(err => console.error("저장 오류:", err));
    }
</script>
</body>  
