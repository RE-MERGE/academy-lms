<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - 페이지를 찾을 수 없습니다 | LMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        html, body {
            height: 100%;
            overflow: hidden;
            background: #0f1f4b;
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
        }

        /* ── 배경 그리드 패턴 ── */
        .bg-grid {
            position: fixed;
            inset: 0;
            background-image:
                linear-gradient(rgba(255,255,255,.035) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255,255,255,.035) 1px, transparent 1px);
            background-size: 48px 48px;
            z-index: 0;
        }

        /* ── 배경 블롭 ── */
        .bg-blob {
            position: fixed;
            border-radius: 50%;
            pointer-events: none;
            z-index: 0;
            filter: blur(80px);
        }
        .bg-blob-1 {
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(37,99,235,.45) 0%, transparent 70%);
            top: -200px; left: -150px;
            animation: blobFloat 8s ease-in-out infinite;
        }
        .bg-blob-2 {
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(59,130,246,.3) 0%, transparent 70%);
            bottom: -100px; right: -100px;
            animation: blobFloat 10s ease-in-out infinite reverse;
        }
        .bg-blob-3 {
            width: 300px; height: 300px;
            background: radial-gradient(circle, rgba(96,165,250,.2) 0%, transparent 70%);
            top: 40%; left: 60%;
            animation: blobFloat 12s ease-in-out infinite 2s;
        }

        @keyframes blobFloat {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33%       { transform: translate(20px, -30px) scale(1.05); }
            66%       { transform: translate(-15px, 20px) scale(.97); }
        }

        /* ── 메인 컨테이너 ── */
        .error-page {
            position: relative;
            z-index: 1;
            height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 0;
            padding: 2rem;
            text-align: center;
        }

        /* ── 404 숫자 ── */
        .error-code-wrap {
            position: relative;
            margin-bottom: 4rem;
            animation: fadeDown .5s cubic-bezier(.22,1,.36,1);
            
        }

        .error-code {
            font-size: clamp(7rem, 18vw, 13rem);
            font-weight: 900;
            line-height: 1;
            letter-spacing: -.04em;
            background: linear-gradient(135deg, #93c5fd 0%, #3b82f6 40%, #1d4ed8 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            position: relative;
            z-index: 1;
            user-select: none;
        }

        /* 그림자 레이어 */
        .error-code-shadow {
            position: absolute;
            inset: 0;
            font-size: clamp(7rem, 18vw, 13rem);
            font-weight: 900;
            line-height: 1;
            letter-spacing: -.04em;
            color: rgba(59,130,246,.12);
            transform: translate(6px, 8px);
            z-index: 0;
            user-select: none;
        }

        /* ── 아이콘 ── */
        .error-icon-wrap {
            width: 64px; height: 64px;
            background: rgba(59,130,246,.15);
            border: 1.5px solid rgba(96,165,250,.3);
            border-radius: 18px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.6rem;
            color: #93c5fd;
            margin: 0 auto 1.4rem;
            animation: fadeUp .45s cubic-bezier(.22,1,.36,1) .1s both;
        }

        /* ── 텍스트 ── */
        .error-title {
            font-size: clamp(1.3rem, 3vw, 1.9rem);
            font-weight: 700;
            color: #2F3699;
            margin-bottom: .6rem;
            animation: fadeUp .45s cubic-bezier(.22,1,.36,1) .15s both;
        }

        .error-desc {
            font-size: .88rem;
            color:  #737CE3;
            line-height: 1.7;
            max-width: 340px;
            margin: 0 auto 2rem;
            animation: fadeUp .45s cubic-bezier(.22,1,.36,1) .2s both;
        }

        /* ── 버튼 ── */
        .error-btn-row {
            display: flex;
            gap: .8rem;
            justify-content: center;
            flex-wrap: wrap;
            animation: fadeUp .45s cubic-bezier(.22,1,.36,1) .25s both;
        }

        .btn-home {
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            padding: .75rem 1.8rem;
            background: #2563eb;
            color: #fff;
            border: none;
            border-radius: 10px;
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            font-size: .9rem;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            transition: all .18s;
            box-shadow: 0 4px 18px rgba(37,99,235,.4);
            letter-spacing: .01em;
        }
        .btn-home:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 6px 24px rgba(37,99,235,.55);
        }
        .btn-home:active { transform: translateY(0); }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            padding: .75rem 1.6rem;
            background: transparent;
            color: rgba(148,183,255,.8);
            border: 1.5px solid rgba(96,165,250,.25);
            border-radius: 10px;
            font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            font-size: .9rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all .18s;
            letter-spacing: .01em;
        }
        .btn-back:hover {
            color: #93c5fd;
            border-color: rgba(96,165,250,.55);
            background: rgba(59,130,246,.08);
            transform: translateY(-2px);
        }
        .btn-back:active { transform: translateY(0); }

        /* ── 하단 브랜드 ── */
        .error-brand {
            position: fixed;
            bottom: 1.8rem;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            align-items: center;
            gap: .5rem;
            color: rgba(148,183,255,.35);
            font-size: .75rem;
            font-weight: 600;
            letter-spacing: .08em;
            text-transform: uppercase;
            white-space: nowrap;
            z-index: 1;
        }
        .error-brand-dot {
            width: 6px; height: 6px;
            background: rgba(96,165,250,.4);
            border-radius: 50%;
        }

        /* ── 떠다니는 파티클 ── */
        .particles {
            position: fixed;
            inset: 0;
            z-index: 0;
            pointer-events: none;
            overflow: hidden;
        }
        .particle {
            position: absolute;
            width: 3px; height: 3px;
            background: rgba(96,165,250,.5);
            border-radius: 50%;
            animation: particleDrift linear infinite;
        }
        .particle:nth-child(1)  { left:  8%; animation-duration: 14s; animation-delay:  0s; }
        .particle:nth-child(2)  { left: 18%; animation-duration: 18s; animation-delay: -4s; }
        .particle:nth-child(3)  { left: 30%; animation-duration: 12s; animation-delay: -8s; }
        .particle:nth-child(4)  { left: 45%; animation-duration: 16s; animation-delay: -2s; }
        .particle:nth-child(5)  { left: 58%; animation-duration: 20s; animation-delay: -6s; }
        .particle:nth-child(6)  { left: 70%; animation-duration: 13s; animation-delay: -1s; }
        .particle:nth-child(7)  { left: 82%; animation-duration: 17s; animation-delay: -9s; }
        .particle:nth-child(8)  { left: 92%; animation-duration: 15s; animation-delay: -3s; }

        @keyframes particleDrift {
            0%   { transform: translateY(110vh) scale(0);   opacity: 0; }
            10%  { opacity: 1; }
            90%  { opacity: .6; }
            100% { transform: translateY(-10vh) scale(1.5); opacity: 0; }
        }

        /* ── 공통 애니메이션 ── */
        @keyframes fadeDown {
            from { opacity: 0; transform: translateY(-24px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

    </style>
</head>
<body>

<!-- 배경 요소 -->
<div class="bg-grid"></div>
<div class="bg-blob bg-blob-1"></div>
<div class="bg-blob bg-blob-2"></div>
<div class="bg-blob bg-blob-3"></div>
<div class="particles">
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
</div>

<!-- 메인 콘텐츠 -->
<div class="error-page">

    <!-- 404 숫자 -->
    <div class="error-code-wrap">
        <div class="error-code-shadow" aria-hidden="true">404</div>
        <div class="error-code">404</div>
        
    </div>

    <!-- 텍스트 -->
    <h1 class="error-title">
        <spring:message code="error.page.notFound.title" default="페이지를 찾을 수 없습니다" />
    </h1>
    <p class="error-desc">
        <spring:message code="error.page.notFound.content" default="요청하신 페이지가 존재하지 않거나 이동되었을 수 있습니다." />
        <br>주소를 다시 확인해 주세요.
    </p>

    <!-- 버튼 -->
    <div class="error-btn-row">
        <a href="${pageContext.request.contextPath}/home/home" class="btn-home">
            <i class="fa-solid fa-house"></i>
            메인페이지로 이동
        </a>
        <a href="javascript:history.back()" class="btn-back">
            <i class="fa-solid fa-arrow-left"></i>
            이전 페이지
        </a>
    </div>

</div>

<!-- 하단 브랜드 -->
<div class="error-brand">
    <div class="error-brand-dot"></div>
    LMS · 학습관리시스템
    <div class="error-brand-dot"></div>
</div>

</body>
</html>
