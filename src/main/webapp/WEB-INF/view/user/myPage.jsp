<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            table-layout: fixed;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        .grade-table th,
        .grade-table td {
            text-align: center;
            vertical-align: middle;
            padding: 15px 10px;
            border-bottom: 1px solid #eee;
        }
        #tab-grades .grade-table th {
            padding: 8px 10px;
        }

        .grade-table thead tr {
            color: #ffffff;
        }

        .grade-table th:nth-child(1), .grade-table td:nth-child(1) { width: 25%; text-align: center; }
        .grade-table th:nth-child(2), .grade-table td:nth-child(2) { width: 14%; text-align: center; }
        .grade-table th:nth-child(3), .grade-table td:nth-child(3) { width: 12%; text-align: center; }
        .grade-table th:nth-child(4), .grade-table td:nth-child(4) { width: 12%; text-align: center; }
        .grade-table th:nth-child(5), .grade-table td:nth-child(5) { width: 10%; text-align: center; }
        .grade-table th:nth-child(6), .grade-table td:nth-child(6) { width: 12%; text-align: center; }
        .grade-table th:nth-child(7), .grade-table td:nth-child(7) { width: 12%; text-align: center; }

        .grade-table td {
            font-variant-numeric: tabular-nums;
        }

        /* 관리자 전용: 5컬럼 균등 분배 */
        .grade-table--admin th:nth-child(1),
        .grade-table--admin td:nth-child(1) { width: 30%; }

        .grade-table--admin th:nth-child(2),
        .grade-table--admin td:nth-child(2) { width: 15%; }

        .grade-table--admin th:nth-child(3),
        .grade-table--admin td:nth-child(3) { width: 20%; }

        .grade-table--admin th:nth-child(4),
        .grade-table--admin td:nth-child(4) { width: 20%; }

        .grade-table--admin th:nth-child(5),
        .grade-table--admin td:nth-child(5) { width: 11%; }

        /* --- 시간표 CSS --- */
        .mp-tt-wrap {
            width: 90%;
            margin: auto;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            overflow: hidden;
            padding: 12px;
            box-sizing: border-box;
        }

        .tt-grid-header {
            display: grid;
            grid-template-columns: 50px repeat(5, 1fr);
            gap: 3px;
            margin-bottom: 4px;
        }

        .tt-day {
            text-align: center;
            font-size: 14px;
            font-weight: 700;
            border-radius: 6px;
            color: #fff;
            background: #1E3A8A;
            min-height: 70px;
            height: 34px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .tt-body {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }

        .tt-row {
            display: grid;
            grid-template-columns: 50px repeat(5, 1fr);
            gap: 3px;
            min-height: 80px;
        }

        .tt-period {
            font-size: 10px;
            color: #888;
            font-weight: 600;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .tt-cell {
            border-radius: 5px; font-size: 14px; font-weight: 600; min-height: 70px;
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

        /* ================================================================
           빈 상태 (Empty State) 공통
           ================================================================ */
        .empty-state {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            padding: 3.5rem 1.5rem;
            min-height: 220px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            text-align: center;
            box-shadow: 0 2px 8px rgba(30, 58, 110, 0.05);
        }

        .empty-state-icon {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            border: 2px solid #bfdbfe;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            margin-bottom: 0.25rem;
        }

        .empty-state-text {
            font-size: 0.9rem;
            font-weight: 700;
            color: #475569;
        }

        .empty-state-sub {
            font-size: 0.75rem;
            color: #94a3b8;
            line-height: 1.6;
        }

        /* ── 성적 테이블 래퍼 ── */
        .grade-table-wrap {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(30, 58, 110, 0.05);
            margin-bottom: 1rem;
        }

        .grade-table-wrap .grade-table {
            border: none;
            box-shadow: none;
            border-radius: 0;
            margin-bottom: 0;
        }

        .grade-empty-body {
            padding: 3.5rem 1.5rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.65rem;
            text-align: center;
        }

        /* ── 시간표 빈 상태 ── */
        .tt-empty-body {
            padding: 3rem 1.5rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.65rem;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="mypage-wrap">
    <h2 class="mypage-title">마이페이지</h2>

    <div class="profile-card">
        <div class="profile-img-wrap">
            <c:choose>
                <c:when test="${not empty sessionUser.profileImg}">
                    <img src="${pageContext.request.contextPath}/upload/profiles/${sessionUser.profileImg}" alt="프로필 이미지" class="profile-img"/>
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/img/default-profile.png" alt="프로필 이미지" class="profile-img"/>
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
                    <td>${sessionUser.userId}</td>
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

        <div class="profile-actions">
            <a href="${pageContext.request.contextPath}/user/editProfile" class="btn-action btn-action-primary">회원정보 수정</a>
            <%--                <a href="${pageContext.request.contextPath}/user/updatePwForm" class="btn-action btn-action-outline">비밀번호 변경</a>--%>
        </div>
    </div>

    <%-- 비밀번호 변경 알림 모달 --%>
    <div id="pwAlertModal"
         style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.45); z-index:9999; justify-content:center; align-items:center;">
        <div style="background:#fff; border-radius:16px; padding:36px 40px; max-width:400px; width:90%; box-shadow:0 8px 32px rgba(0,0,0,0.2); text-align:center;">
            <div style="font-size:48px; margin-bottom:16px;">🔐</div>
            <h3 style="font-size:1.2rem; font-weight:700; color:#1e3a8a; margin-bottom:10px;">비밀번호 변경 안내</h3>
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
                       style="padding:10px 20px; background:#1e3a8a; border-radius:8px; font-size:0.78rem; font-weight:700; color:#fff; text-decoration:none; display:flex; align-items:center; white-space:nowrap;">
                        변경하기
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="mypage-tabs">
        <button class="mypage-tab active" onclick="switchTab('courses')">
            ${sessionUser.role == 'ADMIN' ? '전체 개설 과목' : (sessionUser.role == 'PROFESSOR' ? '강의 중인 과목' : '수강 중인 과목')}
        </button>

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

    <%-- =====================================================
         수강 / 강의 과목 탭
         ===================================================== --%>
    <div id="tab-courses" class="tab-panel active">
        <c:choose>
            <c:when test="${not empty courseList}">
                <div class="course-grid">
                    <c:forEach var="course" items="${courseList}">
                        <div class="course-card">
                            <c:choose>
                                <c:when test="${course.course_type eq 'MAJOR_REQUIRED'}">
                                    <c:set var="badgeText" value="전공필수"/>
                                    <c:set var="badgeClass" value="badge-red"/>
                                </c:when>
                                <c:when test="${course.course_type eq 'MAJOR_ELECTIVE'}">
                                    <c:set var="badgeText" value="전공선택"/>
                                    <c:set var="badgeClass" value="badge-green"/>
                                </c:when>
                                <c:when test="${course.course_type eq 'GENERAL_REQUIRED'}">
                                    <c:set var="badgeText" value="일반필수"/>
                                    <c:set var="badgeClass" value="badge-yellow"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="badgeText" value="일반선택"/>
                                    <c:set var="badgeClass" value="badge-blue"/>
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
                                    <i class="far fa-clock"></i> ${course.start_time} ~ ${course.end_time}
                                </p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">📚</div>
                    <p class="empty-state-text">
                        <c:choose>
                            <c:when test="${sessionUser.role == 'PROFESSOR'}">이번 학기에 담당하는 강의가 없습니다.</c:when>
                            <c:otherwise>현재 수강 중인 과목이 없습니다.</c:otherwise>
                        </c:choose>
                    </p>
                    <p class="empty-state-sub">수강 신청 기간에 과목을 등록해 주세요.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- =====================================================
         강의 통계 탭 (교수 전용)
         ===================================================== --%>
    <c:if test="${sessionUser.role == 'PROFESSOR'}">
        <div id="tab-stats" class="tab-panel">
            <c:choose>
                <c:when test="${not empty myGradeList}">
                    <div class="grade-table-wrap">
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
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grade-table-wrap">
                        <table class="grade-table">
                            <thead>
                            <tr>
                                <th>과목명</th>
                                <th>수강인원</th>
                                <th>평균 점수</th>
                                <th>최고 / 최저</th>
                            </tr>
                            </thead>
                        </table>
                        <div class="grade-empty-body">
                            <div class="empty-state-icon">📊</div>
                            <p class="empty-state-text">아직 등록된 통계 데이터가 없습니다.</p>
                            <p class="empty-state-sub">성적 입력 기간이 지나면 이곳에 통계가 표시됩니다.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <%-- =====================================================
         성적 조회 탭 (학생 / 관리자)
         ===================================================== --%>
    <div id="tab-grades" class="tab-panel">
        <c:choose>
            <c:when test="${not empty myGradeList}">
                <div class="grade-table-wrap">
                    <table class="grade-table ${sessionUser.role == 'ADMIN' ? 'grade-table--admin' : ''}">
                        <thead>
                        <tr>
                            <c:choose>
                                <c:when test="${sessionUser.role == 'ADMIN'}">
                                    <th>과목명</th>
                                    <th>수강인원</th>
                                    <th>중간 평균</th>
                                    <th>기말 평균</th>
                                    <th>최고 / 최저</th>
                                </c:when>
                                <c:when test="${sessionUser.role == 'PROFESSOR'}">
                                    <th>과목명</th>
                                    <th>수강인원</th>
                                    <th>평균 점수</th>
                                    <th>최고 / 최저</th>
                                </c:when>
                                <c:otherwise>
                                    <th>과목명</th>
                                    <th>구분</th>
                                    <th>중간고사</th>
                                    <th>기말고사</th>
                                    <th>출석</th>
                                    <th>총점</th>
                                    <th>학점</th>
                                </c:otherwise>
                            </c:choose>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${sessionUser.role == 'STUDENT'}">
                                <colgroup>
                                    <col style="width: 20%"> <%-- 과목명 --%>
                                    <col style="width: 10%"> <%-- 구분 --%>
                                    <col style="width: 16%"> <%-- 중간고사 --%>
                                    <col style="width: 16%"> <%-- 기말고사 --%>
                                    <col style="width: 16%"> <%-- 출석 --%>
                                    <col style="width: 16%"> <%-- 총점 --%>
                                    <col style="width: 16%"> <%-- 학점 --%>
                                </colgroup>
                                <c:forEach var="grade" items="${gradeRows}">
                                    <tr>
                                        <td>${grade.courseName}</td>
                                        <td>
                                            <c:set var="gBadgeClass" value="badge-gray" />
                                            <c:set var="gBadgeText" value="" />
                                            <c:if test="${grade.courseType eq 'MAJOR_REQUIRED'}"><c:set var="gBadgeClass" value="badge-red" /><c:set var="gBadgeText" value="전공필수" /></c:if>
                                            <c:if test="${grade.courseType eq 'MAJOR_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-green" /><c:set var="gBadgeText" value="전공선택" /></c:if>
                                            <c:if test="${grade.courseType eq 'GENERAL_REQUIRED'}"><c:set var="gBadgeClass" value="badge-orange" /><c:set var="gBadgeText" value="일반필수" /></c:if>
                                            <c:if test="${grade.courseType eq 'GENERAL_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-gray" /><c:set var="gBadgeText" value="일반선택" /></c:if>
                                            <span class="grade-badge ${gBadgeClass}">${gBadgeText}</span>
                                        </td>
                                        <td style="font-weight: 700;">${grade.midterm.score}</td>   <%-- 중간고사 --%>
                                        <td style="font-weight: 700;">${grade.finalExam.score}</td> <%-- 기말고사 --%>
                                        <td style="font-weight: 700;">${grade.attendance.score}</td><%-- 출석 --%>
                                        <td style="font-weight: 700;"> ${grade.midterm.score + grade.finalExam.score + grade.attendance.score}</td><%-- 출석 --%>
                                        <td style="font-weight: 700;">${grade.midterm.alphabet}</td><%-- 학점 --%>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <c:forEach var="grade" items="${myGradeList}">
                                    <tr>
                                        <td>
                                            <div style="font-weight: bold; margin-bottom: 4px;">${grade.courseName}</div>
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
                                        </c:choose>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">🎓</div>
                    <p class="empty-state-text">아직 등록된 성적이 없습니다.</p>
                    <p class="empty-state-sub">성적 입력 기간이 지나면<br>이곳에 성적이 표시됩니다.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- =====================================================
         시간표 탭
         ===================================================== --%>
    <c:if test="${sessionUser.role != 'ADMIN'}">
        <div id="tab-timetable" class="tab-panel">
            <div class="mp-tt-wrap">
                <div id="mpTimetableHeader" class="tt-grid-header">
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

    var MP_CTX      = '${pageContext.request.contextPath}';
    var MP_ROLE     = '${sessionUser.role}';
    var MP_SEMESTER = '${semester}';
    var mp_courses  = [];

    var MP_COLORS = ['mp-c1', 'mp-c2', 'mp-c3', 'mp-c4', 'mp-c5'];
    var MP_DAYS   = ['월', '화', '수', '목', '금'];

    function mpParseDays(str) {
        return str ? str.split(',').map(function(d){ return d.replace(/요일/, '').trim(); }) : [];
    }
    function mpParseHour(t) {
        return t ? parseInt(t.split(':')[0]) : -1;
    }

    function renderMpTimetable() {
        var header = document.getElementById('mpTimetableHeader');
        var body   = document.getElementById('mpTimetableBody');
        body.innerHTML = '';

        var wrap = document.querySelector('.mp-tt-wrap');

        /* ── 과목 없을 때: wrap 스타일 제거 + empty-state 통일 ── */
        if (!mp_courses.length) {
            header.style.display  = 'none';
            wrap.style.width      = '100%';
            wrap.style.background = 'transparent';
            wrap.style.border     = 'none';
            wrap.style.padding    = '0';
            wrap.style.boxShadow  = 'none';
            body.style.display    = 'block';
            body.innerHTML =
                '<div class="empty-state">' +
                '  <div class="empty-state-icon">🗓️</div>' +
                '  <p class="empty-state-text">등록된 시간표가 없습니다.</p>' +
                '  <p class="empty-state-sub">수강 신청 후 시간표가 자동으로 표시됩니다.</p>' +
                '</div>';
            return;
        }

        /* 과목 있을 때: wrap 스타일 복원 + 헤더 복원 */
        header.style.display  = '';
        wrap.style.width      = '';
        wrap.style.background = '';
        wrap.style.border     = '';
        wrap.style.padding    = '';
        wrap.style.boxShadow  = '';

        body.style.display = 'grid';
        body.style.gridTemplateColumns = '50px repeat(5, 1fr)';
        body.style.gap = '3px';

        var DAY_COL  = {'월': 2, '화': 3, '수': 4, '목': 5, '금': 6};
        var DAY_KEYS = ['월', '화', '수', '목', '금'];

        var colorMap = {};
        mp_courses.forEach(function(c, i) {
            colorMap[c.course_no] = MP_COLORS[i % MP_COLORS.length];
        });

        var minH = 9, maxH = 18;
        mp_courses.forEach(function(c) {
            var sh = mpParseHour(c.start_time);
            var eh = mpParseHour(c.end_time);
            if (sh > 0) minH = Math.min(minH, sh);
            if (eh > 0) maxH = Math.max(maxH, eh);
        });

        for (var h = minH; h < maxH; h++) {
            var rowIdx = h - minH + 1;
            var period = h - minH + 1;

            var timeCell = document.createElement('div');
            timeCell.className = 'tt-period';
            timeCell.style.gridColumn = '1';
            timeCell.style.gridRow = String(rowIdx);
            timeCell.innerHTML =
                '<span style="font-size:12px;font-weight:700;color:#444;display:block;">' + period + '교시</span>' +
                '<span style="font-size:10px;font-weight:400;color:#888;">' + String(h).padStart(2,'0') + ':00</span>';
            body.appendChild(timeCell);

            DAY_KEYS.forEach(function(day, di) {
                var occupied = mp_courses.some(function(c) {
                    var days = mpParseDays(c.day_of_week);
                    var sh = mpParseHour(c.start_time);
                    var eh = mpParseHour(c.end_time);
                    return days.indexOf(day) !== -1 && sh <= h && h < eh;
                });
                if (!occupied) {
                    var empty = document.createElement('div');
                    empty.className = 'tt-cell empty';
                    empty.style.gridColumn = String(di + 2);
                    empty.style.gridRow = String(rowIdx);
                    body.appendChild(empty);
                }
            });
        }

        mp_courses.forEach(function(c) {
            var days = mpParseDays(c.day_of_week);
            var sh   = mpParseHour(c.start_time);
            var eh   = mpParseHour(c.end_time);
            var span = eh - sh;
            var rowStart = sh - minH + 1;

            days.forEach(function(day) {
                var colIdx = DAY_COL[day];
                if (!colIdx) return;
                var cell = document.createElement('div');
                cell.className = 'tt-cell ' + colorMap[c.course_no];
                cell.style.gridColumn = String(colIdx);
                cell.style.gridRow = rowStart + ' / span ' + span;
                cell.innerHTML = c.course_name + '<br>' + (c.room_info || '');
                body.appendChild(cell);
            });
        });
    }

    function loadMpTimetable() {
        var endpoint = MP_ROLE === 'PROFESSOR'
            ? MP_CTX + '/enrollment/my-courses?semester=' + MP_SEMESTER
            : MP_CTX + '/enrollment/mine?semester=' + MP_SEMESTER;
        fetch(endpoint, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                mp_courses = data.courses || [];
                renderMpTimetable();
            })
            .catch(function() {
                mp_courses = [];
                renderMpTimetable();
            });
    }

    window.addEventListener('DOMContentLoaded', function() {
        if (MP_ROLE === 'ADMIN') {
            document.querySelector('.mypage-tabs').classList.add('mp-tabs-full');
        } else {
            loadMpTimetable();
        }
    });

    window.addEventListener('DOMContentLoaded', function() {
        var lastChanged = '${sessionUser.last_password_changed}';
        var userId = '${sessionUser.userId}';
        var skipKey = 'pwAlertSkipUntil_' + userId;  // 계정별 키

        if (!lastChanged || lastChanged === 'null' || lastChanged.trim() === '') return;

        var pwDays = Math.floor((new Date() - new Date(lastChanged)) / (1000 * 60 * 60 * 24));
        if (isNaN(pwDays)) return;

        if (pwDays >= 90) {
            var skipUntil = localStorage.getItem(skipKey);
            if (skipUntil && new Date() < new Date(skipUntil)) return;  // 스킵 기간이면 안 띄움
            document.getElementById('pwDayCount').textContent = pwDays;
            document.getElementById('pwAlertModal').style.display = 'flex';
        }
    });

    function skipPwAlert() {
        var userId = '${sessionUser.userId}';
        var skipKey = 'pwAlertSkipUntil_' + userId;
        var skipDate = new Date();
        skipDate.setDate(skipDate.getDate() + 7);
        localStorage.setItem(skipKey, skipDate.toISOString());
        document.getElementById('pwAlertModal').style.display = 'none';
    }

    function closeModal() {
        var userId = '${sessionUser.userId}';
        var skipKey = 'pwAlertSkipUntil_' + userId;
        var checked = document.getElementById('skipCheck').checked;
        if (checked) {
            var skipDate = new Date();
            skipDate.setDate(skipDate.getDate() + 90);
            localStorage.setItem(skipKey, skipDate.toISOString());
        }
        document.getElementById('pwAlertModal').style.display = 'none';
    }
</script>
</body>
</html>
