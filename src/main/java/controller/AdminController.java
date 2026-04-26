package controller;


import dto.user.AdminUserList;
import dto.user.SessionUser;
import dto.user.User;
import dto.user.UserConst;
import dto.user.login.Login;
import dto.user.mypage.AdminCourseList;
import dto.user.mypage.MyPageData;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import service.AdminService;
import service.UserService;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;
    private final UserService userService;

    @GetMapping("userList")
    public String getUserList(@RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "all") String role, Model model) {

        int size = 10;
        int offset = (page - 1) * size;

//        List<AdminUserList> allUserList = adminService.getAllUserList();
        List<AdminUserList> userList = adminService.getUserListPaged(offset, size, role);

        int totalCount = adminService.getTotalUserCount(role);
        int totalPages = (int) Math.ceil((double) totalCount / size);


        model.addAttribute("userList", userList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);

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

    @PostMapping("updateCourseStatus")
    public String updateCourseStatus(@RequestParam String status, @RequestParam List<Integer> courseNos) {
        adminService.updateCourseStatus(status, courseNos);

        return "redirect:/admin/courseList";
    }

    @GetMapping("userDetail/{userNo}")
    public String userDetail(@PathVariable int userNo, Model model) {

        User selectUser = adminService.getSelectUser(userNo);
        SessionUser targetUser = createdSessionUser(selectUser);

        String semester = getSemester();
        MyPageData data = userService.getMyPageData(targetUser, semester);

        model.addAttribute("courseList", data.getCourseList());
        model.addAttribute("myGradeList", data.getGradeList());
        model.addAttribute("semester", semester);
        model.addAttribute(UserConst.SESSION_USER, targetUser);

        return "user/myPage";
    }

    private SessionUser createdSessionUser(User selectUser) {
        SessionUser sessionUser = new SessionUser(selectUser);
        return sessionUser;
    }

    private String getSemester() {

        String year = String.valueOf(LocalDate.now().getYear());
        int month = LocalDate.now().getMonthValue();

        String semester = "-";

        if (month <= 6) {
            month = 1;
        } else {
            month = 2;
        }

        return year += semester += String.valueOf(month);
    }

    
    @GetMapping("roomTimetable")
    public String getRoomTimetable() {
        return "admin/roomTimetable";
    }
}
