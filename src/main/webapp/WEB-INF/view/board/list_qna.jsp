<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>re-merge LMS — Q&A</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>
<body>
<div class="board-wrap">

  <!-- 타이틀 -->
  <div class="page-header">
    <h2 class="page-title">❓ Q&amp;A</h2>
    <div class="page-breadcrumb">
      <a href="${pageContext.request.contextPath}/board/subjectHome?courseNo=${course.course_no}">${courseName}</a>
      <span>›</span>
      Q&amp;A
    </div>
  </div>

  <!-- 검색 툴바 -->
  <div class="board-toolbar">
    <form class="search-form" method="get" action="">
      <input type="hidden" name="boardType" value="QNA">
      <input type="hidden" name="courseNo" value="${course.course_no}">

      <select name="answerStatus" class="search-select">
        <option value="">전체</option>
        <option value="WAIT"     ${post.isAnswered ? 'selected' : ''}>미답변</option>
        <option value="ANSWERED" ${!post.isAnswered ? 'selected' : ''}>답변완료</option>
      </select>

      <select name="searchType" class="search-select">
        <option value="title"  ${searchType == 'title'  ? 'selected' : ''}>제목</option>
        <option value="writer" ${searchType == 'writer' ? 'selected' : ''}>작성자</option>
        <option value="all"    ${searchType == 'all'    ? 'selected' : ''}>제목+작성자</option>
      </select>

      <input type="text" name="keyword" class="search-input"
             placeholder="검색어를 입력하세요" value="${keyword}">
      <button type="submit" class="btn-search">검색</button>
    </form>
  </div>

  <!-- 게시글 테이블 -->
  <div class="board-card">
    <table class="board-table">
      <colgroup>
        <col class="col-no">
        <col style="width: 90px;">
        <col class="col-writer">
        <col class="col-title">
        <col class="col-date">
        <col class="col-views">
      </colgroup>
      <thead>
      <tr>
        <th>No</th>
        <th>상태</th>
        <th>작성자</th>
        <th style="text-align:left; padding-left:14px;">제목</th>
        <th>작성일</th>
        <th>조회</th>
      </tr>
      </thead>
      <tbody>
      <c:choose>
        <c:when test="${empty postList}">
          <tr class="empty-row">
            <td colspan="6">
              <div class="empty-icon">❓</div>
              <div class="empty-text">아직 질문이 없어요. 첫 질문을 남겨보세요!</div>
            </td>
          </tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="post" items="${postList}">
            <tr onclick="location.href='detail_qna?boardNo=${post.boardNo}&boardType=QNA&courseNo=${course.course_no}'">
              <td class="td-no">${post.rowNum}</td>
              <td>
                <c:choose>
                  <c:when test="${post.isAnswered}">
                    <span class="badge badge-green">답변완료</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-yellow">미답변</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>${post.writerName}</td>
              <td class="td-title">
                <div class="title-inner">
                  <span class="title-text">${post.title}</span>
                  <c:if test="${not empty post.fileUrl}">
                    <span class="file-icon-inline">📎</span>
                  </c:if>
<%--                  <c:if test="${post.isNew}">--%>
<%--                    <span class="badge-new">NEW</span>--%>
<%--                  </c:if>--%>
                </div>
              </td>
              <td class="td-date">
                <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd HH:mm"/>
              </td>
              <td class="td-views ${post.views > 200 ? 'views-high' : ''}">${post.views}</td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
      </tbody>
    </table>
  </div>

  <!-- 하단 푸터 -->
  <div class="board-footer">

    <nav class="pagination-wrap">
      <c:set var="queryParam" value="boardType=QNA&courseNo=${course.course_no}&searchType=${searchType}&keyword=${keyword}&answerStatus=${answerStatus}"/>
      <c:choose>
        <c:when test="${currentPage > 1}">
          <a class="page-btn" href="?${queryParam}&page=1">«</a>
          <a class="page-btn" href="?${queryParam}&page=${currentPage - 1}">‹</a>
        </c:when>
        <c:otherwise>
          <span class="page-btn disabled">«</span>
          <span class="page-btn disabled">‹</span>
        </c:otherwise>
      </c:choose>

      <c:forEach begin="${startPage}" end="${endPage}" var="p">
        <c:choose>
          <c:when test="${p == currentPage}">
            <span class="page-btn active">${p}</span>
          </c:when>
          <c:otherwise>
            <a class="page-btn" href="?${queryParam}&page=${p}">${p}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <c:choose>
        <c:when test="${currentPage < totalPages}">
          <a class="page-btn" href="?${queryParam}&page=${currentPage + 1}">›</a>
          <a class="page-btn" href="?${queryParam}&page=${totalPages}">»</a>
        </c:when>
        <c:otherwise>
          <span class="page-btn disabled">›</span>
          <span class="page-btn disabled">»</span>
        </c:otherwise>
      </c:choose>
    </nav>

    <div class="board-footer-right">
      <c:if test="${sessionScope.sessionUser.role eq 'STUDENT'}">
        <button class="btn-write"
                onclick="location.href='${pageContext.request.contextPath}/board/write?boardType=QNA&courseNo=${course.course_no}'">
          ✏️ 질문하기
        </button>
      </c:if>
    </div>

  </div>

</div>
</body>
</html>
