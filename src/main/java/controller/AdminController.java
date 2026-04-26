package controller;


import dto.user.AdminUserList;
import dto.user.login.Login;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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
    public String getCourseList() {

        return "admin/adminCourseList";
    }
    
    @GetMapping("roomTimetable")
    public String getRoomTimetable() {
        return "admin/roomTimetable";
    }
}
