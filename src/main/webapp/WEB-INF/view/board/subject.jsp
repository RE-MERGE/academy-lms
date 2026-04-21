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
            <p style="margin: 0;">23359-01</p>
            <p style="margin: 0;">203관(서라벌홀) 817호 &lt;강의실&gt;</p>
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

<div style="text-align: right; padding: 15px 0; font-size: 16px;">
    출석 <span id="count-present" style="color: blue; font-weight: bold;">0</span>회 / 
    지각 <span id="count-late" style="color: orange; font-weight: bold;">0</span>회 / 
    결석 <span id="count-absent" style="color: red; font-weight: bold;">0</span>회
</div>

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
	        <td class="cell-status">
	            <select class="status-select" onchange="updateCounts()"
                    style="padding: 6px 12px; border-radius: 6px; border: 1px solid #d0d7f0; font-size: 14px; cursor: pointer;">
                    <option value="NONE">강의 예정</option>
                    <option value="PRESENT">✔ 출석</option>
                    <option value="LATE">⏰ 지각</option>
                    <option value="ABSENT">✖ 결석</option>
                    <option value="EXCUSED">📋 자퇴</option>
                </select>
	        </td>
	    </tr>
	</c:forEach>

</tbody>
</table>
<script>
    function toggleDropdown() {
        const dropdown = document.getElementById('courseDropdown');
        dropdown.style.display = dropdown.style.display === 'none' ? 'block' : 'none';
    }

    function changeCourse(course_no) {
        location.href = '${pageContext.request.contextPath}/board/subject?no=' + course_no;
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
    	document.querySelectorAll('.status-select').forEach(function(select) {
    		if(select.value === 'PRESENT') present++;
    		else if(select.value === 'LATE') late++;
    		else if(select.value === 'ABSENT') absent++;
    	});
    	document.getElementById('count-present').textContent = present;
    	document.getElementById('count-late').textContent = late;
    	document.getElementById('count-absent').textContent = absent;
    }
</script>
</body>  
