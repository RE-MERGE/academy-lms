    package controller;

    import dto.Course;
import dto.board.*;
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

    import javax.servlet.http.HttpSession;
    import java.util.List;

    @Controller
    @RequestMapping("board")
    public class BoardController {

        @Autowired
        BoardService boardService;

        @GetMapping("*")
        public void getBoard(Board board) {
        }

        @PostMapping("write")
        public String write(PostCreate board, @RequestParam("uploadFile") MultipartFile uploadFile, HttpSession session) {
            int writerNo = 1;
    //        int writerNo = (int) session.getAttribute("loginUser");
            // TODO: 업로드 처리 해야함
            boardService.insertPost(board, writerNo);
            return "redirect:/board/board";
        }

        @GetMapping("board")
        public ModelAndView Board(@RequestParam(required = false) Integer courseNo, String boardType){
            ModelAndView mav = new ModelAndView();
            List<PostList> postList;
            postList = boardService.postList(courseNo, boardType);
            mav.addObject("postList", postList);
            return mav;
        }

        @GetMapping("detail")
        public ModelAndView detail(int boardNo){
            ModelAndView mav = new ModelAndView();
            PostDetail postDetail = boardService.postDetail(boardNo);
            mav.addObject("postDetail", postDetail);
            return mav;
        }
    }
