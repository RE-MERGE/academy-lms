<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>re-merge LMS · 공지사항</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css"/>
</head>
<body>

<canvas id="bg-canvas"></canvas>
<div class="bg-mesh"></div>

<div class="board-wrap">

  <!-- ── 헤더 ── -->
  <div class="board-header">
    <div class="board-header-left">
      <p class="board-eyebrow">re-merge LMS</p>
      <h1 class="board-title">공지사항 <span>📢</span></h1>
      <p class="board-desc">학생, 강사, 관리자를 위한 공식 공지입니다.</p>
    </div>

    <!-- 글쓰기: 관리자·강사만 노출 -->
    <c:if test="${sessionScope.loginUser.role eq 'ADMIN' or sessionScope.loginUser.role eq 'INSTRUCTOR'}">
      <a href="noticeWrite.do" class="btn-write">＋ 공지 등록</a>
    </c:if>
  </div>

  <!-- ── 검색 ── -->
  <form class="search-bar" action="noticeList.do" method="get">
    <select name="searchType" class="search-select">
      <option value="title"   ${param.searchType eq 'title'   ? 'selected' : ''}>제목</option>
      <option value="content" ${param.searchType eq 'content' ? 'selected' : ''}>내용</option>
      <option value="writer"  ${param.searchType eq 'writer'  ? 'selected' : ''}>작성자</option>
    </select>
    <div class="search-input-wrap">
      <input type="text" name="keyword" value="${param.keyword}"
             placeholder="검색어를 입력하세요" class="search-input"/>
      <button type="submit" class="search-btn">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
          <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
        </svg>
      </button>
    </div>
  </form>

  <!-- ── 게시글 테이블 ── -->
  <div class="table-wrap">
    <table class="board-table">
      <colgroup>
        <col style="width:80px"/>   <%-- 번호 --%>
        <col style="width:80px"/>   <%-- 분류 --%>
        <col/>                      <%-- 제목 --%>
        <col style="width:110px"/>  <%-- 작성자 --%>
        <col style="width:110px"/>  <%-- 작성일 --%>
        <col style="width:70px"/>   <%-- 조회 --%>
        <col style="width:70px"/>   <%-- 파일 --%>
      </colgroup>
      <thead>
        <tr>
          <th>번호</th>
          <th>분류</th>
          <th>제목</th>
          <th>작성자</th>
          <th>작성일</th>
          <th>조회</th>
          <th>파일</th>
        </tr>
      </thead>
      <tbody>
        <%-- 상단 고정 공지 --%>
        <c:forEach var="pin" items="${pinnedList}">
          <tr class="row-pin">
            <td><span class="badge-pin">고정</span></td>
            <td><span class="badge-category ${pin.categoryClass}">${pin.category}</span></td>
            <td class="td-title">
              <a href="noticeDetail.do?id=${pin.id}">${pin.title}</a>
              <c:if test="${pin.isNew}"><span class="badge-new">N</span></c:if>
            </td>
            <td>${pin.writerName}</td>
            <td><fmt:formatDate value="${pin.createdAt}" pattern="yyyy.MM.dd"/></td>
            <td>${pin.viewCount}</td>
            <td>
              <c:if test="${pin.hasFile}">
                <span class="icon-file" title="첨부파일 있음">📎</span>
              </c:if>
            </td>
          </tr>
        </c:forEach>

        <%-- 일반 게시글 --%>
        <c:choose>
          <c:when test="${empty noticeList}">
            <tr>
              <td colspan="7" class="td-empty">등록된 공지사항이 없습니다.</td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="notice" items="${noticeList}" varStatus="st">
              <tr class="row-normal">
                <td>${paging.totalCount - (paging.currentPage - 1) * paging.pageSize - st.index}</td>
                <td><span class="badge-category ${notice.categoryClass}">${notice.category}</span></td>
                <td class="td-title">
                  <a href="noticeDetail.do?id=${notice.id}">${notice.title}</a>
                  <c:if test="${notice.isNew}"><span class="badge-new">N</span></c:if>
                </td>
                <td>${notice.writerName}</td>
                <td><fmt:formatDate value="${notice.createdAt}" pattern="yyyy.MM.dd"/></td>
                <td>${notice.viewCount}</td>
                <td>
                  <c:if test="${notice.hasFile}">
                    <span class="icon-file" title="첨부파일 있음">📎</span>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>

  <!-- ── 페이지네이션 ── -->
  <c:if test="${not empty paging}">
    <nav class="pagination">
      <c:if test="${paging.hasPrev}">
        <a href="noticeList.do?page=${paging.startPage - 1}&searchType=${param.searchType}&keyword=${param.keyword}"
           class="page-nav">&laquo;</a>
      </c:if>

      <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="p">
        <a href="noticeList.do?page=${p}&searchType=${param.searchType}&keyword=${param.keyword}"
           class="page-num ${p eq paging.currentPage ? 'active' : ''}">${p}</a>
      </c:forEach>

      <c:if test="${paging.hasNext}">
        <a href="noticeList.do?page=${paging.endPage + 1}&searchType=${param.searchType}&keyword=${param.keyword}"
           class="page-nav">&raquo;</a>
      </c:if>
    </nav>
  </c:if>

</div><!-- /board-wrap -->

</body>
</html>
