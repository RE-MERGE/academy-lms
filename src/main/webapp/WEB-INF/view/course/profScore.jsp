<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
.attendance-table {
    width: 100%;
    border-collapse: collapse;
    border-radius: 10px 10px 0 0;
    overflow: hidden;
    table-layout: fixed;
}
.attendance-table thead { background-color: #004595; color: white; }
.attendance-table th { padding: 12px; border: 1px solid #003a7d; }
.attendance-table tbody { text-align: center; background-color: #f8faff; }
.attendance-table td { padding: 15px; border: 1px solid #d0d7f0; }
.score {
	width: 80%;
    height: 40px;
    font-size: 18px;
    text-align: center;
    border-radius: 6px;
}
.score:focus {
    border-color: #0d4d94;
    outline: none;
    box-shadow: 0 0 5px rgba(13,77,148,0.3);
}

/* 학점 */
.grade {
    font-weight: bold;
    font-size: 18px;
}

/* 버튼 영역 */
.btn-area {
    margin-top: 15px;
    text-align: right;
}

/* 버튼 스타일 */
button {
    background-color: #0d4d94;
    color: white;
    border: none;
    padding: 10px 20px;
    font-size: 16px;
    border-radius: 6px;
    cursor: pointer;
    transition: 0.2s;
}

button:hover {
    background-color: #083a6b;
}
</style>

<h1>${Course.course_name}</h1>


<form>
<input type="hidden" id="courseNo" value="${Course.course_no}"/>
<input type="hidden" id="contextPath" value="${pageContext.request.contextPath}"/>
    <table class="attendance-table">
        <thead>
            <tr>
                <th style="width: 20%;">이름</th>
                <th style="width: 20%;">중간</th>
                <th style="width: 20%;">기말</th>
                <th style="width: 20%;">출석</th>
                <th style="width: 20%;">학점</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="student" items="${studentList}">
			    <tr data-userno="${student.userNo}">
			        <td>${student.name}</td>
			        <td><input type="text" class="score midterm" inputmode="numeric" pattern="[0-9]*" placeholder="0 ~ 100" /></td>
			        <td><input type="text" class="score final" inputmode="numeric" pattern="[0-9]*" placeholder="0 ~ 100"/></td>
			        <td><input type="text" class="score attendance" inputmode="numeric" pattern="[0-9]*" placeholder="0 ~ 100"/></td>
			        <td class="grade">-</td>
			    </tr>
			</c:forEach>
        </tbody>
    </table>
	<div class="btn-area">
        <button type="button" onclick="saveGrades()">저장</button>
    </div>
</form>
<script>
document.querySelectorAll("input.score").forEach(input => {
    input.addEventListener("input", function () {
        // 숫자 아닌 문자 제거
        this.value = this.value.replace(/[^0-9]/g, '');
        
        let val = parseInt(this.value);
        if (val > 100) this.value = 100;

        calculateGrade.call(this);
    });
});

function calculateGrade() {
    const row = this.closest("tr");

    const mid = parseFloat(row.querySelector(".midterm").value) || 0;
    const fin = parseFloat(row.querySelector(".final").value) || 0;
    const att = parseFloat(row.querySelector(".attendance").value) || 0;

    const total = mid * 0.4 + fin * 0.4 + att * 0.2;

    let grade = "";

    if (total >= 95) grade = "A+";
    else if (total >= 90) grade = "A";
    else if (total >= 85) grade = "B+";
    else if (total >= 80) grade = "B";
    else if (total >= 75) grade = "C+";
    else if (total >= 70) grade = "C";
    else if (total >= 60) grade = "D";
    else grade = "F";

    row.querySelector(".grade").innerText = grade;
}

function saveGrades() {
    const course_no = document.getElementById("courseNo").value;
    const contextPath = document.getElementById("contextPath").value;
    const rows = document.querySelectorAll("tbody tr");
    const gradeList = [];

    rows.forEach(row => {
    	console.log("userno:유저넘버 " + row.dataset.userno);
        const alphabet = row.querySelector(".grade").innerText;
        const midterm = row.querySelector(".midterm").value;
        const final_score = row.querySelector(".final").value;
        const attendance = row.querySelector(".attendance").value;

        // ← 빈값 체크 추가!
        if (alphabet === "-" || midterm === "" || final_score === "" || attendance === "") {
            alert("모든 점수를 입력해주세요!");
            return;
        }

        gradeList.push({
            user_no: row.dataset.userno,
            midterm, final_score, attendance, alphabet,
            course_no: course_no
        });
    });

    if (gradeList.length === 0) return;

    fetch(contextPath + "/course/saveGrades", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(gradeList)
    })
    .then(res => res.text())
    .then(result => {
        if (result === "ok") alert("저장 완료!");
        else alert("저장 실패!");
    });
}

</script>
