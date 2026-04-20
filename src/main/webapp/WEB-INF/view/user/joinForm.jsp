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
        /* 1. 스크롤 및 전체 레이아웃 설정 */
        html, body {
            height: auto !important;
            min-height: 100% !important;
            overflow-y: auto !important;
            overflow-x: hidden !important;
            background: var(--navy);
            /* 페이지 로드 시 부드러운 시작을 위해 스크롤 위치 초기화와 병행 */
            scroll-behavior: smooth;
        }

        .page {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            height: auto !important;
            position: relative;
            z-index: 1;
        }

        .form-panel {
            width: 100%;
            padding: 60px 0; /* 상하 여백을 충분히 주어 카드가 잘리지 않게 함 */
        }

        .card {
            max-width: 520px;
            width: 90%;
            padding: 3rem;
            margin: 0 auto;
            background: rgba(255,255,255,.04);
            border: 1px solid rgba(255,255,255,.09);
            backdrop-filter: blur(24px);
            border-radius: 24px;
            box-shadow: 0 32px 80px rgba(0,0,0,.5);
        }

        /* 2. 프로필 업로드 및 파일 선택 버튼 숨기기 */
        .profile-upload-container {
            position: relative;
            width: 140px;
            height: 140px;
            margin: 0 auto 2.5rem;
        }

        .profile-preview {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--bright);
            background: rgba(255,255,255,0.1);
            display: block;
        }

        .camera-icon-label {
            position: absolute;
            bottom: 5px;
            right: 5px;
            width: 42px;
            height: 42px;
            background: var(--accent);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 3px solid var(--navy);
            color: white;
            transition: transform 0.2s;
        }

        .camera-icon-label:hover { transform: scale(1.1); }

        /* 실제 파일 선택 input은 완전히 숨김 */
        #profile-input {
            display: none !important;
        }

        /* 3. 입력 필드 스타일 */
        .input-style {
            width: 100%;
            padding: 12px;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            color: #fff;
            font-family: inherit;
            margin-bottom: 5px;
            outline: none;
        }

        .input-style:focus {
            border-color: var(--bright);
            background: rgba(77,143,255,0.08);
        }

        .error-msg {
            color: #ff6b6b;
            font-size: 0.8rem;
            margin-bottom: 12px;
            display: block;
            padding-left: 4px;
        }

        .bg-mesh { position: fixed; inset: 0; z-index: 0; }
    </style>
</head>
<body>

<div class="bg-mesh"></div>

<div class="page">
    <div class="form-panel">
        <div class="card">
            <h2 class="card-title" style="text-align: center; color: white; font-family: 'Syne', sans-serif;">회원 가입</h2>
            <p class="card-sub" style="text-align: center; color: var(--text-sub); margin-bottom: 2rem;">계정을 생성하여 학습을 시작하세요.</p>

            <form:form action="join" method="post" enctype="multipart/form-data" modelAttribute="userJoinForm">

                <div class="profile-upload-container">
                    <img id="preview" src="${pageContext.request.contextPath}/img/default-profile.png" class="profile-preview" alt="미리보기">
                    <label for="profile-input" class="camera-icon-label">
                        <i class="fa-solid fa-camera"></i>
                    </label>
                    <input type="file" id="profile-input" name="profileImg" accept="image/*" onchange="previewImage(this)">
                </div>

                <div class="field">
                    <label style="color: var(--text-sub); font-size: 0.8rem; text-transform: uppercase;">이름</label>
                    <form:input path="name" placeholder="실명을 입력하세요" cssClass="input-style" />
                    <form:errors path="name" cssClass="error-msg" />
                </div>

                <div class="field">
                    <label style="color: var(--text-sub); font-size: 0.8rem; text-transform: uppercase;">아이디</label>
                    <form:input path="userId" placeholder="아이디를 입력하세요" cssClass="input-style" />
                    <form:errors path="userId" cssClass="error-msg" element="span" />
                </div>

                <div class="field">
                    <label style="color: var(--text-sub); font-size: 0.8rem; text-transform: uppercase;">비밀번호</label>
                    <form:password path="password" placeholder="비밀번호를 입력하세요" cssClass="input-style" />
                    <form:errors path="password" cssClass="error-msg" />
                </div>

                <div class="field">
                    <label style="color: var(--text-sub); font-size: 0.8rem; text-transform: uppercase;">비밀번호 확인</label>
                    <form:password path="passwordConfirm" placeholder="한 번 더 입력하세요" cssClass="input-style" />
                    <form:errors path="passwordConfirm" cssClass="error-msg" />
                </div>

                <div class="field">
                    <label style="color: var(--text-sub); font-size: 0.8rem; text-transform: uppercase;">이메일</label>
                    <form:input path="email" placeholder="example@lms.com" cssClass="input-style" />
                    <form:errors path="email" cssClass="error-msg" />
                </div>

                <div class="field">
                    <label style="color: var(--text-sub); font-size: 0.8rem; text-transform: uppercase;">연락처</label>
                    <form:input path="phone" placeholder="010-0000-0000" cssClass="input-style" />
                    <form:errors path="phone" cssClass="error-msg" />
                </div>

                <div class="field">
                    <label style="color: var(--text-sub); font-size: 0.8rem; text-transform: uppercase;">직책</label>
                    <form:select path="role" cssClass="input-style" style="background-color: #1a2638;">
                        <form:option value="STUDENT">학생</form:option>
                        <form:option value="TEACHER">교수</form:option>
                    </form:select>
                </div>

                <button type="submit" class="btn-login" style="width: 100%; margin-top: 2rem;">회원 가입 신청</button>

            </form:form>

            <div style="text-align: center; margin-top: 1.5rem;">
                <a href="${pageContext.request.contextPath}/home/home" style="color: var(--bright); text-decoration: none; font-size: 0.9rem;">
                    <i class="fa-solid fa-arrow-left"></i> 이미 계정이 있으신가요? 로그인
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    // 페이지 로드 시 맨 위로 스크롤
    window.onload = function() {
        window.scrollTo(0, 0);
    };

    // 이미지 미리보기 로직
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