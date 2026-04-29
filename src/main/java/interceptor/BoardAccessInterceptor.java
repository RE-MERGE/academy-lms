package interceptor;

import dto.user.SessionUser;
import dto.user.UserRole;
import exception.PostAccessDeniedException;
import org.springframework.web.servlet.HandlerInterceptor;
import service.CourseService;
import service.EnrollmentService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class BoardAccessInterceptor implements HandlerInterceptor {

    private final EnrollmentService enrollmentService;
    private final CourseService courseService;

    public BoardAccessInterceptor(EnrollmentService enrollmentService, CourseService courseService) {
        this.enrollmentService = enrollmentService;
        this.courseService = courseService;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        // 1. 세션 체크
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("sessionUser") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            return false;
        }

        // 2. 쿼리스트링에서 courseNo 꺼내기
        String courseNoParam = request.getParameter("courseNo");
        if (courseNoParam == null || courseNoParam.trim().isEmpty()) return true;

        int courseNo = Integer.parseInt(courseNoParam);
        SessionUser user = (SessionUser) session.getAttribute("sessionUser");

        // 3. 권한별 접근 제어
        UserRole role = user.getRole();

        // 관리자는 무조건 패스
        if (role == UserRole.ADMIN) return true;

        if (role == UserRole.PROFESSOR) {
            // [추가] 교수는 해당 강의의 담당 교수(professor_no)여야 함
            if (!courseService.isCourseOwner(user.getUserNo(), courseNo)) {
                throw new PostAccessDeniedException("본인의 강의 게시판만 접근 가능합니다.");
            }
        } else {
            // 학생은 수강 중인 강의여야 함
            if (!enrollmentService.isEnrolled(user.getUserNo(), courseNo)) {
                throw new PostAccessDeniedException("수강 중인 강의가 아닙니다.");
            }
        }

        return true;
    }
}
