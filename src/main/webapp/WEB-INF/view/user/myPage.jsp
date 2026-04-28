<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<p class="course-time">
    <i class="far fa-clock"></i>
    ${fn:substring(course.start_time, 0, 5)} ~ ${fn:substring(course.end_time, 0, 5)}
</p>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/myPage.css">
    <style>
        /* 테이블 기본 레이아웃 고정 */
        .grade-table {
            width: 100%;
            table-layout: fixed; /* 컬럼 너비를 고정하여 어긋남 방지 */
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        /* 모든 셀의 중앙 정렬 및 패딩 설정 */
        .grade-table th,
        .grade-table td {
            text-align: center;      /* 가로 중앙 정렬 */
            vertical-align: middle;  /* 세로 중앙 정렬 */
            padding: 15px 10px;
            border-bottom: 1px solid #eee;
        }

        /* 헤더 배경 및 텍스트 설정 */
        .grade-table thead tr {
            color: #ffffff;
        }

        /* 열 너비 비율 설정 (합계 100%) */
        .grade-table th:nth-child(1), .grade-table td:nth-child(1) { width: 25%; text-align: center; } /* 과목명 */
        .grade-table th:nth-child(2), .grade-table td:nth-child(2) { width: 25%; text-align: center;} /* 수강인원/구분 */
        .grade-table th:nth-child(3), .grade-table td:nth-child(3) { width: 25%; text-align: center; } /* 평균점수/시험유형 */
        .grade-table th:nth-child(4), .grade-table td:nth-child(4) { width: 25%; text-align: center;} /* 최고-최저/점수 */

        /* 숫자 데이터 강조 (선택 사항) */
        .grade-table td {
            font-variant-numeric: tabular-nums; /* 숫자의 폭을 일정하게 맞춰 정렬 유지 */
        }

        /* --- 시간표 CSS --- */
        .timetable {
            margin: auto;
            width: 90%;
            display: table;
            table-layout: fixed; /* 가로 너비 고정 */
            border-collapse: collapse;
            background: #ffffff;
            border: 1px solid #ddd;
            box-sizing: border-box;
        }

        .timetable-header,
        .timetable-row {
            display: table-row;
        }

        .timetable-header > div,
        .timetable-time,
        .timetable-cell {
            display: table-cell;
            border: 1px solid #eee;
            vertical-align: middle;
            text-align: center;
            height: 85px;
            box-sizing: border-box;
        }

        .timetable-header > div {
            background-color: #2c3e50;
            color: #ffffff;
            height: 45px;
            font-weight: 700;
        }

        .timetable-header > div:first-child,
        .timetable-time {
            width: 10% !important;
            background-color: #f8f9fa;
            color: #666;
            font-size: 0.9em;
        }

        .timetable-header > div:not(:first-child),
        .timetable-cell {
            width: 18% !important;
        }

        .timetable-subject {
            margin: 4px;
            padding: 10px 5px;
            border-radius: 6px;
            font-size: 12px;
            line-height: 1.5;
            font-weight: 500;
            height: calc(100% - 8px);
            display: flex;
            flex-direction: column;
            justify-content: center;
            box-sizing: border-box;
        }

        .subject-amber { background-color: #fff4e0; color: #d4a017; border-left: 4px solid #d4a017; }
        .subject-blue { background-color: #e3f2fd; color: #1976d2; border-left: 4px solid #1976d2; }
        .subject-purple { background-color: #f3e5f5; color: #7b1fa2; border-left: 4px solid #7b1fa2; }
        .subject-green { background-color: #e8f5e9; color: #388e3c; border-left: 4px solid #388e3c; }
        .subject-rose { background-color: #ffebee; color: #c2185b; border-left: 4px solid #c2185b; }

        .badge-orange {
            background-color: #fff3cd;
            color: #e67e22;
            border: 1px solid #e67e22;
        }
        .grade-badge, .course-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            margin-top: 4px;
        }
        /* --- 시간표 CSS --- */
        .mp-tt-wrap {
            width: 90%; margin: auto;
            background: #fff; border: 1px solid #ddd;
            border-radius: 10px; overflow: hidden;
            padding: 12px; box-sizing: border-box;
        }
        .tt-grid-header {
            display: grid;
            grid-template-columns: 50px repeat(5, 1fr);
            gap: 3px; margin-bottom: 4px;
        }
        .tt-day {
            text-align: center; font-size: 14px; font-weight: 700;
            border-radius: 6px; color: #fff; background: #1E3A8A; min-height: 70px;
            height: 34px; display: flex; align-items: center; justify-content: center;
        }
        .tt-body { display: flex; flex-direction: column; gap: 3px; }
        .tt-row {
            display: grid;
            grid-template-columns: 50px repeat(5, 1fr);
            gap: 3px; min-height: 80px;
        }
        .tt-period {
            font-size: 10px; color: #888; font-weight: 600;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
        }
        .tt-cell {
            border-radius: 5px; font-size: 14px; font-weight: 600;  min-height: 70px;
            display: flex; align-items: center; justify-content: center;
            text-align: center; line-height: 1.3; padding: 4px 2px; color: #fff;
        }
        .tt-cell.empty { background: #f1f5f9; }
        .mp-c1 { background: #AEE2FF; color: #0369a1; border: 1.5px solid #0369a1; }
        .mp-c2 { background: #FFCEEE; color: #be185d; border: 1.5px solid #be185d; }
        .mp-c3 { background: #FFF6D2; color: #a16207; border: 1.5px solid #a16207; }
        .mp-c4 { background: #DED9FF; color: #5b21b6; border: 1.5px solid #5b21b6; }
        .mp-c5 { background: #D6FFDE; color: #166534; border: 1.5px solid #166534; }
        .mp-tabs-full .mypage-tab { flex: 1; text-align: center; }
    </style>

    </style>
</head>
<body>
<div class="mypage-wrap">
    <h2 class="mypage-title">마이페이지</h2>

    <div class="profile-card">
        <div class="profile-img-wrap">
            <c:choose>
                <c:when test="${not empty sessionUser.profileImg}">
                    <img src="${pageContext.request.contextPath}/upload/profiles/${sessionUser.profileImg}"
                         class="profile-img"
                         onerror="this.src='${pageContext.request.contextPath}/img/default-profile.png'"/>
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/img/default-profile.png"
                         class="profile-img"/>
                </c:otherwise>
            </c:choose>
            <span class="profile-status">재학중</span>
        </div>

        <div class="profile-info">
            <p class="profile-name">${sessionUser.name}</p>
            <c:if test="${sessionUser.role == 'STUDENT'}">
                <p class="profile-dept">에너지공학과</p>
            </c:if>
            <table class="profile-table">
                <tr>
                    <th>학번</th>
                    <td>${sessionUser.userCode}</td>
                </tr>
                <tr>
                    <th>아이디</th>
                    <td>${sessionUser.displayUserId}</td>
                </tr>
                <tr>
                    <th>이메일</th>
                    <td>${sessionUser.email}</td>
                </tr>
                <tr>
                    <th>역할</th>
                    <td>
                        <c:choose>
                            <c:when test="${sessionUser.role == 'STUDENT'}">학생</c:when>
                            <c:when test="${sessionUser.role == 'PROFESSOR'}">교수</c:when>
                            <c:otherwise>관리자</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </table>
        </div>

        <%-- 비밀번호 변경 알림 모달 --%>
        <div id="pwAlertModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.45); z-index:9999; justify-content:center; align-items:center;">
            <div style="background:#fff; border-radius:16px; padding:36px 40px; max-width:400px; width:90%; box-shadow:0 8px 32px rgba(0,0,0,0.2); text-align:center;">
                <div style="font-size:48px; margin-bottom:16px;">🔐</div>
                <h3 style="font-size:1.2rem; font-weight:700; color:#1e3a6e; margin-bottom:10px;">비밀번호 변경 안내</h3>
                <p style="font-size:0.9rem; color:#64748b; line-height:1.7; margin-bottom:24px;">
                    마지막 비밀번호 변경 후 <strong id="pwDayCount" style="color:#e74c3c;"></strong>일이 경과했습니다.<br>
                    보안을 위해 비밀번호를 변경해주세요.
                </p>
                <div style="display:flex; gap:10px; justify-content:center; flex-direction:column; align-items:center;">
                    <label style="display:flex; align-items:center; gap:6px; font-size:0.78rem; color:#94a3b8; cursor:pointer;">
                        <input type="checkbox" id="skipCheck" style="width:15px; height:15px; cursor:pointer;"/>
                        90일간 보지 않기
                    </label>
                    <div style="display:flex; gap:10px;">
                        <button onclick="closeModal()"
                                style="padding:10px 20px; border:1.5px solid #e2e8f0; border-radius:8px; font-size:0.78rem; cursor:pointer; background:#fff; color:#64748b; white-space:nowrap;">
                            나중에
                        </button>
                        <a href="${pageContext.request.contextPath}/user/updatePwForm"
                           style="padding:10px 20px; background:#1e3a6e; border-radius:8px; font-size:0.78rem; font-weight:700; color:#fff; text-decoration:none; display:flex; align-items:center; white-space:nowrap;">
                            변경하기
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="profile-actions">
<%--                <c:when test="${not empty adminViewUser}">--%>
<%--                    &lt;%&ndash; 관리자가 조회 중일 때 &ndash;%&gt;--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/editUser/${adminViewUser.userNo}"--%>
<%--                       class="btn-action btn-action-primary">회원정보 수정</a>--%>
<%--                </c:when>--%>
                    <%-- 본인이 볼 때 --%>
                    <a href="${pageContext.request.contextPath}/user/editProfile"
                       class="btn-action btn-action-primary">회원정보 수정</a>
                    <a href="${pageContext.request.contextPath}/user/updatePwForm"
                       class="btn-action btn-action-outline">비밀번호 변경</a>
        </div>
    </div>

    <div class="mypage-tabs">
        <button class="mypage-tab active" onclick="switchTab('courses')">
            ${sessionUser.role == 'ADMIN' ? '전체 개설 과목' : (sessionUser.role == 'PROFESSOR' ? '강의 중인 과목' : '수강 중인 과목')}        </button>

        <c:choose>
            <c:when test="${sessionUser.role == 'PROFESSOR'}">
                <button class="mypage-tab" onclick="switchTab('stats')">강의 통계</button>
            </c:when>
            <c:otherwise>
                <button class="mypage-tab" onclick="switchTab('grades')">성적 조회</button>
            </c:otherwise>
        </c:choose>

        <c:if test="${sessionUser.role != 'ADMIN'}">
            <button class="mypage-tab" onclick="switchTab('timetable')">시간표</button>
        </c:if>
    </div>

    <%-- 수강/강의 과목 탭 --%>
    <div id="tab-courses" class="tab-panel active">
        <div class="section-title">
            <c:choose>
                <c:when test="${sessionUser.role == 'STUDENT'}">수강중인 과목</c:when>
                <c:when test="${sessionUser.role == 'PROFESSOR'}">강의중인 과목</c:when>
                <c:when test="${sessionUser.role == 'ADMIN'}">수강중인 전체 과목</c:when>
                <c:otherwise>강의 과목</c:otherwise>
            </c:choose>
            <span>${semester} 학기</span>
        </div>

        <div class="course-grid">
            <c:choose>
                <c:when test="${not empty courseList}">
                    <c:forEach var="course" items="${courseList}">
                        <div class="course-card">
                            <c:choose>
                                <c:when test="${course.course_type eq 'MAJOR_REQUIRED'}">
                                    <c:set var="badgeText" value="전공필수" />
                                    <c:set var="badgeClass" value="badge-red" />
                                </c:when>
                                <c:when test="${course.course_type eq 'MAJOR_ELECTIVE'}">
                                    <c:set var="badgeText" value="전공선택" />
                                    <c:set var="badgeClass" value="badge-green" />
                                </c:when>
                                <c:when test="${course.course_type eq 'GENERAL_REQUIRED'}">
                                    <c:set var="badgeText" value="일반필수" />
                                    <c:set var="badgeClass" value="badge-yellow" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="badgeText" value="일반선택" />
                                    <c:set var="badgeClass" value="badge-blue" />
                                </c:otherwise>
                            </c:choose>

                            <span class="course-badge ${badgeClass}">${badgeText}</span>
                            <p class="course-name">${course.course_name}</p>

                            <div class="course-info-detail">
                                <c:choose>
                                    <c:when test="${sessionUser.role == 'PROFESSOR' || sessionUser.role == 'ADMIN'}">
                                        <p class="course-prof">강의실: ${course.room_info}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="course-prof">담당 교수: ${course.professor_name}</p>
                                    </c:otherwise>
                                </c:choose>
                                <p class="course-time">
                                    <i class="far fa-clock"></i>
                                        ${fn:substring(course.start_time, 0, 5)} ~ ${fn:substring(course.end_time, 0, 5)}
                                </p>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <c:choose>
                            <c:when test="${sessionUser.role == 'PROFESSOR'}">이번 학기에 담당하는 강의가 없습니다.</c:when>
                            <c:otherwise>현재 수강 중인 과목이 없습니다.</c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%-- 강의 통계 탭 (교수전용) --%>
    <c:if test="${sessionUser.role == 'PROFESSOR'}">
        <div id="tab-stats" class="tab-panel">
            <div class="section-title">담당 강의 성적 통계 <span>${semester} 학기</span></div>
            <table class="grade-table">
                <thead>
                <tr>
                    <th>과목명</th>
                    <th>수강인원</th>
                    <th>평균 점수</th>
                    <th>최고 / 최저</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty myGradeList}">
                        <c:forEach var="stat" items="${myGradeList}">
                            <tr>
                                <td>
                                    <div style="font-weight: bold; margin-bottom: 4px;">${stat.courseName}</div>
                                    <c:set var="gBadgeClass" value="badge-gray" />
                                    <c:set var="gBadgeText" value="교양" />
                                    <c:if test="${stat.courseType eq 'MAJOR_REQUIRED'}"><c:set var="gBadgeClass" value="badge-red" /><c:set var="gBadgeText" value="전공필수" /></c:if>
                                    <c:if test="${stat.courseType eq 'MAJOR_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-green" /><c:set var="gBadgeText" value="전공선택" /></c:if>
                                    <c:if test="${stat.courseType eq 'GENERAL_REQUIRED'}"><c:set var="gBadgeClass" value="badge-orange" /><c:set var="gBadgeText" value="일반필수" /></c:if>
                                    <c:if test="${stat.courseType eq 'GENERAL_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-gray" /><c:set var="gBadgeText" value="일반선택" /></c:if>
                                    <span class="grade-badge ${gBadgeClass}">${gBadgeText}</span>
                                </td>
                                <td>${stat.total_students}명</td>
                                <td style="font-weight: 700;">${stat.avg_score}점</td>
                                <td>
                                    <span style="color: #e74c3c; font-weight: bold;">${stat.max_score}</span> /
                                    <span style="color: #3498db; font-weight: bold;">${stat.min_score}</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="4" style="padding: 50px 0; color: #999;">통계 데이터가 없습니다.</td></tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </c:if>

    <%-- 성적 조회 탭 (학생 / 관리자용 통합) --%>
    <div id="tab-grades" class="tab-panel">
        <div class="section-title">
            <c:choose>
                <c:when test="${sessionUser.role == 'PROFESSOR'}">담당 강의 성적 내역</c:when>
                <c:when test="${sessionUser.role == 'ADMIN'}">전체 과목 성적 통계</c:when>
                <c:otherwise>나의 성적 내역</c:otherwise>
            </c:choose>
        </div>
        <table class="grade-table">
            <thead>
            <tr>
                <th>과목명</th>
                <c:choose>
                    <%-- 관리자 헤더: 중간/기말 평균을 각각 표시 --%>
                    <c:when test="${sessionUser.role == 'ADMIN'}">
                        <th>수강인원</th>
                        <th>중간 평균</th>
                        <th>기말 평균</th>
                        <th>최고 / 최저</th>
                    </c:when>
                    <%-- 교수 헤더 --%>
                    <c:when test="${sessionUser.role == 'PROFESSOR'}">
                        <th>수강인원</th>
                        <th>평균 점수</th>
                        <th>최고 / 최저</th>
                    </c:when>
                    <%-- 학생 헤더 --%>
                    <c:otherwise>
                        <th>구분</th>
                        <th>시험유형</th>
                        <th>점수</th>
                    </c:otherwise>
                </c:choose>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty myGradeList}">
                    <c:forEach var="grade" items="${myGradeList}">
                        <tr>
                            <td>
                                <div style="font-weight: bold; margin-bottom: 4px;">${grade.courseName}</div>
                                    <%-- badge 클래스/텍스트 설정 --%>
                                <c:set var="gBadgeClass" value="badge-gray" />
                                <c:set var="gBadgeText" value="${gTypeText}" />
                                <c:if test="${grade.courseType eq 'MAJOR_REQUIRED'}"><c:set var="gBadgeClass" value="badge-red" /><c:set var="gBadgeText" value="전공필수" /></c:if>
                                <c:if test="${grade.courseType eq 'MAJOR_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-green" /><c:set var="gBadgeText" value="전공선택" /></c:if>
                                <c:if test="${grade.courseType eq 'GENERAL_REQUIRED'}"><c:set var="gBadgeClass" value="badge-orange" /><c:set var="gBadgeText" value="일반필수" /></c:if>
                                <c:if test="${grade.courseType eq 'GENERAL_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-gray" /><c:set var="gBadgeText" value="일반선택" /></c:if>

                                <span class="grade-badge ${gBadgeClass}">${gBadgeText}</span>


                            </td>

                            <c:choose>
                                <c:when test="${sessionUser.role == 'ADMIN'}">
                                    <td>${grade.total_students}명</td>
                                    <td style="font-weight: 700; color: #4e73df;">${grade.mid_avg}점</td>
                                    <td style="font-weight: 700; color: #1cc88a;">${grade.final_avg}점</td>
                                    <td>
                                        <span style="color: #e74c3c; font-weight: bold;">${grade.max_score}</span> /
                                        <span style="color: #3498db; font-weight: bold;">${grade.min_score}</span>
                                    </td>
                                </c:when>
                                <c:when test="${sessionUser.role == 'PROFESSOR'}">
                                    <td>${grade.total_students}명</td>
                                    <td style="font-weight: 700;">${grade.avg_score}점</td>
                                    <td>
                                        <span style="color: #e74c3c; font-weight: bold;">${grade.max_score}</span> /
                                        <span style="color: #3498db; font-weight: bold;">${grade.min_score}</span>
                                    </td>
                                </c:when>
                                <c:otherwise>
                                    <td>
                            <span class="type-badge ${grade.examType eq 'MIDTERM' ? 'badge-indigo' : 'badge-purple'}">
                                    ${grade.examType eq 'MIDTERM' ? '중간고사' : '기말고사'}
                            </span>
                                    </td>
                                    <td style="font-weight: 700;">${grade.score}</td>
                                </c:otherwise>
                            </c:choose>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="${sessionUser.role == 'ADMIN' ? 5 : 4}" style="padding: 50px 0; color: #999;">조회된 내역이 없습니다.</td></tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <%-- 시간표 탭 --%>
    <c:if test="${sessionUser.role != 'ADMIN'}">
        <div id="tab-timetable" class="tab-panel">
            <div class="mp-tt-wrap">
                <div class="tt-grid-header">
                    <div></div>
                    <div class="tt-day">월</div>
                    <div class="tt-day">화</div>
                    <div class="tt-day">수</div>
                    <div class="tt-day">목</div>
                    <div class="tt-day">금</div>
                </div>
                <div class="tt-body" id="mpTimetableBody"></div>
            </div>
        </div>
    </c:if>
</div>

<script>
    function switchTab(tab) {
        document.querySelectorAll('.mypage-tab').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));

        document.getElementById('tab-' + tab).classList.add('active');
        event.currentTarget.classList.add('active');
    }

    /* ================================================================
   마이페이지 시간표 — 수강신청 데이터 연동
   기존 코드 수정 없음 / 변수명 MP_ 접두어로 충돌 방지
