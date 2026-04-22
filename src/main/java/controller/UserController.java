package controller;

import config.NaverLoginConfig;
import dao.UserDao;
import dto.user.*;
import dto.user.login.Login;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import service.NaverLoginService;
import service.UserService;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final UserDao userDao;
    private final NaverLoginConfig naverLoginConfig;
    private final NaverLoginService naverLoginService;

    @GetMapping("joinForm")
    public String joinForm(Model model) {
        model.addAttribute(UserConst.USER_JOIN_FORM, new UserJoinForm());
        return "user/joinForm";
    }

    @PostMapping("join")
    public String join(@Validated UserJoinForm userJoinForm, BindingResult bindingResult) {

        validatePasswordMatch(userJoinForm, bindingResult);

        if (bindingResult.hasErrors()) {
            return "user/joinForm";
        }

        User dbUser = userDao.selectUser(userJoinForm.getUserId());

        //아이디가 중복인 경우
        if (dbUser != null) {
            bindingResult.reject("{error.duplication.userId}");
            return "user/joinForm";
        }


        //비밀번호 값이 틀리거나, 없는 경우
        if(userJoinForm.getPassword() == null || userJoinForm.getPasswordConfirm() == null ||
                !userJoinForm.getPassword().equals(userJoinForm.getPasswordConfirm())) {
            bindingResult.reject("{error.mismatch.password}");
            return "user/joinForm";
        }

        User joinUser = createUser(userJoinForm);

        userDao.join(joinUser);

        return "redirect:/home/home";

    }

//    @PostMapping("join")
//    public String join(@Validated UserJoinForm userJoinForm,
//                       BindingResult bindingResult,
//                       HttpSession session) {
//
//        //두 개의 비밀번호 일치 여부 확인
//        validatePasswordMatch(userJoinForm, bindingResult);
//
//        if (bindingResult.hasErrors()) {
//            return "user/joinForm";
//        }
//
//        //DB에 저장할 user, DB에 저장(service 필요)
//        User user = toUser(userJoinForm);
//        userService.join(user);
//
//        //로그인에 저장할 user
//        LoginUser loginUser = toLoginUser(user);
//
//        session.setAttribute(UserConst.LOGIN_USER, loginUser);
//
//        return "redirect:/home/login";
//    }


    @GetMapping("loginForm")
    public String loginForm(Model model) {
        model.addAttribute(UserConst.LOGIN_FORM, new LoginForm());
        return "home/home";
    }

    @GetMapping("logout")
    public String logout(HttpSession session, Model model) {
        session.invalidate();
        model.addAttribute(UserConst.LOGIN_FORM, new LoginForm());
        return "home/home";
    }

    @PostMapping("login")
    public String login(@Valid LoginForm loginForm, BindingResult bindingResult,
                        Model model, HttpSession session, @RequestParam(defaultValue = "/home/dashboard") String redirectURL) {

        if (bindingResult.hasErrors()) {
            return "home/home";
        }

        User dbUser = userDao.selectUser(loginForm.getUserId());

        if (dbUser == null || loginForm.getPassword() == null ||
                !loginForm.getPassword().equals(dbUser.getPassword())) {

            bindingResult.reject("error.loginFail");

            return "home/home";
        }

        SessionUser sessionUser = createSessionUser(dbUser);
        session.setAttribute(UserConst.SESSION_USER, sessionUser);

        return "redirect:" + redirectURL;
    }

    @GetMapping("myPage")
    public String myPage(@Login SessionUser sessionUser, Model model) {

        model.addAttribute(UserConst.SESSION_USER, sessionUser);

        return "user/myPage";
    }

    @PostMapping("findId")
    public String findId(@Validated FindIdForm findIdForm, BindingResult bindingResult, Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("findPwForm", new FindPwForm());
            model.addAttribute("activeTab", "id");
            return "home/findAccount";
        }

        String findUserId = userDao.selectUserIdByEmail(findIdForm.getEmail());

        if (findUserId == null) {
            bindingResult.reject( "error.mismatch.info");
            model.addAttribute("findPwForm", new FindPwForm());
            return "home/findAccount";
        }

        String maskedId = findUserId.replaceAll("^(.{2}).*", "$1****");

        model.addAttribute("findUserId", maskedId);
        model.addAttribute("findPwForm", new FindPwForm()); // 폼 객체 유지를 위해 추가

        return "home/findAccount";
    }

    @PostMapping("findPw")
    public String findPw(@Validated FindPwForm findPwForm, BindingResult bindingResult, Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("findIdForm", new FindIdForm());
            model.addAttribute("activeTab", "pw");
            return "home/findAccount";
        }

        //비밀번호 찾기 하고 있었음
        String findPassword = userDao.selectUserPassword(findPwForm.getUserId(), findPwForm.getEmail(), findPwForm.getPhone());

        return "redirect:/home/dashboard";
    }

    @GetMapping("naverLogin")
    public String naverLogin(HttpSession session) {

        String state = UUID.randomUUID().toString();
        session.setAttribute("naverState", state);

        return "redirect:" + naverLoginConfig.getNaverAuthorizeUrl(state);
    }

    @GetMapping("naverCallback")
    public String naverCallback(@RequestParam String code, @RequestParam String state,
                                HttpSession session) {

        String savedState = (String) session.getAttribute("naverState");
        if (!state.equals(savedState)) {
            return "redirect:/user/login";
        }

        // 액세스 토큰 요청
        String accessToken = naverLoginService.getAccessToken(code, state);

        // 사용자 정보 요청
        Map<String, Object> userInfo = naverLoginService.getUserInfo(accessToken);

        // 세션 저장
        LoginUser loginUser = new LoginUser(
                0,
                (String) userInfo.get("id"),
                (String) userInfo.get("name"),
                UserRole.STUDENT,
                (String) userInfo.get("profile_image")
        );
        session.setAttribute(UserConst.LOGIN_USER, loginUser);

        return "redirect:/home/home";

    }



    private static LoginUser toLoginUser(User user) {
        LoginUser loginUser = new LoginUser(
                user.getUserNo(),
                user.getUserId(),
                user.getName(),
                user.getRole(),
                user.getProfileImg()
        );
        return loginUser;
    }

    private User toUser(UserJoinForm userJoinForm) {

        User user = new User();
        user.setName(userJoinForm.getName());
        user.setUserId(userJoinForm.getUserId());
        user.setPassword(userJoinForm.getPassword());
        user.setEmail(userJoinForm.getEmail());
        user.setPhone(userJoinForm.getPhone());
        user.setRole(UserRole.valueOf(userJoinForm.getRole()));

        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDate.now());
        user.setStatus(UserStatus.PENDING);
        user.setLock_count(0);

        user.setProfileImg(saveProfileImage(userJoinForm.getProfileImg()));

        return user;
    }

    private static String saveProfileImage(MultipartFile file) {

        if (file != null && !file.isEmpty()) {
            File saveForder = new File(UserConst.UPLOAD_PROFILES_IMG_PATH);

            if (!saveForder.exists()) {
                saveForder.mkdirs();
            }

            String originalFilename = file.getOriginalFilename();
            String saveFileName = UUID.randomUUID().toString() + "_" + originalFilename;

            try {
                file.transferTo(new File(UserConst.UPLOAD_PROFILES_IMG_PATH + saveFileName));
                return saveFileName;
            } catch (IOException e) {
                e.printStackTrace();
                return UserConst.DEFAULT_PROFILE_IMG;
            }
        } else {
            return UserConst.DEFAULT_PROFILE_IMG;
        }
    }

    private static void validatePasswordMatch(UserJoinForm userJoinForm, BindingResult bindingResult) {

        if(bindingResult.hasFieldErrors("passwordConfirm")) return;

        if (userJoinForm.getPassword() != null && userJoinForm.getPasswordConfirm() != null) {
            if (!userJoinForm.getPassword().equals(userJoinForm.getPasswordConfirm())) {
                bindingResult.rejectValue("passwordConfirm", "error.mismatch.password", null);
            }
        }
    }

    private static SessionUser createSessionUser(User dbUser) {
        SessionUser sessionUser = new SessionUser(
                dbUser.getUserNo(),
                dbUser.getUserCode(),
                dbUser.getUserId(),
                dbUser.getEmail(),
                dbUser.getName(),
                dbUser.getRole(),
                dbUser.getProfileImg()
        );
        return sessionUser;
    }

    private int getUserCode() {

        int currentYear = LocalDate.now().getYear();
        int lastUserCode = userDao.getLastUserCode();

        int lastYearPart = (lastUserCode % 1000000) / 10000;
        int currentYearPart = currentYear % 100;

        if (currentYearPart > lastYearPart) {
            int prefix = lastUserCode / 1000000;
            return (prefix * 1000000) + (currentYearPart * 10000) + 1;
        } else {
            return lastUserCode + 1;
        }

    }

    private User createUser(UserJoinForm userJoinForm) {

        String profileImage = "";
        if (userJoinForm.getProfileImg() != null && !userJoinForm.getProfileImg().isEmpty()) {
            profileImage = saveProfileImage(userJoinForm.getProfileImg());
        }

        int findUserCode = getUserCode();

        User joinUser = new User();
        joinUser.setUserCode(findUserCode);
        joinUser.setUserId(userJoinForm.getUserId());
        joinUser.setPassword(userJoinForm.getPassword());
        joinUser.setName(userJoinForm.getName());
        joinUser.setEmail(userJoinForm.getEmail());
        joinUser.setPhone(userJoinForm.getPhone());
        joinUser.setRole(UserRole.valueOf(userJoinForm.getRole().toUpperCase()));
        joinUser.setStatus(UserStatus.PENDING);
        joinUser.setProfileImg(profileImage);
        joinUser.setCreatedAt(LocalDateTime.now());
        joinUser.setLast_password_changed(LocalDate.now());
        joinUser.setLock_count(0);
        joinUser.setLastLoginAt(LocalDate.now());
        joinUser.setUpdatedAt(LocalDate.now());

        return joinUser;
    }
/*   adminadminUserList 빈껍데기 컨트롤러 기능X
 * 
    @GetMapping("/adminUserList")
    public String adminUserList(Model model) {
        model.addAttribute("userList", new ArrayList<>());
        model.addAttribute("currentPage", 1);
        return "user/adminUserList";
    }  
  
    
    @GetMapping("/adminCourseList") // 빈껍데기 컨트롤러 기능X
    public String adminCourseList(@RequestParam(defaultValue = "1") int page, Model model) {
        model.addAttribute("courseList", new ArrayList<>());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", 1);
        return "user/adminCourseList";
    }
    
    */
    //=========================== DB연동 전 adminList, adminCorseList 리스트 출력 "테스트"용 지워도됨

    @GetMapping("/adminUserList")
    public String adminUserList(@RequestParam(defaultValue = "1") int page, Model model) {
        
        List<Map<String, Object>> userList = new ArrayList<>();
        
        Map<String, Object> u1 = new HashMap<>();
        u1.put("user_no", 1); u1.put("name", "김일번");
        u1.put("email", "1111@naver.com"); u1.put("role", "STUDENT");
        u1.put("status", "ACTIVE"); u1.put("student_id", "261111");
        u1.put("apply_date", "2026-01-01"); userList.add(u1);

        Map<String, Object> u2 = new HashMap<>();
        u2.put("user_no", 2); u2.put("name", "김이번");
        u2.put("email", "2222@naver.com"); u2.put("role", "STUDENT");
        u2.put("status", "INACTIVE"); u2.put("student_id", "261112");
        u2.put("apply_date", "2026-01-02"); userList.add(u2);

        Map<String, Object> u3 = new HashMap<>();
        u3.put("user_no", 3); u3.put("name", "박삼번");
        u3.put("email", "3333@gmail.com"); u3.put("role", "STUDENT");
        u3.put("status", "PENDING"); u3.put("student_id", "261113");
        u3.put("apply_date", "2026-01-03"); userList.add(u3);

        model.addAttribute("userList", userList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", 3);
        return "user/adminUserList";
    }
    
    @GetMapping("/adminCourseList")
    public String adminCourseList(@RequestParam(defaultValue = "1") int page, Model model) {

        List<Map<String, Object>> courseList = new ArrayList<>();

        Map<String, Object> c1 = new HashMap<>();
        c1.put("course_no", 1); c1.put("prof_name", "김교수");
        c1.put("course_name", "수능 영어 정복반"); c1.put("status", "APPROVED");
        c1.put("course_code", "261111"); c1.put("apply_date", "2026-01-01");
        c1.put("classroom", "203관 817호"); c1.put("day_of_week", "월");
        c1.put("start_time", "09:00"); c1.put("end_time", "11:00");
        c1.put("credits", 3); courseList.add(c1);

        Map<String, Object> c2 = new HashMap<>();
        c2.put("course_no", 2); c2.put("prof_name", "이교수");
        c2.put("course_name", "고난도 독해 집중반"); c2.put("status", "PENDING");
        c2.put("course_code", "261112"); c2.put("apply_date", "2026-01-02");
        c2.put("classroom", "203관 818호"); c2.put("day_of_week", "화");
        c2.put("start_time", "13:00"); c2.put("end_time", "15:00");
        c2.put("credits", 2); courseList.add(c2);

        Map<String, Object> c3 = new HashMap<>();
        c3.put("course_no", 3); c3.put("prof_name", "박교수");
        c3.put("course_name", "너무 어려워 콩글리쉬반"); c3.put("status", "CANCELED");
        c3.put("course_code", "261113"); c3.put("apply_date", "2026-01-03");
        c3.put("classroom", "203관 819호"); c3.put("day_of_week", "목");
        c3.put("start_time", "15:00"); c3.put("end_time", "17:00");
        c3.put("credits", 3); courseList.add(c3);

        model.addAttribute("courseList", courseList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", 3);
        return "user/adminCourseList";
    }
    
    //--------------------------------------------------------------
    
    
}
