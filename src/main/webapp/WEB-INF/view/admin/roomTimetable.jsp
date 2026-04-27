<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>강의실 현황</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/myPage.css">
    <style>
        * { box-sizing: border-box; }

        .room-page {
            padding: 30px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .room-page-title {
            font-size: 1.4rem;
            font-weight: 700;
            color: #1e2235;
            margin-bottom: 24px;
        }

        /* 층 섹션 */
        .floor-section {
            display: none;
            margin-bottom: 40px;
        }
        .floor-section.active {
            display: block;
        }

        /* 층 탭 버튼 */
        .floor-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 20px;
        }
        .floor-tab {
            padding: 8px 24px;
            font-size: 0.9rem;
            font-weight: 700;
            color: #2c3e50;
            background: #f1f5f9;
            border: 1.5px solid #1E3A8A;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.15s;
            font-family: 'Noto Sans KR', sans-serif;
        }
        .floor-tab:hover { background: #e2e8f0; }
        .floor-tab.active {
            background: #E6A817;
            color: #fff;
            border-color: #E6A817;
        }

        /* 강의실 3개 가로 배치 */
        .room-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }

        /* 강의실 카드 */
        .room-card {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 14px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .room-name {
            font-size: 0.9rem;
            font-weight: 700;
            color: #1e2235;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .room-name::before {
            content: '';
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #2c3e50;
        }

        /* 시간표 헤더 */
        .tt-grid-header {
            display: grid;
            grid-template-columns: 42px repeat(5, 1fr);
            gap: 2px;
            margin-bottom: 3px;
        }

        .tt-day {
            text-align: center;
            font-size: 10px;
            font-weight: 700;
            border-radius: 4px;
            color: #fff;
            background: #1E3A8A; 
            min-height: 42px;
            height: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* 시간표 바디 (단일 그리드) */
        .tt-body {
            display: grid;
            grid-template-columns: 42px repeat(5, 1fr);
            gap: 2px;
        }

        .tt-period {
            font-size: 9px;
            color: #888;
            font-weight: 600;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 42px;
            line-height: 1.4;
        }

        .tt-period .p-num {
            font-size: 10px;
            font-weight: 700;
            color: #555;
        }

        .tt-cell {
            border-radius: 4px;
            font-size: 9px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            line-height: 1.3;
            padding: 3px 2px;
            min-height: 42px;
        }

        .tt-cell.empty { background: #f8f9fa; }

        .mp-c1 { background: #AEE2FF; color: #0369a1; border: 1.5px solid #0369a1; }
        .mp-c2 { background: #FFCEEE; color: #be185d; border: 1.5px solid #be185d; }
        .mp-c3 { background: #FFF6D2; color: #a16207; border: 1.5px solid #a16207; }
        .mp-c4 { background: #DED9FF; color: #5b21b6; border: 1.5px solid #5b21b6; }
        .mp-c5 { background: #D6FFDE; color: #166534; border: 1.5px solid #166534; }
        .mp-c6 { background: #FFE5D0; color: #c2410c; border: 1.5px solid #c2410c; }
        .mp-c7 { background: #E0F2FE; color: #0369a1; border: 1.5px solid #075985; }
    </style>
</head>
<body>
<div class="room-page">
    <div class="room-page-title">🏫 강의실 현황</div>

    <!-- 층 탭 버튼 -->
    <div class="floor-tabs">
        <button class="floor-tab active" onclick="switchFloor('floor-1', this)">1층</button>
        <button class="floor-tab" onclick="switchFloor('floor-2', this)">2층</button>
        <button class="floor-tab" onclick="switchFloor('floor-3', this)">3층</button>
    </div>

    <!-- 1층 -->
    <div class="floor-section active" id="floor-1">
        <div class="room-grid">
            <div class="room-card">
                <div class="room-name">101호</div>
                <div class="tt-grid-header">
                    <div></div>
                    <div class="tt-day">월</div>
                    <div class="tt-day">화</div>
                    <div class="tt-day">수</div>
                    <div class="tt-day">목</div>
                    <div class="tt-day">금</div>
                </div>
                <div class="tt-body" id="room-101"></div>
            </div>
            <div class="room-card">
                <div class="room-name">102호</div>
                <div class="tt-grid-header">
                    <div></div>
                    <div class="tt-day">월</div>
                    <div class="tt-day">화</div>
                    <div class="tt-day">수</div>
                    <div class="tt-day">목</div>
                    <div class="tt-day">금</div>
                </div>
                <div class="tt-body" id="room-102"></div>
            </div>
            <div class="room-card">
                <div class="room-name">103호</div>
                <div class="tt-grid-header">
                    <div></div>
                    <div class="tt-day">월</div>
                    <div class="tt-day">화</div>
                    <div class="tt-day">수</div>
                    <div class="tt-day">목</div>
                    <div class="tt-day">금</div>
                </div>
                <div class="tt-body" id="room-103"></div>
            </div>
        </div>
    </div>

    <!-- 2층 -->
    <div class="floor-section" id="floor-2">
        <div class="room-grid">
            <div class="room-card">
                <div class="room-name">201호</div>
                <div class="tt-grid-header">
                    <div></div>
                    <div class="tt-day">월</div>
                    <div class="tt-day">화</div>
                    <div class="tt-day">수</div>
                    <div class="tt-day">목</div>
                    <div class="tt-day">금</div>
                </div>
                <div class="tt-body" id="room-201"></div>
            </div>
            <div class="room-card">
                <div class="room-name">202호</div>
                <div class="tt-grid-header">
                    <div></div>
                    <div class="tt-day">월</div>
                    <div class="tt-day">화</div>
                    <div class="tt-day">수</div>
                    <div class="tt-day">목</div>
                    <div class="tt-day">금</div>
                </div>
                <div class="tt-body" id="room-202"></div>
            </div>
            <div class="room-card">
                <div class="room-name">203호</div>
                <div class="tt-grid-header">
                    <div></div>
                    <div class="tt-day">월</div>
                    <div class="tt-day">화</div>
                    <div class="tt-day">수</div>
                    <div class="tt-day">목</div>
                    <div class="tt-day">금</div>
                </div>
                <div class="tt-body" id="room-203"></div>
            </div>
        </div>
    </div>

    <!-- 3층 -->
    <div class="floor-section" id="floor-3">
        <div class="room-grid">
            <div class="room-card">
                <div class="room-name">301호</div>
                <div class="tt-grid-header">
                    <div></div>
                    <div class="tt-day">월</div>
                    <div class="tt-day">화</div>
                    <div class="tt-day">수</div>
                    <div class="tt-day">목</div>
                    <div class="tt-day">금</div>
                </div>
                <div class="tt-body" id="room-301"></div>
            </div>
            <div class="room-card">
                <div class="room-name">302호</div>
                <div class="tt-grid-header">
                    <div></div>
                    <div class="tt-day">월</div>
                    <div class="tt-day">화</div>
                    <div class="tt-day">수</div>
                    <div class="tt-day">목</div>
                    <div class="tt-day">금</div>
                </div>
                <div class="tt-body" id="room-302"></div>
            </div>
            <div class="room-card">
                <div class="room-name">303호</div>
                <div class="tt-grid-header">
                    <div></div>
                    <div class="tt-day">월</div>
                    <div class="tt-day">화</div>
                    <div class="tt-day">수</div>
                    <div class="tt-day">목</div>
                    <div class="tt-day">금</div>
                </div>
                <div class="tt-body" id="room-303"></div>
            </div>
        </div>
    </div>
</div>

<script>
/* ================================================================
   강의실 현황 — 목업 데이터 (나중에 API 연동으로 교체)
   day_of_week: '월', '화', '수', '목', '금' 또는 '월,수' 형식
   start_time / end_time: 'HH:00' 형식
================================================================ */
var ROOM_MOCK = {
    '101': [
        { course_name: '공학수학', day_of_week: '월,수,금', start_time: '09:00', end_time: '10:00', color: 'mp-c1' },
        { course_name: '회로이론', day_of_week: '화,목',    start_time: '11:00', end_time: '13:00', color: 'mp-c2' }
    ],
    '102': [
        { course_name: '운영체제', day_of_week: '월,수',    start_time: '10:00', end_time: '12:00', color: 'mp-c3' },
        { course_name: '자료구조', day_of_week: '화,목',    start_time: '09:00', end_time: '10:00', color: 'mp-c4' }
    ],
    '103': [
        { course_name: '데이터베이스', day_of_week: '화,목', start_time: '13:00', end_time: '15:00', color: 'mp-c5' },
        { course_name: '알고리즘',    day_of_week: '월,금',  start_time: '10:00', end_time: '11:00', color: 'mp-c6' }
    ],
    '201': [
        { course_name: '네트워크',    day_of_week: '월,수',  start_time: '13:00', end_time: '15:00', color: 'mp-c2' },
        { course_name: '소프트웨어공학', day_of_week: '금',  start_time: '09:00', end_time: '12:00', color: 'mp-c1' }
    ],
    '202': [
        { course_name: '인공지능',    day_of_week: '화,목',  start_time: '10:00', end_time: '12:00', color: 'mp-c3' },
        { course_name: '컴파일러',    day_of_week: '월',     start_time: '14:00', end_time: '16:00', color: 'mp-c5' }
    ],
    '203': [
        { course_name: '경제학원론',  day_of_week: '월,수,금', start_time: '09:00', end_time: '10:00', color: 'mp-c4' }
    ],
    '301': [
        { course_name: '마케팅',      day_of_week: '화,목',  start_time: '13:00', end_time: '15:00', color: 'mp-c6' },
        { course_name: '통계학',      day_of_week: '월,수',  start_time: '10:00', end_time: '11:00', color: 'mp-c1' }
    ],
    '302': [
        { course_name: '열역학',      day_of_week: '화,목',  start_time: '09:00', end_time: '11:00', color: 'mp-c2' },
        { course_name: '유체역학',    day_of_week: '월,금',  start_time: '14:00', end_time: '16:00', color: 'mp-c3' }
    ],
    '303': [
        { course_name: '전자기학',    day_of_week: '화,수,목', start_time: '11:00', end_time: '13:00', color: 'mp-c5' }
    ]
};

var MIN_H = 9;
var MAX_H = 18;
var DAY_KEYS = ['월', '화', '수', '목', '금'];
var DAY_COL  = {'월': 2, '화': 3, '수': 4, '목': 5, '금': 6};

function parseDays(str) {
    return str ? str.split(',').map(function(d){ return d.replace(/요일/, '').trim(); }) : [];
}
function parseHour(t) {
    return t ? parseInt(t.split(':')[0]) : -1;
}

function renderRoomTimetable(roomNo) {
    var body = document.getElementById('room-' + roomNo);
    if (!body) return;

    var courses = ROOM_MOCK[roomNo] || [];

    /* 시간 범위 */
    var minH = MIN_H, maxH = MAX_H;
    if (courses.length) {
        courses.forEach(function(c) {
            var sh = parseHour(c.start_time);
            var eh = parseHour(c.end_time);
            if (sh > 0) minH = Math.min(minH, sh);
            if (eh > 0) maxH = Math.max(maxH, eh);
        });
    }

    /* 시간 라벨 + 빈 셀 */
    for (var h = minH; h < maxH; h++) {
        var rowIdx = h - minH + 1;
        var period = h - minH + 1;

        var timeCell = document.createElement('div');
        timeCell.className = 'tt-period';
        timeCell.style.gridColumn = '1';
        timeCell.style.gridRow = String(rowIdx);
        timeCell.innerHTML =
            '<span class="p-num">' + period + '교시</span>' +
            '<span style="font-size:9px;color:#aaa;">' + String(h).padStart(2,'0') + ':00</span>';
        body.appendChild(timeCell);

        DAY_KEYS.forEach(function(day, di) {
            var occupied = courses.some(function(c) {
                var days = parseDays(c.day_of_week);
                var sh = parseHour(c.start_time);
                var eh = parseHour(c.end_time);
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

    /* 과목 셀 — 연속 시간 병합 */
    courses.forEach(function(c) {
        var days = parseDays(c.day_of_week);
        var sh   = parseHour(c.start_time);
        var eh   = parseHour(c.end_time);
        var span = eh - sh;
        var rowStart = sh - minH + 1;

        days.forEach(function(day) {
            var colIdx = DAY_COL[day];
            if (!colIdx) return;
            var cell = document.createElement('div');
            cell.className = 'tt-cell ' + (c.color || 'mp-c1');
            cell.style.gridColumn = String(colIdx);
            cell.style.gridRow = rowStart + ' / span ' + span;
            cell.textContent = c.course_name;
            body.appendChild(cell);
        });
    });
}

function switchFloor(floorId, btn) {
    document.querySelectorAll('.floor-section').forEach(function(s){ s.classList.remove('active'); });
    document.querySelectorAll('.floor-tab').forEach(function(b){ b.classList.remove('active'); });
    document.getElementById(floorId).classList.add('active');
    btn.classList.add('active');
}

/* 전체 강의실 렌더링 */
window.addEventListener('DOMContentLoaded', function() {
    ['101','102','103','201','202','203','301','302','303'].forEach(function(room) {
        renderRoomTimetable(room);
    });
});
</script>
</body>
</html>
