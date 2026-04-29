package controller;


import dto.user.*;
import dto.user.mypage.UserEditFormForAdmin;
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

        List<AdminUserList> userList = adminService.getUserListPaged(offset, size, role);

        int totalCount = adminService.getTotalUserCount(role);
        int totalPages = (int) Math.ceil((double) totalCount / size);

        model.addAttribute("userList", userList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);

        return "admin/adminUserList";
    }

    @GetMapping("adminCourseList")
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

    @GetMapping("editProfileForAdmin/{userNo}")
    public String editProfileForAdminForm(@PathVariable int userNo, Model model) {

        User targetUser = adminService.selectUser(userNo);
        model.addAttribute(UserConst.DETAIL_USER , new UserDetailForAdmin(targetUser));

        return "admin/editProfileForAdmin";
    }

    @PostMapping("editProfileForAdmin/{userNo}")
    public String editProfileForAdmin(@PathVariable int userNo,
                                      @Validated @ModelAttribute("userDetail") UserDetailForAdmin userDetailForAdmin,
                                      BindingResult bindingResult, Model model) {

        if (bindingResult.hasErrors()) {

            User targetUser = adminService.selectUser(userNo);
            findReadyOnlyFields(userDetailForAdmin, targetUser);

            model.addAttribute(UserConst.DETAIL_USER, userDetailForAdmin);
            model.addAttribute(UserConst.ORIGINAL_NAME, targetUser.getName());

            return "admin/editProfileForAdmin";
        }

        adminService.updateUserFormAdmin(userNo, userDetailForAdmin);

        return "redirect:/admin/userDetail/" + userNo + "?saved=1";
    }

    @PostMapping("resetLock/{userNo}")
    @ResponseBody
    public Map<String, Object> resetLockCount(@PathVariable int userNo) {
        Map<String, Object> result = new HashMap<>();

        try {
            adminService.resetLockCount(userNo);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    @PostMapping("tempPassword/{userNo}")
    @ResponseBody
    public Map<String, Object> sendTempPassword(@PathVariable int userNo) {
        Map<String, Object> result = new HashMap<>();

        try {
            User targetUser = adminService.selectUser(userNo);
            userService.processForgotPassword(targetUser.getUserId(), targetUser.getEmail(), targetUser.getPhone());
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    private static void findReadyOnlyFields(UserDetailForAdmin userDetailForAdmin, User targetUser) {

        userDetailForAdmin.setCurrentProfileImg(targetUser.getProfileImg());
        userDetailForAdmin.setUserCode(targetUser.getUserCode());
        userDetailForAdmin.setUserId(targetUser.getUserId());
        userDetailForAdmin.setCreatedAt(targetUser.getCreatedAt());
        userDetailForAdmin.setLastLoginDate(targetUser.getLastLoginAt());
        userDetailForAdmin.setLockCount(targetUser.getLock_count());
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


    @GetMapping("courselist")
    @ResponseBody
    public Map<String, Object> getCourseListJson(
            @RequestParam(defaultValue = "") String semester,
            @RequestParam(defaultValue = "100") int size) {

    	List<AdminCourseList> courses = adminService.getAllCourseList();

        Map<String, Object> result = new HashMap<>();
        result.put("courses", courses);
        return result;
    }
    
    @GetMapping("roomTimetable")
    public String getRoomTimetable() {
        return "admin/roomTimetable";
    }
}

