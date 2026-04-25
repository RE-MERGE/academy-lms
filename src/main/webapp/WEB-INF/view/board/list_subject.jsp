<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>re-merge LMS — ${course.course_name} 게시판</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
<main class="board-wrap">

  <!-- ══════════════════════════════════════
       과목 정보 헤더
  ══════════════════════════════════════ -->
  <div class="detail-head">
    <span class="badge-category FREE">${course.course_type}</span>
    <h2 class="detail-title">${course.course_name}</h2>
    <div class="detail-meta">
      <span>👨‍🏫 ${professorName} 교수</span>
      <span>🗓 ${course.semester}</span>
      <span>👥 수강인원 ${course.counts}명</span>
      <span>🏫 ${course.room_info}</span>
    </div>
  </div>

  <!-- ══════════════════════════════════════
       탭 + 검색 툴바
  ══════════════════════════════════════ -->

  <!-- 탭 -->
  <div class="board-tabs">
    <a href="?course_no=${course.course_no}&boardType=NOTICE"
       class="${boardType == 'NOTICE' ? 'active' : ''}">📢 공지사항</a>
    <a href="?course_no=${course.course_no}&boardType=FREE"
       class="${boardType == 'FREE' ? 'active' : ''}">💬 자유게시판</a>
    <a href="?course_no=${course.course_no}&boardType=QNA"
       class="${boardType == 'QNA' ? 'active' : ''}">❓ Q&amp;A</a>
  </div>

  <!-- 검색 툴바 -->
  <div class="board-card" style="border-radius: 0 14px 14px 14px;">

    <div class="board-toolbar" style="padding: 14px 16px; border-bottom: 1px solid #f0f2f7;">
      <form class="search-form" method="get" action="">
        <input type="hidden" name="boardType" value="${boardType}">
        <input type="hidden" name="course_no"  value="${course.course_no}">
        <select name="searchType" class="search-select">
          <option value="title"  <c:if test="${searchType == 'title'}">selected</c:if>>제목</option>
          <option value="writer" <c:if test="${searchType == 'writer'}">selected</c:if>>작성자</option>
          <option value="all"    <c:if test="${searchType == 'all'}">selected</c:if>>제목+작성자</option>
        </select>
        <input type="text" name="keyword" class="search-input"
               placeholder="검색어를 입력하세요" value="${keyword}">
        <button type="submit" class="btn-search">🔍 검색</button>
      </form>

      <!-- 탭별 설명 문구 -->
      <c:choose>
        <c:when test="${boardType == 'NOTICE'}">
          <span class="page-info">📢 교수님이 올린 공지사항입니다.</span>
        </c:when>
        <c:when test="${boardType == 'QNA'}">
          <span class="page-info">❓ 수강생 누구나 질문할 수 있어요.</span>
        </c:when>
        <c:otherwise>
          <span class="page-info">💬 자유롭게 이야기 나눠요.</span>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- ══════════════════════════════════════
         게시글 테이블
    ══════════════════════════════════════ -->
    <table class="board-table">
      <colgroup>
        <col class="col-no">
        <col class="col-writer">
        <col class="col-title">
        <col class="col-date">
        <col class="col-views">
        <col class="col-comment">
      </colgroup>
      <thead>
        <tr>
          <th>No</th>
          <th>작성자</th>
          <th style="text-align:left; padding-left:14px;">제목</th>
          <th>작성일</th>
          <th>조회</th>
          <th>댓글</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty postList}">
            <tr class="empty-row">
              <td colspan="6">
                <div class="empty-icon">
                  <c:choose>
                    <c:when test="${boardType == 'NOTICE'}">📢</c:when>
                    <c:when test="${boardType == 'QNA'}">❓</c:when>
                    <c:otherwise>📭</c:otherwise>
                  </c:choose>
                </div>
                <div class="empty-text">
                  <c:choose>
                    <c:when test="${boardType == 'NOTICE'}">등록된 공지사항이 없습니다.</c:when>
                    <c:when test="${boardType == 'QNA'}">아직 질문이 없어요. 첫 질문을 남겨보세요!</c:when>
                    <c:otherwise>게시글이 없습니다. 첫 글을 작성해보세요!</c:otherwise>
                  </c:choose>
                </div>
              </td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="post" items="${postList}">
              <tr onclick="location='detail?boardNo=${post.boardNo}&boardType=${post.boardType}&course_no=${course.course_no}'">

                <!-- 번호 / 공지 뱃지 -->
                <td class="td-no">
                  <c:choose>
                    <c:when test="${post.boardType == 'NOTICE'}">
                      <span class="notice-badge">공지</span>
                    </c:when>
                    <c:otherwise>${post.rowNum}</c:otherwise>
                  </c:choose>
                </td>

                <!-- 작성자 -->
                <td>${post.writerName}</td>

                <!-- 제목 -->
                <td class="td-title">
                  <div class="title-inner">
                    <!-- 카테고리 태그 (QNA일 때만) -->
                    <c:if test="${boardType == 'QNA'}">
                      <span class="category-tag cat-QNA">Q&amp;A</span>
                    </c:if>
                    <span class="title-text">${post.title}</span>
                    <c:if test="${not empty post.fileUrl}">
                      <span class="file-icon-inline">📎</span>
                    </c:if>
                    <!-- 최신글 뱃지 (3일 이내) -->
                    <%-- JSTL로 날짜 비교가 복잡하므로 서버에서 isNew 플래그 권장 --%>
<%--                    <c:if test="${post.isNew}">--%>
<%--                      <span class="badge-new">NEW</span>--%>
<%--                    </c:if>--%>
                  </div>
                </td>

                <!-- 작성일 -->
                <td class="td-date">
                  <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd HH:mm"/>
                </td>

                <!-- 조회수 -->
                <td class="td-views ${post.views > 200 ? 'views-high' : ''}">${post.views}</td>

                <!-- 댓글수 -->
<%--                <td class="td-comment">--%>
<%--                  <c:if test="${post.commentCount > 0}">--%>
<%--                    <span class="comment-count">[${post.commentCount}]</span>--%>
<%--                  </c:if>--%>
<%--                </td>--%>

              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div><!-- /.board-card -->

  <!-- ══════════════════════════════════════
       하단 푸터 (페이지네이션 + 버튼)
  ══════════════════════════════════════ -->
  <div class="board-footer">

    <!-- 페이지네이션 -->
    <nav class="pagination-wrap">
      <!-- 처음 / 이전 블록 -->
      <c:choose>
        <c:when test="${startPage > 1}">
          <a class="page-btn" href="?boardType=${boardType}&course_no=${course.course_no}&page=1&keyword=${keyword}&searchType=${searchType}">«</a>
          <a class="page-btn" href="?boardType=${boardType}&course_no=${course.course_no}&page=${prevBlock}&keyword=${keyword}&searchType=${searchType}">‹</a>
        </c:when>
        <c:otherwise>
          <span class="page-btn disabled">«</span>
          <span class="page-btn disabled">‹</span>
        </c:otherwise>
      </c:choose>

      <!-- 숫자 버튼 -->
      <c:forEach begin="${startPage}" end="${endPage}" var="p">
        <c:choose>
          <c:when test="${p == currentPage}">
            <span class="page-btn active">${p}</span>
          </c:when>
          <c:otherwise>
            <a class="page-btn" href="?boardType=${boardType}&course_no=${course.course_no}&page=${p}&keyword=${keyword}&searchType=${searchType}">${p}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <!-- 다음 블록 / 마지막 -->
      <c:choose>
        <c:when test="${endPage < totalPages}">
          <a class="page-btn" href="?boardType=${boardType}&course_no=${course.course_no}&page=${nextBlock}&keyword=${keyword}&searchType=${searchType}">›</a>
          <a class="page-btn" href="?boardType=${boardType}&course_no=${course.course_no}&page=${totalPages}&keyword=${keyword}&searchType=${searchType}">»</a>
        </c:when>
        <c:otherwise>
          <span class="page-btn disabled">›</span>
          <span class="page-btn disabled">»</span>
        </c:otherwise>
      </c:choose>
    </nav>

    <!-- 글쓰기 버튼 -->
    <div class="board-footer-right">
      <!-- 공지는 교수/관리자만 작성 가능 -->
      <c:choose>
        <c:when test="${boardType == 'NOTICE'}">
          <c:if test="${sessionScope.sessionUser.role eq 'PROFESSOR'
                       or sessionScope.sessionUser.role eq 'ADMIN'}">
            <button class="btn-write"
                    onclick="location='${pageContext.request.contextPath}/board/write?boardType=${boardType}&course_no=${course.course_no}'">
              ✏️ 공지 작성
            </button>
          </c:if>
        </c:when>
        <c:otherwise>
          <button class="btn-write"
                  onclick="location='${pageContext.request.contextPath}/board/write?boardType=${boardType}&course_no=${course.course_no}'">
            ✏️ 글쓰기
          </button>
        </c:otherwise>
      </c:choose>
    </div>

  </div><!-- /.board-footer -->

</main>
