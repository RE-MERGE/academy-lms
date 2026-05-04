package controller;

import dto.Course;
import dto.EnrollmentStudent;
import dto.board.*;
import dto.user.SessionUser;
import dto.user.UserRole;
import dto.user.grade.GradeForm;
import dto.user.grade.MyGrade;
import dto.user.login.Login;
import exception.PostAccessDeniedException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import service.BoardService;
import service.CourseService;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("board")
public class BoardController {

    @Autowired
    BoardService boardService;
    @Autowired
    CourseService courseService;

    @GetMapping("write")
    public void writeForm(@Login SessionUser sessionUser, Model model, String boardType) {
        // 공지 게시판은 PROFESSOR, ADMIN만 작성 가능
        if ("NOTICE".equals(boardType)) {
            if (sessionUser.getRole() == UserRole.STUDENT) {
                throw new PostAccessDeniedException("공지 게시판 작성 권한이 없습니다.");
            }
        }
        model.addAttribute("writerName", sessionUser.getName());
        model.addAttribute("boardType", boardType);
    }

    @PostMapping("write")
    public String write(PostCreate board, @Login SessionUser sessionUser) {
        boardService.insertPost(board, sessionUser.getUserNo());

        // QNA인 경우 list_qna로, 그 외엔 일반 list로 리다이렉트
        if ("QNA".equals(board.getBoardType()) && board.getCourseNo() != null) {
            return "redirect:/board/list_qna?boardType=QNA&courseNo=" + board.getCourseNo();
        }

        // NOTICE나 일반 게시판이라도 courseNo가 있다면 유지해주는 것이 좋습니다.
        String url = "redirect:/board/list?boardType=" + board.getBoardType();
        if (board.getCourseNo() != null) {
            url += "&courseNo=" + board.getCourseNo();
        }
        return url;
    }

    @GetMapping("list")
    public String boardList(@RequestParam(required = false) Integer courseNo,
                            @RequestParam(defaultValue = "1") int page,
                            @RequestParam(defaultValue = "NOTICE") String boardType,
                            @RequestParam(defaultValue = "") String keyword,
                            @RequestParam(defaultValue = "title") String searchType,
                            Model model) {
        Map<String, Object> data = boardService.getBoardList(courseNo, boardType, keyword, searchType, null, page, null);

        if(courseNo != null) {
            Course course = courseService.getBoardCourse(courseNo);
            model.addAttribute("course", course);
        }
        model.addAttribute("postList", data.get("postList"));
        model.addAttribute("boardType", boardType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("searchType", searchType);
        model.addAllAttributes(((PageInfo) data.get("pageInfo")).toMap()); // 또는 개별 addAttribute
        return "board/list";
    }

    @GetMapping({"detail","detail_qna"})
    public String detail(int boardNo, Integer courseNo, HttpServletRequest request, HttpServletResponse response, @RequestParam(defaultValue = "") String answerStatus, Model model, @Login SessionUser sessionUser) {
        // 1. 해당 게시글용 쿠키 이름 생성
        String cookieName = "alreadyViewed_" + boardNo;
        Cookie[] cookies = request.getCookies();
        boolean isFirstVisit = true;

        //2. 쿠키 검사: 이 브라우저에서 방문 확인
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals(cookieName)) {
                    isFirstVisit = false; // 방문!
                    break;
                }
            }
        }

        // 3. 첫 방문이면 DB올리고 쿠키 새로 생성
        if (isFirstVisit) {
            boardService.viewCount(boardNo);

            Cookie newCookie = new Cookie(cookieName, "true");
            newCookie.setMaxAge(60 * 60); // 1시간 유지
            newCookie.setPath("/"); // 프로젝트 전체 경로에서 유효
            response.addCookie(newCookie);
        }
        BoardLike boardlike = new BoardLike();
        boardlike.setBoardNo(boardNo);
        boardlike.setUserNo(sessionUser.getUserNo());
        boolean checkLike = boardService.checkLike(boardlike);
        PostDetail postDetail = boardService.detailPost(boardNo);

        model.addAttribute("checkLike", checkLike);
        model.addAttribute("post", postDetail);
        model.addAttribute("courseNo", courseNo);
        if ("QNA".equals(postDetail.getBoardType())) {
            model.addAttribute("professorName",   courseService.selectProfessorName(courseNo));
            model.addAttribute("answerStatus", answerStatus);
            return "board/detail_qna";
        }
        return "board/detail";
    }

    @GetMapping("update")
    public String update(@Login SessionUser sessionUser, Integer boardNo, Model model) {
        PostDetail postDetail = boardService.detailPost(boardNo);

        if (sessionUser.getRole() != UserRole.ADMIN && sessionUser.getUserNo() != postDetail.getWriterNo()) {
            throw new PostAccessDeniedException();
        }

        model.addAttribute("post", postDetail);
        // 폼에서 courseNo를 hidden으로 넘길 수 있도록 추가
        model.addAttribute("courseNo", postDetail.getCourseNo());
        return "board/update";
    }

    @PostMapping("update")
    public String update(PostUpdate postUpdate,
                         @RequestParam String boardType,
                         @RequestParam(required = false) Integer courseNo) {
        boardService.updatePost(postUpdate);

        // 리다이렉트 경로 결정
        if ("QNA".equals(boardType) && courseNo != null) {
            return "redirect:/board/list_qna?boardType=QNA&courseNo=" + courseNo;
        }

        String url = "redirect:/board/list?boardType=" + boardType;
        if (courseNo != null) {
            url += "&courseNo=" + courseNo;
        }
        return url;
    }

    @PostMapping("delete")
    public String delete(@RequestParam int boardNo,
                         @RequestParam String boardType,
                         @RequestParam(required = false) Integer courseNo,
                         @Login SessionUser sessionUser) {

        // 1. 권한 체크
        PostDetail post = boardService.detailPost(boardNo);
        if (sessionUser.getRole() != UserRole.ADMIN && sessionUser.getUserNo() != post.getWriterNo()) {
            throw new PostAccessDeniedException("삭제 권한이 없습니다.");
        }

        // 2. 삭제 실행
        boardService.deletePost(String.valueOf(boardNo), sessionUser.getUserNo(), sessionUser.getRole());

        // 3. 리다이렉트 경로 처리
        // 기본적으로 QNA는 list_qna로, 나머지는 list로 보냅니다.
        String redirectPath = "QNA".equals(boardType) ? "list_qna" : "list";

        StringBuilder url = new StringBuilder("redirect:/board/" + redirectPath);
        url.append("?boardType=").append(boardType);

        if (courseNo != null) {
            url.append("&courseNo=").append(courseNo);
        }

        return url.toString();
    }

    @GetMapping("list_qna")
    public void list_qna(@RequestParam(required = false) Integer courseNo,
                               @RequestParam(defaultValue = "1") int page,
                               @RequestParam(defaultValue = "QNA") String boardType,
                               @RequestParam(defaultValue = "") String keyword,
                               @RequestParam(defaultValue = "title") String searchType,
                               @RequestParam(defaultValue = "") String answerStatus,
                               @Login SessionUser sessionUser,
                               Model model) {

        Course course = courseService.getBoardCourse(courseNo);
        String professorName = courseService.selectProfessorName(courseNo);

        // QNA면 학생은 본인 글만
        Integer writerNo = null;
        if ("QNA".equals(boardType) && sessionUser.getRole() == UserRole.STUDENT) {
            writerNo = sessionUser.getUserNo();
        }

        Map<String, Object> data = boardService.getBoardList(courseNo, boardType, keyword, searchType, answerStatus, page, writerNo);


        model.addAttribute("postList", data.get("postList"));
        model.addAttribute("course", course);
        model.addAttribute("professorName", professorName);
        model.addAllAttributes(((PageInfo) data.get("pageInfo")).toMap());
        model.addAttribute("boardType", boardType);
        model.addAttribute("answerStatus", answerStatus);
    }

    @GetMapping("subjectHome")
    public void subjectHome(@RequestParam Integer courseNo,
                              @Login SessionUser sessionUser,
                              Model model) {

        // 1. 기본 정보 (과목명, 교수명)
        Course course = courseService.getBoardCourse(courseNo);
        String professorName = courseService.selectProfessorName(courseNo);

        // 2. 공지사항 리스트 (3개 추출)
        Map<String, Object> noticeData = boardService.getBoardList(courseNo, "NOTICE", "", "title", null,1, null);
        List<PostList> noticeList = (List<PostList>) noticeData.get("postList");

        // 리스트가 존재하고 3개보다 많을 때만 자름 (오류 방지)
        if (noticeList != null && noticeList.size() > 3) {
            noticeList = noticeList.subList(0, 3);
        }
        model.addAttribute("postList", noticeList);

        // 3. Q&A 리스트 (5개 추출)
        Integer writerNo = (sessionUser.getRole() == UserRole.STUDENT) ? sessionUser.getUserNo() : null;
        Map<String, Object> qnaData = boardService.getBoardList(courseNo, "QNA", "", "title", "ANSWERED",1, writerNo);
        List<PostList> qnaList = (List<PostList>) qnaData.get("postList");

        // 리스트가 존재하고 5개보다 많을 때만 자름 (오류 방지)
        if (qnaList != null && qnaList.size() > 3) {
            qnaList = qnaList.subList(0, 3);
        }
        model.addAttribute("qnaList", qnaList);

        // 4. 성적 데이터 (기존과 동일)
        List<MyGrade> studentList = courseService.getStudentList(courseNo);
        if (studentList != null && studentList.size() > 3) {
            studentList = studentList.subList(0, 3);
        }
        model.addAttribute("studentList", studentList);

        if (sessionUser.getRole() == UserRole.STUDENT) {
            MyGrade myInfo = studentList.stream()
                    .filter(s -> Integer.valueOf(s.getUserNo()).equals(sessionUser.getUserNo()))
                    .findFirst().orElse(null);
            model.addAttribute("myInfo", myInfo);
        }

        model.addAttribute("course", course);
        model.addAttribute("professorName", professorName);
    }

    @GetMapping("subjectScore")
    public void subjectScore(@Login SessionUser sessionUser, @RequestParam(value="courseNo", required=false) Integer courseNo, Model model){
        if (courseNo == null) courseNo = 1;

        List<MyGrade> studentList = courseService.getStudentList(courseNo);
        Course course = courseService.getCourse(courseNo);

        model.addAttribute("course", course);
        model.addAttribute("studentList", studentList);

        if (studentList != null && sessionUser != null) {
            // [수정 포인트] == 대신 equals()를 사용하여 객체 안의 '값'만 비교합니다.
            MyGrade myData = studentList.stream()
                    .filter(u -> Integer.valueOf(u.getUserNo()).equals(sessionUser.getUserNo()))
                    .findFirst()
                    .orElse(null);

            if (myData != null) {
                model.addAttribute("midtermGrade", myData);
                model.addAttribute("finalGrade", myData);
                model.addAttribute("attendanceGrade", myData);
            }
        }
    }

    @GetMapping("subjectStudents")
    public void subjectStudents(@RequestParam int courseNo,
                                  @Login SessionUser sessionUser,
                                  Model model) {
        Course course = courseService.getBoardCourse(courseNo);
        List<EnrollmentStudent> students = boardService.getStudentList(courseNo);
        String professorName = courseService.selectProfessorName(courseNo);
        model.addAttribute("professorName", professorName);
        model.addAttribute("course", course);
        model.addAttribute("students", students);
    }

    @PostMapping("saveGradeList")
    public String saveGrades(GradeForm gradeForm, RedirectAttributes rttr) {
        try {
            // 서비스에 데이터 전달
            courseService.saveGradesList(gradeForm);

            // 성공 시 메시지 전달
            rttr.addFlashAttribute("saveResult", "ok");
        } catch (Exception e) {
            e.printStackTrace();
            rttr.addFlashAttribute("saveResult", "fail");
        }

        // 다시 성적 관리 페이지로 리다이렉트 (courseNo를 쿼리스트링으로 전달)
        return "redirect:/board/subjectScore?courseNo=" + gradeForm.getCourse_no();
    }

    @PostMapping("approveEnrollment")
    @ResponseBody
    public ResponseEntity<?> approveEnrollment(@RequestParam int enrollmentNo) {
        boardService.approveEnrollment(enrollmentNo);
        return ResponseEntity.ok().build();
    }

    @GetMapping("fileDownload")
    public void fileDownload(@RequestParam String fileUrl, HttpServletResponse response) throws IOException {
        File file = new File("C:/upload/profiles/" + fileUrl);

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" +
                        URLEncoder.encode(fileUrl.substring(fileUrl.indexOf("_") + 1), "UTF-8") + "\"");

        Files.copy(file.toPath(), response.getOutputStream());
    }

    @PostMapping("/like")
    @ResponseBody // AJAX 응답을 위해 필요 (또는 클래스에 @RestController 사용)
    public Map<String, Object> toggleLike(@RequestBody BoardLike boardLike, @Login SessionUser sessionUser) {
        Map<String, Object> result = new HashMap<>();

        boardLike.setUserNo(sessionUser.getUserNo());

        // 3. 서비스 로직 호출 (좋아요 추가 또는 취소)
        String status = boardService.toggleLike(boardLike);

        result.put("status", "success");
        result.put("action", status); // "liked" 또는 "unliked"
        return result;
    }
}
