<%-- ════════════════════════════════════════════════════════════════
     boardDetail.jsp 기존 게시글 상세 내용 아래에 이 블록을 붙여넣으세요.
     기존 comment-section 태그가 있다면 통째로 교체하면 됩니다.
 ════════════════════════════════════════════════════════════════ --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 로그인 유저 정보 JS 변수로 전달 --%>
<script>
  const LOGIN_USER_NO   = ${sessionScope.sessionUser != null ? sessionScope.sessionUser.userNo : 'null'};
  const LOGIN_USER_ROLE = '${sessionScope.sessionUser != null ? sessionScope.sessionUser.role : ""}';
  const BOARD_NO        = ${post.boardNo};
  const CTX             = '${pageContext.request.contextPath}';
</script>

<style>
  /* ── 댓글 래퍼 ── */
  .comment-section { margin-top: 12px; }

  .comment-header {
    font-size: 1rem; font-weight: 700; color: var(--lms-primary);
    margin-bottom: 1rem; display: flex; align-items: center; gap: 6px;
  }
  .comment-count-badge {
    background: var(--lms-primary); color: #fff;
    border-radius: 20px; padding: 1px 10px; font-size: 0.82rem;
  }

  /* ── 원댓글 입력 ── */
  .comment-input-box { display: flex; gap: 8px; margin-bottom: 1.4rem; align-items: flex-end; }
  .comment-input-box textarea {
    flex: 1; height: 72px; padding: 10px 14px;
    border: 1px solid var(--lms-border); border-radius: 8px;
    font-size: 0.92rem; resize: none; font-family: inherit;
    color: var(--lms-text-main); transition: border-color 0.2s;
  }
  .comment-input-box textarea:focus { outline: none; border-color: var(--lms-accent); box-shadow: 0 0 0 3px rgba(46,106,230,0.1); }
  .btn-comment-submit {
    height: 72px; padding: 0 20px; border-radius: 8px; font-weight: 700;
    font-size: 0.9rem; background: var(--lms-primary); color: #fff;
    border: none; cursor: pointer; transition: background 0.2s; white-space: nowrap;
  }
  .btn-comment-submit:hover { background: var(--lms-accent); }

  /* ── 댓글 아이템 ── */
  .comment-list { display: flex; flex-direction: column; }
  .comment-item { padding: 14px 0; border-bottom: 1px solid #f0f0f0; }

  /* 대댓글 들여쓰기 */
  .comment-item.is-reply {
    padding-left: 22px;
    background: #fafafa;
    border-left: 3px solid var(--lms-primary);
    margin-top: -1px;
  }

  .comment-item-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 5px; }

  .comment-writer-wrap { display: flex; align-items: center; gap: 6px; }
  .comment-writer { font-weight: 700; font-size: 0.9rem; color: var(--lms-primary); }
  .reply-badge { font-size: 0.75rem; background: #e6f4ff; color: #1677ff; border-radius: 20px; padding: 1px 8px; }

  .comment-meta-right { display: flex; align-items: center; gap: 10px; font-size: 0.82rem; color: var(--lms-text-sub); }
  .comment-content { font-size: 0.93rem; color: var(--lms-text-main); line-height: 1.7; margin-bottom: 6px; }

  /* 액션 버튼 */
  .comment-actions { display: flex; align-items: center; gap: 12px; }
  .btn-reply-toggle, .btn-comment-delete {
    background: none; border: none; font-size: 0.82rem;
    color: var(--lms-text-sub); cursor: pointer; padding: 0; transition: color 0.2s;
  }
  .btn-reply-toggle:hover { color: var(--lms-accent); }
  .btn-comment-delete:hover { color: #ff4d4f; }

  /* 대댓글 입력 토글 */
  .reply-input-wrap { display: none; margin-top: 10px; gap: 8px; align-items: flex-end; }
  .reply-input-wrap.open { display: flex; }
  .reply-input-wrap textarea {
    flex: 1; height: 56px; padding: 8px 12px;
    border: 1px solid var(--lms-border); border-radius: 8px;
    font-size: 0.88rem; resize: none; font-family: inherit; color: var(--lms-text-main);
  }
  .reply-input-wrap textarea:focus { outline: none; border-color: var(--lms-accent); }
  .btn-reply-submit {
    height: 56px; padding: 0 16px; border-radius: 8px; font-weight: 700;
    font-size: 0.88rem; background: var(--lms-primary); color: #fff;
    border: none; cursor: pointer; transition: background 0.2s; white-space: nowrap;
  }
  .btn-reply-submit:hover { background: var(--lms-accent); }

  .comment-empty { text-align: center; color: var(--lms-text-sub); padding: 2rem 0; font-size: 0.9rem; }
</style>

<!-- ════════════════════════════════════════
     댓글 영역 HTML
════════════════════════════════════════ -->
<div class="comment-section board-card" style="padding: 30px 40px; margin-top: 12px;" id="comments">

  <div class="comment-header">
    💬 댓글 <span class="comment-count-badge" id="comment-count">0</span>
  </div>

  <!-- 원댓글 입력 -->
  <div class="comment-input-box">
    <textarea id="root-content" placeholder="댓글을 입력하세요..."></textarea>
    <button class="btn-comment-submit" onclick="submitComment()">등록</button>
  </div>

  <!-- 댓글 렌더링 영역 -->
  <div class="comment-list" id="comment-list"></div>

</div>

<script>
/* ══════════════════════════════════════════════════════
   댓글 Ajax 모듈
══════════════════════════════════════════════════════ */

// 페이지 로드 시 목록 불러오기
document.addEventListener('DOMContentLoaded', () => loadComments());

// ── 목록 조회 ────────────────────────────────────────
async function loadComments() {
  const res  = await fetch(`${CTX}/comment/list?boardNo=${BOARD_NO}`);
  const tree = await res.json();
  renderComments(tree);
}

// ── 렌더링 ───────────────────────────────────────────
function renderComments(tree) {
  const list = document.getElementById('comment-list');
  let totalCount = 0;

  if (!tree || tree.length === 0) {
    list.innerHTML = '<div class="comment-empty">아직 댓글이 없습니다. 첫 댓글을 남겨보세요!</div>';
    document.getElementById('comment-count').textContent = '0';
    return;
  }

  let html = '';
  tree.forEach(comment => {
    html += buildCommentHTML(comment, false);
    totalCount++;
    if (comment.replies && comment.replies.length > 0) {
      comment.replies.forEach(reply => {
        html += buildCommentHTML(reply, true);
        totalCount++;
      });
    }
  });

  list.innerHTML = html;
  document.getElementById('comment-count').textContent = totalCount;
}

// ── HTML 조각 생성 ────────────────────────────────────
function buildCommentHTML(c, isReply) {
  const canDelete = LOGIN_USER_NO !== null &&
                    (LOGIN_USER_ROLE === 'ADMIN' || LOGIN_USER_NO === c.writerNo);
  const date = new Date(c.createdAt).toLocaleString('ko-KR', {
    year: 'numeric', month: '2-digit', day: '2-digit',
    hour: '2-digit', minute: '2-digit'
  });

  const deleteBtn = canDelete
    ? `<button class="btn-comment-delete" onclick="deleteComment(${c.commentNo})">삭제</button>`
    : '';

  const replyBtn = !isReply && LOGIN_USER_NO !== null
    ? `<button class="btn-reply-toggle" onclick="toggleReplyBox(${c.commentNo})">답글 달기</button>`
    : '';

  const replyBox = !isReply
    ? `<div class="reply-input-wrap" id="reply-box-${c.commentNo}">
         <textarea id="reply-content-${c.commentNo}" placeholder="답글을 입력하세요..."></textarea>
         <button class="btn-reply-submit"
                 onclick="submitReply(${c.commentNo}, ${c.rootNo != null ? c.rootNo : c.commentNo}
)">등록</button>
       </div>`
    : '';

  return `
    <div class="comment-item ${isReply ? 'is-reply' : ''}" id="comment-item-${c.commentNo}">
      <div class="comment-item-header">
        <div class="comment-writer-wrap">
          <span class="comment-writer">${escHtml(c.writerName)}</span>
          ${isReply ? '<span class="reply-badge">↩ 답글</span>' : ''}
        </div>
        <div class="comment-meta-right">
          <span>${date}</span>
          ${deleteBtn}
        </div>
      </div>
      <div class="comment-content">${escHtml(c.content)}</div>
      <div class="comment-actions">
        ${replyBtn}
      </div>
      ${replyBox}
    </div>`;
}

// ── 원댓글 등록 ──────────────────────────────────────
async function submitComment() {
  const textarea = document.getElementById('root-content');
  const content  = textarea.value.trim();
  if (!content) { alert('댓글 내용을 입력해주세요.'); return; }

  const res = await fetch(`${CTX}/comment/write`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ boardNo: BOARD_NO, content })
  });

  if (res.status === 401) { alert('로그인이 필요합니다.'); return; }
  if (!res.ok) { alert('오류가 발생했습니다.'); return; }

  textarea.value = '';
  const tree = await res.json();
  renderComments(tree);
  document.getElementById('comments').scrollIntoView({ behavior: 'smooth', block: 'start' });
}

// ── 대댓글 등록 ──────────────────────────────────────
async function submitReply(parentNo, rootNo) {
  const textarea = document.getElementById(`reply-content-${parentNo}`);
  const content  = textarea.value.trim();
  if (!content) { alert('답글 내용을 입력해주세요.'); return; }

  const res = await fetch(`${CTX}/comment/reply`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ boardNo: BOARD_NO, parentNo, rootNo, content })
  });

  if (res.status === 401) { alert('로그인이 필요합니다.'); return; }
  if (!res.ok) { alert('오류가 발생했습니다.'); return; }

  const tree = await res.json();
  renderComments(tree);
}

// ── 댓글 삭제 ────────────────────────────────────────
async function deleteComment(commentNo) {
  if (!confirm('댓글을 삭제하시겠습니까?')) return;

  const res = await fetch(`${CTX}/comment/${commentNo}?boardNo=${BOARD_NO}`, {
    method: 'DELETE'
  });

  if (res.status === 401) { alert('로그인이 필요합니다.'); return; }
  if (res.status === 403) { alert('삭제 권한이 없습니다.'); return; }
  if (!res.ok) { alert('오류가 발생했습니다.'); return; }

  const tree = await res.json();
  renderComments(tree);
}

// ── 답글 입력창 토글 ─────────────────────────────────
function toggleReplyBox(commentNo) {
  const box = document.getElementById(`reply-box-${commentNo}`);
  box.classList.toggle('open');
  if (box.classList.contains('open')) {
    box.querySelector('textarea').focus();
  }
}

// ── XSS 방지 ────────────────────────────────────────
function escHtml(str) {
  if (!str) return '';
  return str.replace(/&/g,'&amp;').replace(/</g,'&lt;')
            .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
</script>
