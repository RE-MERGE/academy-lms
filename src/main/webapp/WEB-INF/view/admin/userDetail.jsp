<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/myPage.css">
    <style>
        .grade-badge, .course-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            margin-top: 4px;
        }
        .badge-orange {
            background-color: #fff3cd;
            color: #e67e22;
            border: 1px solid #e67e22;
        }
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
            font-variant-numeric: tabular-nums;
        }
        .grade-table thead tr { color: #ffffff; }
        .grade-table th:nth-child(1), .grade-table td:nth-child(1) { width: 25%; }
        .grade-table th:nth-child(2), .grade-table td:nth-child(2) { width: 14%; }
        .grade-table th:nth-child(3), .grade-table td:nth-child(3) { width: 12%; }
        .grade-table th:nth-child(4), .grade-table td:nth-child(4) { width: 12%; }
        .grade-table th:nth-child(5), .grade-table td:nth-child(5) { width: 10%; }
        .grade-table th:nth-child(6), .grade-table td:nth-child(6) { width: 12%; }
        .grade-table th:nth-child(7), .grade-table td:nth-child(7) { width: 12%; }
        /* 관리자 전용: 6컬럼 */
        .grade-table--admin th:nth-child(1), .grade-table--admin td:nth-child(1) { width: 30%; }
        .grade-table--admin th:nth-child(2), .grade-table--admin td:nth-child(2) { width: 15%; }
        .grade-table--admin th:nth-child(3), .grade-table--admin td:nth-child(3) { width: 15%; }
        .grade-table--admin th:nth-child(4), .grade-table--admin td:nth-child(4) { width: 15%; }
        .grade-table--admin th:nth-child(5), .grade-table--admin td:nth-child(5) { width: 15%; }
        .grade-table--admin th:nth-child(6), .grade-table--admin td:nth-child(6) { width: 10%; }
        /* 교수 전용: 5컬럼 */
        .grade-table--professor th:nth-child(1), .grade-table--professor td:nth-child(1) { width: 30%; }
        .grade-table--professor th:nth-child(2), .grade-table--professor td:nth-child(2) { width: 15%; }
        .grade-table--professor th:nth-child(3), .grade-table--professor td:nth-child(3) { width: 15%; }
        .grade-table--professor th:nth-child(4), .grade-table--professor td:nth-child(4) { width: 25%; }
        .grade-table--professor th:nth-child(5), .grade-table--professor td:nth-child(5) { width: 15%; }
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
        .empty-state-text { font-size: 0.9rem; font-weight: 700; color: #475569; }
        .empty-state-sub { font-size: 0.75rem; color: #94a3b8; line-height: 1.6; }
        .mp-tt-wrap {
            width: 90%; margin: auto; background: #fff;
            border: 1px solid #ddd; border-radius: 10px;
            overflow: hidden; padding: 12px; box-sizing: border-box;
        }
        .tt-grid-header { display: grid; grid-template-columns: 50px repeat(5, 1fr); gap: 3px; margin-bottom: 4px; }
        .tt-day {
            text-align: center; font-size: 14px; font-weight: 700;
            border-radius: 6px; color: #fff; background: #1E3A8A;
            height: 34px; display: flex; align-items: center; justify-content: center;
        }
        .tt-body { display: flex; flex-direction: column; gap: 3px; }
        .tt-row { display: grid; grid-template-columns: 50px repeat(5, 1fr); gap: 3px; min-height: 80px; }
        .tt-period { font-size: 10px; color: #888; font-weight: 600; display: flex; flex-direction: column; align-items: center; justify-content: center; }
        .tt-cell {
            border-radius: 5px; font-size: 14px; font-weight: 600; min-height: 70px;
            display: flex; align-items: center; justify-content: center;
            text-align: center; line-height: 1.3; padding: 4px 2px; color: #fff;
        }
        .tt-cell.empty {
            background: #f1f5f9;
            min-height: 80px; /* 추가 */
        }
        .mp-c1 { background: #AEE2FF; color: #0369a1; border: 1.5px solid #0369a1; }
        .mp-c2 { background: #FFCEEE; color: #be185d; border: 1.5px solid #be185d; }
        .mp-c3 { background: #FFF6D2; color: #a16207; border: 1.5px solid #a16207; }
        .mp-c4 { background: #DED9FF; color: #5b21b6; border: 1.5px solid #5b21b6; }
        .mp-c5 { background: #D6FFDE; color: #166534; border: 1.5px solid #166534; }
        .mp-tabs-full .mypage-tab { flex: 1; text-align: center; }
        .tt-empty-body { padding: 3rem 1.5rem; display: flex; flex-direction: column; align-items: center; gap: 0.65rem; text-align: center; }

        .grade-table th:nth-child(1), .grade-table td:nth-child(1) { width: 25%; text-align: center; }
        .grade-table th:nth-child(2), .grade-table td:nth-child(2) { width: 14%; text-align: center; }
        .grade-table th:nth-child(3), .grade-table td:nth-child(3) { width: 12%; text-align: center; }
        .grade-table th:nth-child(4), .grade-table td:nth-child(4) { width: 12%; text-align: center; }
        .grade-table th:nth-child(5), .grade-table td:nth-child(5) { width: 10%; text-align: center; }
        .grade-table th:nth-child(6), .grade-table td:nth-child(6) { width: 12%; text-align: center; }
        .grade-table th:nth-child(7), .grade-table td:nth-child(7) { width: 12%; text-align: center; }

        .tt-body {
            display: grid;
            grid-template-columns: 50px repeat(5, 1fr);
            grid-auto-rows: 80px;
            gap: 3px;
        }
    </style>
</head>
<body>
<div class="mypage-wrap">
    <h2 class="mypage-title">마이페이지</h2>

    <!-- 프로필 카드 -->
    <div class="profile-card">
        <div class="profile-img-wrap">
            <c:choose>
                <c:when test="${not empty userDetail.currentProfileImg}">
                    <img src="${userDetail.currentProfileImg}"
                         class="profile-img"
                         onerror="this.src='${pageContext.request.contextPath}/img/default-profile.png'"/>
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/img/default-profile.png" class="profile-img"/>
                </c:otherwise>
            </c:choose>
            <span class="profile-status">재학중</span>
        </div>
        <div class="profile-info">
            <p class="profile-name">${userDetail.name}</p>
            <c:if test="${userDetail.role == 'STUDENT'}">
                <p class="profile-dept">에너지공학과</p>
            </c:if>
            <table class="profile-table">
                <tr><th>학번</th><td>${userDetail.userCode}</td></tr>
                <tr><th>아이디</th><td>${userDetail.displayUserId}</td></tr>
                <tr><th>이메일</th><td>${userDetail.email}</td></tr>
                <tr>
                    <th>역할</th>
                    <td>
                        <c:choose>
                            <c:when test="${userDetail.role == 'STUDENT'}">학생</c:when>
                            <c:when test="${userDetail.role == 'PROFESSOR'}">교수</c:when>
                            <c:otherwise>관리자</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr><th>연락처</th><td>${userDetail.phone}</td></tr>
                <tr>
                    <th>상태</th>
                    <td>
                        <c:choose>
                            <c:when test="${userDetail.status eq 'ACTIVE'}"><span class="status-active">활동</span></c:when>
                            <c:when test="${userDetail.status eq 'INACTIVE'}"><span class="status-active">휴면</span></c:when>
                            <c:when test="${userDetail.status eq 'LOCKED'}"><span class="status-active">정지</span></c:when>
                            <c:when test="${userDetail.status eq 'PENDING'}"><span class="status-active">대기</span></c:when>
                            <c:when test="${userDetail.status eq 'DELETE'}"><span class="status-active">탈퇴</span></c:when>
                            <c:otherwise>${userDetail.status}</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>회원 가입일</th>
                    <td>
                        <fmt:parseDate value="${userDetail.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCreatedAt" type="both"/>
                        <fmt:formatDate value="${parsedCreatedAt}" pattern="yyyy년 M월 d일 E요일"/>
                    </td>
                </tr>
                <tr>
                    <th>마지막 접속일</th>
                    <td>
                        <fmt:parseDate value="${userDetail.lastLoginDate}" pattern="yyyy-MM-dd" var="parsedLastLogin" type="date"/>
                        <fmt:formatDate value="${parsedLastLogin}" pattern="yyyy년 M월 d일 E요일"/>
                    </td>
                </tr>
                <tr><th>로그인 실패 횟수</th><td>${userDetail.lockCount} 회</td></tr>
            </table>
        </div>
        <div class="profile-actions">
            <a href="${pageContext.request.contextPath}/admin/editProfileForAdmin/${userDetail.userNo}"
               class="btn-action btn-action-primary">회원정보 수정</a>
            <%--            <a href="${pageContext.request.contextPath}/admin/updatePwForm/${userDetail.userNo}"--%>
            <%--               class="btn-action btn-action-outline">비밀번호 변경</a>--%>
        </div>
    </div>

    <!-- 탭 네비게이션 -->
    <div class="mypage-tabs">
        <button class="mypage-tab active" onclick="switchTab('courses')">
            ${userDetail.role == 'ADMIN' ? '전체 개설 과목'
                    : userDetail.role == 'PROFESSOR' ? '강의 중인 과목'
                    : '수강 중인 과목'}
        </button>
        <c:choose>
            <c:when test="${userDetail.role == 'PROFESSOR'}">
                <button class="mypage-tab" onclick="switchTab('stats')">강의 통계</button>
            </c:when>
            <c:otherwise>
                <button class="mypage-tab" onclick="switchTab('grades')">성적 조회</button>
            </c:otherwise>
        </c:choose>
        <c:if test="${userDetail.role != 'ADMIN'}">
            <button class="mypage-tab" onclick="switchTab('timetable')">시간표</button>
        </c:if>
    </div>

    <!-- 탭 1: 수강/강의 과목 -->
    <div id="tab-courses" class="tab-panel active">
        <c:choose>
            <c:when test="${not empty courseList}">
                <div class="course-grid">
                    <c:forEach var="course" items="${courseList}">
                        <div class="course-card">
                            <c:choose>
                                <c:when test="${course.course_type eq 'MAJOR_REQUIRED'}"><c:set var="badgeText" value="전공필수"/><c:set var="badgeClass" value="badge-red"/></c:when>
                                <c:when test="${course.course_type eq 'MAJOR_ELECTIVE'}"><c:set var="badgeText" value="전공선택"/><c:set var="badgeClass" value="badge-green"/></c:when>
                                <c:when test="${course.course_type eq 'GENERAL_REQUIRED'}"><c:set var="badgeText" value="일반필수"/><c:set var="badgeClass" value="badge-orange"/></c:when>
                                <c:when test="${course.course_type eq 'GENERAL_ELECTIVE'}"><c:set var="badgeText" value="일반선택"/><c:set var="badgeClass" value="badge-gray"/></c:when>
                                <c:when test="${course.course_type eq 'FREE_ELECTIVE'}"><c:set var="badgeText" value="자율선택"/><c:set var="badgeClass" value="badge-yellow"/></c:when>
                                <c:otherwise><c:set var="badgeText" value="일반선택"/><c:set var="badgeClass" value="badge-blue"/></c:otherwise>
                            </c:choose>
                            <span class="course-badge ${badgeClass}">${badgeText}</span>
                            <p class="course-name">${course.course_name}</p>
                            <div class="course-info-detail">
                                <c:choose>
                                    <c:when test="${userDetail.role == 'PROFESSOR' || userDetail.role == 'ADMIN'}">
                                        <p class="course-prof">강의실: ${course.room_info}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="course-prof">담당 교수: ${course.professor_name}</p>
                                    </c:otherwise>
                                </c:choose>
                                <p class="course-time"><i class="far fa-clock"></i> ${course.start_time} ~ ${course.end_time}</p>
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
                            <c:when test="${userDetail.role == 'PROFESSOR'}">이번 학기에 담당하는 강의가 없습니다.</c:when>
                            <c:otherwise>현재 수강 중인 과목이 없습니다.</c:otherwise>
                        </c:choose>
                    </p>
                    <p class="empty-state-sub">수강 신청 기간에 과목을 등록해 주세요.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 탭 2: 강의 통계 (교수 전용) -->
    <c:if test="${userDetail.role == 'PROFESSOR'}">
        <div id="tab-stats" class="tab-panel">
            <c:choose>
                <c:when test="${not empty myGradeList}">
                    <div class="grade-table-wrap">
                        <table class="grade-table">
                            <thead>
                            <tr>
                                <th>과목명</th>
                                <th>구분</th>
                                <th>수강인원</th>
                                <th>평균 점수</th>
                                <th>최고 / 최저</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="stat" items="${myGradeList}">
                                <tr>
                                    <td><div style="font-weight:bold; margin-bottom:4px;">${stat.courseName}</div></td>
                                    <td>
                                        <c:set var="gBadgeClass" value="badge-gray"/><c:set var="gBadgeText" value="교양"/>
                                        <c:if test="${stat.courseType eq 'MAJOR_REQUIRED'}"><c:set var="gBadgeClass" value="badge-red"/><c:set var="gBadgeText" value="전공필수"/></c:if>
                                        <c:if test="${stat.courseType eq 'MAJOR_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-green"/><c:set var="gBadgeText" value="전공선택"/></c:if>
                                        <c:if test="${stat.courseType eq 'GENERAL_REQUIRED'}"><c:set var="gBadgeClass" value="badge-orange"/><c:set var="gBadgeText" value="일반필수"/></c:if>
                                        <c:if test="${stat.courseType eq 'GENERAL_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-gray"/><c:set var="gBadgeText" value="일반선택"/></c:if>
                                        <span class="grade-badge ${gBadgeClass}">${gBadgeText}</span>
                                    </td>
                                    <td>${stat.total_students}명</td>
                                    <td style="font-weight:700;">${stat.avg_score}점</td>
                                    <td>
                                        <span style="color:#e74c3c; font-weight:bold;">${stat.max_score}</span> /
                                        <span style="color:#3498db; font-weight:bold;">${stat.min_score}</span>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grade-table-wrap">
                        <table class="grade-table grade-table--professor">
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

    <!-- 탭 3: 성적 조회 (학생/관리자) -->
    <c:if test="${userDetail.role != 'PROFESSOR'}">
        <div id="tab-grades" class="tab-panel">
            <c:choose>
                <c:when test="${not empty myGradeList}">
                    <div class="grade-table-wrap">
                        <table class="grade-table ${userDetail.role == 'ADMIN' ? 'grade-table--admin' : ''}">
                            <thead>
                            <tr>
                                <th>과목명</th>
                                <th>구분</th>
                                <c:choose>
                                    <c:when test="${userDetail.role == 'ADMIN'}">
                                        <th>수강인원</th>
                                        <th>중간 평균</th>
                                        <th>기말 평균</th>
                                        <th>최고 / 최저</th>
                                    </c:when>
                                    <c:otherwise>
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
                            <c:when test="${userDetail.role == 'STUDENT'}">
                                <c:forEach var="grade" items="${gradeRows}">
                                    <tr>
                                        <td>${grade.courseName}</td>
                                        <td>
                                            <c:set var="gBadgeClass" value="badge-gray"/><c:set var="gBadgeText" value=""/>
                                            <c:if test="${grade.courseType eq 'MAJOR_REQUIRED'}"><c:set var="gBadgeClass" value="badge-red"/><c:set var="gBadgeText" value="전공필수"/></c:if>
                                            <c:if test="${grade.courseType eq 'MAJOR_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-green"/><c:set var="gBadgeText" value="전공선택"/></c:if>
                                            <c:if test="${grade.courseType eq 'GENERAL_REQUIRED'}"><c:set var="gBadgeClass" value="badge-orange"/><c:set var="gBadgeText" value="일반필수"/></c:if>
                                            <c:if test="${grade.courseType eq 'GENERAL_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-gray"/><c:set var="gBadgeText" value="일반선택"/></c:if>
                                            <span class="grade-badge ${gBadgeClass}">${gBadgeText}</span>
                                        </td>
                                        <td style="font-weight:700;">${grade.midterm.score}</td>
                                        <td style="font-weight:700;">${grade.finalExam.score}</td>
                                        <td style="font-weight:700;">${grade.attendance.score}</td>
                                        <td style="font-weight:700;">${grade.midterm.score + grade.finalExam.score + grade.attendance.score}</td>
                                        <td style="font-weight:700;">${grade.midterm.alphabet}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                            <c:forEach var="grade" items="${myGradeList}">
                            <tr>
                                <td><div style="font-weight:bold; margin-bottom:4px;">${grade.courseName}</div></td>
                                <td>
                                    <c:set var="gBadgeClass" value="badge-gray"/><c:set var="gBadgeText" value=""/>
                                    <c:if test="${grade.courseType eq 'MAJOR_REQUIRED'}"><c:set var="gBadgeClass" value="badge-red"/><c:set var="gBadgeText" value="전공필수"/></c:if>
                                    <c:if test="${grade.courseType eq 'MAJOR_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-green"/><c:set var="gBadgeText" value="전공선택"/></c:if>
                                    <c:if test="${grade.courseType eq 'GENERAL_REQUIRED'}"><c:set var="gBadgeClass" value="badge-orange"/><c:set var="gBadgeText" value="일반필수"/></c:if>
                                    <c:if test="${grade.courseType eq 'GENERAL_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-gray"/><c:set var="gBadgeText" value="일반선택"/></c:if>
                                    <span class="grade-badge ${gBadgeClass}">${gBadgeText}</span>
                                </td>
                                <td>${grade.total_students}명</td>
                                <td style="font-weight:700; color:#4e73df;">${grade.mid_avg}점</td>
                                <td style="font-weight:700; color:#1cc88a;">${grade.final_avg}점</td>
                                <td>
                                    <span style="color:#e74c3c; font-weight:bold;">${grade.max_score}</span> /
                                    <span style="color:#3498db; font-weight:bold;">${grade.min_score}</span>
                                </td>
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
    </c:if>

    <c:if test="${userDetail.role != 'ADMIN'}">
    <div id="tab-timetable" class="tab-panel">
        <c:choose>
        <c:when test="${not empty timetable.cells}">
        <div class="mp-tt-wrap">
            <div style="display:grid; grid-template-columns: 50px repeat(5, 1fr); gap:3px; margin-bottom:3px;">
                <div></div>
                <div class="tt-day">월</div>
                <div class="tt-day">화</div>
                <div class="tt-day">수</div>
                <div class="tt-day">목</div>
                <div class="tt-day">금</div>
            </div>

            <div style="display:flex; gap:3px;">
                    <%-- 시간 라벨 --%>
                <div style="display:flex; flex-direction:column; width:50px; flex-shrink:0; gap:3px;">
                    <c:forEach begin="${timetable.minHour}" end="${timetable.maxHour}" var="h">
                        <div style="height:80px; min-height:80px; box-sizing:border-box; display:flex; flex-direction:column; align-items:center; justify-content:center;">
                            <span style="font-size:12px; font-weight:700; color:#444; display:block;">${h - timetable.minHour + 1}교시</span>
                            <span style="font-size:10px; color:#888;">${h}:00</span>
                        </div>
                    </c:forEach>
                </div>

                    <%-- 빈 셀 --%>
                <div style="flex:1; display:grid; grid-template-columns: repeat(5, 1fr); grid-template-rows: repeat(9, 80px); grid-auto-rows: 0; gap:3px; overflow:hidden;">
                    <c:forEach begin="1" end="45" var="i">
                        <div class="tt-cell empty"></div>
                    </c:forEach>

                        <%-- 과목 셀 --%>
                    <c:forEach var="cell" items="${timetable.cells}" varStatus="vs">
                        <div class="tt-cell mp-c${(vs.index % 5) + 1}"
                             style="grid-column:${cell.colIndex}; grid-row:${cell.rowStart} / span ${cell.rowSpan}; z-index:1;">
                                ${cell.courseName}<br>${cell.roomInfo}
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>
</c:when>
<c:otherwise>
    <div class="empty-state">
        <div class="empty-state-icon">🗓️</div>
        <p class="empty-state-text">등록된 시간표가 없습니다.</p>
        <p class="empty-state-sub">수강 신청 후 시간표가 자동으로 표시됩니다.</p>
    </div>
</c:otherwise>
</c:choose>
</div>
</c:if>

<script>
    function switchTab(tab) {
        document.querySelectorAll('.mypage-tab').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.getElementById('tab-' + tab).classList.add('active');
        event.currentTarget.classList.add('active');
    }

    window.addEventListener('DOMContentLoaded', () => {
        if ('${userDetail.role}' === 'ADMIN') {
            document.querySelector('.mypage-tabs').classList.add('mp-tabs-full');
        }
        // 비밀번호 변경 알림
        var pwDays = Math.floor((new Date() - new Date('${userDetail.last_password_changed}')) / 86400000);
        if (pwDays >= 90) {
            var skipUntil = localStorage.getItem('pwAlertSkipUntil');
            if (skipUntil && new Date() < new Date(skipUntil)) return;
            document.getElementById('pwDayCount').textContent = pwDays;
            document.getElementById('pwAlertModal').style.display = 'flex';
        }
    });

    function skipPwAlert() {
        var d = new Date();
        d.setDate(d.getDate() + 7);
        localStorage.setItem('pwAlertSkipUntil', d.toISOString());
        document.getElementById('pwAlertModal').style.display = 'none';
    }

    function closeModal() {
        if (document.getElementById('skipCheck').checked) {
            var d = new Date();
            d.setDate(d.getDate() + 90);
            localStorage.setItem('pwAlertSkipUntil', d.toISOString());
        }
        document.getElementById('pwAlertModal').style.display = 'none';
    }
</script>
</body>
</html>