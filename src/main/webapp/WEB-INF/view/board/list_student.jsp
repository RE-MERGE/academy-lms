<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<head>
  <title>${course.course_name} — 수강생 목록</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>

<body>
<div class="board-wrap">

  <!-- ── 페이지 헤더 ── -->
  <div class="write-header">
    <div class="header-title">
      <h2>${course.course_name}</h2>
      <p>${course.professor_name} 교수 &middot; ${course.semester} &middot; ${course.day_of_week} ${course.start_time}~${course.end_time}</p>
    </div>
    <div>
      <span class="category-tag cat-FREE">수강생 ${course.counts} / ${course.max_students}명</span>
    </div>
  </div>

  <!-- ── 학생 테이블 ── -->
  <div class="board-card">
    <table class="board-table">
      <colgroup>
        <col style="width:56px">
        <col style="width:110px">
        <col>
        <col style="width:200px">
        <col style="width:130px">
        <col style="width:110px">
      </colgroup>
      <thead>
      <tr>
        <th>No</th>
        <th>학번</th>
        <th style="text-align:left; padding-left:14px;">이름</th>
        <th>이메일</th>
        <th>수강신청일</th>
        <th>상태</th>
      </tr>
      </thead>
      <tbody>
      <c:choose>
        <c:when test="${empty students}">
          <tr class="empty-row">
            <td colspan="6">
              <div class="empty-icon">👤</div>
              <div class="empty-text">수강생이 없습니다.</div>
            </td>
          </tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="s" items="${students}" varStatus="loop">
            <tr>
              <td class="td-no">${loop.count}</td>
              <td class="td-no">${s.studentId}</td>
              <td class="td-title">
                <div class="title-inner">
                  <span class="title-text">${s.studentName}</span>
                </div>
              </td>
              <td style="font-size:0.85rem; color:var(--lms-text-sub);">${s.email}</td>
              <td class="td-date">${s.enrolledAt}</td>
              <td>
                <c:choose>
                  <c:when test="${s.status == 'APPROVED'}">
                    <span class="category-tag cat-QNA">승인</span>
                  </c:when>
                  <c:when test="${s.status == 'APPLIED'}">
                    <span class="category-tag cat-FREE">신청</span>
                  </c:when>
                  <c:otherwise>
                    <span class="category-tag" style="background:#f5f5f5;color:#888;border:1px solid #ddd;">${s.status}</span>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
      </tbody>
    </table>
  </div>

  <!-- ── 하단 버튼 ── -->
  <div class="board-footer">
    <div class="board-footer-left"></div>
    <div class="board-footer-right">
      <a href="${pageContext.request.contextPath}/board/subject?no=${course.course_no}"
         class="btn-cancel">← 과목으로</a>
    </div>
  </div>

</div>
</body>
