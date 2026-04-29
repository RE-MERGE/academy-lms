<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css"/>

<div class="board-wrap">

  <!-- ══════════════════════════════════════
       과목 정보 헤더
  ══════════════════════════════════════ -->
  <div class="detail-head">
    <span class="badge-category FREE">
      <c:choose>
      <c:when test="${course.course_type eq 'MAJOR_REQUIRED'}">전공필수</c:when>
      <c:when test="${course.course_type eq 'MAJOR_ELECTIVE'}">전공선택</c:when>
      <c:when test="${course.course_type eq 'GENERAL_REQUIRED'}">교양필수</c:when>
      <c:when test="${course.course_type eq 'GENERAL_ELECTIVE'}">교양선택</c:when>
      <c:when test="${course.course_type eq 'FREE_ELECTIVE'}">일반선택</c:when>
      <c:otherwise>${course.course_type}
      </c:otherwise>
    </c:choose></span>
    <h2 class="detail-title">${course.course_name}</h2>
    <div class="detail-meta">
      <span>👨‍🏫 ${professorName} 교수</span>
      <span>🗓 ${course.semester}</span>
      <span>🏫 ${course.room_info}</span>
      <span>⏰ ${course.start_time}</span>
    </div>
  </div>

  <!-- ══════════════════════════════════════
       상단 — 공지사항
  ══════════════════════════════════════ -->
  <div class="board-card" style="margin-bottom: 1.2rem;">

    <div class="board-toolbar" style="padding: 1rem 1.2rem 0;">
      <h3 style="font-size: 0.95rem; font-weight: 700; color: var(--lms-primary); display: flex; align-items: center; gap: 6px;">
        📢 공지사항
      </h3>
      <a href="${pageContext.request.contextPath}/board/list?boardType=NOTICE&courseNo=${course.course_no}"
         class="back-link" style="margin-bottom: 0;">전체보기 →</a>
    </div>

    <table class="board-table">
      <colgroup>
        <col class="col-no">
        <col class="col-title">
        <col class="col-date">
      </colgroup>
      <thead>
        <tr>
          <th>No</th>
          <th style="text-align:left; padding-left:14px;">제목</th>
          <th>작성일</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty postList}">
            <tr class="empty-row">
              <td colspan="3">
                <div class="empty-icon">📢</div>
                <div class="empty-text">등록된 공지사항이 없습니다.</div>
              </td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="post" items="${postList}">
              <tr onclick="location='${pageContext.request.contextPath}/board/detail?boardNo=${post.boardNo}&boardType=NOTICE&courseNo=${course.course_no}'">
                <td class="td-no">
                  <span class="notice-badge">공지</span>
                </td>
                <td class="td-title">
                  <div class="title-inner">
                    <span class="title-text">${post.title}</span>
                    <c:if test="${not empty post.fileUrl}">
                      <span class="file-icon-inline">📎</span>
                    </c:if>
<%--                    <c:if test="${post.isNew}">--%>
<%--                      <span class="badge-new">NEW</span>--%>
<%--                    </c:if>--%>
                  </div>
                </td>
                <td class="td-date">
                  <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd"/>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>

  <!-- ══════════════════════════════════════
       하단 — 강의일정 + 성적현황 나란히
  ══════════════════════════════════════ -->
  <div class="flex">

    <!-- ── 왼쪽: 강의 일정 ── -->
    <div class="left">
      <div class="board-card">

        <div class="board-toolbar" style="padding: 1rem 1.2rem 0;">
          <h3 style="font-size: 0.95rem; font-weight: 700; color: var(--lms-primary); display: flex; align-items: center; gap: 6px;">
            📅 강의 일정
          </h3>
        </div>

        <table class="board-table">
          <colgroup>
            <col style="width: 60px;">
            <col>
            <col style="width: 90px;">
          </colgroup>
          <thead>
            <tr>
              <th>주차</th>
              <th style="text-align:left; padding-left:14px;">강의 내용</th>
              <th>상태</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty scheduleList}">
                <tr class="empty-row">
                  <td colspan="3">
                    <div class="empty-icon">📅</div>
                    <div class="empty-text">등록된 강의 일정이 없습니다.</div>
                  </td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="schedule" items="${scheduleList}">
                  <tr>
                    <td class="td-no">${schedule.weekNo}주차</td>
                    <td class="td-title">
                      <div class="title-inner">
                        <span class="title-text">${schedule.topic}</span>
                      </div>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${schedule.status == 'DONE'}">
                          <span class="badge badge-gray">완료</span>
                        </c:when>
                        <c:when test="${schedule.status == 'CURRENT'}">
                          <span class="badge badge-blue">진행중</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-gray" style="opacity:0.5;">예정</span>
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
    </div>

    <!-- ── 오른쪽: 성적 현황 ── -->
    <div class="right">
      <div class="board-card">

        <div class="board-toolbar" style="padding: 1rem 1.2rem 0;">
          <h3 style="font-size: 0.95rem; font-weight: 700; color: var(--lms-primary); display: flex; align-items: center; gap: 6px;">
            📊 내 성적 현황
          </h3>
        </div>

        <table class="board-table">
          <colgroup>
            <col>
            <col style="width: 70px;">
            <col style="width: 70px;">
          </colgroup>
          <thead>
            <tr>
              <th style="text-align:left; padding-left:14px;">항목</th>
              <th>만점</th>
              <th>내 점수</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty gradeList}">
                <tr class="empty-row">
                  <td colspan="3">
                    <div class="empty-icon">📊</div>
                    <div class="empty-text">아직 성적이 없습니다.</div>
                  </td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="grade" items="${gradeList}">
                  <tr>
                    <td class="td-title">
                      <span class="title-text">${grade.itemName}</span>
                    </td>
                    <td class="td-views">${grade.fullScore}</td>
                    <td class="td-views">
                      <c:choose>
                        <c:when test="${grade.myScore == null}">
                          <span style="color: var(--lms-text-sub);">-</span>
                        </c:when>
                        <c:when test="${grade.myScore >= grade.fullScore * 0.8}">
                          <span style="color: var(--green); font-weight: 700;">${grade.myScore}</span>
                        </c:when>
                        <c:when test="${grade.myScore < grade.fullScore * 0.6}">
                          <span class="views-high">${grade.myScore}</span>
                        </c:when>
                        <c:otherwise>
                          <span style="font-weight: 600;">${grade.myScore}</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>

                <!-- 합계 행 -->
                <tr style="border-top: 2px solid var(--lms-border); background: var(--lms-bg-light);">
                  <td class="td-title"><strong>합계</strong></td>
                  <td class="td-views"><strong>${totalFullScore}</strong></td>
                  <td class="td-views"><strong>${totalMyScore}</strong></td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>

        <!-- 진행률 바 -->
        <c:if test="${not empty gradeList}">
          <div style="padding: 1rem 1.2rem;">
            <div style="display:flex; justify-content:space-between; font-size:0.78rem; color:var(--lms-text-sub); margin-bottom:4px;">
              <span>취득률</span>
              <span>${totalMyScore} / ${totalFullScore}점</span>
            </div>
            <div class="progress">
              <div style="width: ${totalMyScore / totalFullScore * 100}%;"></div>
            </div>
          </div>
        </c:if>

      </div>
    </div>

  </div><!-- /.flex -->

</div><!-- /.board-wrap -->
