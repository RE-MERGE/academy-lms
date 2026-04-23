package controller;

import dto.board.*;
import dto.user.SessionUser;
import dto.user.UserConst;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import service.BoardService;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("board")
public class BoardController {

    @Autowired
    BoardService boardService;

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
        return "redirect:/board/list?boardType=" + board.getBoardType();
    }

    @GetMapping("list")
    public String boardList(@RequestParam(required = false) Integer courseNo,
                            @RequestParam(defaultValue = "1") int page,
                            @RequestParam(defaultValue = "NOTICE") String boardType,
                            @RequestParam(defaultValue = "") String keyword,
                            @RequestParam(defaultValue = "title") String searchType,
                            Model model) {

        Map<String, Object> data = boardService.getBoardList(boardType, keyword, searchType, page);

        model.addAttribute("postList", data.get("postList"));
        model.addAllAttributes(((PageInfo) data.get("pageInfo")).toMap()); // 또는 개별 addAttribute
        model.addAttribute("boardType", boardType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("searchType", searchType);
        return "board/list";
    }

    @GetMapping("detail")
    public ModelAndView detail(int boardNo) {
        ModelAndView mav = new ModelAndView();
        PostDetail postDetail = boardService.detailPost(boardNo);
        mav.addObject("post", postDetail);
        return mav;
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

    @GetMapping("update")
    public ModelAndView update(@Login SessionUser sessionUser, int boardNo) {
        PostDetail postDetail = boardService.detailPost(boardNo);
        if (sessionUser.getRole() != UserRole.ADMIN && sessionUser.getUserNo() != postDetail.getWriterNo()) {
            throw new PostAccessDeniedException();
        }
        ModelAndView mav = new ModelAndView();
        mav.addObject("post", postDetail);
        return mav;
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
}
