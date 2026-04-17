<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>re-merge LMS · ${notice.title}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css"/>
</head>
<body>

<canvas id="bg-canvas"></canvas>
<div class="bg-mesh"></div>

<div class="board-wrap board-wrap--detail">

  <!-- ── 뒤로가기 ── -->
  <a href="noticeList.do?page=${param.page}&searchType=${param.searchType}&keyword=${param.keyword}"
     class="back-link">&#8592; 목록으로</a>

  <!-- ── 게시글 헤더 ── -->
  <div class="detail-head">
    <div class="detail-meta-top">
      <span class="badge-category ${notice.categoryClass}">${notice.category}</span>
      <c:if test="${notice.isPinned}">
        <span class="badge-pin">고정</span>
      </c:if>
    </div>
    <h2 class="detail-title">${notice.title}</h2>
    <div class="detail-meta">
      <span>✍ ${notice.writerName}</span>
      <span>🕐 <fmt:formatDate value="${notice.createdAt}" pattern="yyyy.MM.dd HH:mm"/></span>
      <c:if test="${notice.updatedAt ne null}">
        <span class="meta-edited">(수정됨: <fmt:formatDate value="${notice.updatedAt}" pattern="yyyy.MM.dd HH:mm"/>)</span>
      </c:if>
      <span>👁 ${notice.viewCount}</span>
    </div>
  </div>

  <!-- ── 첨부파일 ── -->
  <c:if test="${not empty notice.files}">
    <div class="attach-box">
      <p class="attach-label">📎 첨부파일</p>
      <ul class="attach-list">
        <c:forEach var="file" items="${notice.files}">
          <li>
            <a href="fileDownload.do?fileId=${file.id}" class="attach-item">
              <span class="attach-icon">⬇</span>
              ${file.originalName}
              <span class="attach-size">(${file.sizeLabel})</span>
            </a>
          </li>
        </c:forEach>
      </ul>
    </div>
  </c:if>

  <!-- ── 본문 ── -->
  <div class="detail-body">
    ${notice.content}
  </div>

  <!-- ── 관리 버튼: 작성자·관리자만 ── -->
  <c:if test="${sessionScope.loginUser.role eq 'ADMIN'
               or sessionScope.loginUser.id eq notice.writerId}">
    <div class="detail-actions">
      <a href="noticeWrite.do?id=${notice.id}" class="btn-edit">수정</a>
      <button class="btn-delete" onclick="confirmDelete(${notice.id})">삭제</button>
    </div>
  </c:if>

  <!-- ── 이전 / 다음 글 ── -->
  <div class="nav-post">
    <c:if test="${not empty prevNotice}">
      <a href="noticeDetail.do?id=${prevNotice.id}" class="nav-post-item">
        <span class="nav-label">▲ 이전글</span>
        <span class="nav-post-title">${prevNotice.title}</span>
      </a>
    </c:if>
    <c:if test="${not empty nextNotice}">
      <a href="noticeDetail.do?id=${nextNotice.id}" class="nav-post-item">
        <span class="nav-label">▼ 다음글</span>
        <span class="nav-post-title">${nextNotice.title}</span>
      </a>
    </c:if>
  </div>

</div><!-- /board-wrap -->

<!-- 삭제 확인 스크립트 -->
<script>
  function confirmDelete(id) {
    if (!confirm('공지사항을 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.')) return;
    const form = document.createElement('form');
    form.method = 'post';
    form.action = 'noticeDelete.do';
    const input = document.createElement('input');
    input.type  = 'hidden';
    input.name  = 'id';
    input.value = id;
    form.appendChild(input);
    document.body.appendChild(form);
    form.submit();
  }
</script>
<script src="${pageContext.request.contextPath}/js/bgParticle.js"></script>
</body>
</html>
