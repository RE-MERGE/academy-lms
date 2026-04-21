package controller;

import dto.Board;
import dto.Course;
import dto.user.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import service.BoardService;

@Controller
@RequestMapping("board")
public class BoardController {

    @Autowired
    BoardService boardService;
    
    @GetMapping("subject")
    public ModelAndView getSubject(@RequestParam(value="no", defaultValue="1") int no) {
        ModelAndView mav = new ModelAndView();
        Course courseDetail = boardService.selectCourse(no);
        String profName = boardService.selectProfessorName(no);
        mav.addObject("Course", courseDetail);
        mav.addObject("profName", profName);
        mav.setViewName("board/subject");
        return mav;
    }
    

    @GetMapping("*")
    public void getBoard(Board board) {
    }
    @PostMapping("write")
    public String write(Board board, @RequestParam("uploadFile") MultipartFile uploadFile) {
        board.setWriterNo(1);
        boardService.insert(board);
        return "redirect:/board/board";
    }
}
