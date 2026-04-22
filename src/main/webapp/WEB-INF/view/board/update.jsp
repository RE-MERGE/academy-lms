<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>re-merge LMS · 게시글 수정</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css"/>
  <style>
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

    /* 기존 파일 표시 */
    .current-file {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 10px 14px;
      background: var(--lms-bg-light);
      border: 1px solid var(--lms-border);
      border-radius: 8px;
      font-size: 0.88rem;
      color: var(--lms-text-sub);
      margin-top: 8px;
    }

    .current-file a {
      color: var(--lms-accent);
      text-decoration: none;
    }
    .current-file a:hover { opacity: 0.75; }

    .btn-remove-file {
      margin-left: auto;
      background: none;
      border: none;
      color: #ff4d4f;
      cursor: pointer;
      font-size: 0.82rem;
      padding: 0;
    }

    /* 비밀글 토글 */
    .secret-toggle {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 12px 0;
    }

    .secret-toggle input[type=checkbox] {
      width: 18px;
      height: 18px;
      accent-color: var(--lms-primary);
      cursor: pointer;
    }

    .secret-toggle label {
      font-size: 0.9rem;
      color: var(--lms-text-main);
      cursor: pointer;
      font-weight: 500;
    }

    /* 하단 버튼 */
    .form-actions {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 1.5rem;
      padding-top: 1.2rem;
      border-top: 1px solid var(--lms-border);
    }
  </style>
</head>
<body>

<div class="board-wrap">

  <!-- 뒤로가기 -->
  <a href="detail?boardNo=${post.boardNo}" class="back-link">&#8592; 게시글로 돌아가기</a>

  <!-- 헤더 -->
  <div class="write-header">
    <div class="header-title">
      <h2>게시글 수정</h2>
      <p>내용을 수정한 후 저장 버튼을 눌러주세요.</p>
    </div>
  </div>

  <!-- 수정 폼 -->
  <form method="post" action="updatePost"
        enctype="multipart/form-data">

    <input type="hidden" name="boardNo" value="${post.boardNo}">

    <!-- 제목 -->
    <div class="form-group" style="margin-bottom: 1rem;">
      <label>제목</label>
      <input type="text" name="title" class="lms-input"
             value="${post.title}" placeholder="제목을 입력하세요" required>
    </div>

    <!-- 내용 -->
    <div class="form-group" style="margin-bottom: 1rem;">
      <label>내용</label>
      <textarea name="content" class="lms-textarea"
                placeholder="내용을 입력하세요">${post.content}</textarea>
    </div>

    <!-- 첨부파일 -->
    <div class="form-group" style="margin-bottom: 1rem;">
      <label>첨부파일</label>

      <!-- 기존 파일 표시 -->
      <c:if test="${not empty post.fileUrl}">
        <div class="current-file">
          <span>📎</span>
          <a href="${pageContext.request.contextPath}/board/fileDownload?fileUrl=${post.fileUrl}">
            ${post.fileUrl}
          </a>
          <button type="button" class="btn-remove-file"
                  onclick="removeFile()">✕ 삭제</button>
        </div>
        <input type="hidden" name="existingFileUrl" id="existingFileUrl" value="${post.fileUrl}">
      </c:if>

      <!-- 새 파일 업로드 -->
      <div class="file-upload-wrapper" style="margin-top: 8px;">
        <input type="file" name="uploadFile" id="uploadFile" class="file-input">
        <label for="uploadFile" class="file-label">
          <span class="file-icon">📁</span>
          <span id="file-name-display">새 파일을 선택하려면 클릭하세요</span>
        </label>
      </div>
    </div>

    <!-- 비밀글 -->
    <div class="form-group" style="margin-bottom: 1rem;">
      <div class="secret-toggle">
        <input type="checkbox" name="isSecret" id="isSecret" value="1"
               ${post.isSecret == 1 ? 'checked' : ''}>
        <label for="isSecret">🔒 비밀글로 설정</label>
      </div>
    </div>

    <!-- 하단 버튼 -->
    <div class="form-actions">
      <button type="button" class="btn-cancel"
              onclick="history.back()">취소</button>
      <button type="submit" class="btn-submit">저장하기</button>
    </div>

  </form>

</div>

<script>
  // 파일 선택 시 파일명 표시
  document.getElementById('uploadFile').addEventListener('change', function () {
    const display = document.getElementById('file-name-display');
    display.textContent = this.files.length > 0 ? this.files[0].name : '새 파일을 선택하려면 클릭하세요';
  });

  // 기존 파일 삭제
  function removeFile() {
    if (!confirm('첨부파일을 삭제하시겠습니까?')) return;
    document.getElementById('existingFileUrl').value = '';
    document.querySelector('.current-file').style.display = 'none';
  }
</script>

</body>
</html>
