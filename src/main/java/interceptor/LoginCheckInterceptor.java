package interceptor;

import dto.user.UserConst;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        String requestURI = request.getRequestURI();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute(UserConst.SESSION_USER) == null ||
                "ACTIVE".equals(session.getAttribute(UserConst.SESSION_USER))) {

            String contextPath = request.getContextPath();
            String redirectURL = requestURI.substring(contextPath.length());

            response.sendRedirect(contextPath + "/home/home?redirectURL=" + redirectURL);

            return false;
        }

        return true;
    }
}
