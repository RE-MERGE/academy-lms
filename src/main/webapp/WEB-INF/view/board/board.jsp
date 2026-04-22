<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
  <style>
    /* ── 탭 ── */
    .board-tabs {
      display: flex;
      gap: 0;
      margin-bottom: 0;
      border-bottom: none;
    }

    .board-tabs a {
      padding: 10px 28px;
      font-weight: 700;
      font-size: 0.95rem;
      color: var(--lms-text-sub);
      background: #f0f2f5;
      border: 1px solid var(--lms-border);
      border-bottom: none;
      border-radius: 8px 8px 0 0;
      text-decoration: none;
      transition: all 0.2s;
      margin-right: 4px;
    }

    .board-tabs a:hover {
      background: #e6ecff;
      color: var(--lms-accent);
    }

    .board-tabs a.active {
      background: #ffffff;
      color: var(--lms-primary);
      border-color: var(--lms-border);
      border-bottom: 2px solid #ffffff;
      margin-bottom: -1px;
      z-index: 1;
      position: relative;
    }

    /* ── 체크박스 컬럼 ── */
    .td-check { width: 40px; text-align: center !important; }
    .td-check input[type=checkbox] { cursor: pointer; width: 16px; height: 16px; accent-color: var(--lms-primary); }

    /* ── 댓글수 ── */
    .td-comment { width: 60px; }
    .comment-count { color: var(--lms-accent); font-weight: 700; font-size: 0.9rem; }

    /* ── 파일 아이콘 ── */
    .file-icon-inline { font-size: 0.85rem; margin-left: 4px; }

    /* ── 하단 버튼 영역 ── */
    .board-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 1.2rem;
    }

    .board-footer-left { display: flex; gap: 8px; align-items: center; }
    .board-footer-right { display: flex; gap: 8px; }

    /* ── 검색 영역 ── */
    .board-toolbar {
      margin-bottom: 1rem;
    }

    /* ── 페이지네이션 ── */
    .pagination-wrap {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 6px;
      margin-top: 0;
    }

    .page-info {
      font-size: 0.85rem;
      color: var(--lms-text-sub);
      margin: 0 8px;
    }

    /* ── 조회수 높을 때 ── */
    .views-high { color: #e63946; font-weight: 700; }

    /* ── 카테고리 태그 ── */
    .category-tag {
      padding: 3px 10px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 700;
    }
    .cat-NOTICE { background: #fff1f0; color: #ff4d4f; border: 1px solid #ffccc7; }
    .cat-FREE   { background: #e6f4ff; color: #1677ff; border: 1px solid #91caff; }
    .cat-QNA    { background: #f6ffed; color: #52c41a; border: 1px solid #b7eb8f; }
  </style>
</head>
<body>

<main class="board-wrap">

  <!-- 툴바: 검색 -->
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

  <!-- 탭 -->
  <div class="board-tabs">
    <a href="?boardType=NOTICE<c:if test='${not empty courseNo}'>&courseNo=${courseNo}</c:if>"
       class="<c:if test='${boardType == \"NOTICE\"}'>active</c:if>">공지</a>
<%--    <a href="?boardType=QNA<c:if test='${not empty courseNo}'>&courseNo=${courseNo}</c:if>"--%>
<%--       class="<c:if test='${boardType == \"QNA\"}'>active</c:if>">Q &amp; A</a>--%>
    <a href="?boardType=FREE<c:if test='${not empty courseNo}'>&courseNo=${courseNo}</c:if>"
       class="<c:if test='${boardType == \"FREE\"}'>active</c:if>">자유게시판</a>
  </div>

  <!-- 게시글 테이블 -->
  <div class="board-card">
    <table class="board-table">
      <thead>
        <tr>
          <th class="td-check">
            <input type="checkbox" id="checkAll" onclick="toggleAll(this)">
          </th>
          <th>번호</th>
          <th>이름</th>
          <th>제목</th>
          <th>작성일</th>
          <th>조회수</th>
          <th>댓글</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty postList}">
            <tr class="empty-row">
              <td colspan="7">
                <div class="empty-icon">📭</div>
                <div class="empty-text">게시글이 없습니다.</div>
              </td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="post" items="${postList}">
              <tr onclick="location='detail?boardNo=${post.boardNo}'">
                <td class="td-check" onclick="event.stopPropagation()">
                  <input type="checkbox" name="selectedBoard" value="${post.boardNo}">
                </td>
                <td class="td-no">
                  <c:choose>
                    <c:when test="${post.boardType == 'NOTICE'}">
                      <span class="notice-badge">공지</span>
                    </c:when>
                    <c:otherwise>${post.boardNo}</c:otherwise>
                  </c:choose>
                </td>
                <td>${post.writerName}</td>
                <td class="td-title">
                  <div class="title-inner">
                    <span class="title-text">${post.title}</span>
<%--                    <c:if test="${not empty post.fileUrl}">--%>
<%--                      <span class="file-icon-inline">📎</span>--%>
<%--                    </c:if>--%>
                  </div>
                </td>
                <td>${post.createdAt}</td>
                <td class="td-views <c:if test='${post.views > 200}'>views-high</c:if>">${post.views}</td>
<%--                <td class="td-comment">--%>
<%--                  <span class="comment-count">${post.commentCount}</span>--%>
<%--                </td>--%>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>

<%--  <!-- 하단: 전체선택 + 페이지네이션 + 버튼 -->--%>
<%--  <div class="board-footer">--%>
<%--    <!-- 왼쪽: 전체선택 라벨 -->--%>
<%--    <div class="board-footer-left">--%>
<%--      <label style="font-size:0.9rem; color:var(--lms-text-sub); cursor:pointer;">--%>
<%--        <input type="checkbox" onclick="toggleAll(this)"> 전체선택--%>
<%--      </label>--%>
<%--    </div>--%>

<%--    <!-- 가운데: 페이지네이션 -->--%>
<%--    <nav class="pagination-wrap">--%>
<%--      <c:choose>--%>
<%--        <c:when test="${currentPage > 1}">--%>
<%--          <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=1&keyword=${keyword}&searchType=${searchType}">«</a>--%>
<%--          <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=${prevBlock}&keyword=${keyword}&searchType=${searchType}">‹</a>--%>
<%--        </c:when>--%>
<%--        <c:otherwise>--%>
<%--          <span class="page-btn arrow disabled">«</span>--%>
<%--          <span class="page-btn arrow disabled">‹</span>--%>
<%--        </c:otherwise>--%>
<%--      </c:choose>--%>

<%--      <span class="page-info">${currentPage} / ${totalPages}</span>--%>

<%--      <c:choose>--%>
<%--        <c:when test="${currentPage < totalPages}">--%>
<%--          <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=${nextBlock}&keyword=${keyword}&searchType=${searchType}">›</a>--%>
<%--          <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=${totalPages}&keyword=${keyword}&searchType=${searchType}">»</a>--%>
<%--        </c:when>--%>
<%--        <c:otherwise>--%>
<%--          <span class="page-btn arrow disabled">›</span>--%>
<%--          <span class="page-btn arrow disabled">»</span>--%>
<%--        </c:otherwise>--%>
<%--      </c:choose>--%>
<%--    </nav>--%>

    <!-- 오른쪽: 수정/글쓰기 버튼 -->
    <div class="board-footer-right">
      <button class="btn-cancel" onclick="editSelected()">수정하기</button>
      <button class="btn-write"  onclick="location='${pageContext.request.contextPath}/board/write?boardType=${boardType}&courseNo=${courseNo}'">글쓰기</button>
    </div>
  </div>

</main>

<script>
  function toggleAll(source) {
    const checkboxes = document.querySelectorAll('input[name="selectedBoard"]');
    checkboxes.forEach(cb => cb.checked = source.checked);
    // 전체선택 체크박스 두 개 동기화
    document.querySelectorAll('input[type=checkbox]').forEach(cb => {
      if (cb !== source && cb.id !== 'checkAll' && !cb.name) cb.checked = source.checked;
    });
  }

  function editSelected() {
    const selected = [...document.querySelectorAll('input[name="selectedBoard"]:checked')];
    if (selected.length === 0) { alert('수정할 게시글을 선택해주세요.'); return; }
    if (selected.length > 1)   { alert('게시글을 하나만 선택해주세요.'); return; }
    location.href = '${pageContext.request.contextPath}/board/update?boardNo=' + selected[0].value;
  }
</script>

</body>
</html>
