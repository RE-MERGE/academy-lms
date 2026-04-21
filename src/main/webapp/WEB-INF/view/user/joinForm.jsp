<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 - LMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>

        html, body {
            height: auto !important;
            min-height: 100% !important;
            overflow-y: auto !important;
            overflow-x: hidden !important;
          	background: linear-gradient(135deg, #f0f4ff 0%, #e8f0fe 100%);
            scroll-behavior: smooth;
        }

        /* ── 전체 페이지 ── */
        .find-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem 1rem;
            position: relative;
        }

        /* 배경 블롭 */
        .find-page::before,
        .find-page::after {
            content: '';
            position: fixed;
            border-radius: 50%;
            pointer-events: none;
            z-index: 0;
        }
        .find-page::before {
            width: 480px; height: 480px;
            background: radial-gradient(circle, var(--primary-tint) 0%, transparent 70%);
            top: -120px; left: -140px;
            opacity: .7;
        }
        .find-page::after {
            width: 360px; height: 360px;
            background: radial-gradient(circle, var(--primary-pale) 0%, transparent 70%);
            bottom: -100px; right: -100px;
            opacity: .8;
        }

        /* ── 래퍼 ── */
        .find-wrap {
            width: 100%;
            max-width: 500px;
            position: relative;
            z-index: 1;
            animation: fadeUp .3s cubic-bezier(.22,1,.36,1);
        }

        /* ── 상단 로고 ── */
        .find-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: .6rem;
            margin-bottom: 1.6rem;
            text-decoration: none;
        }
        .find-emblem {
            width: 34px; height: 34px;
            border-radius: var(--radius-sm);
            background: var(--primary);
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem;
        }
        .find-logo-text {
            font-family: 'DM Serif Display', serif;
            font-size: 1.15rem;
            color: var(--gray-800);
            letter-spacing: -.01em;
        }
        .find-logo-text span { color: var(--primary); }

        /* ── 카드 ── */
        .find-card {
            background: var(--white);
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }

        .find-card-topbar {
            height: 4px;
            background: linear-gradient(90deg, var(--primary-dark), var(--primary-mid), var(--primary-light));
        }

        .find-card-body {
            padding: 2.2rem 2.4rem 2.4rem;
        }

        /* ── 헤더 ── */
        .find-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .find-icon-wrap {
            width: 56px; height: 56px;
            background: var(--primary-pale);
            border: 1.5px solid var(--primary-tint);
            border-radius: var(--radius-lg);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem;
            margin: 0 auto .9rem;
        }

          .find-title { 
          font-size: 1.5rem; 
          font-weight: 700; 
          color: #1e3a8a; 
          margin-bottom: 0.4rem; }

        .find-sub {
            font-size: .78rem;
            color: var(--gray-400);
            font-weight: 500;
        }

        /* ── 프로필 업로드 ── */
       .profile-upload-container {
  		 position: relative;
   		 width: 120px; height: 120px;
   		 margin: 0 auto 2rem;
		}

        .profile-preview {
           width: 120px; height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--primary-tint);
            background: var(--primary-pale);
            display: block;
        }

        .camera-icon-label {
            position: absolute;
            bottom: 4px; right: 4px;
    		width: 32px; height: 32px;
            background: var(--primary);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            border: 2px solid var(--white);
            color: var(--white);
            font-size: .72rem;
            transition: background .16s, transform .16s;
        }
        .camera-icon-label:hover {
            background: var(--primary-mid);
            transform: scale(1.1);
        }

        #profile-input { display: none !important; }

        /* ── 필드 ── */
        .field { margin-bottom: 1rem; }

        .field label {
            display: flex;
            align-items: center;
            gap: .35rem;
            font-size: .72rem;
            font-weight: 700;
            letter-spacing: .07em;
            text-transform: uppercase;
            color: #444444;
            margin-bottom: .4rem;
        }
        .field label .field-icon {
            color: var(--primary-light);
            font-size: .78rem;
        }

        .field input,
        .field select {
            width: 100%;
            padding: .65rem .9rem;
            background: var(--gray-50);
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            font-size: .87rem;
            font-weight: 500;
            color: var(--gray-900);
            outline: none;
            transition: border-color .16s, background .16s, box-shadow .16s;
        }
        .field input::placeholder { color: var(--gray-300); }
        .field input:focus,
        .field select:focus {
            border-color: var(--primary-light);
            background: var(--primary-pale);
            box-shadow: 0 0 0 3px rgba(59,130,246,.1);
        }
        .field select { cursor: pointer; }

        .error-msg {
            display: block;
            color: var(--red);
            font-size: .73rem;
            font-weight: 600;
            margin-top: .3rem;
            padding-left: .2rem;
        }

        /* ── 구분선 ── */
        .fields-divider {
            display: flex;
            align-items: center;
            gap: .75rem;
            margin: 1.2rem 0;
        }
        .fields-divider::before,
        .fields-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--gray-100);
        }
        .fields-divider span {
            font-size: .68rem;
            font-weight: 700;
            color: var(--gray-300);
            letter-spacing: .06em;
            text-transform: uppercase;
        }

        /* ── 제출 버튼 ── */
        .btn-submit {
            width: 100%;
            margin-top: 1.4rem;
            padding: .72rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: .45rem;
            background: var(--primary);
            color: var(--white);
            border: none;
            border-radius: var(--radius-md);
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            font-size: .88rem;
            font-weight: 700;
            cursor: pointer;
            transition: all .16s;
            box-shadow: 0 2px 8px rgba(29,78,216,.2);
            letter-spacing: .01em;
        }
        .btn-submit:hover {
            background: var(--primary-mid);
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(29,78,216,.3);
        }
        .btn-submit:active { transform: translateY(0); }

        /* ── 카드 푸터 ── */
        .find-card-footer {
            border-top: 1px solid var(--gray-100);
            padding: 1.1rem 2.4rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .back-link {
            display: flex;
            align-items: center;
            gap: .4rem;
            font-size: .78rem;
            font-weight: 600;
            color: var(--gray-400);
            text-decoration: none;
            transition: color .16s;
        }
        .back-link:hover { color: var(--primary); }

    </style>
</head>
<body>
<div class="find-page">
    <div class="find-wrap">

        <!-- 상단 로고 -->
        <a href="${pageContext.request.contextPath}/home/home" class="find-logo">
            <div class="find-emblem">🍕</div>
            <span class="find-logo-text">re-<span>merge</span> LMS</span>
        </a>

        <div class="find-card">
            <div class="find-card-topbar"></div>
            <div class="find-card-body">

                <!-- 헤더 -->
                <div class="find-header">
                    <h2 class="find-title">회원 가입</h2>
                    <p class="find-sub">계정을 생성하여 학습을 시작하세요.</p>
                </div>

                <!-- 프로필 업로드 -->
                <div class="profile-upload-container">
                    <img id="preview" src="${pageContext.request.contextPath}/img/default-profile.png" class="profile-preview" alt="미리보기">
                    <label for="profile-input" class="camera-icon-label">
                        <i class="fa-solid fa-camera"></i>
                    </label>
                    <input type="file" id="profile-input" name="profileImg" accept="image/*" onchange="previewImage(this)">
                </div>

                <form:form action="join" method="post" enctype="multipart/form-data" modelAttribute="userJoinForm">

                    <div class="field">
                        <label><span class="field-icon">✦</span> 이름</label>
                        <form:input path="name" placeholder="실명을 입력하세요" />
                        <form:errors path="name" cssClass="error-msg" />
                    </div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 아이디</label>
                        <form:input path="userId" placeholder="아이디를 입력하세요" />
                        <form:errors path="userId" cssClass="error-msg" element="span" />
                    </div>

                    <div class="fields-divider"><span>비밀번호 설정</span></div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 비밀번호</label>
                        <form:password path="password" placeholder="비밀번호를 입력하세요" />
                        <form:errors path="password" cssClass="error-msg" />
                    </div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 비밀번호 확인</label>
                        <form:password path="passwordConfirm" placeholder="한 번 더 입력하세요" />
                        <form:errors path="passwordConfirm" cssClass="error-msg" />
                    </div>

                    <div class="fields-divider"><span>연락처 정보</span></div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 이메일</label>
                        <form:input path="email" placeholder="example@lms.com" />
                        <form:errors path="email" cssClass="error-msg" />
                    </div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 연락처</label>
                        <form:input path="phone" placeholder="010-0000-0000" />
                        <form:errors path="phone" cssClass="error-msg" />
                    </div>

                    <div class="fields-divider"><span>역할</span></div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 직책</label>
                        <form:select path="role">
                            <form:option value="STUDENT">학생</form:option>
                            <form:option value="TEACHER">교수</form:option>
                        </form:select>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fa-solid fa-user-plus"></i>
                        회원 가입 신청
                    </button>

                </form:form>

            </div><!-- /find-card-body -->

            <div class="find-card-footer">
                <a href="${pageContext.request.contextPath}/home/home" class="back-link">
                    ← 이미 계정이 있으신가요? 로그인
                </a>
            </div>

        </div><!-- /find-card -->
    </div><!-- /find-wrap -->
</div><!-- /find-page -->

<script>
    window.onload = function() {
        window.scrollTo(0, 0);
    };

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
