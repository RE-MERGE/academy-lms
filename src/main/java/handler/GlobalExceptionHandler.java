package handler;

import exception.PostAccessDeniedException;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@ControllerAdvice
public class GlobalExceptionHandler {

    @RequestMapping("/error404")
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handle404(NoHandlerFoundException ex, Model model) {
        ex.printStackTrace();
        model.addAttribute("errorMessage", "error.page.notFound");
        return "error/404";

    }

    @RequestMapping("/error500")
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleAllException(Exception ex, Model model) {
        ex.printStackTrace();
        model.addAttribute("errorMessage", "error.page.serverError");
        return "error/500";
    }

    @ExceptionHandler(PostAccessDeniedException.class)
    public String handlePostAccessDenied(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMsg", "해당 게시글에 대한 권한이 없습니다.");
        return "redirect:/board/list";
    }
}