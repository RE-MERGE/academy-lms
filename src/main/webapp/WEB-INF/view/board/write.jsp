<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>re-merge LMS — 글쓰기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>
<body>

<div class="bg-mesh"></div>

<main class="write-wrap">
    <div class="write-header">
        <div class="header-title">
            <h2>새 게시글 작성</h2>
            <p>지식과 질문을 공유하여 함께 성장하는 커뮤니티를 만들어주세요.</p>
        </div>
        <div class="header-actions">
            <button type="button" class="btn-cancel" onclick="history.back();">취소</button>
            <button type="submit" form="writeForm" class="btn-submit">등록하기</button>
        </div>
    </div>

    <div class="card write-card">
        <form id="writeForm" action="boardWriteAction.do" method="post" enctype="multipart/form-data">

            <div class="form-row">
                <div class="form-group group-category">
                    <label for="boardType">분류</label>
                    <select name="boardType" id="boardType" class="lms-select">
                        <option value="공지">공지</option>
                        <option value="자유" selected>자유</option>
                        <option value="질문">질문</option>
                        <option value="스터디">스터디</option>
                        <option value="정보">정보</option>
                    </select>
                </div>
                <div class="form-group group-title">
                    <label for="title">제목</label>
                    <input type="text" name="title" id="title" class="lms-input" placeholder="제목을 입력하세요" required>
                </div>
            </div>

            <div class="form-group">
                <label for="content">내용</label>
                <textarea name="content" id="content" class="lms-textarea" placeholder="내용을 상세히 입력해 주세요. 타인에 대한 비방이나 부적절한 콘텐츠는 제재를 받을 수 있습니다."></textarea>
            </div>

            <div class="form-group">
                <label>파일 첨부</label>
                <div class="file-upload-wrapper">
                    <input type="file" name="uploadFile" id="uploadFile" class="file-input">
                    <label for="uploadFile" class="file-label">
                        <span class="file-icon">📁</span>
                        <span class="file-text">클릭하여 파일을 선택하거나 드래그하세요.</span>
                    </label>
                </div>
            </div>

        </form>
    </div>
</main>

</body>
</html>