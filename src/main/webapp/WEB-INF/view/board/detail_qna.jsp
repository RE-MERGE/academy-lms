<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css"/>

<div class="board-wrap">

  <!-- ══════════════════════════════════════
       질문 본문 카드
  ══════════════════════════════════════ -->
  <div class="board-card" style="padding: 40px 40px 1px; margin-top: 10px;">

    <div class="detail-head">

      <!-- 상태 뱃지 + 카테고리 -->
      <div style="display:flex; gap: 8px; align-items: center; margin-bottom: 0.5rem;">
        <span class="category-tag cat-QNA">Q&amp;A</span>
        <%-- ✅ FIX 1: boolean 필드는 not empty 대신 == true / != true 로 비교 --%>
        <c:choose>
          <c:when test="${post.answered == true}">
            <span class="badge badge-green">✅ 답변완료</span>
          </c:when>
          <c:otherwise>
            <span class="badge badge-yellow">⏳ 미답변</span>
          </c:otherwise>
        </c:choose>
      </div>

      <h2 class="detail-title">${post.title}</h2>
      <div class="detail-meta">
        <span>✍ ${post.writerName}</span>
        <span>🕐 <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd HH:mm"/></span>
        <span>👁 ${post.views}</span>
      </div>
    </div>

    <!-- 첨부파일 -->
    <c:if test="${not empty post.fileUrl}">
      <div class="attach-box">
        <p class="attach-label">📎 첨부파일</p>
        <ul class="attach-list">
          <li>
            <a href="${pageContext.request.contextPath}/board/fileDownload?fileUrl=${post.fileUrl}"
               class="attach-item">
              <span>⬇</span>${post.fileUrl}
            </a>
          </li>
        </ul>
      </div>
    </c:if>

    <!-- 질문 본문 -->
    <div class="detail-body">${post.content}</div>

    <!-- 관리 버튼 -->
    <div class="detail-actions">
      <a href="list_qna?boardType=QNA&courseNo=${post.courseNo}" class="btn-search">목록으로</a>
      <c:if test="${sessionScope.sessionUser.role eq 'ADMIN'
                   or sessionScope.sessionUser.userNo eq post.writerNo}">
        <a href="update?boardNo=${post.boardNo}&boardType=QNA&courseNo=${post.courseNo}"
           class="btn-edit">수정</a>
        <button class="btn-delete" onclick="confirmDelete(${post.boardNo})">삭제</button>
      </c:if>
    </div>
  </div>

  <!-- ══════════════════════════════════════
       교수 답변 카드
  ══════════════════════════════════════ -->


  <!-- ══════════════════════════════════════
       댓글 카드 (학생 댓글)
  ══════════════════════════════════════ -->
  <div class="board-card comment-section" style="padding: 30px 40px; margin-top: 12px;" id="comments">
    <c:choose>
      <c:when test="${post.answered == true}">
        <div class="comment-item" style="border-left: 3px solid var(--lms-primary); padding-left: 1.2rem; margin-bottom: 1rem;">
          <div class="comment-item-header">
            <span class="comment-writer">👨‍🏫 교수</span>
              <%-- 교수/관리자만 삭제 버튼 --%>
            <c:if test="${sessionScope.sessionUser.role eq 'PROFESSOR'
                     or sessionScope.sessionUser.role eq 'ADMIN'}">
              <button class="btn-comment-delete" onclick="deleteAnswer()">삭제</button>
            </c:if>
          </div>
          <div class="comment-content" id="professor-answer-content"></div>
        </div>
      </c:when>
      <c:otherwise>
        <div class="comment-header">
          💬 아직 교수님의 답변이 없습니다.
        </div>
        <c:if test="${sessionScope.sessionUser.role eq 'PROFESSOR'
                   or sessionScope.sessionUser.role eq 'ADMIN'}">
          <div class="comment-input-box">
            <textarea id="answer-content" placeholder="답변을 입력하세요..."></textarea>
            <button class="btn-comment-submit" onclick="submitAnswer(${post.boardNo})">답변 등록</button>
          </div>
        </c:if>
      </c:otherwise>
    </c:choose>
  </div>
</div><!-- /.board-wrap -->

<script>
  const LOGIN_USER_NO   = ${sessionScope.sessionUser != null ? sessionScope.sessionUser.userNo : 'null'};
  const LOGIN_USER_ROLE = '${sessionScope.sessionUser != null ? sessionScope.sessionUser.role : ""}';
  const BOARD_NO        = ${post.boardNo};
  const CTX             = '${pageContext.request.contextPath}';
  const COURSE_NO       = ${post.courseNo};

  /* ── 댓글 로드 ── */
  document.addEventListener('DOMContentLoaded', loadComments);

  async function loadComments() {
    const res  = await fetch(`\${CTX}/comment/list?boardNo=\${BOARD_NO}`);
    const tree = await res.json();

    const answerEl = document.getElementById('professor-answer-content');
    if (answerEl && tree && tree.length > 0) {
      answerEl.textContent = tree[0].content;
      professorCommentNo = tree[0].commentNo
    }
  }

  /* ── 댓글 삭제 ── */
  /* ✅ FIX 2: boardType=QNA 쿼리 파라미터 추가 (없으면 교수 댓글 삭제 시 미답변 처리 안 됨) */
  async function deleteAnswer() {
    if (!confirm('삭제하시겠습니까?')) return;
    const res = await fetch(`\${CTX}/comment/\${professorCommentNo}?boardNo=\${BOARD_NO}&boardType=QNA`, { method: 'DELETE' });
    if (res.ok) location.reload();
  }

  /* ── 교수 답변 등록 ── */
  async function submitAnswer(boardNo) {
    const content = document.getElementById('answer-content').value.trim();
    if (!content) return;
    const res = await fetch(`\${CTX}/comment/write?boardType=QNA`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ boardNo, content })
    });
    if (res.ok) location.href = `\${CTX}/board/detail_qna?boardNo=\${boardNo}&boardType=QNA&courseNo=\${COURSE_NO}`;
  }
  /* ── 게시글 삭제 ── */
  function confirmDelete(boardNo) {
    if (!confirm('게시글을 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.')) return;
    const form = document.createElement('form');
    form.method = 'post';
    form.action = `\${CTX}/board/delete`;
    [
      { name: 'boardNo',   value: boardNo },
      { name: 'writerNo',  value: ${post.writerNo} },
      { name: 'boardType', value: 'QNA' },
      { name: 'courseNo',  value: ${post.courseNo} }
    ].forEach(({ name, value }) => {
      const input = document.createElement('input');
      input.type = 'hidden'; input.name = name; input.value = value;
      form.appendChild(input);
    });
    document.body.appendChild(form);
    form.submit();
  }

  /* ── XSS 방지 ── */
  function escHtml(s) {
    return String(s).replace(/[&<>"']/g, m => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    }[m]));
  }
</script>
</div>