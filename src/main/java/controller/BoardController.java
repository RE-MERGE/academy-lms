    package controller;

    import dto.Course;
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

    import javax.servlet.http.HttpSession;
    import java.util.List;

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
            List<Course> courseList = boardService.selectAllCourses(); // 이게 있어야 함
            mav.addObject("Course", courseDetail);
            mav.addObject("courseList", courseList); // 이게 있어야 함
            mav.addObject("profName",profName);
            mav.setViewName("board/subject");
            return mav;
        }
        @GetMapping("*")
        public void getBoard(Board board) {
        }


        @PostMapping("write")
        public String write(PostCreate board, @RequestParam("uploadFile") MultipartFile uploadFile, @Login SessionUser sessionUser) {
            int writerNo = sessionUser.getUserNo();
            // TODO: 업로드 처리 해야함
            boardService.insertPost(board, writerNo);
            return "redirect:/board/board?boardType=" + board.getBoardType();
        }

        @GetMapping("board")
        public ModelAndView Board(@RequestParam(required = false) Integer courseNo, String boardType){
            ModelAndView mav = new ModelAndView();
            List<PostList> postList;
            postList = boardService.postList(courseNo, boardType);
            mav.addObject("postList", postList);
            mav.addObject("courseNo", courseNo);
            mav.addObject("boardType", boardType);
            return mav;
        }

        @GetMapping("detail")
        public ModelAndView detail(int boardNo){
            ModelAndView mav = new ModelAndView();
            PostDetail postDetail = boardService.postDetail(boardNo);
            mav.addObject("postDetail", postDetail);
            return mav;
        }

        @GetMapping("update")
        public ModelAndView update(int boardNo){
            ModelAndView mav = new ModelAndView();
            PostDetail postDetail = boardService.postDetail(boardNo);
            mav.addObject("post", postDetail);
            return mav;
        }

        @PostMapping("updatePost")
        public String updatePost(PostUpdate postUpdate){
            boardService.updatePost(postUpdate);
            return "redirect:/board/board?boardtype=";
        }
    }
