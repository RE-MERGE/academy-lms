<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>re-merge LMS — 게시판</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>
<body>
<main class="board-wrap">
  <!-- ── 검색 툴바 ── -->
  <div class="board-toolbar">
    <form class="search-form" method="get" action="">
      <input type="hidden" name="boardType" value="${boardType}">
      <input type="hidden" name="courseNo"  value="${courseNo}">
      <select name="searchType" class="search-select">
        <option value="title"  <c:if test="${searchType == 'title'}">selected</c:if>>제목</option>
        <option value="writer" <c:if test="${searchType == 'writer'}">selected</c:if>>작성자</option>
        <option value="all"    <c:if test="${searchType == 'all'}">selected</c:if>>제목+작성자</option>
      </select>
      <input type="text" name="keyword" class="search-input"
             placeholder="검색어를 입력하세요" value="${keyword}">
      <button type="submit" class="btn-search">검색</button>
    </form>
  </div>
  <!-- ── 탭 ── -->
  <div class="board-tabs">
    <a href="?boardType=NOTICE<c:if test='${not empty courseNo}'>&courseNo=${courseNo}</c:if>"
       class="<c:if test='${boardType == \"NOTICE\"}'>active</c:if>">공지</a>
    <a href="?boardType=FREE<c:if test='${not empty courseNo}'>&courseNo=${courseNo}</c:if>"
       class="<c:if test='${boardType == \"FREE\"}'>active</c:if>">자유게시판</a>
  </div>
  <!-- ── 게시글 테이블 ── -->
  <div class="board-card">
    <table class="board-table">
      <colgroup>
        <col class="col-no">
        <col class="col-writer">
        <col class="col-title">
        <col class="col-date">
        <col class="col-views">
      </colgroup>
      <thead>
        <tr>
          <th>No</th>
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
              <td colspan="5">
                <div class="empty-icon">📭</div>
                <div class="empty-text">게시글이 없습니다.</div>
              </td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="post" items="${postList}">
              <tr onclick="location='detail?boardNo=${post.boardNo}&boardType=${post.boardType}&courseNo=${post.courseNo}'">
                <!-- 번호 -->
                <td class="td-no">${post.rowNum}</td>
                <!-- 작성자 -->
                <td>${post.writerName}</td>
                <!-- 제목 -->
                <td class="td-title">
                  <div class="title-inner">
                    <span class="title-text">${post.title}</span>
                    <c:if test="${not empty post.fileUrl}">
                      <span class="file-icon-inline">📎</span>
                    </c:if>
                  </div>
                </td>
                <!-- 작성일 -->
                <td class="td-date"><fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd HH:mm"/></td>
                <!-- 조회수 -->
                <td class="td-views <c:if test='${post.views > 200}'>views-high</c:if>">${post.views}</td>
                <!-- 댓글수 -->
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>
  <!-- ── 하단 푸터 ── -->
  <div class="board-footer">
    <!-- 왼쪽: 전체선택 라벨 -->
      <nav class="pagination-wrap">
          <%-- 처음(«) / 이전 블록(‹) --%>
          <c:choose>
              <c:when test="${startPage > 1}">
                  <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=1&keyword=${keyword}&searchType=${searchType}">«</a>
                  <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=${prevBlock}&keyword=${keyword}&searchType=${searchType}">‹</a>
              </c:when>
              <c:otherwise>
                  <span class="page-btn disabled">«</span>
                  <span class="page-btn disabled">‹</span>
              </c:otherwise>
          </c:choose>
          <%-- 숫자 페이지 버튼 --%>
          <c:forEach begin="${startPage}" end="${endPage}" var="p">
              <c:choose>
                  <c:when test="${p == currentPage}">
                      <span class="page-btn active">${p}</span>
                  </c:when>
                  <c:otherwise>
                      <a class="page-btn" href="?boardType=${boardType}&courseNo=${courseNo}&page=${p}&keyword=${keyword}&searchType=${searchType}">${p}</a>
                  </c:otherwise>
              </c:choose>
          </c:forEach>
          <%-- 다음 블록(›) / 마지막(») --%>
          <c:choose>
              <c:when test="${endPage < totalPages}">
                  <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=${nextBlock}&keyword=${keyword}&searchType=${searchType}">›</a>
                  <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=${totalPages}&keyword=${keyword}&searchType=${searchType}">»</a>
              </c:when>
              <c:otherwise>
                  <span class="page-btn disabled">›</span>
                  <span class="page-btn disabled">»</span>
              </c:otherwise>
          </c:choose>
      </nav>
    <!-- 오른쪽: 수정 / 글쓰기 -->
          <c:if test="${((boardType eq 'NOTICE') and (sessionScope.sessionUser.role eq 'ADMIN' or sessionScope.sessionUser.role eq 'PROFESSOR')) || boardType eq 'FREE'}">
            <div class="board-footer-right">
              <button class="btn-write"  onclick="location='${pageContext.request.contextPath}/board/write?boardType=${boardType}'">글쓰기</button>
            </div>
          </c:if>
  </div>
</main>
</body>
</html>
