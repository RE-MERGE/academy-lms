<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 변경 - LMS</title>
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

        .find-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem 1rem;
            position: relative;
        }

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

        .find-wrap {
            width: 100%;
            max-width: 500px;
            position: relative;
            z-index: 1;
            animation: fadeUp .3s cubic-bezier(.22,1,.36,1);
        }

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
            color: var(--primary);
        }

        .find-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1e3a8a;
            margin-bottom: 0.4rem;
        }

        .find-sub {
            font-size: .78rem;
            color: var(--gray-400);
            font-weight: 500;
        }

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

        .field input {
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
            box-sizing: border-box;
        }
        .field input::placeholder { color: var(--gray-300); }
        .field input:focus {
            border-color: var(--primary-light);
            background: var(--primary-pale);
            box-shadow: 0 0 0 3px rgba(59,130,246,.1);
        }

        .field-hint {
            font-size: .7rem;
            color: var(--gray-300);
            margin-top: .3rem;
            padding-left: .2rem;
        }

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

        /* ── 버튼 영역 ── */
        .btn-row {
            display: flex;
            gap: .7rem;
            margin-top: 1.6rem;
        }

        .btn-submit {
            flex: 1;
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

        .btn-cancel {
            flex: 1;
            padding: .72rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: .45rem;
            background: transparent;
            color: var(--gray-400);
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            font-size: .88rem;
            font-weight: 600;
            cursor: pointer;
            transition: all .16s;
            text-decoration: none;
            letter-spacing: .01em;
        }
        .btn-cancel:hover {
            color: var(--gray-600);
            border-color: var(--gray-400);
            background: var(--gray-50);
            transform: translateY(-1px);
        }
        .btn-cancel:active { transform: translateY(0); }

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
        <div class="find-card">
            <div class="find-card-topbar"></div>
            <div class="find-card-body">

                <!-- 헤더 -->
                <div class="find-header">
                
                    <h2 class="find-title">비밀번호 변경</h2>
                    <p class="find-sub">새로운 비밀번호를 설정하세요.</p>
                </div>

                <form action="${pageContext.request.contextPath}/user/changePassword" method="post">

                    <div class="fields-divider"><span>현재 비밀번호 확인</span></div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 현재 비밀번호</label>
                        <input type="password" name="currentPassword" placeholder="현재 비밀번호를 입력하세요" />
                    </div>

                    <div class="fields-divider"><span>새 비밀번호 설정</span></div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 새 비밀번호</label>
                        <input type="password" name="newPassword" placeholder="새 비밀번호를 입력하세요" />
                        <p class="field-hint">영문자, 숫자, 특수문자 포함 최소 8~20자</p>
                    </div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 새 비밀번호 확인</label>
                        <input type="password" name="newPasswordConfirm" placeholder="한 번 더 입력하세요" />
                    </div>

                    <div class="btn-row">
                        <a href="${pageContext.request.contextPath}/user/myPage" class="btn-cancel">
                            <i class="fa-solid fa-xmark"></i>
                            변경 취소
                        </a>
                        <button type="submit" class="btn-submit">
                            <i class="fa-solid fa-floppy-disk"></i>
                            저장
                        </button>
                    </div>

                </form>

            </div><!-- /find-card-body -->

            <div class="find-card-footer">
                <a href="${pageContext.request.contextPath}/user/myPage" class="back-link">
                    ← 마이페이지로 돌아가기
                </a>
            </div>

        </div><!-- /find-card -->
    </div><!-- /find-wrap -->
</div><!-- /find-page -->

<script>
    window.onload = function () {
        window.scrollTo(0, 0);
    };
</script>
</body>
</html>
