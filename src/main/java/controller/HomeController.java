package controller;

import dto.user.LoginForm;
import dto.user.UserConst;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("home")
public class HomeController {

    @GetMapping("home")
    public String home(Model model) {
        model.addAttribute("loginForm", new LoginForm());
        return "home/home";
    }

}
