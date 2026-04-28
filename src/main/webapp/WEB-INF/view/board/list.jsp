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
    <!-- ── 타이틀 ── -->
    <c:if test="${not empty course.course_no}">
        <div class="page-header">
            <h2 class="page-title">
                <c:choose>
                    <c:when test="${boardType == 'NOTICE'}">📢 공지사항</c:when>
                    <c:when test="${boardType == 'QNA'}">❓ Q&amp;A</c:when>
                </c:choose>
            </h2>
            <div class="page-breadcrumb">
                <a href="${pageContext.request.contextPath}/board/subjectHome?courseNo=${course.course_no}">${course.course_name}</a>
                <span>›</span>
                <c:choose>
                    <c:when test="${boardType == 'NOTICE'}">공지사항</c:when>
                    <c:when test="${boardType == 'QNA'}">Q&A</c:when>
                    <c:otherwise>자유게시판</c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>
  <!-- ── 검색 툴바 ── -->
  <div class="board-toolbar">
    <form class="search-form" method="get" action="">
      <input type="hidden" name="boardType" value="${boardType}">
      <input type="hidden" name="courseNo"  value="${course.course_no}">
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
            <%-- 세부 과목 게시판 --%>
            <c:if test="${empty course.course_no}">
                <a href="?boardType=NOTICE"
                   class="${boardType == 'NOTICE' ? 'active' : ''}">공지</a>
                <a href="?boardType=FREE"
                   class="${boardType == 'FREE' ? 'active' : ''}">자유게시판</a>
            </c:if>
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
            <c:forEach var="post" items="${postList}" varStatus="status">
                <tr onclick="location.href='detail?boardNo=${post.boardNo}&boardType=${post.boardType}${not empty post.courseNo ? "&courseNo=".concat(post.courseNo) : ""}'">
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
          <%-- 공통 파라미터 변수화 (코드가 깔끔해집니다) --%>
          <c:set var="queryParam" value="boardType=${boardType}&courseNo=${course.course_no}&searchType=${searchType}&keyword=${keyword}" />

          <%-- 처음(«) / 이전(‹) --%>
          <c:choose>
              <c:when test="${currentPage > 1}">
                  <a class="page-btn arrow" href="?${queryParam}&page=1">«</a>
                  <a class="page-btn arrow" href="?${queryParam}&page=${currentPage - 1}">‹</a>
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
                      <a class="page-btn" href="?${queryParam}&page=${p}">${p}</a>
                  </c:otherwise>
              </c:choose>
          </c:forEach>

          <%-- 다음(›) / 마지막(») --%>
          <c:choose>
              <c:when test="${currentPage < totalPages}">
                  <a class="page-btn arrow" href="?${queryParam}&page=${currentPage + 1}">›</a>
                  <a class="page-btn arrow" href="?${queryParam}&page=${totalPages}">»</a>
              </c:when>
              <c:otherwise>
                  <span class="page-btn disabled">›</span>
                  <span class="page-btn disabled">»</span>
              </c:otherwise>
          </c:choose>
      </nav>
<%--      <nav class="pagination-wrap">--%>
<%--          &lt;%&ndash; 처음(«) / 이전 블록(‹) &ndash;%&gt;--%>
<%--          <c:choose>--%>
<%--              <c:when test="${startPage > 1}">--%>
<%--                  <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${course.course_no}&page=1&keyword=${keyword}&searchType=${searchType}">«</a>--%>
<%--                  <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${course.course_no}&page=${prevBlock}&keyword=${keyword}&searchType=${searchType}">‹</a>--%>
<%--              </c:when>--%>
<%--              <c:otherwise>--%>
<%--                  <span class="page-btn disabled">«</span>--%>
<%--                  <span class="page-btn disabled">‹</span>--%>
<%--              </c:otherwise>--%>
<%--          </c:choose>--%>
<%--          &lt;%&ndash; 숫자 페이지 버튼 &ndash;%&gt;--%>
<%--          <c:forEach begin="${startPage}" end="${endPage}" var="p">--%>
<%--              <c:choose>--%>
<%--                  <c:when test="${p == currentPage}">--%>
<%--                      <span class="page-btn active">${p}</span>--%>
<%--                  </c:when>--%>
<%--                  <c:otherwise>--%>
<%--                      <a class="page-btn" href="?boardType=${boardType}&courseNo=${course.course_no}&page=${p}&keyword=${keyword}&searchType=${searchType}">${p}</a>--%>
<%--                  </c:otherwise>--%>
<%--              </c:choose>--%>
<%--          </c:forEach>--%>
<%--          &lt;%&ndash; 다음 블록(›) / 마지막(») &ndash;%&gt;--%>
<%--          <c:choose>--%>
<%--              <c:when test="${endPage < totalPages}">--%>
<%--                  <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${course.course_no}&page=${nextBlock}&keyword=${keyword}&searchType=${searchType}">›</a>--%>
<%--                  <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${course.course_no}&page=${totalPages}&keyword=${keyword}&searchType=${searchType}">»</a>--%>
<%--              </c:when>--%>
<%--              <c:otherwise>--%>
<%--                  <span class="page-btn disabled">›</span>--%>
<%--                  <span class="page-btn disabled">»</span>--%>
<%--              </c:otherwise>--%>
<%--          </c:choose>--%>
<%--      </nav>--%>
    <!-- 오른쪽: 수정 / 글쓰기 -->
          <c:if test="${((boardType eq 'NOTICE') and (sessionScope.sessionUser.role eq 'ADMIN' or sessionScope.sessionUser.role eq 'PROFESSOR')) || boardType eq 'FREE'}">
            <div class="board-footer-right">
                <button class="btn-write"
                        onclick="location.href='${pageContext.request.contextPath}/board/write?boardType=${boardType}${not empty course.course_no ? '&courseNo='.concat(course.course_no) : ''}'">
                    글쓰기
                </button>
            </div>
          </c:if>
  </div>
</main>
</body>
</html>
