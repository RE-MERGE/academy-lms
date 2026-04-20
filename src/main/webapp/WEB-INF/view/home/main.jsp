<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>re-merge LMS · Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
  <style>
    /* 메인 대시보드 전용 레이아웃 오버라이드 */
    body {
      overflow-y: auto; /* 대시보드는 스크롤 허용 */
      background: var(--navy);
    }

    .dashboard-container {
      display: flex;
      min-height: 100vh;
      position: relative;
      z-index: 1;
    }

    /* 사이드바 스타일 */
    .sidebar {
      width: 260px;
      background: rgba(255, 255, 255, 0.03);
      border-right: 1px solid rgba(255, 255, 255, 0.08);
      backdrop-filter: blur(20px);
      padding: 2.5rem 1.5rem;
      display: flex;
      flex-direction: column;
    }

    .sidebar-logo {
      font-family: 'Syne', sans-serif;
      font-size: 1.8rem;
      font-weight: 800;
      color: var(--white);
      margin-bottom: 3rem;
      padding-left: 1rem;
    }
    .sidebar-logo span { color: var(--bright); }

    .nav-group { margin-bottom: 2rem; }
    .nav-label {
      font-size: 0.7rem;
      color: var(--text-sub);
      text-transform: uppercase;
      letter-spacing: 0.1em;
      margin-bottom: 1rem;
      display: block;
      padding-left: 1rem;
    }

    .nav-item {
      display: flex;
      align-items: center;
      padding: 0.8rem 1rem;
      color: var(--white);
      text-decoration: none;
      font-size: 0.95rem;
      border-radius: 12px;
      margin-bottom: 0.5rem;
      transition: all 0.2s;
    }
    .nav-item:hover { background: rgba(77, 143, 255, 0.1); color: var(--bright); }
    .nav-item.active { background: var(--accent); color: var(--white); box-shadow: 0 4px 15px rgba(46, 106, 230, 0.3); }

    /* 메인 콘텐츠 영역 */
    .main-content {
      flex: 1;
      padding: 2.5rem 3.5rem;
    }

    .top-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 3rem;
    }

    .welcome-text h1 { font-size: 1.8rem; color: var(--white); margin-bottom: 0.3rem; }
    .welcome-text p { color: var(--text-sub); font-size: 0.9rem; }

    .user-profile {
      display: flex;
      align-items: center;
      gap: 1rem;
      background: rgba(255, 255, 255, 0.05);
      padding: 0.5rem 1.2rem;
      border-radius: 50px;
      border: 1px solid rgba(255, 255, 255, 0.1);
    }

    /* 그리드 레이아웃 */
    .dashboard-grid {
      display: grid;
      grid-template-columns: 2fr 1fr;
      gap: 1.5rem;
    }

    .dashboard-card {
      background: rgba(255, 255, 255, 0.04);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 24px;
      padding: 1.8rem;
      backdrop-filter: blur(10px);
    }

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 1.5rem;
    }
    .card-title { font-size: 1.1rem; font-weight: 700; color: var(--white); display: flex; align-items: center; gap: 0.6rem; }
    .card-more { color: var(--text-sub); font-size: 0.8rem; text-decoration: none; }

    /* 공지사항 스타일 */
    .notice-list { list-style: none; }
    .notice-item {
      display: flex;
      justify-content: space-between;
      padding: 1rem 0;
      border-bottom: 1px solid rgba(255, 255, 255, 0.05);
    }
    .notice-item:last-child { border: none; }
    .notice-link { color: var(--text-sub); text-decoration: none; font-size: 0.9rem; transition: 0.2s; }
    .notice-link:hover { color: var(--white); }
    .notice-date { color: rgba(255, 255, 255, 0.2); font-size: 0.8rem; }

    /* 강의 진행률 스타일 */
    .course-item { margin-bottom: 1.5rem; }
    .course-info { display: flex; justify-content: space-between; margin-bottom: 0.6rem; }
    .course-name { color: var(--white); font-size: 0.95rem; font-weight: 500; }
    .course-percent { color: var(--bright); font-size: 0.9rem; font-weight: 700; }
    .progress-bar { height: 8px; background: rgba(255, 255, 255, 0.05); border-radius: 10px; overflow: hidden; }
    .progress-fill { height: 100%; background: linear-gradient(90deg, var(--accent), var(--bright)); border-radius: 10px; }

    /* 빠른 메뉴 버튼 */
    .quick-group { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-top: 1.5rem; }
    .quick-btn {
      background: rgba(255, 255, 255, 0.03);
      border: 1px solid rgba(255, 255, 255, 0.08);
      padding: 1.5rem;
      border-radius: 20px;
      text-align: center;
      cursor: pointer;
      transition: all 0.3s;
    }
    .quick-btn:hover { background: var(--accent); transform: translateY(-5px); border-color: var(--bright); }
    .quick-icon { font-size: 1.5rem; margin-bottom: 0.8rem; display: block; }
    .quick-label { color: var(--white); font-size: 0.9rem; font-weight: 600; }

    /* 시간표 스타일 (이미지 기반) */
    .timetable {
      width: 100%;
      border-collapse: separate;
      border-spacing: 4px;
      margin-top: 10px;
    }
    .timetable th { color: var(--text-sub); font-size: 0.75rem; padding: 8px; font-weight: 500; }
    .timetable td {
      background: rgba(255, 255, 255, 0.02);
      height: 40px;
      border-radius: 6px;
      transition: 0.2s;
    }
    .timetable td.active { background: var(--mid); border: 1px solid var(--accent); }
  </style>
</head>
<body>

<div class="bg-mesh"></div>

<div class="dashboard-container">
  <aside class="sidebar">
    <div class="sidebar-logo">RE<span>MERGE</span></div>

    <nav class="nav-group">
      <span class="nav-label">Academic</span>
      <a href="#" class="nav-item active">대시보드</a>
      <a href="#" class="nav-item">내 강의실</a>
      <a href="#" class="nav-item">성적 조회</a>
      <a href="#" class="nav-item">수강 신청</a>
    </nav>

    <nav class="nav-group">
      <span class="nav-label">Community</span>
      <a href="#" class="nav-item">공지사항</a>
      <a href="#" class="nav-item">질문게시판</a>
      <a href="#" class="nav-item">자료실</a>
    </nav>

    <div style="margin-top: auto;">
      <a href="${pageContext.request.contextPath}/user/logout" class="nav-item" style="color: var(--red);">로그아웃</a>
    </div>
  </aside>

  <main class="main-content">
    <header class="top-bar">
      <div class="welcome-text">
        <h1>안녕하세요, <span>김철수</span>님! 👋</h1>
        <p>오늘도 스마트한 학습을 시작해보세요.</p>
      </div>
      <div class="user-profile">
        <span style="color: var(--text-sub); font-size: 0.85rem;">202612345 (학생)</span>
        <div style="width: 32px; height: 32px; background: var(--bright); border-radius: 50%;"></div>
      </div>
    </header>

    <div class="dashboard-grid">

      <div class="grid-left">
        <section class="dashboard-card" style="margin-bottom: 1.5rem;">
          <div class="card-header">
            <h2 class="card-title">📢 공지사항</h2>
            <a href="#" class="card-more">전체보기 +</a>
          </div>
          <ul class="notice-list">
            <li class="notice-item">
              <a href="#" class="notice-link">[중요] 2026-1학기 수강신청 최종 안내</a>
              <span class="notice-date">2026-04-18</span>
            </li>
            <li class="notice-item">
              <a href="#" class="notice-link">중간고사 시험 일정 및 강의실 배정 공고</a>
              <span class="notice-date">2026-04-15</span>
            </li>
            <li class="notice-item">
              <a href="#" class="notice-link">LMS 시스템 고도화에 따른 점검 안내 (04/20)</a>
              <span class="notice-date">2026-04-12</span>
            </li>
          </ul>
        </section>

        <section class="dashboard-card">
          <div class="card-header">
            <h2 class="card-title">📚 내 강의 진행 현황</h2>
          </div>
          <div class="course-item">
            <div class="course-info">
              <span class="course-name">객체지향 프로그래밍 (Java)</span>
              <span class="course-percent">75%</span>
            </div>
            <div class="progress-bar">
              <div class="progress-fill" style="width: 75%;"></div>
            </div>
          </div>
          <div class="course-item">
            <div class="course-info">
              <span class="course-name">데이터베이스 설계 및 실습</span>
              <span class="course-percent">40%</span>
            </div>
            <div class="progress-bar">
              <div class="progress-fill" style="width: 40%;"></div>
            </div>
          </div>

          <div class="quick-group">
            <div class="quick-btn">
              <span class="quick-icon">📝</span>
              <span class="quick-label">수강신청</span>
            </div>
            <div class="quick-btn">
              <span class="quick-icon">📊</span>
              <span class="quick-label">성적확인</span>
            </div>
            <div class="quick-btn">
              <span class="quick-icon">✅</span>
              <span class="quick-label">출석체크</span>
            </div>
          </div>
        </section>
      </div>

      <div class="grid-right">
        <section class="dashboard-card" style="height: 100%;">
          <div class="card-header">
            <h2 class="card-title">🗓 주간 시간표</h2>
          </div>
          <table class="timetable">
            <thead>
            <tr>
              <th></th>
              <th>월</th>
              <th>화</th>
              <th>수</th>
              <th>목</th>
              <th>금</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="i" begin="1" end="9">
              <tr>
                <td style="font-size: 0.7rem; color: var(--text-sub); text-align: center;">${i}교시</td>
                <td class="${(i==2 || i==3) ? 'active' : ''}"></td>
                <td class="${(i==5 || i==6) ? 'active' : ''}"></td>
                <td class="${(i==2 || i==3) ? 'active' : ''}"></td>
                <td></td>
                <td class="${(i==1 || i==2) ? 'active' : ''}"></td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <button class="btn-submit" style="margin-top: 1.5rem; font-size: 0.85rem; padding: 0.7rem;">
            전체 시간표 보기
          </button>
        </section>
      </div>

    </div>
  </main>
</div>

</body>
</html>