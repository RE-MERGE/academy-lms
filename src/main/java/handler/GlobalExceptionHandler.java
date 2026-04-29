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

//    @RequestMapping("/error404")
//    @ExceptionHandler(NoHandlerFoundException.class)
//    @ResponseStatus(HttpStatus.NOT_FOUND)
//    public String handle404(NoHandlerFoundException ex, Model model) {
//        ex.printStackTrace();
//        model.addAttribute("errorMessage", "error.page.notFound");
//        return "error/404";
//
//    }
//
//    @RequestMapping("/error500")
//    @ExceptionHandler(Exception.class)
//    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
//    public String handleAllException(Exception ex, Model model) {
//        ex.printStackTrace();
//        model.addAttribute("errorMessage", "error.page.serverError");
//        return "error/500";
//    }

    @ExceptionHandler(PostAccessDeniedException.class)
    public String handlePostAccessDenied(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMsg", "해당 게시글에 대한 권한이 없습니다.");
        return "redirect:/board/list";
    }

    @ExceptionHandler(UnauthorizedException.class)
    public void handleUnauthorized(UnauthorizedException ex, HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        System.out.println("==== UnauthorizedException 처리 ====");
        System.out.println("세션 존재: " + (session != null));
        String prevUrl = null;

        if (session != null) {
            prevUrl = (String) session.getAttribute(UserConst.PREV_URL);
        }

        String redirectURL = (prevUrl != null) ? prevUrl : request.getContextPath() + "/home/dashboard";

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 3. 자바스크립트 작성 및 전송
        out.println("<script>");
        out.println("alert('" + ex.getMessage() + "');");
        out.println("location.href='" + redirectURL + "';");
        out.println("</script>");

        out.flush();
        out.close();
    }
}