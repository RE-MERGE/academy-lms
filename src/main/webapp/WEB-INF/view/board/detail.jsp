<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>re-merge LMS · ${post.title}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css"/>
</head>
<body>
<div class="board-wrap">

  <!-- ── 게시글 본문 카드 ── -->
  <div class="board-card" style="padding: 40px 40px 1px; margin-top: 10px;">

    <div class="detail-head">
      <span class="badge-category ${post.boardType}">
        ${post.boardType == 'NOTICE' ? '공지사항' : '자유게시판'}
      </span>
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
            <a href="${pageContext.request.contextPath}/board/fileDownload?fileUrl=${post.fileUrl}" class="attach-item">
              <span>⬇</span>${post.fileUrl}
            </a>
          </li>
        </ul>
      </div>
    </c:if>

    <!-- 본문 -->
    <div class="detail-body">${post.content}</div>
<div class="detail-actions">
    <!-- 하단 버튼 -->
  <c:choose>
    <%-- courseNo가 없으면 일반 리스트로 --%>
    <c:when test="${empty post.courseNo}">
        <a href="list?boardType=${post.boardType}" class="btn-search">목록으로</a>
    </c:when>
    
    <%-- courseNo가 있으면 과목별 리스트로 --%>
    <c:otherwise>
        <a href="list_subject?course_no=${post.courseNo}&boardType=${post.boardType}" class="btn-search">목록으로</a>
    </c:otherwise>
</c:choose>

  <a href="list?boardType=${post.boardType}" class="btn-search">목록으로</a>
      <c:if test="${sessionScope.sessionUser.role eq 'ADMIN'
                   or sessionScope.sessionUser.userNo eq post.writerNo}">
        <a href="update?boardNo=${post.boardNo}&boardType=${post.boardType}&courseNo=${post.courseNo}"
           class="btn-edit">수정</a>
        <button class="btn-delete" onclick="confirmDelete(${post.boardNo})">삭제</button>
      </c:if>
    </div>
  </div>

  <!-- ── 댓글 카드 ── -->
  <div class="comment-section board-card" style="padding: 30px 40px; margin-top: 12px;" id="comments">

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
  /* ── 서버 변수 ── */
  const LOGIN_USER_NO   = ${sessionScope.sessionUser != null ? sessionScope.sessionUser.userNo : 'null'};
  const LOGIN_USER_ROLE = '${sessionScope.sessionUser != null ? sessionScope.sessionUser.role : ""}';
  const BOARD_NO        = ${post.boardNo};
  const CTX             = '${pageContext.request.contextPath}';

  /* ── 초기 로드 ── */
  document.addEventListener('DOMContentLoaded', loadComments);

  /* ── 댓글 목록 조회 ── */
  async function loadComments() {
    const res  = await fetch(CTX + '/comment/list?boardNo=' + BOARD_NO);
    const tree = await res.json();
    renderComments(tree);
  }

  /* ── 댓글 렌더링 ── */
  function renderComments(tree) {
    const list = document.getElementById('comment-list');

    if (!tree || tree.length === 0) {
      list.innerHTML = '<div class="comment-empty">아직 댓글이 없습니다.</div>';
      document.getElementById('comment-count').textContent = '0';
      return;
    }

    let html  = '';
    let total = 0;

    tree.forEach(comment => {
      html += buildCommentHTML(comment, false);
      total++;
      (comment.replies || []).forEach(reply => {
        html += buildCommentHTML(reply, true);
        total++;
      });
    });

    list.innerHTML = html;
    document.getElementById('comment-count').textContent = total;
  }

  /* ── 댓글 HTML 생성 ── */
  function buildCommentHTML(c, isReply) {
    const canDelete = LOGIN_USER_NO !== null &&
            (LOGIN_USER_ROLE === 'ADMIN' || LOGIN_USER_NO === c.writerNo);
    const date      = new Date(c.createdAt).toLocaleString('ko-KR');

    const deleteBtn = canDelete
            ? '<button class="btn-comment-delete" onclick="deleteComment(' + c.commentNo + ')">삭제</button>'
            : '';

    const replyBtn  = (!isReply && LOGIN_USER_NO !== null)
            ? '<button class="btn-reply-toggle" onclick="toggleReplyBox(' + c.commentNo + ')">답글</button>'
            : '';

    const replyBox  = !isReply
            ? '<div class="reply-input-wrap" id="reply-box-' + c.commentNo + '">' +
            '<textarea id="reply-content-' + c.commentNo + '" placeholder="답글 입력..."></textarea>' +
            '<button class="btn-reply-submit" onclick="submitReply(' + c.commentNo + ', ' + (c.rootNo || c.commentNo) + ')">등록</button>' +
            '</div>'
            : '';

    return '<div class="comment-item ' + (isReply ? 'is-reply' : '') + '">' +
            '<div class="comment-item-header">' +
            '<span class="comment-writer">' + escHtml(c.writerName) + '</span>' +
            '<span class="comment-meta-right">' + date + ' ' + deleteBtn + '</span>' +
            '</div>' +
            '<div class="comment-content">' + escHtml(c.content) + '</div>' +
            '<div class="comment-actions">' + replyBtn + '</div>' +
            replyBox +
            '</div>';
  }

  /* ── 원댓글 등록 ── */
  async function submitComment() {
    const textarea = document.getElementById('root-content');
    const content  = textarea.value.trim();
    if (!content) return;

    const res = await fetch(CTX + '/comment/write', {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify({ boardNo: BOARD_NO, content })
    });

    if (res.ok) {
      textarea.value = '';
      renderComments(await res.json());
    }
  }

  /* ── 대댓글 등록 ── */
  async function submitReply(parentNo, rootNo) {
    const content = document.getElementById('reply-content-' + parentNo).value.trim();
    if (!content) return;

    const res = await fetch(CTX + '/comment/reply', {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify({ boardNo: BOARD_NO, parentNo, rootNo, content })
    });

    if (res.ok) renderComments(await res.json());
  }

  /* ── 댓글 삭제 ── */
  async function deleteComment(commentNo) {
    if (!confirm('삭제하시겠습니까?')) return;

    const res = await fetch(CTX + '/comment/' + commentNo + '?boardNo=' + BOARD_NO, {
      method: 'DELETE'
    });

    if (res.ok) renderComments(await res.json());
  }

  /* ── 게시글 삭제 ── */
  function confirmDelete(boardNo) {
    if (!confirm('게시글을 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.')) return;

    const form = document.createElement('form');
    form.method = 'post';
    form.action = CTX + '/board/delete';

    [
      { name: 'boardNo',    value: boardNo },
      { name: 'writerNo',   value: ${post.writerNo} },
      { name: 'boardType',  value: '${post.boardType}' }
    ].forEach(({ name, value }) => {
      const input = document.createElement('input');
      input.type  = 'hidden';
      input.name  = name;
      input.value = value;
      form.appendChild(input);
    });

    document.body.appendChild(form);
    form.submit();
  }

  /* ── 답글 입력창 토글 ── */
  function toggleReplyBox(n) {
    document.getElementById('reply-box-' + n).classList.toggle('open');
  }

  /* ── XSS 방지 ── */
  function escHtml(s) {
    return String(s).replace(/[&<>"']/g, m => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    }[m]));
  }
</script>
</body>
</html>
