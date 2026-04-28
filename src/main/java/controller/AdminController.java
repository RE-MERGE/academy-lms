package controller;


import dto.user.*;
import dto.user.mypage.UserEditFormForAdmin;
import dto.user.login.Login;
import dto.user.mypage.AdminCourseList;
import dto.user.mypage.MyPageData;
import dto.user.mypage.UserDetailForAdmin;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import service.AdminService;
import service.UserService;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import service.CourseService;

@Controller
@RequestMapping("admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;
    private final UserService userService;
    private final CourseService courseService;

    @GetMapping("userList")
    public String getUserList(@RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "all") String role, Model model) {

        int size = 10;
        int offset = (page - 1) * size;

        List<AdminUserList> userList = adminService.getUserListPaged(offset, size, role);

        int totalCount = adminService.getTotalUserCount(role);
        int totalPages = (int) Math.ceil((double) totalCount / size);

        model.addAttribute("userList", userList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("currentRole", role);
        
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

        User selectUser = adminService.selectUser(userNo);
        String semester = getSemester();
        UserDetailForAdmin targetUser = createdUserDetail(selectUser);

        MyPageData data = userService.getMyPageData(targetUser, semester);

        model.addAttribute("courseList", data.getCourseList());
        model.addAttribute("myGradeList", data.getGradeList());
        model.addAttribute("semester", semester);
        model.addAttribute(UserConst.DETAIL_USER, targetUser);

        return "admin/userDetail";
    }

    @GetMapping("editProfile/{userNo}")
    public String editProfileForAdminForm(@PathVariable int userNo, Model model) {

        User targetUser = adminService.selectUser(userNo);
        model.addAttribute(UserConst.EDIT_FORM, new UserEditFormForAdmin(targetUser));

        return "admin/editProfileForAdmin";
    }

    @PostMapping("editProfile/{userNo}")
    public String editProfileForAdmin(@PathVariable int userNo,
                                      @Validated @ModelAttribute("editForm") UserEditFormForAdmin userEditFormForAdmin,
                                      BindingResult bindingResult, Model model) {

        if (bindingResult.hasErrors()) {
            return "admin/editProfileForAdmin";
        }

        adminService.updateUserFormAdmin(userNo, userEditFormForAdmin);

        return "redirect:/admin/userDetail/" + userNo + "?saved=1";
    }

    private UserDetailForAdmin createdUserDetail(User selectUser) {
        UserDetailForAdmin userDetailForAdmin = new UserDetailForAdmin(selectUser);
        return userDetailForAdmin;
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
    
    @GetMapping("courselist")
    @ResponseBody
    public Map<String, Object> getEnrollmentList(
        @RequestParam(defaultValue = "1") int page,
        @RequestParam(defaultValue = "10") int size,
        @RequestParam(defaultValue = "") String type,
        @RequestParam(defaultValue = "") String credits,
        @RequestParam(defaultValue = "") String keyword,
        @RequestParam(defaultValue = "") String status,
        @RequestParam(defaultValue = "") String semester,
        @Login SessionUser sessionUser
    ) {
        Map<String, Object> result = new HashMap<>();
        int offset = (page - 1) * size;
        String effectiveStatus = status;
        if (UserRole.STUDENT == sessionUser.getRole()) {
            effectiveStatus = "APPROVED";
        }
       
        
        List<Map<String, Object>> courseList = courseService.getlist(semester, type, credits, keyword, effectiveStatus, offset, size);
        int totalCount = courseService.getCount(semester, type, credits, keyword, effectiveStatus);
        result.put("courses", courseList);
        result.put("totalCount", courseList.size());
        result.put("totalPages", (int) Math.ceil((double) totalCount / size));
        return result;
    }
    
}
