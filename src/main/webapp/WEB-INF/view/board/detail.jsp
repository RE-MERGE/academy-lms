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
  <style>
    /* ── 뒤로가기 ── */
    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      color: var(--lms-text-sub);
      text-decoration: none;
      font-size: 0.9rem;
      margin-bottom: 1.2rem;
      transition: color 0.2s;
    }
    .back-link:hover { color: var(--lms-accent); }

    /* ── 게시글 헤더 ── */
    .detail-head {
      border-bottom: 2px solid var(--lms-primary);
      padding-bottom: 1rem;
      margin-bottom: 1.2rem;
    }

    /*.detail-meta-top { margin-bottom: 0.6rem; }*/

    .badge-category {
      display: inline-block;
      padding: 3px 12px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 700;
    }
    .NOTICE { background: #fff1f0; color: #ff4d4f; border: 1px solid #ffccc7; }
    .FREE   { background: #e6f4ff; color: #1677ff; border: 1px solid #91caff; }
    .QNA    { background: #f6ffed; color: #52c41a; border: 1px solid #b7eb8f; }

    .detail-title {
      font-size: 1.5rem;
      font-weight: 800;
      color: var(--lms-text-main);
      margin: 0.5rem 0 0.8rem;
    }

    .detail-meta {
      display: flex;
      gap: 1.2rem;
      font-size: 0.88rem;
      color: var(--lms-text-sub);
      flex-wrap: wrap;
    }

    .meta-edited { color: #aaa; font-size: 0.82rem; }

    /* ── 첨부파일 ── */
    .attach-box {
      background: var(--lms-bg-light);
      border: 1px solid var(--lms-border);
      border-radius: 8px;
      padding: 12px 16px;
      margin-bottom: 1.2rem;
    }

    .attach-label { font-weight: 700; color: var(--lms-primary); margin-bottom: 6px; font-size: 0.9rem; }
    .attach-list { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 4px; }

    .attach-item {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      color: var(--lms-accent);
      text-decoration: none;
      font-size: 0.9rem;
      transition: opacity 0.2s;
    }
    .attach-item:hover { opacity: 0.75; }
    .attach-size { color: var(--lms-text-sub); font-size: 0.82rem; }

    /* ── 본문 ── */
    .detail-body {
      min-height: 200px;
      line-height: 1.9;
      color: var(--lms-text-main);
      font-size: 0.97rem;
      padding: 1.2rem 0;
      border-bottom: 1px solid var(--lms-border);
      margin-bottom: 1.2rem;
    }

    /* ── 관리 버튼 ── */
    .detail-actions {
      display: flex;
      justify-content: flex-end;
      gap: 8px;
      margin-bottom: 2rem;
    }

    .btn-edit {
      height: 42px;
      padding: 0 20px;
      border-radius: 8px;
      font-weight: 700;
      font-size: 0.9rem;
      background: #ffffff;
      color: var(--lms-primary);
      border: 1px solid var(--lms-primary);
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      transition: all 0.2s;
      cursor: pointer;
    }
    .btn-edit:hover { background: #f1f5ff; color: var(--lms-accent); border-color: var(--lms-accent); }

    .btn-delete {
      height: 42px;
      padding: 0 20px;
      border-radius: 8px;
      font-weight: 700;
      font-size: 0.9rem;
      background: #ffffff;
      color: #ff4d4f;
      border: 1px solid #ffccc7;
      cursor: pointer;
      transition: all 0.2s;
    }
    .btn-delete:hover { background: #fff1f0; }

    /* ── 댓글 영역 ── */
    .comment-section { margin-top: 1rem; }

    .comment-header {
      font-size: 1rem;
      font-weight: 700;
      color: var(--lms-primary);
      margin-bottom: 1rem;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .comment-count-badge {
      background: var(--lms-primary);
      color: #fff;
      border-radius: 20px;
      padding: 1px 10px;
      font-size: 0.82rem;
    }

    /* 댓글 입력 */
    .comment-input-box {
      display: flex;
      gap: 8px;
      margin-bottom: 1.2rem;
      align-items: flex-end;
    }

    .comment-input-box textarea {
      flex: 1;
      height: 72px;
      padding: 10px 14px;
      border: 1px solid var(--lms-border);
      border-radius: 8px;
      font-size: 0.92rem;
      resize: none;
      font-family: inherit;
      color: var(--lms-text-main);
      transition: border-color 0.2s;
    }

    .comment-input-box textarea:focus {
      outline: none;
      border-color: var(--lms-accent);
      box-shadow: 0 0 0 3px rgba(46,106,230,0.1);
    }

    .btn-comment-submit {
      height: 72px;
      padding: 0 20px;
      border-radius: 8px;
      font-weight: 700;
      font-size: 0.9rem;
      background: var(--lms-primary);
      color: #fff;
      border: none;
      cursor: pointer;
      transition: background 0.2s;
      white-space: nowrap;
    }
    .btn-comment-submit:hover { background: var(--lms-accent); }

    /* 댓글 목록 */
    .comment-list { display: flex; flex-direction: column; gap: 0; }

    .comment-item {
      padding: 14px 0;
      border-bottom: 1px solid #f0f0f0;
    }

    .comment-item-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 6px;
    }

    .comment-writer {
      font-weight: 700;
      font-size: 0.9rem;
      color: var(--lms-primary);
    }

    .comment-meta {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 0.82rem;
      color: var(--lms-text-sub);
    }

    .comment-content {
      font-size: 0.93rem;
      color: var(--lms-text-main);
      line-height: 1.7;
    }

    .btn-comment-delete {
      background: none;
      border: none;
      color: #ccc;
      font-size: 0.82rem;
      cursor: pointer;
      padding: 0;
      transition: color 0.2s;
    }
    .btn-comment-delete:hover { color: #ff4d4f; }

    .comment-empty {
      text-align: center;
      color: var(--lms-text-sub);
      padding: 2rem 0;
      font-size: 0.9rem;
    }
  </style>
</head>
<body>
<div class="board-wrap">
  <div class="board-card" style="padding: 40px 40px 1px 40px; margin-top: 10px;">
  <!-- 게시글 헤더 -->
  <div class="detail-head">
    <div class="detail-meta-top">
      <span class="badge-category ${post.boardType}">${post.boardType=="NOTICE"?"공지사항":"자유게시판"}</span>
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
          <a href="${pageContext.request.contextPath}/board/fileDownload?fileUrl=${post.fileUrl}" class="attach-item">
            <span>⬇</span>
            ${post.fileUrl}
          </a>
        </li>
      </ul>
    </div>
  </c:if>

  <!-- 본문 -->
  <div class="detail-body">
    ${post.content}
  </div>


  <!-- 뒤로가기 -->
  <div class="detail-actions">
  <a href="list?boardType=${post.boardType}<c:if test='${not empty post.courseNo}'>&courseNo=${post.courseNo}</c:if>"
     class="btn-search">목록으로</a>

  <!-- 관리 버튼: 작성자·관리자만 -->
  <c:if test="${sessionScope.sessionUser.role eq 'ADMIN'
               or sessionScope.sessionUser.userNo eq post.writerNo}">
      <a href="update?boardNo=${post.boardNo}&boardType=${post.boardType}&courseNo=${post.courseNo}" class="btn-edit">수정</a>
      <button class="btn-delete" onclick="confirmDelete(${post.boardNo})">삭제</button>
  </c:if>
  </div>
  </div>

  <!-- 댓글 영역 -->
  <div class="comment-section">

<%--    <div class="comment-header">--%>
      💬 댓글
<%--      <span class="comment-count-badge">${fn:length(commentList)}</span>--%>
<%--    </div>--%>
    <!-- 댓글 입력 -->
<%--    <form method="post" action="${pageContext.request.contextPath}/comment/write">--%>
<%--      <input type="hidden" name="boardNo" value="${post.boardNo}">--%>
<%--      <div class="comment-input-box">--%>
<%--        <textarea name="content" placeholder="댓글을 입력하세요..."></textarea>--%>
<%--        <button type="submit" class="btn-comment-submit">등록</button>--%>
<%--      </div>--%>
<%--    </form>--%>

    <!-- 댓글 목록 -->
<%--    <div class="comment-list">--%>
<%--      <c:choose>--%>
<%--        <c:when test="${empty commentList}">--%>
<%--          <div class="comment-empty">아직 댓글이 없습니다. 첫 댓글을 남겨보세요!</div>--%>
<%--        </c:when>--%>
<%--        <c:otherwise>--%>
<%--          <c:forEach var="comment" items="${commentList}">--%>
<%--            <div class="comment-item">--%>
<%--              <div class="comment-item-header">--%>
<%--                <span class="comment-writer">${comment.writerName}</span>--%>
<%--                <div class="comment-meta">--%>
<%--                  <fmt:formatDate value="${comment.createdAt}" pattern="yyyy.MM.dd HH:mm"/>--%>
<%--                  <c:if test="${sessionScope.loginUser.role eq 'ADMIN'--%>
<%--                               or sessionScope.loginUser.userNo eq comment.writeName}">--%>
<%--                    <button class="btn-comment-delete"--%>
<%--                            onclick="deleteComment(${comment.commentNo})">삭제</button>--%>
<%--                  </c:if>--%>
<%--                </div>--%>
<%--              </div>--%>
<%--              <div class="comment-content">${comment.content}</div>--%>
<%--            </div>--%>
<%--          </c:forEach>--%>
<%--        </c:otherwise>--%>
<%--      </c:choose>--%>
<%--    </div>--%>
<%--  </div>--%>
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
        const res = await fetch(CTX + "/comment/list?boardNo=" + BOARD_NO);
        const tree = await res.json();
        renderComments(tree);
      }

      // ── 렌더링 ───────────────────────────────────────────
      function renderComments(tree) {
        const list = document.getElementById('comment-list');
        let totalCount = 0;

        if (!tree || tree.length === 0) {
          list.innerHTML = '<div class="comment-empty">아직 댓글이 없습니다.</div>';
          document.getElementById('comment-count').textContent = '0';
          return;
        }

        let html = '';
        tree.forEach(comment => {
          html += buildCommentHTML(comment, false);
          totalCount++;
          if (comment.replies) {
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
        const canDelete = LOGIN_USER_NO !== null && (LOGIN_USER_ROLE === 'ADMIN' || LOGIN_USER_NO === c.writerNo);
        const date = new Date(c.createdAt).toLocaleString('ko-KR');

        const deleteBtn = canDelete ? '<button class="btn-comment-delete" onclick="deleteComment(' + c.commentNo + ')">삭제</button>' : '';
        const replyBtn = !isReply && LOGIN_USER_NO !== null ? '<button class="btn-reply-toggle" onclick="toggleReplyBox(' + c.commentNo + ')">답글</button>' : '';

        const replyBox = !isReply ?
                '<div class="reply-input-wrap" id="reply-box-' + c.commentNo + '">' +
                '<textarea id="reply-content-' + c.commentNo + '" placeholder="답글 입력..."></textarea>' +
                '<button class="btn-reply-submit" onclick="submitReply(' + c.commentNo + ', ' + (c.rootNo || c.commentNo) + ')">등록</button>' +
                '</div>' : '';

        return '<div class="comment-item ' + (isReply ? 'is-reply' : '') + '">' +
                '<div class="comment-item-header"><span class="comment-writer">' + escHtml(c.writerName) + '</span>' +
                '<span>' + date + ' ' + deleteBtn + '</span></div>' +
                '<div class="comment-content">' + escHtml(c.content) + '</div>' +
                '<div class="comment-actions">' + replyBtn + '</div>' + replyBox + '</div>';
      }

      // ── 원댓글 등록 ──────────────────────────────────────
      async function submitComment() {
        const textarea = document.getElementById('root-content');
        const content = textarea.value.trim();
        if (!content) return;

        const res = await fetch(CTX + "/comment/write", {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ boardNo: BOARD_NO, content: content })
        });

        if (res.ok) {
          textarea.value = '';
          renderComments(await res.json());
        }
      }

      // ── 대댓글 등록 ──────────────────────────────────────
      async function submitReply(parentNo, rootNo) {
        const content = document.getElementById('reply-content-' + parentNo).value.trim();
        if (!content) return;

        const res = await fetch(CTX + "/comment/reply", {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ boardNo: BOARD_NO, parentNo: parentNo, rootNo: rootNo, content: content })
        });

        if (res.ok) renderComments(await res.json());
      }

      // ── 댓글 삭제 ────────────────────────────────────────
      async function deleteComment(commentNo) {
        if (!confirm('삭제하시겠습니까?')) return;

        const res = await fetch(CTX + "/comment/" + commentNo + "?boardNo=" + BOARD_NO, {
          method: 'DELETE'
        });

        if (res.ok) renderComments(await res.json());
      }

      // ── 답글 입력창 토글 ─────────────────────────────────
      function toggleReplyBox(n) {
        const b = document.getElementById('reply-box-' + n);
        b.style.display = (b.style.display === 'flex') ? 'none' : 'flex';
      }

      // ── XSS 방지 ────────────────────────────────────────
      function escHtml(s) {
        return s.replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":"&#39;"}[m]));
      }
    </script>

</div>
</div>
<script>
  function confirmDelete(boardNo) {
    if (!confirm('게시글을 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.')) return;
    const form = document.createElement('form');
    form.method = 'post';
    form.action = '${pageContext.request.contextPath}/board/delete';
    const input_boardNo = document.createElement('input');
    input_boardNo.type  = 'hidden';
    input_boardNo.name  = 'boardNo';
    input_boardNo.value = boardNo;
    const input_writerNo = document.createElement("input");
    input_writerNo.type = "hidden"
    input_writerNo.name = "writerNo"
    input_writerNo.value = ${post.writerNo};
    const input_boardType = document.createElement("input");
    input_boardType.type = "hidden";
    input_boardType.name = "boardType";
    input_boardType.value = "${post.boardType}";

    form.appendChild(input_writerNo);
    form.appendChild(input_boardNo);
    form.appendChild(input_boardType);
    document.body.appendChild(form);
    form.submit();
  }
</script>
</body>
</html>
<%--  function deleteComment(commentNo) {--%>
<%--    if (!confirm('댓글을 삭제하시겠습니까?')) return;--%>
<%--    const form = document.createElement('form');--%>
<%--    form.method = 'post';--%>
<%--    form.action = '${pageContext.request.contextPath}/comment/delete';--%>
<%--    const input = document.createElement('input');--%>
<%--    input.type  = 'hidden';--%>
<%--    input.name  = 'commentNo';--%>
<%--    input.value = commentNo;--%>
<%--    form.appendChild(input);--%>
<%--    document.body.appendChild(form);--%>
<%--    form.submit();--%>
<%--  }--%>
<%--</script>--%>