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
     하단 — 성적현황 + QNA 나란히
══════════════════════════════════════ -->
  <div class="flex">

    <!-- ── 왼쪽: 내 성적 현황 ── -->
    <div class="left">
      <div class="board-card">

        <div class="board-toolbar" style="padding: 1rem 1.2rem 0;">
          <h3 style="font-size: 0.95rem; font-weight: 700; color: var(--lms-primary); display: flex; align-items: center; gap: 6px;">
            📊 성적
          </h3>
          <a href="${pageContext.request.contextPath}/course/score?courseNo=${course.course_no}"
             class="back-link" style="margin-bottom: 0;">전체보기 →</a>
        </div>

        <c:choose>
          <%-- 교수/관리자: 전체 학생 수만 요약 표시 --%>
          <c:when test="${sessionScope.sessionUser.role eq 'PROFESSOR' or sessionScope.sessionUser.role eq 'ADMIN'}">
            <table class="board-table">
              <colgroup>
                <col style="width:110px"><col style="width:120px"><col><col style="width:80px">
              </colgroup>
              <tbody>
              <c:choose>
                <c:when test="${empty studentList}">
                  <tr class="empty-row">
                    <td colspan="4">
                      <div class="empty-icon">📋</div>
                      <div class="empty-text">수강 학생이 없습니다.</div>
                    </td>
                  </tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="s" items="${studentList}">
                    <tr>
                      <td class="td-no">${s.userCode}</td>
                      <td class="td-title"><div class="title-inner"><span class="title-text">${s.name}</span></div></td>
                      <td class="td-views">
                        <c:choose>
                          <c:when test="${not empty s.midterm and not empty s.finalScore and not empty s.attendance}">
                            ${s.midterm * 0.4 + s.finalScore * 0.4 + s.attendance * 0.2}점
                          </c:when>
                          <c:otherwise><span style="color:var(--lms-text-sub);">미입력</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td class="td-no">
                        <c:choose>
                          <c:when test="${not empty s.alphabet}">
                              <span class="category-tag
                                <c:choose>
                                  <c:when test="${s.alphabet.startsWith('A')}">cat-QNA</c:when>
                                  <c:when test="${s.alphabet.startsWith('B')}">cat-FREE</c:when>
                                  <c:when test="${s.alphabet eq 'F'}">cat-NOTICE</c:when>
                                  <c:otherwise>cat-FREE</c:otherwise>
                                </c:choose>
                              ">${s.alphabet}</span>
                          </c:when>
                          <c:otherwise><span style="color:var(--lms-text-sub);">—</span></c:otherwise>
                        </c:choose>
                      </td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </c:when>

          <%-- 학생: 본인 성적만 카드로 --%>
          <c:otherwise>
            <c:set var="myInfo" value="${null}"/>
            <c:forEach var="s" items="${studentList}">
              <c:if test="${s.userNo eq sessionScope.sessionUser.userNo}">
                <c:set var="myInfo" value="${s}"/>
              </c:if>
            </c:forEach>

            <c:choose>
              <c:when test="${not empty myInfo}">
                <div style="padding: 1.2rem;">
                  <div class="stat-grid" style="grid-template-columns: repeat(2,1fr); gap: 10px; margin-bottom: 1rem;">
                    <div class="stat-card">
                      <div class="stat-label">중간고사</div>
                      <div class="stat-value">${myInfo.midterm}<small style="font-size:1rem;">/100</small></div>
                    </div>
                    <div class="stat-card">
                      <div class="stat-label">기말고사</div>
                      <div class="stat-value">${myInfo.finalScore}<small style="font-size:1rem;">/100</small></div>
                    </div>
                    <div class="stat-card">
                      <div class="stat-label">출석</div>
                      <div class="stat-value">${myInfo.attendance}<small style="font-size:1rem;">/100</small></div>
                    </div>
                    <div class="stat-card">
                      <div class="stat-label">최종 학점</div>
                      <div class="stat-value" style="color:var(--lms-accent);">${myInfo.alphabet}</div>
                    </div>
                  </div>
                    <%-- 진행률 바 --%>
                  <div style="display:flex; justify-content:space-between; font-size:0.78rem; color:var(--lms-text-sub); margin-bottom:4px;">
                    <span>총점</span>
                    <span>${myInfo.midterm * 0.4 + myInfo.finalScore * 0.4 + myInfo.attendance * 0.2}점 / 100점</span>
                  </div>
                  <div class="progress">
                    <div style="width:${myInfo.midterm * 0.4 + myInfo.finalScore * 0.4 + myInfo.attendance * 0.2}%;"></div>
                  </div>
                </div>
              </c:when>
              <c:otherwise>
                <div style="padding:2.5rem; text-align:center;">
                  <div class="empty-icon">📋</div>
                  <div class="empty-text">아직 성적이 등록되지 않았습니다.</div>
                </div>
              </c:otherwise>
            </c:choose>
          </c:otherwise>
        </c:choose>

      </div>
    </div>

    <!-- ── 오른쪽: Q&A 최근글 ── -->
    <div class="right">
      <div class="board-card">

        <div class="board-toolbar" style="padding: 1rem 1.2rem 0;">
          <h3 style="font-size: 0.95rem; font-weight: 700; color: var(--lms-primary); display: flex; align-items: center; gap: 6px;">
            💬 Q&amp;A
          </h3>
          <a href="${pageContext.request.contextPath}/board/list_qna?boardType=QNA&courseNo=${course.course_no}"
             class="back-link" style="margin-bottom: 0;">전체보기 →</a>
        </div>

        <table class="board-table">
          <colgroup>
            <col class="col-title">
            <col style="width:90px;">
          </colgroup>
          <tbody>
          <c:choose>
            <c:when test="${empty qnaList}">
              <tr class="empty-row">
                <td colspan="2">
                  <div class="empty-icon">💬</div>
                  <div class="empty-text">등록된 Q&amp;A가 없습니다.</div>
                </td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="qna" items="${qnaList}">
                <tr onclick="location='${pageContext.request.contextPath}/board/detail_qna?boardNo=${qna.boardNo}&courseNo=${course.course_no}'">
                  <td class="td-title">
                    <div class="title-inner">
                      <span class="title-text">${qna.title}</span>
                    </div>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${qna.answerStatus eq 'ANSWERED'}">
                        <span class="category-tag cat-QNA" style="font-size:0.72rem;">답변완료</span>
                      </c:when>
                      <c:otherwise>
                        <span class="category-tag cat-FREE" style="font-size:0.72rem;">대기중</span>
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

  </div><!-- /.flex -->

</div><!-- /.board-wrap -->
