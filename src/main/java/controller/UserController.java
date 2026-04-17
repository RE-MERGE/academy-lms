package controller;

import dto.user.UserForm;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("user")
public class UserController {

    @GetMapping("joinForm")
    public String joinForm(Model model) {
        model.addAttribute("userForm", new UserForm());
        return null;
    }

    @PostMapping("join")
    public String join(@Validated @ModelAttribute("userForm") UserForm userForm, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            return "user/joinForm";
        }

        return "redirect:/home/home";
    }
}
