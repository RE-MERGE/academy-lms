<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  ================================================================
  re-merge LMS — 게시판 (board.jsp)
  Java 로직(페이징 계산, 더미데이터)은 주석 처리
  실제 DB 연동 시 Servlet/Controller에서 request attribute로 전달하세요.

  [Servlet에서 넘겨줘야 할 attribute 목록]
  - postList     : List<BoardDTO>  게시글 목록
  - totalCount   : int             전체 게시글 수
  - currentPage  : int             현재 페이지
  - totalPages   : int             전체 페이지 수
  - blockStart   : int             페이지 블럭 시작
  - blockEnd     : int             페이지 블럭 끝
  - prevBlock    : int             이전 블럭 페이지
  - nextBlock    : int             다음 블럭 페이지
  - keyword      : String          검색어
  - searchType   : String          검색 타입
  ================================================================
--%>

<%--
  ※ 아래 더미데이터 및 페이징 계산 로직은 Servlet으로 이전 예정
  ※ Servlet에서 request.setAttribute("postList", list) 형태로 전달

  <%@ page import="java.util.*" %>
  <%
    int pageSize   = 10;
    int blockSize  = 5;
    String pageStr    = request.getParameter("page");
    String keyword    = request.getParameter("keyword");
    String searchType = request.getParameter("searchType");
    if (keyword == null)    keyword = "";
    if (searchType == null) searchType = "title";

    int currentPage = 1;
    try { currentPage = Integer.parseInt(pageStr); } catch (Exception e) {}
    if (currentPage < 1) currentPage = 1;

    List<Map<String,Object>> allPosts = new ArrayList<>();
    String[] boardTypes = {"공지", "자유", "질문", "스터디", "정보"};
    String[] writers    = {"김민준", "이서연", "박지호", "최수아", "정태양",
                           "한예린", "오도현", "신미래", "윤성찬", "임하늘"};
    String[] titles = {
      "Java Spring Boot 강의 오픈 안내", "LMS 사용 방법 질문드립니다", ...
    };

    Random rnd = new Random(42);
    for (int i = titles.length; i >= 1; i--) {
      Map<String,Object> post = new LinkedHashMap<>();
      post.put("boardNo",   i);
      post.put("boardType", boardTypes[rnd.nextInt(boardTypes.length)]);
      post.put("title",     titles[titles.length - i]);
      post.put("writerNo",  writers[rnd.nextInt(writers.length)]);
      post.put("views",     rnd.nextInt(300) + 1);
      post.put("createdAt", String.format("2025.%02d.%02d", rnd.nextInt(4)+1, rnd.nextInt(28)+1));
      post.put("isNew",     i > (titles.length - 5));
      post.put("isNotice",  i > (titles.length - 2));
      allPosts.add(post);
    }

    // 검색 필터, 페이징 계산 ...
    // int totalCount = filtered.size();
    // int totalPages = ...
    // int blockStart = ...
    // int blockEnd   = ...
    // int prevBlock  = blockStart - 1;
    // int nextBlock  = blockEnd + 1;
    // request.setAttribute("postList",   pagePosts);
    // request.setAttribute("totalCount", totalCount);
    // request.setAttribute("currentPage",currentPage);
    // request.setAttribute("totalPages", totalPages);
    // request.setAttribute("blockStart", blockStart);
    // request.setAttribute("blockEnd",   blockEnd);
    // request.setAttribute("prevBlock",  prevBlock);
    // request.setAttribute("nextBlock",  nextBlock);
    // request.setAttribute("keyword",    keyword);
    // request.setAttribute("searchType", searchType);
  %>
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>re-merge LMS — 게시판</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>
<body>

<canvas id="bg-canvas"></canvas>
<div class="bg-mesh"></div>
<!-- ── 본문 ── -->
<main class="board-wrap">
  <!-- 툴바 -->
  <div class="board-toolbar">
    <form class="search-form" method="get" action="searchType">
      <select name="searchType" class="search-select">
        <option value="title"  <c:if test="${searchType == 'title'}">selected</c:if>>제목</option>
        <option value="writer" <c:if test="${searchType == 'writer'}">selected</c:if>>작성자</option>
        <option value="all"    <c:if test="${searchType == 'all'}">selected</c:if>>제목+작성자</option>
      </select>
      <input type="text" name="keyword" class="search-input"
             placeholder="검색어를 입력하세요" value="${keyword}">
      <button type="submit" class="btn-search">검색</button>
    </form>
    <button class="btn-write" onclick="alert('글쓰기 페이지로 이동합니다.')">✏ 글쓰기</button>
  </div>

  <!-- 검색 결과 안내 -->
  <c:if test="${not empty keyword}">
    <div class="search-notice">
      <span>🔍</span>
      "<strong>${keyword}</strong>" 검색 결과 — <strong>${totalCount}</strong>건
      <a href="board.jsp">✕ 검색 초기화</a>
    </div>
  </c:if>

  <!-- 게시글 테이블 -->
  <div class="board-card">
    <table class="board-table">
      <thead>
      <tr>
        <th>번호</th>
        <th>분류</th>
        <th>제목</th>
        <th>작성자</th>
        <th>조회</th>
        <th>작성일</th>
      </tr>
      </thead>
      <tbody>
      <c:choose>
        <c:when test="${empty postList}">
          <tr class="empty-row">
            <td colspan="6">
              <div class="empty-icon">📭</div>
              <div class="empty-text">게시글이 없습니다.</div>
            </td>
          </tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="post" items="${postList}">
            <tr class="${post.isNotice ? 'notice-row' : ''}"
                onclick="alert('게시글 ${post.boardNo}번 상세 페이지로 이동합니다.')">
              <td class="td-no">
                <c:choose>
                  <c:when test="${post.isNotice}">
                    <span class="notice-badge">공지</span>
                  </c:when>
                  <c:otherwise>${post.boardNo}</c:otherwise>
                </c:choose>
              </td>
              <td>
                <span class="category-tag cat-${post.boardType}">${post.boardType}</span>
              </td>
              <td class="td-title">
                <div class="title-inner">
                  <span class="title-text">${post.title}</span>
                  <c:if test="${post.isNew}">
                    <span class="badge-new">NEW</span>
                  </c:if>
                </div>
              </td>
              <td>${post.writerNo}</td>  <%-- 실제 연동 시 작성자 이름으로 JOIN --%>
              <td class="td-views ${post.views > 200 ? 'views-high' : ''}">${post.views}</td>
              <td>${post.createdAt}</td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
      </tbody>
    </table>
  </div>

  <!-- ── 페이지네이션 ── -->
  <nav class="pagination-wrap" aria-label="페이지 탐색">

    <%-- 처음 --%>
    <c:choose>
      <c:when test="${currentPage > 1}">
        <a class="page-btn arrow" href="board.jsp?page=1&keyword=${keyword}&searchType=${searchType}" title="처음">«</a>
      </c:when>
      <c:otherwise>
        <span class="page-btn arrow disabled">«</span>
      </c:otherwise>
    </c:choose>

    <%-- 이전 블럭 --%>
    <c:choose>
      <c:when test="${prevBlock >= 1}">
        <a class="page-btn arrow" href="board.jsp?page=${prevBlock}&keyword=${keyword}&searchType=${searchType}" title="이전">‹</a>
      </c:when>
      <c:otherwise>
        <span class="page-btn arrow disabled">‹</span>
      </c:otherwise>
    </c:choose>

    <%-- 번호 블럭 --%>
    <c:forEach var="p" begin="${blockStart}" end="${blockEnd}">
      <c:choose>
        <c:when test="${p == currentPage}">
          <span class="page-btn active">${p}</span>
        </c:when>
        <c:otherwise>
          <a class="page-btn" href="board.jsp?page=${p}&keyword=${keyword}&searchType=${searchType}">${p}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>

    <%-- 다음 블럭 --%>
    <c:choose>
      <c:when test="${nextBlock <= totalPages}">
        <a class="page-btn arrow" href="board.jsp?page=${nextBlock}&keyword=${keyword}&searchType=${searchType}" title="다음">›</a>
      </c:when>
      <c:otherwise>
        <span class="page-btn arrow disabled">›</span>
      </c:otherwise>
    </c:choose>

    <%-- 마지막 --%>
    <c:choose>
      <c:when test="${currentPage < totalPages}">
        <a class="page-btn arrow" href="board.jsp?page=${totalPages}&keyword=${keyword}&searchType=${searchType}" title="마지막">»</a>
      </c:when>
      <c:otherwise>
        <span class="page-btn arrow disabled">»</span>
      </c:otherwise>
    </c:choose>

  </nav>

</main>

</body>
</html>
