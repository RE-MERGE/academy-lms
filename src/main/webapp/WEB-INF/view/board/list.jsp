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
<%--        <col class="col-check">--%>
        <col class="col-no">
        <col class="col-writer">
        <col class="col-title">
        <col class="col-date">
        <col class="col-views">
<%--        <col class="col-comment">--%>
      </colgroup>
      <thead>
        <tr>
<%--          <th class="td-check">--%>
<%--            <input type="checkbox" id="checkAll" onclick="toggleAll(this)">--%>
<%--          </th>--%>
          <th>No</th>
          <th>작성자</th>
          <th style="text-align:left; padding-left:14px;">제목</th>
          <th>작성일</th>
          <th>조회</th>
<%--          <th>댓글</th>--%>
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
              <tr onclick="location='detail?boardNo=${post.boardNo}&boardType=${post.boardType}'">
                <!-- 체크박스 -->
<%--                <td class="td-check" onclick="event.stopPropagation()">--%>
<%--                  <input type="checkbox" name="selectedBoard" value="${post.boardNo}">--%>
<%--                </td>--%>
                <!-- 번호 -->
                <td class="td-no">${post.rowNum}</td>
                <!-- 작성자 -->
                <td>${post.writerName}</td>
                <!-- 제목 -->
                <td class="td-title">
                  <div class="title-inner">
                    <span class="title-text">${post.title}</span>
<%--                  <c:if test="${not empty post.fileUrl}">
                      <span class="file-icon-inline">📎</span>
                    </c:if> --%>
                  </div>
                </td>
                <!-- 작성일 -->
                <td class="td-date"><fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd HH:mm"/></td>
                <!-- 조회수 -->
                <td class="td-views <c:if test='${post.views > 200}'>views-high</c:if>">${post.views}</td>
                <!-- 댓글수 -->
<%--                <td class="td-comment">--%>
<%--                  <span class="comment-count">--%>
<%--                  ${post.commentCount} --%>
<%--                  </span>--%>
<%--                </td>--%>
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
<%--    <div class="board-footer-left">--%>
<%--      <label style="font-size:0.88rem; color:var(--lms-text-sub); cursor:pointer; display:flex; align-items:center; gap:6px;">--%>
<%--        <input type="checkbox" onclick="toggleAll(this)"> 전체선택--%>
<%--      </label>--%>
<%--    </div>--%>

    <!-- 가운데: 페이지네이션 -->
<%--    <nav class="pagination-wrap">--%>
<%--      <c:choose>--%>
<%--        <c:when test="${currentPage > 1}">--%>
<%--          <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=1&keyword=${keyword}&searchType=${searchType}">«</a>--%>
<%--          <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=${prevBlock}&keyword=${keyword}&searchType=${searchType}">‹</a>--%>
<%--        </c:when>--%>
<%--        <c:otherwise>--%>
<%--          <span class="page-btn disabled">«</span>--%>
<%--          <span class="page-btn disabled">‹</span>--%>
<%--        </c:otherwise>--%>
<%--      </c:choose>--%>

<%--      <span class="page-info">${currentPage} / ${totalPages}</span>--%>

<%--      <c:choose>--%>
<%--        <c:when test="${currentPage < totalPages}">--%>
<%--          <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=${nextBlock}&keyword=${keyword}&searchType=${searchType}">›</a>--%>
<%--          <a class="page-btn arrow" href="?boardType=${boardType}&courseNo=${courseNo}&page=${totalPages}&keyword=${keyword}&searchType=${searchType}">»</a>--%>
<%--        </c:when>--%>
<%--        <c:otherwise>--%>
<%--          <span class="page-btn disabled">›</span>--%>
<%--          <span class="page-btn disabled">»</span>--%>
<%--        </c:otherwise>--%>
<%--      </c:choose>--%>
<%--    </nav>--%>
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
    <div class="board-footer-right">
<%--      <button class="btn-cancel" onclick="editSelected()">수정하기</button>--%>
      <button class="btn-write"  onclick="location='${pageContext.request.contextPath}/board/write?boardType=${boardType}'">글쓰기</button>
    </div>
  </div>

</main>

<script>
  // function toggleAll(source) {
  //   document.querySelectorAll('input[name="selectedBoard"]')
  //     .forEach(cb => cb.checked = source.checked);
  //   // 전체선택 체크박스 두 개 동기화
  //   document.querySelectorAll('input[type=checkbox]').forEach(cb => {
  //     if (!cb.name && cb !== document.getElementById('checkAll') && cb !== source) {
  //       cb.checked = source.checked;
  //     }
  //   });
  // }

  <%--function editSelected() {--%>
  <%--  const selected = [...document.querySelectorAll('input[name="selectedBoard"]:checked')];--%>
  <%--  if (selected.length === 0) { alert('수정할 게시글을 선택해주세요.'); return; }--%>
  <%--  if (selected.length > 1)   { alert('게시글을 하나만 선택해주세요.'); return; }--%>
  <%--  location.href = '${pageContext.request.contextPath}/board/update?boardNo=' + selected[0].value;--%>
  <%--}--%>
</script>

</body>
</html>
