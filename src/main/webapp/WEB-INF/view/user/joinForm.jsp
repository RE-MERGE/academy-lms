<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 - LMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .page { display: flex; align-items: center; justify-content: center; height: 100vh; }
        .card { max-width: 520px; width: 90%; padding: 3rem; margin: 20px auto; }
        .input-style {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            display: block;
            margin-bottom: 5px;
        }
        .error-msg {
            color: #ff4d4d;
            font-size: 0.85rem;
            margin-bottom: 10px;
            display: block;
        }
        .profile-upload-container { position: relative; width: 140px; height: 140px; margin: 0 auto 2rem; }
        .profile-preview { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; border: 3px solid var(--bright); background: transparent; }
        .camera-icon-label { position: absolute; bottom: 5px; right: 5px; width: 40px; height: 40px; background: var(--accent); border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; border: 3px solid var(--navy); }
        #profile-input { display: none; }
        .form-panel { width: 100%; max-height: 100vh; overflow-y: auto; padding: 40px 0; }
    </style>
</head>
<body>
    <div class="bg-mesh"></div>

    <div class="page">
        <div class="form-panel">
            <div class="card">
                <h2 class="card-title" style="text-align: center;">회원 가입</h2>
                <p class="card-sub" style="text-align: center;">계정을 생성하여 학습을 시작하세요.</p>

                <form:form action="join" method="post" enctype="multipart/form-data" modelAttribute="userJoinForm">

                    <div class="profile-upload-container">
                        <label for="profile-input" style="cursor: pointer; display: block; width: 100%; height: 100$;">
                            <img id="preview" src="${pageContext.request.contextPath}/img/default-profile.png" class="profile-preview" alt="미리보기" style="width:140px; height:140px; object-fit:cover; border-radius:50%;">
                             <label for="profile-input" class="camera-icon-label">
                                <i class="fa-solid fa-camera"></i>
                             </label>
                        </label>
                        <input type="file" id="profile-input" name="profileImg" accept="image/*" onchange="previewImage(this)">
                    </div>

                    <div class="field">
                        <label>이름</label>
                        <form:input path="name" placeholder="실명을 입력하세요" cssClass="input-style" />
                        <form:errors path="name" cssClass="error-msg" />
                    </div>

                    <div class="field">
                        <label>아이디</label>
                        <form:input path="userId" placeholder="아이디를 입력하세요" cssClass="input-style" />
                        <form:errors path="userId" cssClass="error-msg" element="span" />
                        </div>

                    <div class="field">
                        <label>비밀번호</label>
                        <form:password path="password" placeholder="비밀번호를 입력하세요" cssClass="input-style" />
                        <form:errors path="password" cssClass="error-msg" />
                    </div>

                    <div class="field">
                        <label>비밀번호 확인</label>
                        <form:password path="passwordConfirm" placeholder="한 번 더 입력하세요" cssClass="input-style" />
                        <form:errors path="passwordConfirm" cssClass="error-msg" />
                    </div>

                    <div class="field">
                        <label>이메일</label>
                        <form:input path="email" placeholder="example@lms.com" cssClass="input-style" />
                        <form:errors path="email" cssClass="error-msg" />
                    </div>

                    <div class="field">
                        <label>연락처</label>
                        <form:input path="phone" placeholder="010-0000-0000" cssClass="input-style" />
                        <form:errors path="phone" cssClass="error-msg" />
                    </div>

                    <div class="field">
                        <label>직책</label>
                        <form:select path="role" cssClass="input-style">
                            <form:option value="STUDENT">학생</form:option>
                            <form:option value="TEACHER">교수</form:option>
                        </form:select>
                    </div>

                    <button type="submit" class="btn-submit">회원 가입 신청</button>

                </form:form>

                <div style="text-align: center; margin-top: 1.5rem;">
                    <a href="${pageContext.request.contextPath}/home/home" class="back-link">
                        <i class="fa-solid fa-arrow-left"></i> 이미 계정이 있으신가요? 로그인
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('preview').src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>