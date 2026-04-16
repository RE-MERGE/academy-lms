package controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("home")
public class HomeController {

    @RequestMapping("*")
    public ModelAndView home() {
        ModelAndView mav = new ModelAndView();
        return mav;
    }
}
