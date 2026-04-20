<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>re-merge LMS · ${empty notice.id ? '공지 등록' : '공지 수정'}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css"/>
</head>
<body>

<canvas id="bg-canvas"></canvas>
<div class="bg-mesh"></div>

<%-- 권한 체크: 학생은 접근 불가 --%>
<c:if test="${sessionScope.loginUser.role eq 'STUDENT'}">
  <c:redirect url="noticeList.do"/>
</c:if>

<div class="board-wrap board-wrap--write">

  <a href="javascript:history.back()" class="back-link">&#8592; 뒤로가기</a>

  <div class="board-header">
    <div class="board-header-left">
      <p class="board-eyebrow">re-merge LMS</p>
      <h1 class="board-title">
        ${empty notice.id ? '공지 등록' : '공지 수정'} <span>📝</span>
      </h1>
    </div>
  </div>

  <form id="writeForm"
        action="${empty notice.id ? 'noticeWrite.do' : 'noticeUpdate.do'}"
        method="post"
        enctype="multipart/form-data"
        onsubmit="return validateForm()">

    <c:if test="${not empty notice.id}">
      <input type="hidden" name="id" value="${notice.id}"/>
    </c:if>

    <!-- ── 분류 + 고정 여부 ── -->
    <div class="write-row write-row--half">
      <div class="field">
        <label for="category">분류</label>
        <select id="category" name="category">
          <option value="일반"     ${notice.category eq '일반'     ? 'selected' : ''}>일반</option>
          <option value="긴급"     ${notice.category eq '긴급'     ? 'selected' : ''}>긴급</option>
          <option value="이벤트"   ${notice.category eq '이벤트'   ? 'selected' : ''}>이벤트</option>
          <option value="시스템"   ${notice.category eq '시스템'   ? 'selected' : ''}>시스템</option>
        </select>
      </div>

      <%-- 고정 기능: 관리자만 --%>
      <c:if test="${sessionScope.loginUser.role eq 'ADMIN'}">
        <div class="field field--checkbox">
          <label class="checkbox-label">
            <input type="checkbox" name="isPinned" value="true"
                   ${notice.isPinned ? 'checked' : ''}/>
            <span class="checkbox-custom"></span>
            상단 고정
          </label>
        </div>
      </c:if>
    </div>

    <!-- ── 제목 ── -->
    <div class="field">
      <label for="title">제목</label>
      <input type="text" id="title" name="title"
             value="${notice.title}" placeholder="제목을 입력하세요" maxlength="200"/>
      <p class="error-msg" id="err-title">제목을 입력해주세요.</p>
    </div>

    <!-- ── 본문 ── -->
    <div class="field">
      <label for="content">내용</label>
      <textarea id="content" name="content"
                rows="14" placeholder="내용을 입력하세요"
                class="write-textarea">${notice.content}</textarea>
      <p class="error-msg" id="err-content">내용을 입력해주세요.</p>
    </div>

    <!-- ── 파일 첨부 ── -->
    <div class="field">
      <label>파일 첨부 <span class="label-hint">(최대 5개 · 파일당 20MB)</span></label>

      <%-- 수정 시: 기존 첨부파일 목록 --%>
      <c:if test="${not empty notice.files}">
        <ul class="attach-list attach-list--edit">
          <c:forEach var="file" items="${notice.files}">
            <li class="attach-item-edit">
              <span>📎 ${file.originalName} (${file.sizeLabel})</span>
              <label class="checkbox-label checkbox-label--sm">
                <input type="checkbox" name="deleteFileIds" value="${file.id}"/>
                <span class="checkbox-custom"></span>
                삭제
              </label>
            </li>
          </c:forEach>
        </ul>
      </c:if>

      <div class="file-drop-zone" id="fileDropZone">
        <p class="file-drop-text">파일을 드래그하거나 클릭해서 업로드</p>
        <input type="file" id="fileInput" name="files" multiple
               accept="*/*" class="file-input-hidden"/>
      </div>
      <ul class="file-preview-list" id="filePreview"></ul>
      <p class="error-msg" id="err-file">파일은 최대 5개, 파일당 20MB까지 첨부할 수 있습니다.</p>
    </div>

    <!-- ── 버튼 ── -->
    <div class="write-actions">
      <button type="button" class="btn-cancel"
              onclick="location.href='noticeList.do'">취소</button>
      <button type="submit" class="btn-submit">
        ${empty notice.id ? '등록하기' : '수정 완료'}
      </button>
    </div>

  </form>
</div>
<script>
  /* ── 파일 드래그앤드롭 + 미리보기 ── */
  const dropZone   = document.getElementById('fileDropZone');
  const fileInput  = document.getElementById('fileInput');
  const previewList = document.getElementById('filePreview');
  const MAX_FILES  = 5;
  const MAX_SIZE   = 20 * 1024 * 1024; // 20MB
  let selectedFiles = [];

  dropZone.addEventListener('click', () => fileInput.click());
  dropZone.addEventListener('dragover', e => { e.preventDefault(); dropZone.classList.add('drag-over'); });
  dropZone.addEventListener('dragleave', () => dropZone.classList.remove('drag-over'));
  dropZone.addEventListener('drop', e => {
    e.preventDefault();
    dropZone.classList.remove('drag-over');
    addFiles(Array.from(e.dataTransfer.files));
  });
  fileInput.addEventListener('change', () => addFiles(Array.from(fileInput.files)));

  function addFiles(newFiles) {
    const errEl = document.getElementById('err-file');
    for (const f of newFiles) {
      if (selectedFiles.length >= MAX_FILES) { errEl.style.display = 'block'; break; }
      if (f.size > MAX_SIZE)                 { errEl.style.display = 'block'; continue; }
      selectedFiles.push(f);
    }
    renderPreview();
    syncFileInput();
  }

  function removeFile(idx) {
    selectedFiles.splice(idx, 1);
    renderPreview();
    syncFileInput();
  }

  function renderPreview() {
    previewList.innerHTML = '';
    selectedFiles.forEach((f, i) => {
      const li = document.createElement('li');
      li.className = 'file-preview-item';
      <%--li.innerHTML = `<span>📎 ${f.name} (${formatSize(f.size)})</span>--%>
                      <button type="button" onclick="removeFile(${i})">✕</button>`;
      previewList.appendChild(li);
    });
  }

  function syncFileInput() {
    const dt = new DataTransfer();
    selectedFiles.forEach(f => dt.items.add(f));
    fileInput.files = dt.files;
  }

  function formatSize(bytes) {
    if (bytes < 1024)       return bytes + ' B';
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
    return (bytes / 1024 / 1024).toFixed(1) + ' MB';
  }

  /* ── 폼 유효성 검사 ── */
  function validateForm() {
    let valid = true;

    const title   = document.getElementById('title');
    const content = document.getElementById('content');
    const errT    = document.getElementById('err-title');
    const errC    = document.getElementById('err-content');

    if (!title.value.trim()) {
      errT.style.display = 'block'; title.focus(); valid = false;
    } else { errT.style.display = 'none'; }

    if (!content.value.trim()) {
      errC.style.display = 'block'; if (valid) content.focus(); valid = false;
    } else { errC.style.display = 'none'; }

    return valid;
  }
</script>
</body>
</html>
