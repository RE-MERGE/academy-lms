package handler;

import dto.user.UserConst;
import exception.PostAccessDeniedException;
import exception.UnauthorizedException;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@ControllerAdvice
public class GlobalExceptionHandler {

    @RequestMapping("/error404")
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handle404(NoHandlerFoundException ex, Model model) {
        ex.printStackTrace();
        return "error/404";

    }

    @RequestMapping("/error500")
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleAllException(Exception ex, Model model) {
        ex.printStackTrace();
        return "error/500";
    }

    @ExceptionHandler(PostAccessDeniedException.class) // 예외 핸들러 선언 확인
    public String handlePostAccessDenied(PostAccessDeniedException e, HttpServletRequest request, RedirectAttributes redirectAttributes) {

        // e.getMessage()를 사용해야 인터셉터에서 작성한 상세 메시지가 전달됩니다.
        redirectAttributes.addFlashAttribute("errorMsg", e.getMessage());

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            return "redirect:" + referer;
        }
        return "redirect:/home/dashboard";
    }

    @ExceptionHandler(UnauthorizedException.class)
    public void handleUnauthorized(UnauthorizedException ex, HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        String prevUrl = null;

        if (session != null) {
            prevUrl = (String) session.getAttribute(UserConst.PREV_URL);
        }

        String redirectURL = (prevUrl != null) ? prevUrl : request.getContextPath() + "/home/dashboard";

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        //자바스크립트 작성
        out.println("<script>");
        out.println("alert('" + ex.getMessage() + "');");
        out.println("location.href='" + redirectURL + "';");
        out.println("</script>");

        out.flush();
        out.close();
    }
}