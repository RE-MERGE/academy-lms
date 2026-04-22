package controller;

import dto.board.*;
import dto.user.SessionUser;
import dto.user.login.Login;
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

import javax.mail.Session;
import java.util.Map;

@Controller
@RequestMapping("board")
public class BoardController {

    @Autowired
    BoardService boardService;

    @GetMapping("write")
    public void writeForm(@Login SessionUser sessionUser, Model model, String boardType) {
        model.addAttribute("writerName", sessionUser.getName());
        model.addAttribute("boardType", boardType);
    }

    @PostMapping("write")
    public String write(PostCreate board, @RequestParam("uploadFile") MultipartFile uploadFile, @Login SessionUser sessionUser) {
        int writerNo = sessionUser.getUserNo();
        // TODO: 업로드 처리 해야함
        boardService.insertPost(board, writerNo, sessionUser.getRole());
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
        model.addAttribute("boardType",   boardType);
        model.addAttribute("keyword",     keyword);
        model.addAttribute("searchType",  searchType);
        return "board/list";
    }

    @GetMapping("detail")
    public ModelAndView detail(int boardNo, String boardType) {
        ModelAndView mav = new ModelAndView();
        PostDetail postDetail = boardService.postDetail(boardNo);
        mav.addObject("postDetail", postDetail);
        mav.addObject("boardType", boardType);
        return mav;
    }

    @GetMapping("update")
    public ModelAndView update(int boardNo, String boardType) {
        ModelAndView mav = new ModelAndView();
        PostDetail postDetail = boardService.postDetail(boardNo);
        mav.addObject("post", postDetail);
        mav.addObject("boardType", boardType);
        return mav;
    }

    @PostMapping("updatePost")
    public String updatePost(PostUpdate postUpdate, String boardType, @Login SessionUser sessionUser) {
        boardService.updatePost(postUpdate, sessionUser.getUserNo());
        return "redirect:/board/list?boardType=" + boardType;
    }

    @PostMapping("delete")
    public String delete(String boardNo, String boardType, @Login SessionUser sessionUser) {
        boardService.deletePost(boardNo, sessionUser.getUserNo());
        return "redirect:/board/list?boardType=" + boardType;
    }
}
