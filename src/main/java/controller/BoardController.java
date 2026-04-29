package controller;

import dto.Course;
import dto.board.*;
import dto.user.SessionUser;
import dto.user.UserRole;
import dto.user.login.Login;
import exception.PostAccessDeniedException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import service.BoardService;
import service.CourseService;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
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
    public String write(PostCreate board,
                        @Login SessionUser sessionUser) {
        boardService.insertPost(board, sessionUser.getUserNo());
        if (board.getCourseNo() != null && board.getBoardType().equals("QNA")){
            return "redirect:/board/list_qna?boardType=QNA&courseNo=" + board.getCourseNo();
        }
        return "redirect:/board/list?courseNo=" + board.getCourseNo() + "&boardType=" + board.getBoardType();
    }

    @GetMapping("list")
    public String boardList(@RequestParam(required = false) Integer courseNo,
                            @RequestParam(defaultValue = "1") int page,
                            @RequestParam(defaultValue = "NOTICE") String boardType,
                            @RequestParam(defaultValue = "") String keyword,
                            @RequestParam(defaultValue = "title") String searchType,
                            Model model) {
        Map<String, Object> data = boardService.getBoardList(courseNo, boardType, keyword, searchType, page, null);

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
    public String detail(int boardNo, Integer courseNo, HttpServletRequest request, HttpServletResponse response, @RequestParam(defaultValue = "") String answerStatus, Model model) {
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

        PostDetail postDetail = boardService.detailPost(boardNo);
        model.addAttribute("post", postDetail);
        model.addAttribute("courseNo", courseNo);
        if ("QNA".equals(postDetail.getBoardType())) {
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
        return "board/update";
    }

    @PostMapping("update")
    public String update(PostUpdate postUpdate, String boardType) {
        boardService.updatePost(postUpdate);
        return "redirect:/board/list?boardType=" + boardType;
    }

    @PostMapping("delete")
    public String delete(String boardNo, String boardType, @Login SessionUser sessionUser) {
        boardService.deletePost(boardNo, sessionUser.getUserNo(), sessionUser.getRole());
        return "redirect:/board/list?boardType=" + boardType;
    }

    @GetMapping({"subjectHome", "list_qna"})
    public String subjectBoard(@RequestParam(required = false) Integer courseNo,
                               @RequestParam(defaultValue = "1") int page,
                               @RequestParam(defaultValue = "NOTICE") String boardType,
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

        Map<String, Object> data = boardService.getBoardList(courseNo, boardType, keyword, searchType, page, writerNo);


        model.addAttribute("postList", data.get("postList"));
        model.addAttribute("course", course);
        model.addAttribute("professorName", professorName);
        model.addAllAttributes(((PageInfo) data.get("pageInfo")).toMap());
        model.addAttribute("boardType", boardType);

        // QNA면 다른 뷰
        if ("QNA".equals(boardType)) {
            model.addAttribute("answerStatus", answerStatus);
            return "board/list_qna";
        }
        return "board/subjectHome";
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
}
