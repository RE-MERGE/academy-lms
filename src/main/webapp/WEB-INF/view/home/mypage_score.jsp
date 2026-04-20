<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Grade Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
<div class="mypage-content">
    <div class="page-header">
        <h2 class="page-title">Grade Management</h2>
        <p style="font-size: 0.8rem; color: var(--gray-400); margin-top: 0.4rem;">마이페이지 > 성적 관리</p>
    </div>

    <div style="margin-bottom: 1.5rem;">
        <select class="select-semester">
            <option value="2026-1">2026-1학기</option>
            <option value="2025-2">2025-2학기</option>
            <option value="2025-1">2025-1학기</option>
        </select>
    </div>

    <div class="card">
        <h3><i class="fas fa-chart-line card-title-icon"></i> 성적취이</h3>
        <div style="overflow-x: auto;">
            <table class="lms-table">
                <thead>
                    <tr>
                        <th>구분</th>
                        <th>전필</th>
                        <th>전선</th>
                        <th>교필</th>
                        <th>교선</th>
                        <th>일선</th>
                        <th>취득 학점</th>
                        <th>총 평점</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>학점</td>
                        <td>30</td>
                        <td>15</td>
                        <td>25</td>
                        <td>10</td>
                        <td>10</td>
                        <td style="font-weight: 700; color: var(--primary);">90</td>
                        <td style="font-weight: 700; color: var(--primary);">4.5</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="card">
        <h3><i class="fas fa-calendar-alt card-title-icon"></i> 년도별 성적</h3>
        <div style="overflow-x: auto;">
            <table class="lms-table">
                <thead>
                    <tr>
                        <th>년도 / 학기</th>
                        <th>취득 학점</th>
                        <th>평점 평균 (F제외)</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>2020 / 1</td>
                        <td>18</td>
                        <td>4.2</td>
                    </tr>
                    <tr>
                        <td>2020 / 2</td>
                        <td>21</td>
                        <td>3.8</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>