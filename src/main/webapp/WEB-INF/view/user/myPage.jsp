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
</head>
<body>

<div class="mypage-wrap">

    <h2 class="mypage-title">마이페이지</h2>

    <!-- ── 프로필 카드 ── -->
    <div class="profile-card">

        <!-- 프로필 이미지 -->
       <div class="profile-img-wrap">
    <c:choose>
        <c:when test="${not empty sessionUser.profileImg}">
            <img src="${pageContext.request.contextPath}/upload/profiles/${sessionUser.profileImg}"
                 alt="프로필 이미지" class="profile-img"/>
        </c:when>
        <c:otherwise>
            <img src="${pageContext.request.contextPath}/img/default-profile3.png"
                 alt="프로필 이미지" class="profile-img"/>
        </c:otherwise>
    	</c:choose>
   	 	<span class="profile-status">재학중</span>
		</div>

        <!-- 프로필 정보 -->
        <div class="profile-info">
            <p class="profile-name">${sessionUser.name}</p>
            <p class="profile-dept">컴퓨터공학과 · 3학년</p>

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

        <!-- 액션 버튼 -->
        <div class="profile-actions">
            <a href="${pageContext.request.contextPath}/user/editProfile" class="btn-action btn-action-primary">
                회원정보 수정
            </a>
            <a href="${pageContext.request.contextPath}/user/updatePwForm" class="btn-action btn-action-outline">
                비밀번호 변경
            </a>
        </div>

    </div>

    <!-- ── 탭 메뉴 ── -->
    <div class="mypage-tabs">
        <button class="mypage-tab active" onclick="switchTab('courses')">수강 중인 과목</button>
        <button class="mypage-tab" onclick="switchTab('grades')">성적 조회</button>
        <button class="mypage-tab" onclick="switchTab('timetable')">시간표</button>
    </div>

    <!-- ── 수강 중인 과목 탭 ── -->
    <div id="tab-courses" class="tab-panel active">
        <div class="section-title">
            수강 중인 과목
            <span>2026학년도 1학기</span>
        </div>

        <div class="course-grid">

            <div class="course-card">
                <span class="course-badge badge-blue">전공필수</span>
                <p class="course-name">운영체제</p>
                <p class="course-prof">김철수 교수 · 월수 10:00</p>
                <div class="course-progress-label">
                    <span>출석률</span>
                    <span>92%</span>
                </div>
                <div class="course-progress-bar">
                    <div class="course-progress-fill" style="width: 92%"></div>
                </div>
            </div>

            <div class="course-card">
                <span class="course-badge badge-green">전공선택</span>
                <p class="course-name">데이터베이스</p>
                <p class="course-prof">이영희 교수 · 화목 13:00</p>
                <div class="course-progress-label">
                    <span>출석률</span>
                    <span>88%</span>
                </div>
                <div class="course-progress-bar">
                    <div class="course-progress-fill" style="width: 88%"></div>
                </div>
            </div>

            <div class="course-card">
                <span class="course-badge badge-amber">교양필수</span>
                <p class="course-name">공학수학</p>
                <p class="course-prof">박민준 교수 · 월수금 09:00</p>
                <div class="course-progress-label">
                    <span>출석률</span>
                    <span>75%</span>
                </div>
                <div class="course-progress-bar">
                    <div class="course-progress-fill" style="width: 75%"></div>
                </div>
            </div>

            <div class="course-card">
                <span class="course-badge badge-blue">전공필수</span>
                <p class="course-name">소프트웨어공학</p>
                <p class="course-prof">최지원 교수 · 화목 10:30</p>
                <div class="course-progress-label">
                    <span>출석률</span>
                    <span>96%</span>
                </div>
                <div class="course-progress-bar">
                    <div class="course-progress-fill" style="width: 96%"></div>
                </div>
            </div>

            <div class="course-card">
                <span class="course-badge badge-red">전공선택</span>
                <p class="course-name">컴퓨터네트워크</p>
                <p class="course-prof">정수현 교수 · 금 14:00</p>
                <div class="course-progress-label">
                    <span>출석률</span>
                    <span>83%</span>
                </div>
                <div class="course-progress-bar">
                    <div class="course-progress-fill" style="width: 83%"></div>
                </div>
            </div>

        </div>
    </div>

    <!-- ── 성적 조회 탭 ── -->
    <div id="tab-grades" class="tab-panel">

        <div class="grade-summary">
            <div class="grade-summary-card">
                <p class="grade-summary-label">평균 학점</p>
                <p class="grade-summary-value">3.8</p>
            </div>
            <div class="grade-summary-card">
                <p class="grade-summary-label">취득 학점</p>
                <p class="grade-summary-value">85</p>
            </div>
            <div class="grade-summary-card">
                <p class="grade-summary-label">이번 학기</p>
                <p class="grade-summary-value">15</p>
            </div>
            <div class="grade-summary-card">
                <p class="grade-summary-label">전공 학점</p>
                <p class="grade-summary-value">52</p>
            </div>
        </div>

        <br>

        <table class="grade-table">
            <thead>
            <tr>
                <th>과목명</th>
                <th>구분</th>
                <th>학점</th>
                <th>중간</th>
                <th>기말</th>
                <th>성적</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>운영체제</td>
                <td>전공필수</td>
                <td>3</td>
                <td>88</td>
                <td>92</td>
                <td><span class="grade-badge grade-a">A+</span></td>
            </tr>
            <tr>
                <td>데이터베이스</td>
                <td>전공선택</td>
                <td>3</td>
                <td>82</td>
                <td>85</td>
                <td><span class="grade-badge grade-a">A0</span></td>
            </tr>
            <tr>
                <td>공학수학</td>
                <td>교양필수</td>
                <td>3</td>
                <td>71</td>
                <td>74</td>
                <td><span class="grade-badge grade-b">B+</span></td>
            </tr>
            <tr>
                <td>소프트웨어공학</td>
                <td>전공필수</td>
                <td>3</td>
                <td>90</td>
                <td>94</td>
                <td><span class="grade-badge grade-a">A+</span></td>
            </tr>
            <tr>
                <td>컴퓨터네트워크</td>
                <td>전공선택</td>
                <td>3</td>
                <td>78</td>
                <td>80</td>
                <td><span class="grade-badge grade-b">B+</span></td>
            </tr>
            </tbody>
        </table>
    </div>

    <!-- ── 시간표 탭 ── -->
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
                <div class="timetable-cell">
                    <div class="timetable-subject subject-amber">공학수학<br>공학관 101</div>
                </div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell">
                    <div class="timetable-subject subject-amber">공학수학<br>공학관 101</div>
                </div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell">
                    <div class="timetable-subject subject-amber">공학수학<br>공학관 101</div>
                </div>
            </div>

            <div class="timetable-row">
                <div class="timetable-time">10:00</div>
                <div class="timetable-cell">
                    <div class="timetable-subject subject-blue">운영체제<br>IT관 203</div>
                </div>
                <div class="timetable-cell">
                    <div class="timetable-subject subject-purple">소프트웨어공학<br>공학관 305</div>
                </div>
                <div class="timetable-cell">
                    <div class="timetable-subject subject-blue">운영체제<br>IT관 203</div>
                </div>
                <div class="timetable-cell">
                    <div class="timetable-subject subject-purple">소프트웨어공학<br>공학관 305</div>
                </div>
                <div class="timetable-cell"></div>
            </div>

            <div class="timetable-row">
                <div class="timetable-time">13:00</div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell">
                    <div class="timetable-subject subject-green">데이터베이스<br>IT관 401</div>
                </div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell">
                    <div class="timetable-subject subject-green">데이터베이스<br>IT관 401</div>
                </div>
                <div class="timetable-cell"></div>
            </div>

            <div class="timetable-row">
                <div class="timetable-time">14:00</div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell"></div>
                <div class="timetable-cell">
                    <div class="timetable-subject subject-rose">컴퓨터네트워크<br>IT관 202</div>
                </div>
            </div>

        </div>
    </div>

</div>

<script>
    function switchTab(tab) {
        document.querySelectorAll('.mypage-tab').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));

        document.getElementById('tab-' + tab).classList.add('active');
        event.target.classList.add('active');
    }
</script>

</body>
</html>
