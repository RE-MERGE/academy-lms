<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원정보 수정 | 관리자</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/myPage.css">
    <style>
        /* =============================================
           1. 레이아웃 & 래퍼
        ============================================= */
        .edit-wrap {
            max-width: 860px;
            margin: 40px auto;
            padding: 0 20px 60px;
            font-family: 'Noto Sans KR', sans-serif;
        }

        .edit-title {
            font-size: 22px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 28px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .edit-title::before {
            content: '';
            display: inline-block;
            width: 5px;
            height: 22px;
            background: #1E3A8A;
            border-radius: 3px;
        }

        /* =============================================
           2. 프로필 이미지 영역
        ============================================= */
        .edit-profile-img-section {
            display: flex;
            align-items: center;
            gap: 24px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 24px 28px;
            margin-bottom: 28px;
        }

        .edit-img-preview-wrap {
            position: relative;
            flex-shrink: 0;
        }

        .edit-img-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #1E3A8A;
            display: block;
        }

        .edit-img-overlay {
            position: absolute;
            bottom: 4px;
            right: 4px;
            width: 28px;
            height: 28px;
            background: #1E3A8A;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 2px solid #fff;
        }

        .edit-img-overlay svg {
            width: 14px;
            height: 14px;
            fill: #fff;
        }

        .edit-img-info {
            flex: 1;
        }

        .edit-img-info p {
            font-size: 13px;
            color: #64748b;
            margin: 0 0 10px;
            line-height: 1.6;
        }

        .edit-img-info strong {
            color: #1e293b;
            font-weight: 600;
        }

        .btn-img-upload {
            display: inline-block;
            padding: 7px 18px;
            background: #1E3A8A;
            color: #fff;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: background 0.18s;
        }

        .btn-img-upload:hover { background: #1e40af; }

        #profileImgInput { display: none; }

        /* =============================================
           3. 폼 카드 & 섹션
        ============================================= */
        .edit-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .edit-card-header {
            background: #1E3A8A;
            color: #fff;
            padding: 14px 24px;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 0.3px;
        }

        .edit-card-body {
            padding: 24px 28px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px 28px;
        }

        .edit-card-body.single-col {
            grid-template-columns: 1fr;
        }

        /* =============================================
           4. 폼 필드
        ============================================= */
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            font-size: 13px;
            font-weight: 600;
            color: #374151;
        }

        .form-label .required {
            color: #ef4444;
            margin-left: 3px;
        }

        .form-input,
        .form-select {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid #d1d5db;
            border-radius: 8px;
            font-size: 14px;
            font-family: 'Noto Sans KR', sans-serif;
            color: #1e293b;
            background: #fff;
            transition: border-color 0.18s, box-shadow 0.18s;
            box-sizing: border-box;
        }

        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: #1E3A8A;
            box-shadow: 0 0 0 3px rgba(30, 58, 138, 0.1);
        }

        .form-input:disabled,
        .form-input[readonly] {
            background: #f1f5f9;
            color: #64748b;
            cursor: not-allowed;
            border-color: #e2e8f0;
        }

        .form-hint {
            font-size: 12px;
            color: #94a3b8;
            margin-top: 2px;
        }

        .form-hint.warn {
            color: #f59e0b;
        }

        /* =============================================
           5. 상태/역할 뱃지 셀렉트
        ============================================= */
        .status-select-wrap {
            position: relative;
        }

        .status-dot {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #22c55e;
            pointer-events: none;
        }

        .status-select-wrap .form-select {
            padding-left: 30px;
        }

        /* =============================================
           6. 잠금 해제 버튼
        ============================================= */
        .lock-info-row {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .lock-count-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 14px;
            background: #fef2f2;
            border: 1.5px solid #fca5a5;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            color: #dc2626;
        }

        .btn-unlock {
            padding: 7px 16px;
            background: #fff;
            border: 1.5px solid #dc2626;
            border-radius: 7px;
            color: #dc2626;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.15s, color 0.15s;
        }

        .btn-unlock:hover {
            background: #dc2626;
            color: #fff;
        }

        /* =============================================
           7. 하단 버튼
        ============================================= */
        .edit-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 12px;
        }

        .btn-cancel {
            padding: 11px 28px;
            border: 1.5px solid #d1d5db;
            border-radius: 8px;
            background: #fff;
            color: #374151;
            font-size: 14px;
            font-weight: 600;
            font-family: 'Noto Sans KR', sans-serif;
            cursor: pointer;
            transition: border-color 0.15s, background 0.15s;
        }

        .btn-cancel:hover {
            border-color: #9ca3af;
            background: #f9fafb;
        }

        .btn-save {
            padding: 11px 32px;
            background: #1E3A8A;
            border: none;
            border-radius: 8px;
            color: #fff;
            font-size: 14px;
            font-weight: 700;
            font-family: 'Noto Sans KR', sans-serif;
            cursor: pointer;
            transition: background 0.15s;
        }

        .btn-save:hover { background: #1e40af; }

        /* =============================================
           8. 완료 토스트
        ============================================= */
        .toast {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #1e293b;
            color: #fff;
            padding: 14px 22px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            display: none;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            z-index: 9999;
            animation: slideUp 0.3s ease;
        }

        .toast.show { display: flex; }

        .toast-icon {
            width: 20px;
            height: 20px;
            background: #22c55e;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(12px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* =============================================
           9. 반응형
        ============================================= */
        @media (max-width: 640px) {
            .edit-card-body { grid-template-columns: 1fr; }
            .edit-profile-img-section { flex-direction: column; align-items: flex-start; }
            .edit-actions { flex-direction: column-reverse; }
            .btn-cancel, .btn-save { width: 100%; text-align: center; }
        }
        .input-error { border-color: #ef4444 !important; }
        .form-error  { font-size: 12px; color: #ef4444; margin-top: 2px; }
        .btn-temp-pw {
            padding: 11px 28px;
            border: 1.5px solid #f59e0b;
            border-radius: 8px;
            background: #fff;
            color: #f59e0b;
            font-size: 14px;
            font-weight: 600;
            font-family: 'Noto Sans KR', sans-serif;
            cursor: pointer;
            transition: background 0.15s, color 0.15s;
        }
        .btn-temp-pw:hover {
            background: #f59e0b;
            color: #fff;
        }
    </style>
</head>
<body>
<div class="edit-wrap">
    <h2 class="edit-title">회원정보 수정</h2>

    <form:form id="editProfileForm" modelAttribute="userDetail"
               action="${pageContext.request.contextPath}/admin/editProfileForAdmin/${userDetail.userNo}"
               method="post"
               enctype="multipart/form-data">
        <input type="hidden" name="currentProfileImg" value="${userDetail.currentProfileImg}"/>


        <!-- =============================================
        프로필 이미지
        ============================================= -->
        <div class="edit-profile-img-section">
            <div class="edit-img-preview-wrap">
                <c:choose>
                    <c:when test="${not empty userDetail.currentProfileImg}">
                        <img id="previewImg"
                             src="${userDetail.currentProfileImg}"
                             class="edit-img-preview"
                             onerror="this.src='${pageContext.request.contextPath}/img/default-profile.png'"/>
                    </c:when>
                    <c:otherwise>
                        <img id="previewImg"
                             src="${pageContext.request.contextPath}/img/default-profile.png"
                             class="edit-img-preview"/>
                    </c:otherwise>
                </c:choose>
                <label for="profileImgInput" class="edit-img-overlay" title="이미지 변경">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zm17.71-10.21a1 1 0 0 0 0-1.41l-2.34-2.34a1 1 0 0 0-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                    </svg>
                </label>
            </div>
            <div class="edit-img-info">
                <p>
                    <strong>${not empty originalName ? originalName : userDetail.name}</strong> 님의 프로필 이미지입니다.<br>
                    JPG, PNG, GIF 형식의 파일을 업로드할 수 있으며 최대 <strong>5MB</strong>까지 허용됩니다.
                </p>
                <label for="profileImgInput" class="btn-img-upload">이미지 변경</label>
                <input type="file" id="profileImgInput" name="profileImg" accept="image/*"/>
            </div>
        </div>

        <!-- =============================================
        기본 정보
        ============================================= -->
        <div class="edit-card">
            <div class="edit-card-header">기본 정보</div>
            <div class="edit-card-body">

                <div class="form-group">
                    <label class="form-label">학번 / 사번</label>
                    <input type="text" class="form-input" value="${userDetail.userCode}" readonly/>
                    <span class="form-hint">변경 불가 항목입니다.</span>
                </div>

                <div class="form-group">
                    <label class="form-label">아이디</label>
                    <input type="text" class="form-input" value="${userDetail.userId}" readonly/>
                    <span class="form-hint">변경 불가 항목입니다.</span>
                </div>

                    <%-- 이름 --%>
                <div class="form-group">
                    <label class="form-label" for="name">이름 <span class="required">*</span></label>
                    <form:input path="name" id="name" cssClass="form-input" cssErrorClass="form-input input-error" required="true"/>
                    <form:errors path="name" cssClass="form-error"/>
                </div>

                    <%-- 연락처 --%>
                <div class="form-group">
                    <label class="form-label" for="phone">연락처 <span class="required">*</span></label>
                    <form:input path="phone" id="phone" cssClass="form-input" cssErrorClass="form-input input-error" placeholder="010-0000-0000" required="true"/>
                    <form:errors path="phone" cssClass="form-error"/>
                </div>

                    <%-- 이메일 --%>
                <div class="form-group full-width">
                    <label class="form-label" for="email">이메일 <span class="required">*</span></label>
                    <form:input path="email" id="email" cssClass="form-input" cssErrorClass="form-input input-error" required="true"/>
                    <form:errors path="email" cssClass="form-error"/>
                </div>
            </div>
        </div>

        <!-- =============================================
        계정 설정
        ============================================= -->
        <div class="edit-card">
            <div class="edit-card-header">계정 설정</div>
            <div class="edit-card-body">

                <div class="form-group">
                    <label class="form-label" for="role">역할</label>
                    <select id="role" name="role" class="form-select">
                        <option value="STUDENT"   ${userDetail.role eq 'STUDENT'   ? 'selected' : ''}>학생</option>
                        <option value="PROFESSOR" ${userDetail.role eq 'PROFESSOR' ? 'selected' : ''}>교수</option>
                        <option value="ADMIN"     ${userDetail.role eq 'ADMIN'     ? 'selected' : ''}>관리자</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="status">상태</label>
                    <div class="status-select-wrap">
                        <span class="status-dot" id="statusDot"></span>
                        <select id="status" name="status" class="form-select" onchange="updateStatusDot(this.value)">
                            <option value="ACTIVE"   ${userDetail.status eq 'ACTIVE'   ? 'selected' : ''}>활동</option>
                            <option value="INACTIVE" ${userDetail.status eq 'INACTIVE' ? 'selected' : ''}>휴면</option>
                            <option value="LOCKED"   ${userDetail.status eq 'LOCKED'   ? 'selected' : ''}>정지</option>
                            <option value="PENDING"  ${userDetail.status eq 'PENDING'  ? 'selected' : ''}>대기</option>
                            <option value="DELETE"   ${userDetail.status eq 'DELETE'   ? 'selected' : ''}>탈퇴</option>
                        </select>
                    </div>
                </div>

                <div class="form-group full-width">
                    <label class="form-label">로그인 실패 횟수</label>
                    <div class="lock-info-row">
    <span class="lock-count-badge">
    ⚠ ${userDetail.lockCount}회 실패
    </span>
                        <c:if test="${userDetail.lockCount > 0}">
                            <button type="button" class="btn-unlock"
                                    onclick="resetLockCount(${userDetail.userNo})">
                                실패 횟수 초기화
                            </button>
                        </c:if>
                    </div>
                    <span class="form-hint warn">5회 이상 실패 시 계정이 잠깁니다.</span>
                </div>

            </div>
        </div>

        <!-- =============================================
        가입 정보 (읽기 전용)
        ============================================= -->
        <div class="edit-card">
            <div class="edit-card-header">가입 정보</div>
            <div class="edit-card-body"> <fmt:parseDate value="${userDetail.lastLoginDate}" pattern="yyyy-MM-dd" var="pLogin" type="date"/>
                <fmt:parseDate value="${userDetail.createdAt}" pattern="yyyy-MM-dd" var="pCreated" type="date"/>

                <fmt:formatDate value="${pLogin}" pattern="yyyy년 M월 d일 E요일" var="formattedLogin"/>
                <fmt:formatDate value="${pCreated}" pattern="yyyy년 M월 d일 E요일" var="formattedCreated"/>

                <div class="form-group">
                    <label class="form-label">마지막 접속일</label>
                    <input type="text" class="form-input" readonly value="${formattedLogin}"/>
                </div>

                <div class="form-group">
                    <label class="form-label">회원가입 신청일</label>
                    <input type="text" class="form-input" readonly value="${formattedCreated}"/>
                </div>

            </div>
        </div>

        <!-- =============================================
        하단 버튼
        ============================================= -->
        <div class="edit-actions">
            <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
            <button type="button" class="btn-temp-pw" onclick="sendTempPassword(${userDetail.userNo}, '${userDetail.email}')">임시 비밀번호 발급</button>
            <button type="submit" class="btn-save">저장하기</button>
        </div>

    </form:form>
</div>

<!-- 완료 토스트 -->
<div class="toast" id="toast">
    <span class="toast-icon">
    <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
    <path d="M2 6l3 3 5-5" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
    </span>
    <span id="toastMsg">저장되었습니다.</span>
</div>

<script>
    /* ============================================
    상태 점 색상 업데이트
    ============================================ */
    var STATUS_COLORS = {
        ACTIVE:   '#22c55e',
        INACTIVE: '#94a3b8',
        LOCKED:   '#ef4444',
        PENDING:  '#f59e0b',
        DELETE:   '#6b7280'
    };

    function updateStatusDot(value) {
        document.getElementById('statusDot').style.background = STATUS_COLORS[value] || '#94a3b8';
    }

    /* 페이지 로드 시 초기 상태 반영 */
    window.addEventListener('DOMContentLoaded', () => {
        var currentStatus = document.getElementById('status').value;
        updateStatusDot(currentStatus);
    });

    /* ============================================
    프로필 이미지 미리보기
    ============================================ */
    document.getElementById('profileImgInput').addEventListener('change', function () {
        var file = this.files[0];
        if (!file) return;

        if (file.size > 5 * 1024 * 1024) {
            showToast('파일 크기는 5MB를 초과할 수 없습니다.', true);
            this.value = '';
            return;
        }

        var reader = new FileReader();
        reader.onload = e => { document.getElementById('previewImg').src = e.target.result; };
        reader.readAsDataURL(file);
    });

    /* ============================================
    로그인 실패 횟수 초기화 (AJAX)
    ============================================ */
    function resetLockCount(userNo) {
        if (!confirm('로그인 실패 횟수를 초기화하시겠습니까?')) return;

        fetch('${pageContext.request.contextPath}/admin/resetLock/' + userNo, {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(r => {
                if (!r.ok) throw new Error('서버 오류');
                return r.json();
            })
            .then(data => {
                if (data.success) {
                    document.querySelector('.lock-count-badge').innerHTML = '✅ 0회 실패';
                    document.querySelector('.btn-unlock').style.display = 'none';
                    showToast('실패 횟수가 초기화되었습니다.');
                } else {
                    showToast('초기화에 실패했습니다.', true);
                }
            })
            .catch(() => showToast('요청 중 오류가 발생했습니다.', true));
    }

    /* ============================================
    폼 제출 처리
    ============================================ */
    document.getElementById('editProfileForm').addEventListener('submit', function (e) {
        /* 기본 submit 허용 — 필요 시 AJAX로 전환 */
        var name  = document.getElementById('name').value.trim();
        var phone = document.getElementById('phone').value.trim();
        var email = document.getElementById('email').value.trim();

        if (!name || !phone || !email) {
            e.preventDefault();
            showToast('필수 항목을 모두 입력해주세요.', true);
        }
    });

    /* ============================================
    토스트 알림
    ============================================ */
    function showToast(msg, isError) {
        var toast = document.getElementById('toast');
        document.getElementById('toastMsg').textContent = msg;
        toast.style.background = isError ? '#dc2626' : '#1e293b';
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 3000);
    }

    /* URL 파라미터로 저장 성공 메시지 처리 */
    window.addEventListener('DOMContentLoaded', () => {
        var params = new URLSearchParams(location.search);
        if (params.get('saved') === '1') showToast('회원정보가 저장되었습니다.');
    });
    function sendTempPassword(userNo, email) {
        if (!confirm(email + ' 으로 임시 비밀번호를 발급하시겠습니까?')) return;

        fetch('${pageContext.request.contextPath}/admin/tempPassword/' + userNo, {
            method: 'POST',
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
            .then(r => {
                if (!r.ok) throw new Error('서버 오류');
                return r.json();
            })
            .then(data => {
                if (data.success) {
                    showToast('임시 비밀번호가 이메일로 발송되었습니다.');
                } else {
                    showToast('발송에 실패했습니다.', true);
                }
            })
            .catch(() => showToast('요청 중 오류가 발생했습니다.', true));
    }
</script>
</body>
</html>
