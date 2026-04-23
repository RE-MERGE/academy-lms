<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                    <img src="${pageContext.request.contextPath}/img/default-profile3.png" alt="프로필 이미지" class="profile-img"/>
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
            <a href="${pageContext.request.contextPath}/user/updatePwForm" class="btn-action btn-action-outline">비밀번호 변경</a>
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

        <button class="mypage-tab" onclick="switchTab('timetable')">시간표</button>
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
                                    <i class="far fa-clock"></i> ${course.start_time} ~ ${course.end_time}
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
                                <td>${stat.courseName}</td>
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
                                ${grade.courseName}
                                <c:if test="${sessionUser.role == 'ADMIN'}">
                                    <br><small style="color: #888;">(${grade.courseType})</small>
                                </c:if>
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
                                <%-- 교수 데이터 --%>
                                <c:when test="${sessionUser.role == 'PROFESSOR'}">
                                    <td>${grade.total_students}명</td>
                                    <td style="font-weight: 700;">${grade.avg_score}점</td>
                                    <td>
                                        <span style="color: #e74c3c; font-weight: bold;">${grade.max_score}</span> /
                                        <span style="color: #3498db; font-weight: bold;">${grade.min_score}</span>
                                    </td>
                                </c:when>
                                <%-- 학생 데이터 --%>
                                <c:otherwise>
                                    <td>
                                        <c:set var="gBadgeClass" value="badge-gray" />
                                        <c:set var="gBadgeText" value="${grade.courseType}" />
                                        <c:if test="${grade.courseType eq 'MAJOR_REQUIRED'}"><c:set var="gBadgeClass" value="badge-red" /><c:set var="gBadgeText" value="전공필수" /></c:if>
                                        <c:if test="${grade.courseType eq 'MAJOR_ELECTIVE'}"><c:set var="gBadgeClass" value="badge-green" /><c:set var="gBadgeText" value="전공선택" /></c:if>
                                        <span class="grade-badge ${gBadgeClass}">${gBadgeText}</span>
                                    </td>
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
                    <%-- 관리자일 경우 5열이므로 colspan="5" 처리 --%>
                    <tr><td colspan="${sessionUser.role == 'ADMIN' ? 5 : 4}" style="padding: 50px 0; color: #999;">조회된 내역이 없습니다.</td></tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <%-- 시간표 탭 --%>
    <div id="tab-timetable" class="tab-panel">
        <div class="timetable">
            <div class="timetable-header">
                <div>시간</div>
                <div>월</div>
                <div>화</div>
                <div>수</div>
                <div>목</div>
                <div>금</div>
            </div>
            <div class="timetable-row">
                <div class="timetable-time">09:00</div>
                <div class="timetable-cell"><div class="timetable-subject subject-amber">공학수학<br>공학관 101</div></div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell"><div class="timetable-subject subject-amber">공학수학<br>공학관 101</div></div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell"><div class="timetable-subject subject-amber">공학수학<br>공학관 101</div></div>
            </div>
            <div class="timetable-row">
                <div class="timetable-time">10:00</div>
                <div class="timetable-cell"><div class="timetable-subject subject-blue">운영체제<br>IT관 203</div></div>
                <div class="timetable-cell"><div class="timetable-subject subject-purple">소프트웨어공학<br>공학관 305</div></div>
                <div class="timetable-cell"><div class="timetable-subject subject-blue">운영체제<br>IT관 203</div></div>
                <div class="timetable-cell"><div class="timetable-subject subject-purple">소프트웨어공학<br>공학관 305</div></div>
                <div class="timetable-cell"></div>
            </div>
            <div class="timetable-row">
                <div class="timetable-time">13:00</div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell"><div class="timetable-subject subject-green">데이터베이스<br>IT관 401</div></div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell"><div class="timetable-subject subject-green">데이터베이스<br>IT관 401</div></div>
                <div class="timetable-cell"></div>
            </div>
            <div class="timetable-row">
                <div class="timetable-time">14:00</div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell"><div class="timetable-subject subject-rose">컴퓨터네트워크<br>IT관 202</div></div>
            </div>
        </div>
    </div>
</div>

<script>
    function switchTab(tab) {
        document.querySelectorAll('.mypage-tab').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));

        document.getElementById('tab-' + tab).classList.add('active');
        event.currentTarget.classList.add('active');
    }
</script>
</body>
</html>