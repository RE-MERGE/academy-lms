package handler;

import exception.PostAccessDeniedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(PostAccessDeniedException.class)
    public String handlePostAccessDenied(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMsg", "해당 게시글에 대한 권한이 없습니다.");
        return "redirect:/board/list";
    }
}