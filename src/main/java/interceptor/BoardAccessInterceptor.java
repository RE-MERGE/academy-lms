package interceptor;

import dto.board.Board;
import dto.board.PostDetail;
import dto.user.SessionUser;
import dto.user.UserRole;
import exception.PostAccessDeniedException;
import org.springframework.web.servlet.HandlerInterceptor;
import service.BoardService;
import service.CourseService;
import service.EnrollmentService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class BoardAccessInterceptor implements HandlerInterceptor {

    private final EnrollmentService enrollmentService;
    private final CourseService courseService;
    private final BoardService boardService;

    public BoardAccessInterceptor(EnrollmentService enrollmentService, CourseService courseService, BoardService boardService) {
        this.enrollmentService = enrollmentService;
        this.courseService = courseService;
        this.boardService = boardService;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        // 1. 세션 체크
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("sessionUser") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            return false;
        }

        SessionUser user = (SessionUser) session.getAttribute("sessionUser");
        UserRole role = user.getRole();

        // 관리자는 무조건 패스
        if (role == UserRole.ADMIN) return true;

        // 2. 파라미터 및 URI 준비
        String boardNoParam = request.getParameter("boardNo");
        String boardType = request.getParameter("boardType");
        String courseNoParam = request.getParameter("courseNo");
        String uri = request.getRequestURI();

        // 3. [우선순위 1] QNA 상세 보기 권한 체크 (boardNo 기준)
        if (uri.endsWith("/board/list") && ("QNA".equals(boardType) || "qna".equals(boardType))) {
                response.sendRedirect(request.getContextPath() + "/board/list");
                return false;
        }

        // 4. [우선순위 2] 특정 메뉴 접근 제한
        if (role == UserRole.STUDENT && uri.contains("/board/subjectStudents")) {
            throw new PostAccessDeniedException("조회할 권한이 없습니다.");
        }

        // 5. [우선순위 3] 강의실 입장 권한 체크 (courseNo 기준)
        // courseNo가 없는 요청(예: 공지사항 목록 등)은 여기서 걸러줍니다.
        if (courseNoParam == null || courseNoParam.trim().isEmpty() || "null".equals(courseNoParam)) {
            return true;
        }

        int courseNo = Integer.parseInt(courseNoParam);
        if (role == UserRole.PROFESSOR) {
            if (!courseService.isCourseOwner(user.getUserNo(), courseNo)) {
                throw new PostAccessDeniedException("본인의 강의 게시판만 접근 가능합니다.");
            }
        } else {
            if (!enrollmentService.isEnrolled(user.getUserNo(), courseNo)) {
                throw new PostAccessDeniedException("수강 중인 강의가 아닙니다.");
            }
        }

        return true;
    }
}
