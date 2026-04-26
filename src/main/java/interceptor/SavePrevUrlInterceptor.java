package interceptor;

import dto.user.UserConst;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SavePrevUrlInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute(UserConst.SESSION_USER) != null) {
            if (request.getMethod().equalsIgnoreCase("GET")) {
                session.setAttribute(UserConst.PREV_URL, request.getRequestURI());
            }
        }
        return true;
    }
}
