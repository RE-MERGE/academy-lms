package controller;

import dto.user.FindIdForm;
import dto.user.FindPwForm;
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

    @GetMapping("findAccount")
    public String findAccount(Model model) {
        model.addAttribute("findIdForm", new FindIdForm());
        model.addAttribute("findPwForm", new FindPwForm());
        return "home/findAccount";
    }

    @GetMapping("dashboard")
    public String dashboard() {
        return "home/dashboard";
    }
}
