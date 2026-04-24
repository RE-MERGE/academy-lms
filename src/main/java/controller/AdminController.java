package controller;


import dto.user.AdminUserList;
import dto.user.login.Login;
import dto.user.mypage.AdminCourseList;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import service.AdminService;

import java.util.List;

@Controller
@RequestMapping("admin")
public class AdminController {

    private final AdminService adminService;

    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    @GetMapping("userList")
    public String getUserList(Model model) {

        List<AdminUserList> allUserList = adminService.getAllUserList();

        model.addAttribute("userList", allUserList);
        model.addAttribute("currentPage", 1);
        model.addAttribute("totalPages", 1);

        return "admin/adminUserList";
    }

    @GetMapping("courseList")
    public String getCourseList(Model model) {

        List<AdminCourseList> courseList = adminService.getAllCourseList();
        model.addAttribute("courseList", courseList);
        model.addAttribute("currentPage", 1);
        model.addAttribute("totalPages", 1);

        return "admin/adminCourseList";
    }

    @PostMapping("updateUserStatus")
    public String updateUserStatus(@RequestParam String status, @RequestParam List<Integer> userNos) {
        adminService.updateUserStatus(status, userNos);

        return "redirect:/admin/userList";
    }
}
