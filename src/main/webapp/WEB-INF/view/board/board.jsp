<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%--
  ================================================================
  re-merge LMS — 연습 게시판 (board.jsp)
  페이징 연습용 게시판 (더미 데이터 포함)
  실제 DB 연동 시 dummy 데이터 부분을 DAO 호출로 교체하세요.
  ================================================================
--%>
<%
  /* ── 페이징 파라미터 ──────────────────────────────────── */
  int pageSize   = 10;   // 한 페이지당 게시글 수
  int blockSize  = 5;    // 페이지 번호 블럭 크기
  String pageStr = request.getParameter("page");
  String keyword = request.getParameter("keyword");
  String searchType = request.getParameter("searchType");
  if (keyword == null)     keyword = "";
  if (searchType == null)  searchType = "title";

  int currentPage = 1;
  try { currentPage = Integer.parseInt(pageStr); } catch (Exception e) {}
  if (currentPage < 1) currentPage = 1;

  /* ── 더미 게시글 데이터 (DB 연동 전 테스트용) ────────── */
  List<Map<String,Object>> allPosts = new ArrayList<>();
  String[] board_type = {"공지", "자유", "질문", "스터디", "정보"};
  String[] writer    = {"김민준", "이서연", "박지호", "최수아", "정태양",
                          "한예린", "오도현", "신미래", "윤성찬", "임하늘"};
  String[] title = {
    "Java Spring Boot 강의 오픈 안내", "LMS 사용 방법 질문드립니다", "스터디 그룹 모집합니다",
    "과제 제출 기한 연장 요청", "React 기초 스터디 모집", "백엔드 개발 로드맵 공유",
    "MySQL JOIN 쿼리 질문", "프론트엔드 포트폴리오 피드백 부탁드려요", "Spring Security 설정 오류",
    "알고리즘 스터디 4기 모집", "Docker 환경 세팅 가이드", "Git Flow 전략 정리",
    "AWS EC2 배포 실패 도움 요청", "CSS Grid vs Flexbox 비교", "TypeScript 마이그레이션 후기",
    "Kotlin 코루틴 완벽 정리", "JPA N+1 문제 해결법", "Redis 캐시 전략 공유",
    "Kafka 메시지 큐 입문 가이드", "Vue3 Composition API 예제", "Next.js 13 App Router 정리",
    "파이썬 FastAPI 튜토리얼", "마이크로서비스 아키텍처 개요", "GraphQL vs REST 비교 정리",
    "쿠버네티스 입문 스터디", "테스트 주도 개발 TDD 실습", "클린코드 독서 모임 모집",
    "정보처리기사 시험 후기", "리눅스 기초 명령어 정리", "CI/CD 파이프라인 구축 후기",
    "MongoDB 스키마 설계 팁", "WebSocket 채팅 구현기", "OAuth2 소셜 로그인 구현",
    "JWT 토큰 갱신 전략", "Nginx 리버스 프록시 설정", "Gradle 빌드 스크립트 최적화",
    "IntelliJ 단축키 모음", "Postman 자동화 테스트 팁", "Swagger UI 커스터마이징",
    "Spring Batch 도입 후기", "Elasticsearch 검색 최적화", "Prometheus + Grafana 모니터링",
    "코드 리뷰 문화 정착기", "기술 면접 준비 자료 공유", "신입 개발자 취업 후기",
    "사이드 프로젝트 팀원 모집", "오픈소스 컨트리뷰션 시작하기", "개발자 유튜브 채널 추천",
    "노션으로 TIL 정리하는 방법"
  };

  Random rnd = new Random(42);
  for (int i = title.length; i >= 1; i--) {
    Map<String,Object> post = new LinkedHashMap<>();
    post.put("no",       i);
    post.put("board_type", board_type[rnd.nextInt(board_type.length)]);
    post.put("title",    title[title.length - i]);
    post.put("writer",   writer[rnd.nextInt(writer.length)]);
    post.put("views",    rnd.nextInt(300) + 1);
    post.put("date",     String.format("2025.%02d.%02d", rnd.nextInt(4)+1, rnd.nextInt(28)+1));
    post.put("isNew",    i > (title.length - 5));  // 최근 5개는 NEW 뱃지
    post.put("isNotice", i > (title.length - 2));  // 최근 2개는 공지
    allPosts.add(post);
  }

  /* ── 검색 필터 ───────────────────────────────────────── */
  List<Map<String,Object>> filtered = new ArrayList<>();
  for (Map<String,Object> p : allPosts) {
    if (keyword.isEmpty()) {
      filtered.add(p);
    } else {
      String kw = keyword.toLowerCase();
      boolean match = false;
      if (searchType.equals("title")  && ((String)p.get("title")).toLowerCase().contains(kw))  match = true;
      if (searchType.equals("writer") && ((String)p.get("writer")).toLowerCase().contains(kw)) match = true;
      if (searchType.equals("all")    && (((String)p.get("title")).toLowerCase().contains(kw)
                                       || ((String)p.get("writer")).toLowerCase().contains(kw))) match = true;
      if (match) filtered.add(p);
    }
  }

  /* ── 페이징 계산 ─────────────────────────────────────── */
  int totalCount = filtered.size();
  int totalPages = (int)Math.ceil((double)totalCount / pageSize);
  if (totalPages < 1) totalPages = 1;
  if (currentPage > totalPages) currentPage = totalPages;

  int startIdx = (currentPage - 1) * pageSize;
  int endIdx   = Math.min(startIdx + pageSize, totalCount);
  List<Map<String,Object>> pagePosts = filtered.subList(startIdx, endIdx);

  int blockStart = ((currentPage - 1) / blockSize) * blockSize + 1;
  int blockEnd   = Math.min(blockStart + blockSize - 1, totalPages);
  int prevBlock  = blockStart - 1;
  int nextBlock  = blockEnd + 1;
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<!-- ── 헤더 ── -->
<header class="lms-header">
  <div class="lms-logo">re<span>·</span>merge</div>
  <nav class="header-nav">
    <a href="#">대시보드</a>
    <a href="#">강의실</a>
    <a href="#" class="active">커뮤니티</a>
    <a href="#">공지사항</a>
  </nav>
  <div class="header-user">
    <div class="avatar">${book.name}</div>
    <span>노현웅</span>
  </div>
</header>

<!-- ── 본문 ── -->
<main class="board-wrap">

  <!-- 페이지 헤더 -->
  <div class="board-header">
    <div class="board-eyebrow">Community</div>
    <h1 class="board-title">자유 게시판</h1>
    <p class="board-count">
      총 <strong><%= totalCount %></strong>개의 게시글
      <% if (currentPage > 1) { %> · <strong><%= currentPage %></strong> / <%= totalPages %> 페이지<% } %>
    </p>
  </div>

  <!-- 통계 칩 -->
  <div class="stats-bar">
    <div class="stat-chip"><span class="dot" style="background:#ff6b6b"></span>공지 <strong>2</strong></div>
    <div class="stat-chip"><span class="dot" style="background:#4ade80"></span>자유 <strong>18</strong></div>
    <div class="stat-chip"><span class="dot" style="background:#fbbf24"></span>질문 <strong>12</strong></div>
    <div class="stat-chip"><span class="dot" style="background:var(--bright)"></span>스터디 <strong>10</strong></div>
    <div class="stat-chip"><span class="dot" style="background:#c4b5fd"></span>정보 <strong>8</strong></div>
  </div>

  <!-- 툴바 -->
  <div class="board-toolbar">
    <form class="search-form" method="get" action="board.jsp">
      <select name="searchType" class="search-select">
        <option value="title"  <%= "title" .equals(searchType) ? "selected" : "" %>>제목</option>
        <option value="author" <%= "author".equals(searchType) ? "selected" : "" %>>작성자</option>
        <option value="all"    <%= "all"   .equals(searchType) ? "selected" : "" %>>제목+작성자</option>
      </select>
      <input type="text" name="keyword" class="search-input"
             placeholder="검색어를 입력하세요" value="<%= keyword %>">
      <button type="submit" class="btn-search">검색</button>
    </form>
    <button class="btn-write" onclick="alert('글쓰기 페이지로 이동합니다.')">✏ 글쓰기</button>
  </div>

  <!-- 검색 결과 안내 -->
  <% if (!keyword.isEmpty()) { %>
  <div class="search-notice">
    <span>🔍</span>
    "<strong><%= keyword %></strong>" 검색 결과 — <strong><%= totalCount %></strong>건
    <a href="board.jsp">✕ 검색 초기화</a>
  </div>
  <% } %>

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
        <% if (pagePosts.isEmpty()) { %>
        <tr class="empty-row">
          <td colspan="6">
            <div class="empty-icon">📭</div>
            <div class="empty-text">게시글이 없습니다.</div>
          </td>
        </tr>

        <% } else {
             for (Map<String,Object> post : pagePosts) {
               boolean isNotice = (boolean) post.get("isNotice");
               boolean isNew    = (boolean) post.get("isNew");
               int     views    = (int)     post.get("views");
               String  cat      = (String)  post.get("category");
        %>
        <tr class="<%= isNotice ? "notice-row" : "" %>"
            onclick="alert('게시글 <%= post.get("no") %>번 상세 페이지로 이동합니다.')">
          <td class="td-no">
            <% if (isNotice) { %><span class="notice-badge">공지</span><% } else { %><%= post.get("no") %><% } %>
          </td>
          <td>
            <span class="category-tag cat-<%= cat %>"><%= cat %></span>
          </td>
          <td class="td-title">
            <div class="title-inner">
              <span class="title-text"><%= post.get("title") %></span>
              <% if (isNew) { %><span class="badge-new">NEW</span><% } %>
            </div>
          </td>
          <td><%= post.get("author") %></td>
          <td class="td-views <%= views > 200 ? "views-high" : "" %>"><%= views %></td>
          <td><%= post.get("date") %></td>
        </tr>
        <% } } %>
      </tbody>
    </table>
  </div>

  <!-- ── 페이지네이션 ── -->
  <nav class="pagination-wrap" aria-label="페이지 탐색">

    <%-- 처음 --%>
    <% if (currentPage > 1) { %>
    <a class="page-btn arrow" href="board.jsp?page=1&keyword=<%= keyword %>&searchType=<%= searchType %>" title="처음">«</a>
    <% } else { %>
    <span class="page-btn arrow disabled">«</span>
    <% } %>

    <%-- 이전 블럭 --%>
    <% if (prevBlock >= 1) { %>
    <a class="page-btn arrow" href="board.jsp?page=<%= prevBlock %>&keyword=<%= keyword %>&searchType=<%= searchType %>" title="이전">‹</a>
    <% } else { %>
    <span class="page-btn arrow disabled">‹</span>
    <% } %>

    <%-- 번호 블럭 --%>
    <% for (int p = blockStart; p <= blockEnd; p++) { %>
      <% if (p == currentPage) { %>
    <span class="page-btn active"><%= p %></span>
      <% } else { %>
    <a class="page-btn" href="board.jsp?page=<%= p %>&keyword=<%= keyword %>&searchType=<%= searchType %>"><%= p %></a>
      <% } %>
    <% } %>

    <%-- 다음 블럭 --%>
    <% if (nextBlock <= totalPages) { %>
    <a class="page-btn arrow" href="board.jsp?page=<%= nextBlock %>&keyword=<%= keyword %>&searchType=<%= searchType %>" title="다음">›</a>
    <% } else { %>
    <span class="page-btn arrow disabled">›</span>
    <% } %>

    <%-- 마지막 --%>
    <% if (currentPage < totalPages) { %>
    <a class="page-btn arrow" href="board.jsp?page=<%= totalPages %>&keyword=<%= keyword %>&searchType=<%= searchType %>" title="마지막">»</a>
    <% } else { %>
    <span class="page-btn arrow disabled">»</span>
    <% } %>

  </nav>

</main>

<script src="${pageContext.request.contextPath}/js/bgParticle.js"></script>
</body>
</html>
