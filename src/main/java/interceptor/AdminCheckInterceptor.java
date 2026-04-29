package interceptor;

import dto.user.SessionUser;
import dto.user.UserConst;
import dto.user.UserRole;
import dto.user.login.Login;
import exception.UnauthorizedException;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HttpSession session = request.getSession(false);
        SessionUser sessionUser = (session != null) ? (SessionUser) session.getAttribute(UserConst.SESSION_USER) : null;

        if (sessionUser == null || UserRole.ADMIN != sessionUser.getRole()) {
            throw new UnauthorizedException("관리자 권한이 필요한 서비스입니다.");
        }

        return true;

    }
}
