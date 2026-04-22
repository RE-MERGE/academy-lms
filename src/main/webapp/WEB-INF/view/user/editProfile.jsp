<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정 - LMS</title>
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

        /* ── 아이디 읽기 전용 배지 ── */
        .readonly-badge {
            display: inline-flex;
            align-items: center;
            gap: .25rem;
            font-size: .62rem;
            font-weight: 700;
            color: var(--gray-300);
            background: var(--gray-100);
            border: 1px solid var(--gray-200);
            border-radius: 99px;
            padding: .1rem .45rem;
            margin-left: .35rem;
            letter-spacing: .04em;
            text-transform: uppercase;
            vertical-align: middle;
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
            box-sizing: border-box;
        }
        .field input::placeholder { color: var(--gray-300); }
        .field input:focus,
        .field select:focus {
            border-color: var(--primary-light);
            background: var(--primary-pale);
            box-shadow: 0 0 0 3px rgba(59,130,246,.1);
        }

        /* 읽기 전용 입력 */
        .field input[readonly] {
            background: var(--gray-100);
            color: var(--gray-400);
            cursor: not-allowed;
            border-color: var(--gray-200);
        }
        .field input[readonly]:focus {
            border-color: var(--gray-200);
            background: var(--gray-100);
            box-shadow: none;
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
            margin-top: 1.4rem;
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

        /* 회원 탈퇴 버튼 */
        .btn-withdraw {
            padding: .72rem 1.1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: .4rem;
            background: transparent;
            color: var(--gray-300);
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            font-size: .82rem;
            font-weight: 600;
            cursor: pointer;
            transition: all .16s;
            white-space: nowrap;
            letter-spacing: .01em;
        }
        .btn-withdraw:hover {
            color: var(--red);
            border-color: var(--red);
            background: #fff5f5;
            transform: translateY(-1px);
        }
        .btn-withdraw:active { transform: translateY(0); }

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

        /* ── 탈퇴 모달 ── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,.45);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.active { display: flex; }

        .modal-box {
            background: var(--white);
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow-lg);
            padding: 2rem 2.2rem;
            max-width: 360px;
            width: 90%;
            text-align: center;
            animation: fadeUp .2s cubic-bezier(.22,1,.36,1);
        }
        .modal-icon {
            font-size: 2rem;
            margin-bottom: .8rem;
            color: var(--red);
        }
        .modal-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: .5rem;
        }
        .modal-desc {
            font-size: .82rem;
            color: var(--gray-400);
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }
        .modal-btn-row {
            display: flex;
            gap: .6rem;
        }
        .modal-btn-cancel {
            flex: 1;
            padding: .65rem;
            background: var(--gray-100);
            color: var(--gray-600);
            border: none;
            border-radius: var(--radius-md);
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            font-size: .85rem;
            font-weight: 600;
            cursor: pointer;
            transition: background .16s;
        }
        .modal-btn-cancel:hover { background: var(--gray-200); }
        .modal-btn-confirm {
            flex: 1;
            padding: .65rem;
            background: var(--red);
            color: var(--white);
            border: none;
            border-radius: var(--radius-md);
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            font-size: .85rem;
            font-weight: 700;
            cursor: pointer;
            transition: opacity .16s;
        }
        .modal-btn-confirm:hover { opacity: .85; }

    </style>
</head>
<body>

<!-- ── 탈퇴 확인 모달 ── -->
<div class="modal-overlay" id="withdrawModal">
    <div class="modal-box">
        <div class="modal-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <p class="modal-title">정말 탈퇴하시겠어요?</p>
        <p class="modal-desc">
            탈퇴 시 모든 학습 기록과 계정 정보가<br>
            영구적으로 삭제되며 복구할 수 없습니다.
        </p>
        <div class="modal-btn-row">
            <button class="modal-btn-cancel" onclick="closeWithdrawModal()">취소</button>
            <button class="modal-btn-confirm" onclick="confirmWithdraw()">탈퇴하기</button>
        </div>
    </div>
</div>

<div class="find-page">
    <div class="find-wrap">
        <div class="find-card">
            <div class="find-card-topbar"></div>
            <div class="find-card-body">

                <!-- 헤더 -->
                <div class="find-header">
                    <h2 class="find-title">회원정보 수정</h2>
                    <p class="find-sub">변경할 정보를 입력하고 저장하세요.</p>
                </div>

                <!-- 프로필 업로드 -->
                <div class="profile-upload-container">
                    <img id="preview"
                         src="${pageContext.request.contextPath}/upload/profiles/${userEditForm.currentProfileImg}" class="profile-preview" alt="프로필 미리보기">
                    <label for="profile-input" class="camera-icon-label" title="사진 변경">
                        <i class="fa-solid fa-camera"></i>
                    </label>
                </div>

                <form:form action="${pageContext.request.contextPath}/user/editProfile" method="post"
                           enctype="multipart/form-data" modelAttribute="userEditForm">
                    <input type="hidden" name="currentProfileImg" value="${userEditForm.currentProfileImg}"/>

                    <input type="file" id="profile-input" name="profileImg" accept="image/*"
                           onchange="previewImage(this)">

                    <!-- 기본 정보 -->
                    <div class="field">
                        <label>
                            <span class="field-icon">✦</span> 아이디
                            <span class="readonly-badge"><i class="fa-solid fa-lock" style="font-size:.55rem;"></i> 변경 불가</span>
                        </label>
                        <form:input path="userId" readonly="true" />
                    </div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 이름</label>
                        <form:input path="name" placeholder="실명을 입력하세요" />
                        <form:errors path="name" cssClass="error-msg" />
                    </div>


                    <!-- 연락처 정보 -->
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


                    <div class="fields-divider"><span>비밀번호 인증</span></div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 현재 비밀번호</label>
                        <form:password path="password" placeholder="현재 비밀번호를 입력하세요" />
                        <form:errors path="password" cssClass="error-msg" />
                    </div>

                    <!-- 버튼 -->
                    <div class="btn-row">
                        <button type="submit" class="btn-submit">
                            <i class="fa-solid fa-floppy-disk"></i>
                            저장하기
                        </button>
                        <button type="button" class="btn-withdraw" onclick="openWithdrawModal()">
                            <i class="fa-solid fa-user-slash"></i>
                            탈퇴
                        </button>
                    </div>

                </form:form>

            </div><!-- /find-card-body -->

            <div class="find-card-footer">
                <a href="${pageContext.request.contextPath}/home/home" class="back-link">
                    ← 홈으로 돌아가기
                </a>
            </div>

        </div><!-- /find-card -->
    </div><!-- /find-wrap -->
</div><!-- /find-page -->

<!-- 탈퇴 처리용 hidden form -->
<form id="withdrawForm" action="${pageContext.request.contextPath}/user/withdraw" method="post" style="display:none;"></form>

<script>
    window.onload = function () {
        window.scrollTo(0, 0);
    };

    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                document.getElementById('preview').src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    function openWithdrawModal() {
        document.getElementById('withdrawModal').classList.add('active');
    }

    function closeWithdrawModal() {
        document.getElementById('withdrawModal').classList.remove('active');
    }

    function confirmWithdraw() {
        document.getElementById('withdrawForm').submit();
    }

    /* 모달 바깥 클릭 시 닫기 */
    document.getElementById('withdrawModal').addEventListener('click', function (e) {
        if (e.target === this) closeWithdrawModal();
    });
</script>
</body>
</html>
