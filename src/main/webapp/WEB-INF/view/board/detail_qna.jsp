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
        <c:choose>
          <c:when test="${post.answered}">
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
      <a href="list?boardType=QNA&courseNo=${post.courseNo}" class="btn-search">목록으로</a>
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
  <div class="board-card" style="padding: 30px 40px; margin-top: 12px;">

    <div class="comment-header">
      💬 교수 답변
      <c:choose>
        <c:when test="${post.answered}">
          <span class="badge badge-green" style="font-size: 0.75rem;">답변완료</span>
        </c:when>
        <c:otherwise>
          <span class="badge badge-yellow" style="font-size: 0.75rem;">미답변</span>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 기존 답변 표시 -->
    <c:choose>
      <c:when test="${not empty post.answered}">
        <div class="comment-item" style="border-left: 3px solid var(--lms-primary); padding-left: 1.2rem; margin-bottom: 1rem;">
          <div class="comment-item-header">
            <span class="comment-writer">👨‍🏫 ${professorName}</span>
<%--            <span class="comment-meta-right">--%>
<%--              <fmt:formatDate value="${post.answeredAt}" pattern="yyyy.MM.dd HH:mm"/>--%>
<%--            </span>--%>
          </div>
          <div class="comment-content">${post.answered}</div>

          <!-- 교수/관리자만 답변 수정/삭제 -->
          <c:if test="${sessionScope.sessionUser.role eq 'PROFESSOR'
                       or sessionScope.sessionUser.role eq 'ADMIN'}">
            <div class="comment-actions">
              <button class="btn-reply-toggle" onclick="toggleAnswerEdit()">✏️ 수정</button>
              <button class="btn-comment-delete" onclick="deleteAnswer(${post.boardNo})">삭제</button>
            </div>
          </c:if>
        </div>

        <!-- 답변 수정 폼 (교수/관리자) -->
        <c:if test="${sessionScope.sessionUser.role eq 'PROFESSOR'
                     or sessionScope.sessionUser.role eq 'ADMIN'}">
          <div class="reply-input-wrap" id="answer-edit-box">
            <textarea id="answer-edit-content" placeholder="답변을 수정하세요...">${post.answered}</textarea>
            <button class="btn-reply-submit" onclick="updateAnswer(${post.boardNo})">수정 등록</button>
          </div>
        </c:if>
      </c:when>

      <c:otherwise>
        <!-- 답변 없을 때 -->
        <div class="comment-empty">
          아직 교수님의 답변이 없습니다.
        </div>

        <!-- 교수/관리자 답변 입력 폼 -->
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

  <!-- ══════════════════════════════════════
       댓글 카드 (학생 댓글)
  ══════════════════════════════════════ -->
  <div class="board-card comment-section" style="padding: 30px 40px; margin-top: 12px;" id="comments">

    <div class="comment-header">
      💬 댓글 <span class="comment-count-badge" id="comment-count">0</span>
    </div>

    <div class="comment-input-box">
      <textarea id="root-content" placeholder="댓글을 입력하세요..."></textarea>
      <button class="btn-comment-submit" onclick="submitComment()">등록</button>
    </div>

    <div class="comment-list" id="comment-list"></div>

  </div>

</div><!-- /.board-wrap -->

<script>
  const LOGIN_USER_NO   = ${sessionScope.sessionUser != null ? sessionScope.sessionUser.userNo : 'null'};
  const LOGIN_USER_ROLE = '${sessionScope.sessionUser != null ? sessionScope.sessionUser.role : ""}';
  const BOARD_NO        = ${post.boardNo};
  const CTX             = '${pageContext.request.contextPath}';

  /* ── 댓글 로드 ── */
  document.addEventListener('DOMContentLoaded', loadComments);

  async function loadComments() {
    const res  = await fetch(`${CTX}/comment/list?boardNo=${BOARD_NO}`);
    const tree = await res.json();
    renderComments(tree);
  }

  function renderComments(tree) {
    const list = document.getElementById('comment-list');
    if (!tree || tree.length === 0) {
      list.innerHTML = '<div class="comment-empty">아직 댓글이 없습니다.</div>';
      document.getElementById('comment-count').textContent = '0';
      return;
    }
    let html = '', total = 0;
    tree.forEach(c => {
      html += buildCommentHTML(c, false); total++;
      (c.replies || []).forEach(r => { html += buildCommentHTML(r, true); total++; });
    });
    list.innerHTML = html;
    document.getElementById('comment-count').textContent = total;
  }

  function buildCommentHTML(c, isReply) {
    const canDelete = LOGIN_USER_NO !== null &&
                      (LOGIN_USER_ROLE === 'ADMIN' || LOGIN_USER_NO === c.writerNo);
    const date = new Date(c.createdAt).toLocaleString('ko-KR');
    const deleteBtn = canDelete
      ? `<button class="btn-comment-delete" onclick="deleteComment(${c.commentNo})">삭제</button>` : '';
    const replyBtn = (!isReply && LOGIN_USER_NO !== null)
      ? `<button class="btn-reply-toggle" onclick="toggleReplyBox(${c.commentNo})">답글</button>` : '';
    const replyBox = !isReply
      ? `<div class="reply-input-wrap" id="reply-box-${c.commentNo}">
           <textarea id="reply-content-${c.commentNo}" placeholder="답글 입력..."></textarea>
           <button class="btn-reply-submit" onclick="submitReply(${c.commentNo}, ${c.rootNo || c.commentNo})">등록</button>
         </div>` : '';
    return `
      <div class="comment-item ${isReply ? 'is-reply' : ''}">
        <div class="comment-item-header">
          <span class="comment-writer">\${escHtml(c.writerName)}</span>  <span class="comment-meta-right">\${date} \${deleteBtn}</span> </div>
        <div class="comment-content">\${escHtml(c.content)}</div>       <div class="comment-actions">\${replyBtn}</div>                 \${replyBox}                                                   </div>`;
  }

  /* ── 댓글 등록 ── */
  async function submitComment() {
    const textarea = document.getElementById('root-content');
    const content = textarea.value.trim();
    if (!content) return;
    const res = await fetch(`${CTX}/comment/write`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ boardNo: BOARD_NO, content })
    });
    if (res.ok) { textarea.value = ''; renderComments(await res.json()); }
  }

  /* ── 대댓글 등록 ── */
  async function submitReply(parentNo, rootNo) {
    const content = document.getElementById(`reply-content-${parentNo}`).value.trim();
    if (!content) return;
    const res = await fetch(`${CTX}/comment/reply`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ boardNo: BOARD_NO, parentNo, rootNo, content })
    });
    if (res.ok) renderComments(await res.json());
  }

  /* ── 댓글 삭제 ── */
  async function deleteComment(commentNo) {
    if (!confirm('삭제하시겠습니까?')) return;
    const res = await fetch(`${CTX}/comment/${commentNo}?boardNo=${BOARD_NO}`, { method: 'DELETE' });
    if (res.ok) renderComments(await res.json());
  }

  /* ── 교수 답변 등록 ── */
  async function submitAnswer(boardNo) {
    const content = document.getElementById('answer-content').value.trim();
    if (!content) return;
    const res = await fetch(`${CTX}/board/answer`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ boardNo, content })
    });
    if (res.ok) location.reload();
  }

  /* ── 교수 답변 수정 ── */
  async function updateAnswer(boardNo) {
    const content = document.getElementById('answer-edit-content').value.trim();
    if (!content) return;
    const res = await fetch(`${CTX}/board/answer`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ boardNo, content })
    });
    if (res.ok) location.reload();
  }

  /* ── 교수 답변 삭제 ── */
  async function deleteAnswer(boardNo) {
    if (!confirm('답변을 삭제하시겠습니까?')) return;
    const res = await fetch(`${CTX}/board/answer?boardNo=${boardNo}`, { method: 'DELETE' });
    if (res.ok) location.reload();
  }

  /* ── 답변 수정폼 토글 ── */
  function toggleAnswerEdit() {
    document.getElementById('answer-edit-box').classList.toggle('open');
  }

  /* ── 게시글 삭제 ── */
  function confirmDelete(boardNo) {
    if (!confirm('게시글을 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.')) return;
    const form = document.createElement('form');
    form.method = 'post';
    form.action = `${CTX}/board/delete`;
    [
      { name: 'boardNo',   value: boardNo },
      { name: 'writerNo',  value: ${post.writerNo} },
      { name: 'boardType', value: 'QNA' }
    ].forEach(({ name, value }) => {
      const input = document.createElement('input');
      input.type = 'hidden'; input.name = name; input.value = value;
      form.appendChild(input);
    });
    document.body.appendChild(form);
    form.submit();
  }

  /* ── 답글 토글 ── */
  function toggleReplyBox(n) {
    document.getElementById(`reply-box-${n}`).classList.toggle('open');
  }

  /* ── XSS 방지 ── */
  function escHtml(s) {
    return String(s).replace(/[&<>"']/g, m => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    }[m]));
  }
</script>
