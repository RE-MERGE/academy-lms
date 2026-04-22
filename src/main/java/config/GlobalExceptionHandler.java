package config;

import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice
public class GlobalExceptionHandler {

    @RequestMapping("/error404")
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handle404(NoHandlerFoundException ex, Model model) {

        model.addAttribute("errorMessage", "error.page.notFound");
        return "error/404";

    }

    @RequestMapping("/error500")
    @ExceptionHandler(Exception.class)
    public String handleAllException(Exception ex, Model model) {
        model.addAttribute("errorMessage", "error.page.serverError");
        return "error/500";
    }
}
