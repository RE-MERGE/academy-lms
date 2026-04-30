package controller;

import dto.user.*;
import dto.user.login.Login;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("home")
public class HomeController {

    @GetMapping("home")
    public String home(Model model,
                       @RequestParam(required = false) String redirectURL,
                       @RequestParam(required = false) Boolean expired,
                       @Login SessionUser sessionUser) {

        if (sessionUser != null) {
            String target = (redirectURL != null && !redirectURL.isBlank()) ?
                    redirectURL : "/home/dashboard";

            return "redirect:" + target;
        }

        if (Boolean.TRUE.equals(expired)) {
            model.addAttribute("expiredMessage", "세션이 만료되었습니다. 다시 로그인해 주세요.");
        }

        model.addAttribute(UserConst.LOGIN_FORM, new LoginForm());

        return "home/home";
    }

    @GetMapping("findAccount")
    public String findAccount(Model model) {
        model.addAttribute("findIdForm", new FindIdForm());
        model.addAttribute("findPwForm", new FindPwForm());
        return "home/findAccount";
    }

//    @GetMapping("dashboard")
//    public String dashboard(Model model) {
//        return "home/dashboard";
//    }

}
