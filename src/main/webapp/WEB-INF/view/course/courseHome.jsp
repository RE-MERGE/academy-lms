<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>전체 과목</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: 'Noto Sans KR', sans-serif; background: #f5f6fa; color: #1a1a2e; }

  .home-header { background: #004595; padding: 28px 36px 24px; color: #fff; }
  .home-header h1 { font-size: 24px; font-weight: 700; margin-bottom: 4px; }
  .home-header .sub { font-size: 13px; opacity: 0.75; }

  .control-bar {
    display: flex; align-items: center; gap: 10px;
    padding: 18px 36px; background: #fff;
    border-bottom: 1px solid #e8eaf0; flex-wrap: wrap;
  }
  .count-label { font-size: 14px; color: #666; margin-right: auto; }
  .count-label span { font-weight: 700; color: #004595; }

  .btn-fav {
    display: flex; align-items: center; gap: 6px;
    font-size: 13px; font-family: inherit; padding: 7px 14px;
    border-radius: 20px; border: 1.5px solid #d0d7f0;
    background: #fff; color: #666; cursor: pointer; transition: all 0.18s;
  }
  .btn-fav:hover { border-color: #004595; color: #004595; }
  .btn-fav.on { background: #fff8e6; border-color: #e0a800; color: #a07800; font-weight: 600; }

  input[type="text"] {
    font-family: inherit; font-size: 13px; padding: 7px 13px;
    border-radius: 8px; border: 1px solid #d0d7f0;
    background: #fff; color: #333; outline: none;
    transition: border-color 0.15s; width: 170px;
  }
  input[type="text"]:focus { border-color: #004595; }

  .section-wrap { padding: 28px 36px 0; }
  .section-title {
    font-size: 16px; font-weight: 700; color: #1a1a2e;
    margin-bottom: 16px; display: flex; align-items: center; gap: 8px;
  }
  .section-title .badge {
    font-size: 12px; font-weight: 600;
  }
  .type-major-req  { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
  .type-major-elec { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
  .type-gen-req    { background: #fffbeb; color: #a16207; border: 1px solid #fde68a; }
  .type-gen-elec   { background: #fdf4ff; color: #7e22ce; border: 1px solid #e9d5ff; }
  .type-free       { background: #f3f4f6; color: #4b5563; border: 1px solid #d1d5db;
    padding: 2px 8px; border-radius: 20px;
  }

  .section-divider { border: none; border-top: 2px solid #e8eaf0; margin: 28px 36px; }

  .grid-wrap { padding: 0 36px 40px; }
  .course-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
    gap: 16px;
  }

  .course-card {
    background: #fff; border: 1px solid #e4e8f5; border-radius: 12px;
    padding: 18px; position: relative; cursor: pointer;
    transition: box-shadow 0.18s, transform 0.18s;
    text-decoration: none; color: inherit; display: block;
  }
  .course-card:hover {
    box-shadow: 0 6px 20px rgba(0,69,149,0.10);
    transform: translateY(-3px); text-decoration: none; color: inherit;
  }

  .card-accent {
    position: absolute; top: 0; left: 0; right: 0;
    height: 4px; border-radius: 12px 12px 0 0; background: #004595;
  }

  .star-btn {
    position: absolute; top: 14px; right: 14px;
    background: none; border: none; cursor: pointer;
    padding: 3px; line-height: 1; transition: transform 0.15s; z-index: 1;
  }
  .star-btn:hover { transform: scale(1.25); }
  .star-btn svg path {
    fill: none; stroke: #c8c7c2;
    stroke-width: 1.6; stroke-linejoin: round;
    transition: fill 0.15s, stroke 0.15s;
  }
  .star-btn.on svg path { fill: #FFC107; stroke: #e0a800; }

  .card-type-badge {
    display: inline-flex; align-items: center; justify-content: center;
    font-size: 11px; font-weight: 700;
    padding: 4px 10px; border-radius: 6px; margin-bottom: 12px; white-space: nowrap; letter-spacing: 0.02em;
  }
  .type-major-req  { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
  .type-major-elec { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
  .type-gen-req    { background: #fffbeb; color: #a16207; border: 1px solid #fde68a; }
  .type-gen-elec   { background: #fdf4ff; color: #7e22ce; border: 1px solid #e9d5ff; }
  .type-free       { background: #f3f4f6; color: #4b5563; border: 1px solid #d1d5db;
  }
  .card-name { font-size: 15px; font-weight: 700; color: #1a1a2e; margin-bottom: 4px; padding-right: 24px; }
  .card-info { font-size: 12px; color: #888; margin-bottom: 14px; }
  .card-divider { border: none; border-top: 1px solid #f0f0f5; margin-bottom: 11px; }
  .card-meta { font-size: 12px; color: #aaa; }

  .empty-state { padding: 40px 0; text-align: center; color: #aaa; font-size: 14px; }
</style>
</head>
<body>

<div class="home-header">
  <h1>전체 과목</h1>
  <div class="sub">수강 중인 모든 과목을 확인하세요</div>
</div>

<div class="control-bar">
  <div class="count-label">총 <span id="totalCount">${enrolledList.size() + otherList.size()}</span>개 과목</div>
  <button class="btn-fav" id="favBtn" onclick="toggleFavFilter()">
    <svg width="14" height="14" viewBox="0 0 20 20">
      <path d="M10 2l2.4 4.9 5.4.8-3.9 3.8.9 5.3L10 14.3l-4.8 2.5.9-5.3L2.2 7.7l5.4-.8z"
            stroke="#e0a800" stroke-width="1.5" fill="none" stroke-linejoin="round"/>
    </svg>
    즐겨찾기만 보기
  </button>
  <input type="text" id="searchInput" placeholder="과목명 검색..." oninput="filterCards()"/>
</div>

<%-- ════════════ 수강중인 강의 ════════════ --%>
<div class="section-wrap">
  <div class="section-title">
    <c:choose>
      <c:when test="${userRole == 'ADMIN'}">모든 과목</c:when>
      <c:otherwise>수강중인 강의</c:otherwise>
    </c:choose>
    <span class="badge">${enrolledList.size()}</span>
  </div>
</div>
<div class="grid-wrap">
  <div class="course-grid">

    <%-- 즐겨찾기 먼저 --%>
    <c:forEach var="course" items="${enrolledList}">
      <c:set var="isFav" value="${favSet.contains(course.course_no)}"/>
      <c:if test="${isFav}">
        <a href="${pageContext.request.contextPath}/course/subject?no=${course.course_no}"
           class="course-card" data-name="${course.course_name}" data-fav="true" data-courseno="${course.course_no}">
          <div class="card-accent"></div>
          <button class="star-btn on" title="즐겨찾기 해제" onclick="toggleStar(event,this,${course.course_no})">
            <svg width="20" height="20" viewBox="0 0 20 20"><path d="M10 2l2.4 4.9 5.4.8-3.9 3.8.9 5.3L10 14.3l-4.8 2.5.9-5.3L2.2 7.7l5.4-.8z"/></svg>
          </button>
          <c:choose>
            <c:when test="${course.course_type == 'MAJOR_REQUIRED'}"><c:set var="typeClass" value="type-major-req"/><c:set var="typeLabel" value="전공필수"/></c:when>
            <c:when test="${course.course_type == 'MAJOR_ELECTIVE'}"><c:set var="typeClass" value="type-major-elec"/><c:set var="typeLabel" value="전공선택"/></c:when>
            <c:when test="${course.course_type == 'GENERAL_REQUIRED'}"><c:set var="typeClass" value="type-gen-req"/><c:set var="typeLabel" value="교양필수"/></c:when>
            <c:when test="${course.course_type == 'GENERAL_ELECTIVE'}"><c:set var="typeClass" value="type-gen-elec"/><c:set var="typeLabel" value="교양선택"/></c:when>
            <c:otherwise><c:set var="typeClass" value="type-free"/><c:set var="typeLabel" value="일반선택"/></c:otherwise>
          </c:choose>
          <div class="card-type-badge ${typeClass}">${typeLabel}</div>
          <div class="card-name">${course.course_name}</div>
          <div class="card-info">${course.semester} &nbsp;|&nbsp; ${course.credits}학점</div>
          <hr class="card-divider"/>
          <div class="card-meta">${course.day_of_week}요일 &nbsp;${course.start_time} ~ ${course.end_time}</div>
        </a>
      </c:if>
    </c:forEach>

    <%-- 즐겨찾기 아닌 것 --%>
    <c:forEach var="course" items="${enrolledList}">
      <c:set var="isFav" value="${favSet.contains(course.course_no)}"/>
      <c:if test="${!isFav}">
        <a href="${pageContext.request.contextPath}/course/subject?no=${course.course_no}"
           class="course-card" data-name="${course.course_name}" data-fav="false" data-courseno="${course.course_no}">
          <div class="card-accent"></div>
          <button class="star-btn" title="즐겨찾기 추가" onclick="toggleStar(event,this,${course.course_no})">
            <svg width="20" height="20" viewBox="0 0 20 20"><path d="M10 2l2.4 4.9 5.4.8-3.9 3.8.9 5.3L10 14.3l-4.8 2.5.9-5.3L2.2 7.7l5.4-.8z"/></svg>
          </button>
          <c:choose>
            <c:when test="${course.course_type == 'MAJOR_REQUIRED'}"><c:set var="typeClass" value="type-major-req"/><c:set var="typeLabel" value="전공필수"/></c:when>
            <c:when test="${course.course_type == 'MAJOR_ELECTIVE'}"><c:set var="typeClass" value="type-major-elec"/><c:set var="typeLabel" value="전공선택"/></c:when>
            <c:when test="${course.course_type == 'GENERAL_REQUIRED'}"><c:set var="typeClass" value="type-gen-req"/><c:set var="typeLabel" value="교양필수"/></c:when>
            <c:when test="${course.course_type == 'GENERAL_ELECTIVE'}"><c:set var="typeClass" value="type-gen-elec"/><c:set var="typeLabel" value="교양선택"/></c:when>
            <c:otherwise><c:set var="typeClass" value="type-free"/><c:set var="typeLabel" value="일반선택"/></c:otherwise>
          </c:choose>
          <div class="card-type-badge ${typeClass}">${typeLabel}</div>
          <div class="card-name">${course.course_name}</div>
          <div class="card-info">${course.semester} &nbsp;|&nbsp; ${course.credits}학점</div>
          <hr class="card-divider"/>
          <div class="card-meta">${course.day_of_week}요일 &nbsp;${course.start_time} ~ ${course.end_time}</div>
        </a>
      </c:if>
    </c:forEach>

    <c:if test="${empty enrolledList}">
      <div class="empty-state">
        <c:choose>
          <c:when test="${userRole == 'ADMIN'}">등록된 과목이 없습니다.</c:when>
          <c:otherwise>수강중인 강의가 없습니다.</c:otherwise>
        </c:choose>
      </div>
    </c:if>
  </div>
</div>

<c:if test="${userRole != 'ADMIN'}"><hr class="section-divider"/></c:if>

<%-- ════════════ 전체 강의 (수강중 제외) ════════════ --%>
<c:if test="${userRole != 'ADMIN'}">
<div class="section-wrap">
  <div class="section-title">
    전체 강의 <span class="badge">${otherList.size()}</span>
  </div>
</div>
<div class="grid-wrap">
  <div class="course-grid">

    <%-- 즐겨찾기 먼저 --%>
    <c:forEach var="course" items="${otherList}">
      <c:set var="isFav" value="${favSet.contains(course.course_no)}"/>
      <c:if test="${isFav}">
        <a href="${pageContext.request.contextPath}/course/subject?no=${course.course_no}"
           class="course-card" data-name="${course.course_name}" data-fav="true" data-courseno="${course.course_no}">
          <div class="card-accent"></div>
          <button class="star-btn on" title="즐겨찾기 해제" onclick="toggleStar(event,this,${course.course_no})">
            <svg width="20" height="20" viewBox="0 0 20 20"><path d="M10 2l2.4 4.9 5.4.8-3.9 3.8.9 5.3L10 14.3l-4.8 2.5.9-5.3L2.2 7.7l5.4-.8z"/></svg>
          </button>
          <c:choose>
            <c:when test="${course.course_type == 'MAJOR_REQUIRED'}"><c:set var="typeClass" value="type-major-req"/><c:set var="typeLabel" value="전공필수"/></c:when>
            <c:when test="${course.course_type == 'MAJOR_ELECTIVE'}"><c:set var="typeClass" value="type-major-elec"/><c:set var="typeLabel" value="전공선택"/></c:when>
            <c:when test="${course.course_type == 'GENERAL_REQUIRED'}"><c:set var="typeClass" value="type-gen-req"/><c:set var="typeLabel" value="교양필수"/></c:when>
            <c:when test="${course.course_type == 'GENERAL_ELECTIVE'}"><c:set var="typeClass" value="type-gen-elec"/><c:set var="typeLabel" value="교양선택"/></c:when>
            <c:otherwise><c:set var="typeClass" value="type-free"/><c:set var="typeLabel" value="일반선택"/></c:otherwise>
          </c:choose>
          <div class="card-type-badge ${typeClass}">${typeLabel}</div>
          <div class="card-name">${course.course_name}</div>
          <div class="card-info">${course.semester} &nbsp;|&nbsp; ${course.credits}학점</div>
          <hr class="card-divider"/>
          <div class="card-meta">${course.day_of_week}요일 &nbsp;${course.start_time} ~ ${course.end_time}</div>
        </a>
      </c:if>
    </c:forEach>

    <%-- 즐겨찾기 아닌 것 --%>
    <c:forEach var="course" items="${otherList}">
      <c:set var="isFav" value="${favSet.contains(course.course_no)}"/>
      <c:if test="${!isFav}">
        <a href="${pageContext.request.contextPath}/course/subject?no=${course.course_no}"
           class="course-card" data-name="${course.course_name}" data-fav="false" data-courseno="${course.course_no}">
          <div class="card-accent"></div>
          <button class="star-btn" title="즐겨찾기 추가" onclick="toggleStar(event,this,${course.course_no})">
            <svg width="20" height="20" viewBox="0 0 20 20"><path d="M10 2l2.4 4.9 5.4.8-3.9 3.8.9 5.3L10 14.3l-4.8 2.5.9-5.3L2.2 7.7l5.4-.8z"/></svg>
          </button>
          <c:choose>
            <c:when test="${course.course_type == 'MAJOR_REQUIRED'}"><c:set var="typeClass" value="type-major-req"/><c:set var="typeLabel" value="전공필수"/></c:when>
            <c:when test="${course.course_type == 'MAJOR_ELECTIVE'}"><c:set var="typeClass" value="type-major-elec"/><c:set var="typeLabel" value="전공선택"/></c:when>
            <c:when test="${course.course_type == 'GENERAL_REQUIRED'}"><c:set var="typeClass" value="type-gen-req"/><c:set var="typeLabel" value="교양필수"/></c:when>
            <c:when test="${course.course_type == 'GENERAL_ELECTIVE'}"><c:set var="typeClass" value="type-gen-elec"/><c:set var="typeLabel" value="교양선택"/></c:when>
            <c:otherwise><c:set var="typeClass" value="type-free"/><c:set var="typeLabel" value="일반선택"/></c:otherwise>
          </c:choose>
          <div class="card-type-badge ${typeClass}">${typeLabel}</div>
          <div class="card-name">${course.course_name}</div>
          <div class="card-info">${course.semester} &nbsp;|&nbsp; ${course.credits}학점</div>
          <hr class="card-divider"/>
          <div class="card-meta">${course.day_of_week}요일 &nbsp;${course.start_time} ~ ${course.end_time}</div>
        </a>
      </c:if>
    </c:forEach>

    <c:if test="${empty otherList}">
      <div class="empty-state">다른 강의가 없습니다.</div>
    </c:if>
  </div>
</div>
</c:if>

<script>
  const contextPath = "${pageContext.request.contextPath}";
  let favOnly = false;

  function toggleFavFilter() {
    favOnly = !favOnly;
    document.getElementById('favBtn').classList.toggle('on', favOnly);
    filterCards();
  }

  function filterCards() {
    const query = document.getElementById('searchInput').value.trim().toLowerCase();
    const cards = document.querySelectorAll('.course-card');
    let visible = 0;

    cards.forEach(card => {
      const name  = card.dataset.name.toLowerCase();
      const isFav = card.dataset.fav === 'true';
      const matchSearch = !query || name.includes(query);
      const matchFav    = !favOnly || isFav;

      if (matchSearch && matchFav) {
        card.style.display = 'block';
        visible++;
      } else {
        card.style.display = 'none';
      }
    });

    document.getElementById('totalCount').textContent = visible;
  }

  function toggleStar(e, btn, courseNo) {
    e.preventDefault();
    e.stopPropagation();

    const card     = btn.closest('.course-card');
    const isFav    = btn.classList.contains('on');
    const endpoint = isFav ? '/course/remove' : '/course/add';

    fetch(contextPath + endpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'course_no=' + courseNo
    })
    .then(res => res.text())
    .then(result => {
      if (result === 'ok') {
        btn.classList.toggle('on');
        btn.title = btn.classList.contains('on') ? '즐겨찾기 해제' : '즐겨찾기 추가';
        card.dataset.fav = btn.classList.contains('on') ? 'true' : 'false';
        if (favOnly) filterCards();
      } else {
        alert('즐겨찾기 처리 중 오류가 발생했습니다.');
      }
    })
    .catch(err => console.error('즐겨찾기 오류:', err));
  }
</script>
</body>
</html>
