<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
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
.attendance-table td { padding: 15px; border: 1px solid #d0d7f0; font-size: 18px; }
.grade { font-weight: bold; font-size: 20px; color: #0d4d94; }
</style>

<h1>${Course.course_name}</h1>
<br>
<hr>
<br>
<c:choose>
    <c:when test="${empty gradeMap}">
        <p style="text-align:center; color:#888; margin-top:30px;">아직 등록된 성적이 없습니다.</p>
    </c:when>
    <c:otherwise>
        <table class="attendance-table">
            <thead>
                <tr>
                    <th>중간</th>
                    <th>기말</th>
                    <th>출석</th>
                    <th>학점</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>${gradeMap.MIDTERM.score}</td>
                    <td>${gradeMap.FINAL.score}</td>
                    <td>${gradeMap.ATTENDANCE.score}</td>
                    <td class="grade">${gradeMap.MIDTERM.alphabet}</td>
                </tr>
            </tbody>
        </table>
    </c:otherwise>
</c:choose>