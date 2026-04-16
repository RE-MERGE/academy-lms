package controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("kkm")
public class ttController {

    @RequestMapping("*")
    public String dd(){
        return "kkm";
    }

}
