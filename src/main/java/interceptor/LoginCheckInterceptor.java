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

        if (session == null || session.getAttribute(UserConst.SESSION_USER) == null) {

            response.sendRedirect(request.getContextPath() + "/home/home?redirectURL=" + requestURI);
            return false;
        }

        return true;
    }
}
