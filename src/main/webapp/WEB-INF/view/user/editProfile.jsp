<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

        /* ── 전체 페이지 & 카드 디자인 ── */
        .find-page { min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2.5rem 1rem; position: relative; }
        .find-wrap { width: 100%; max-width: 500px; position: relative; z-index: 1; animation: fadeUp .3s cubic-bezier(.22,1,.36,1); }
        .find-card { background: var(--white); border: 1px solid var(--gray-200); border-radius: var(--radius-xl); box-shadow: var(--shadow-lg); overflow: hidden; }
        .find-card-topbar { height: 4px; background: linear-gradient(90deg, var(--primary-dark), var(--primary-mid), var(--primary-light)); }
        .find-card-body { padding: 2.2rem 2.4rem 2.4rem; }
        .find-header { text-align: center; margin-bottom: 2rem; }
        .find-title { font-size: 1.5rem; font-weight: 700; color: #1e3a8a; margin-bottom: 0.4rem; }
        .find-sub { font-size: .78rem; color: var(--gray-400); font-weight: 500; }

        /* ── 프로필 이미지 ── */
        .profile-upload-container { position: relative; width: 120px; height: 120px; margin: 0 auto 2rem; }
        .profile-preview { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid var(--primary-tint); background: var(--primary-pale); display: block; }
        .camera-icon-label { position: absolute; bottom: 4px; right: 4px; width: 32px; height: 32px; background: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; border: 2px solid var(--white); color: var(--white); font-size: .72rem; transition: background .16s, transform .16s; }
        #profile-input { display: none !important; }

        /* ── 입력 필드 공통 ── */
        .field { margin-bottom: 1rem; }
        .field label { display: flex; align-items: center; gap: .35rem; font-size: .72rem; font-weight: 700; color: #444; margin-bottom: .4rem; }
        .field input { width: 100%; padding: .65rem .9rem; background: var(--gray-50); border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); font-size: .87rem; box-sizing: border-box; }
        .field input[readonly] { background: var(--gray-100); color: var(--gray-400); cursor: not-allowed; }
        .readonly-badge { display: inline-flex; align-items: center; gap: .25rem; font-size: .62rem; font-weight: 700; color: var(--gray-300); background: var(--gray-100); border: 1px solid var(--gray-200); border-radius: 99px; padding: .1rem .45rem; margin-left: .35rem; }
        .fields-divider { display: flex; align-items: center; gap: .75rem; margin: 1.2rem 0; }
        .fields-divider::before, .fields-divider::after { content: ''; flex: 1; height: 1px; background: var(--gray-100); }
        .fields-divider span { font-size: .68rem; font-weight: 700; color: var(--gray-300); text-transform: uppercase; }
        .error-msg { display: block; color: var(--red); font-size: .73rem; font-weight: 600; margin-top: .3rem; }

        /* ── 버튼 ── */
        .btn-row { display: flex; gap: .7rem; margin-top: 1.4rem; }
        .btn-submit { flex: 1; padding: .72rem; background: var(--primary); color: var(--white); border: none; border-radius: var(--radius-md); font-weight: 700; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: .45rem; }
        .btn-withdraw { padding: .72rem 1.1rem; background: transparent; color: var(--gray-300); border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); font-weight: 600; cursor: pointer; }
        .btn-withdraw:hover { color: var(--red); border-color: var(--red); background: #fff5f5; }

        /* ── 탈퇴 모달 ── */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.45); z-index: 9999; align-items: center; justify-content: center; }
        .modal-overlay.active { display: flex; }
        .modal-box { background: var(--white); border-radius: var(--radius-xl); box-shadow: var(--shadow-lg); padding: 2rem 2.2rem; max-width: 380px; width: 90%; text-align: center; }
        .modal-icon { font-size: 2rem; margin-bottom: .8rem; color: var(--red); }
        .modal-title { font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 0.5rem; }
        .modal-desc-box { text-align: left; background: #fff5f5; padding: 12px; border-radius: 8px; margin-bottom: 1.2rem; }
        .modal-btn-row { display: flex; gap: .6rem; margin-top: 1rem; }
        .modal-btn-cancel { flex: 1; padding: .65rem; background: var(--gray-100); border: none; border-radius: var(--radius-md); font-weight: 600; cursor: pointer; }
        .modal-btn-confirm { flex: 1; padding: .65rem; background: var(--red); color: var(--white); border: none; border-radius: var(--radius-md); font-weight: 700; cursor: pointer; }
        .modal-input-group { margin-bottom: 1rem; text-align: left; }
        .modal-input-group label { font-size: 0.8rem; color: var(--gray-600); cursor: pointer; }
        .modal-input-group input[type="password"] { width: 100%; padding: 10px; border: 1px solid var(--gray-200); border-radius: 6px; box-sizing: border-box; margin-top: 8px; }

        /* ── 카드 푸터 ── */
        .find-card-footer { border-top: 1px solid var(--gray-100); padding: 1.2rem 2.4rem; display: flex; align-items: center; justify-content: center; background-color: #fafbff; }
        .back-link { display: inline-flex; align-items: center; gap: 0.5rem; font-size: 0.85rem; font-weight: 600; color: var(--gray-400); text-decoration: none; padding: 0.5rem 1rem; border-radius: var(--radius-md); transition: all 0.2s ease; }
        .back-link:hover { color: var(--primary); background-color: var(--primary-pale); transform: translateX(-4px); }

        @keyframes fadeUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

<div class="find-page">
    <div class="find-wrap">
        <div class="find-card">
            <div class="find-card-topbar"></div>
            <div class="find-card-body">

                <div class="find-header">
                    <h2 class="find-title">회원정보 수정</h2>
                    <p class="find-sub">변경할 정보를 입력하고 저장하세요.</p>
                </div>

<div class="profile-upload-container">
    <c:choose>
        <%-- 프로필 이미지가 있는 경우 --%>
        <c:when test="${not empty userEditForm.currentProfileImg and userEditForm.currentProfileImg != 'default-profile.png'}">
            <img id="preview" src="${userEditForm.currentProfileImg}" class="profile-preview">
        </c:when>

        <%-- 프로필 이미지가 없는 경우 (기본 이미지) --%>
        <c:otherwise>
            <img id="preview" src="${pageContext.request.contextPath}/img/default-profile.png" class="profile-preview">
        </c:otherwise>
    </c:choose>

    <label for="profile-input" class="camera-icon-label" title="사진 변경">
        <i class="fa-solid fa-camera"></i>
    </label>
</div>

                <%-- [중요] 프로필 수정 폼 시작 --%>
                <form:form action="${pageContext.request.contextPath}/user/editProfile" method="post" enctype="multipart/form-data" modelAttribute="userEditForm">
                    <input type="hidden" name="currentProfileImg" value="${userEditForm.currentProfileImg}"/>
                    <input type="file" id="profile-input" name="profileImg" accept="image/*" onchange="previewImage(this)">

                    <div class="field">
                        <label><span class="field-icon">✦</span> 아이디 <span class="readonly-badge"><i class="fa-solid fa-lock"></i> 변경 불가</span></label>
                        <form:input path="userId" readonly="true" />
                    </div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 이름</label>
                        <form:input path="name" />
                        <form:errors path="name" cssClass="error-msg" />
                    </div>

                    <div class="fields-divider"><span>연락처 정보</span></div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 이메일</label>
                        <form:input path="email" />
                        <form:errors path="email" cssClass="error-msg" />
                    </div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 연락처</label>
                        <form:input path="phone" />
                        <form:errors path="phone" cssClass="error-msg" />
                    </div>

                    <div class="fields-divider"><span>비밀번호 인증</span></div>

                    <div class="field">
                        <label><span class="field-icon">✦</span> 현재 비밀번호</label>
                        <form:password path="password" placeholder="정보 수정을 위해 입력하세요" />
                        <form:errors path="password" cssClass="error-msg" />
                    </div>

                    <div class="btn-row">
                        <button type="submit" class="btn-submit">
                            <i class="fa-solid fa-floppy-disk"></i> 저장하기
                        </button>

                        <c:if test="${sessionUser.role != 'ADMIN'}">
                            <button type="button" class="btn-withdraw" onclick="openWithdrawModal()">
                                <i class="fa-solid fa-user-slash"></i> 탈퇴
                            </button>
                        </c:if>
                    </div>
                </form:form>
                <%-- [중요] 여기서 프로필 수정 폼이 끝남 --%>

            </div> <%-- find-card-body 끝 --%>

            <div class="find-card-footer">
                <a href="${pageContext.request.contextPath}/user/myPage" class="back-link">
                    <i class="fa-solid fa-house-chimney"></i> 돌아가기
                </a>
            </div>
        </div>
    </div>
</div>

<%-- [중요] 탈퇴 모달은 모든 폼 바깥에 독립적으로 존재해야 함 --%>
<div class="modal-overlay" id="withdrawModal">
    <div class="modal-box">
        <div class="modal-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <p class="modal-title">정말 탈퇴하시겠습니까?</p>

        <div class="modal-desc-box">
            <p style="color: #e53e3e; font-weight: bold; font-size: 0.85rem; margin-bottom: 4px;">⚠️ 탈퇴 전 유의사항</p>
            <p style="font-size: 0.78rem; color: #666; line-height: 1.5;">탈퇴 시 모든 학습 기록 및 계정 정보가 삭제되며 다시 복구할 수 없습니다.</p>
        </div>

        <%-- 탈퇴 전용 독립 폼 --%>
        <form id="withdrawForm" action="${pageContext.request.contextPath}/user/withdraw" method="post">
            <div class="modal-input-group">
                <label>
                    <input type="checkbox" id="agreeCheck"> 안내 사항을 확인하였으며 동의합니다.
                </label>
                <%-- [중요] name을 컨트롤러의 @RequestParam 명칭인 "withdrawPassword"와 일치시킴 --%>
                <input type="password" id="withdrawPassword" name="password" placeholder="현재 비밀번호를 입력하세요">
            </div>

            <div class="modal-btn-row">
                <button type="button" class="modal-btn-cancel" onclick="closeWithdrawModal()">취소</button>
                <button type="button" class="modal-btn-confirm" onclick="confirmWithdraw()">탈퇴 확정</button>
            </div>
        </form>
    </div>
</div>

<script>
    window.onload = function() {
        // 컨트롤러에서 보낸 에러 메시지가 있는지 확인 (주소창 방식 대응)
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('error') === 'pw') {
            alert("비밀번호가 일치하지 않습니다.");
            history.replaceState({}, null, location.pathname); // 주소창 파라미터 제거
        }

        // FlashAttribute 방식 대응
        const flashError = "${error}";
        if (flashError === "pw") {
            alert("비밀번호가 일치하지 않습니다.");
        } else if (flashError === "system") {
            alert("시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
    };

    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) { document.getElementById('preview').src = e.target.result; };
            reader.readAsDataURL(input.files[0]);
        }
    }

    function openWithdrawModal() {
        document.getElementById('withdrawModal').classList.add('active');
    }

    function closeWithdrawModal() {
        document.getElementById('withdrawModal').classList.remove('active');
        document.getElementById('withdrawPassword').value = '';
        document.getElementById('agreeCheck').checked = false;
    }

    function confirmWithdraw() {
        const password = document.getElementById('withdrawPassword').value;
        const agree = document.getElementById('agreeCheck').checked;

        if (!agree) {
            alert("안내 사항에 동의해야 탈퇴가 가능합니다.");
            return;
        }

        if (!password || password.trim() === "") {
            alert("본인 확인을 위해 비밀번호를 입력해주세요.");
            document.getElementById('withdrawPassword').focus();
            return;
        }

        if (confirm("정말로 탈퇴하시겠습니까?")) {
            document.getElementById('withdrawForm').submit();
        }
    }

    document.getElementById('withdrawModal').addEventListener('click', function (e) {
        if (e.target === this) closeWithdrawModal();
    });
</script>
</body>
</html>