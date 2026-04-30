<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<head>
  <title>${course.course_name} — 수강생 관리</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>

<body>
<div class="board-wrap">

  <!-- ── 페이지 헤더 ── -->
  <div class="write-header">
    <div class="header-title">
      <h2>${course.course_name}</h2>
      <p>${professorName} 교수 &middot; ${course.semester} &middot; ${course.day_of_week} ${course.start_time}~${course.end_time}</p>
    </div>
    <div style="display:flex; align-items:center; gap:10px;">
      <span class="category-tag cat-QNA">승인 <strong id="approvedCount">0</strong>명</span>
      <span class="category-tag cat-FREE">대기 <strong id="pendingCount">0</strong>명</span>
    </div>
  </div>

  <!-- ── 학생 테이블 ── -->
  <div class="board-card">
    <table class="board-table">
      <colgroup>
        <col style="width:56px">
        <col style="width:110px">
        <col style="width:120px">
        <col>
        <col style="width:160px">
        <col style="width:100px">
        <col style="width:110px">
      </colgroup>
      <thead>
      <tr>
        <th>No</th>
        <th>학번</th>
        <th style="text-align:left; padding-left:14px;">이름</th>
        <th style="text-align:left; padding-left:14px;">이메일</th>
        <th>전화번호</th>
        <th>수강 상태</th>
        <th>관리</th>
      </tr>
      </thead>
      <tbody>
      <c:choose>
        <c:when test="${empty students}">
          <tr class="empty-row">
            <td colspan="7">
              <div class="empty-icon">👤</div>
              <div class="empty-text">수강생이 없습니다.</div>
            </td>
          </tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="s" items="${students}" varStatus="loop">
            <tr id="row-${s.enrollmentNo}">
              <td class="td-no">${loop.count}</td>
              <td class="td-no">${s.userCode}</td>
              <td class="td-title">
                <div class="title-inner">
                  <span class="title-text">${s.name}</span>
                </div>
              </td>
              <td class="td-title">
                <div class="title-inner">
                  <span class="title-text" style="font-weight:400;">${s.email}</span>
                </div>
              </td>
              <td class="td-date">${s.phone}</td>
              <td id="status-${s.enrollmentNo}">
                <c:choose>
                  <c:when test="${s.status == 'APPROVED'}">
                    <span class="category-tag cat-QNA">✔ 승인</span>
                  </c:when>
                  <c:otherwise>
                    <span class="category-tag cat-FREE">⏳ 대기</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td id="action-${s.enrollmentNo}">
                <c:choose>
                  <c:when test="${s.status == 'PENDING'}">
                    <button class="btn-submit"
                            style="height:32px; padding:0 14px; font-size:0.8rem;"
                            onclick="approve(${s.enrollmentNo})">승인</button>
                  </c:when>
                  <c:otherwise>
                    <span style="font-size:0.82rem; color:var(--lms-text-sub);">—</span>
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

  <!-- ── 하단 ── -->
  <div class="board-footer">
    <div class="board-footer-left"></div>
  </div>

</div>

<script>
  // 페이지 로드 시 승인/대기 카운트
  function updateCount() {
    const approved = document.querySelectorAll('[id^="status-"] .cat-QNA').length;
    const pending  = document.querySelectorAll('[id^="status-"] .cat-FREE').length;
    document.getElementById('approvedCount').textContent = approved;
    document.getElementById('pendingCount').textContent  = pending;
  }

  // 승인 처리
  function approve(enrollmentNo) {
    if (!confirm('수강을 승인하시겠습니까?')) return;

    fetch('${pageContext.request.contextPath}/board/approveEnrollment', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'enrollmentNo=' + enrollmentNo
    })
            .then(res => {
              if (res.ok) {
                // 상태 배지 변경
                document.getElementById('status-' + enrollmentNo).innerHTML =
                        '<span class="category-tag cat-QNA">✔ 승인</span>';
                // 버튼 제거
                document.getElementById('action-' + enrollmentNo).innerHTML =
                        '<span style="font-size:0.82rem; color:var(--lms-text-sub);">—</span>';
                updateCount();
              } else {
                alert('승인 처리 중 오류가 발생했습니다.');
              }
            })
            .catch(() => alert('서버와 통신 중 오류가 발생했습니다.'));
  }

  updateCount();
</script>
</body>
