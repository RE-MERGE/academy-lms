package controller;

import config.NaverLoginConfig;
import dao.CourseDao;
import dao.EnrollmentDao;
import dao.UserDao;
import dto.Course;
import dto.user.*;
import dto.user.login.Login;
import dto.user.login.UpdatePwForm;
import lombok.RequiredArgsConstructor;
import org.mariadb.jdbc.plugin.codec.LocalDateCodec;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import service.NaverLoginService;
import service.UserService;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Month;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final UserDao userDao;
    private final EnrollmentDao enrollmentDao;
    private final NaverLoginConfig naverLoginConfig;
    private final NaverLoginService naverLoginService;
    private final MailSender mailSender;

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

        //이메일이 중복인 경우
        if (dbUser != null && userJoinForm.getEmail().equals(dbUser.getEmail())) {
            bindingResult.reject("{error.duplication.email}");
            return "user/joinForm";
        }

        //비밀번호 값이 틀리거나, 없는 경우
        if (userJoinForm.getPassword() == null || userJoinForm.getPasswordConfirm() == null ||
                !userJoinForm.getPassword().equals(userJoinForm.getPasswordConfirm())) {
            bindingResult.reject("{error.mismatch.password}");
            return "user/joinForm";
        }

        User joinUser = createUser(userJoinForm);

        userDao.join(joinUser);

        return "redirect:/home/home";

    }

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

        //활동 가능한 상태의 아이디가 아니라면,
        if (dbUser.getStatus() != UserStatus.ACTIVE) {
            bindingResult.reject("error.status.notActive");
            return "home/home";
        }

        SessionUser sessionUser = createSessionUser(dbUser);
        session.setAttribute(UserConst.SESSION_USER, sessionUser);
        return "redirect:" + redirectURL;
    }

    @GetMapping("myPage")
    public String myPage(@Login SessionUser sessionUser, Model model) {

        String semester = getSemester();
//        int courseNo = enrollmentDao.getCourse(sessionUser.getUserId());

//        List<Course> courseList = courseDao.getMyCourse(sessionUser.getUserNo(), semester);

//        System.out.println("courseList = " + courseList);

        model.addAttribute(UserConst.SESSION_USER, sessionUser);
//        model.addAttribute("courseList", courseList);

        return "user/myPage";
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

    @PostMapping("findId")
    public String findId(@Validated FindIdForm findIdForm, BindingResult bindingResult, Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("findPwForm", new FindPwForm());
            model.addAttribute("activeTab", "id");
            return "home/findAccount";
        }

        String findUserId = userDao.selectUserIdByEmail(findIdForm.getEmail());

        if (findUserId == null) {
            bindingResult.reject("error.mismatch.info");
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

        String findPassword = userDao.selectUserPassword(findPwForm.getUserId(), findPwForm.getEmail(), findPwForm.getPhone());

        if (findPassword == null || findPassword.trim().isEmpty()) {

            bindingResult.reject("error.mismatch.info");
            model.addAttribute("findIdForm", new FindIdForm());
            model.addAttribute("activeTab", "pw");
            return "home/findAccount";
        }

        String tempPassword = UUID.randomUUID().toString().substring(0, 8);

        userDao.updatePassword(findPwForm.getUserId(), tempPassword);

        try {
            sentTempPasswordEmail(findPwForm.getEmail(), tempPassword);
            model.addAttribute("message", "이메일로 임시 비밀번호를 발송했습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message", "메일 발송에 실패했습니다. 관리자에게 문의하세요.");
        }

        model.addAttribute("findIdForm", new FindIdForm()); // 폼 객체 유지를 위해 추가
        model.addAttribute("activeTab", "pw");
        return "home/findAccount";
    }

    private void sentTempPasswordEmail(String email, String tempPassword) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("alswo818@naver.com");
        message.setTo(email);
        message.setSubject("[re-merge LMS] 임시 비밀번호 발급 ");
        message.setText("안녕하세요, [re-merge LMS]입니다. \n" +
                "요청하신 임시 비밀번호는 [ " + tempPassword + "] 입니다.\n" +
                "로그인 후 반드시 비밀번호를 변경해주세요.");

        mailSender.send(message);

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

    @GetMapping("editProfile")
    public String editForm(Model model, UserEditForm userEditForm, @Login SessionUser sessionUser) {

        model.addAttribute("userEditForm", new UserEditForm(
                sessionUser.getProfileImg(),
                sessionUser.getUserId(),
                sessionUser.getName(),
                sessionUser.getEmail(),
                sessionUser.getPhone(),
                ""
        ));

        return "user/editProfile";
    }

    @PostMapping("editProfile")
    public String editForm(@Validated UserEditForm userEditForm, BindingResult bindingResult, HttpSession session, @Login SessionUser sessionUser) {

        if (bindingResult.hasErrors()) {
            return "user/editProfile";
        }

        User dbUser = userDao.selectUser(sessionUser.getUserId());

        if (dbUser == null) {
            return "rediredct:/home/home";
        }

        if (!userEditForm.getPassword().equals(dbUser.getPassword())) {
            bindingResult.rejectValue("password", "error.mismatch.password");
            return "user/editProfile";
        }

        if (userEditForm.getProfileImg() != null && !userEditForm.getProfileImg().isEmpty()) {
            String newProfileImgName = saveProfileImage(userEditForm.getProfileImg());
            userEditForm.setCurrentProfileImg(newProfileImgName);
            userDao.updateProfileImg(userEditForm.getUserId(), userEditForm.getCurrentProfileImg());
        }

        userDao.updateInfo(userEditForm);

        SessionUser updatedUser = new SessionUser(
                sessionUser.getUserNo(),
                sessionUser.getUserCode(),
                sessionUser.getUserId(),
                userEditForm.getEmail(),
                userEditForm.getPhone(),
                userEditForm.getName(),
                sessionUser.getRole(),
                sessionUser.getStatus(),
                userEditForm.getCurrentProfileImg()
        );

        session.setAttribute(UserConst.SESSION_USER, updatedUser);

        return "redirect:/user/myPage";
    }

    @GetMapping("updatePwForm")
    public String updatePwForm(Model model, @Login SessionUser sessionUser) {

        UpdatePwForm updatePwForm = new UpdatePwForm();
        updatePwForm.setUserId(sessionUser.getUserId());

        model.addAttribute("updatePwForm", updatePwForm);
        return "user/updatePwForm";
    }

    @PostMapping("updatePassword")
    public String changePassword(@Validated UpdatePwForm updatePwForm, BindingResult bindingResult, HttpSession session, Model model) {

        if (bindingResult.hasErrors()) {
            return "user/updatePwForm";
        }

        User dbUser = userDao.selectUser(updatePwForm.getUserId());

        //입력한 비밀번호와 현재 비밀번호가 일치하지 않으면
        if (!updatePwForm.getCurrentPassword().equals(dbUser.getPassword())) {
            bindingResult.rejectValue("currentPassword", "error.mismatch.password");
            return "user/updatePwForm";
        }

        //변경하려는 비밀번호와, 확인 비밀번호값이 다르다면
        if (!updatePwForm.getNewPassword().equals(updatePwForm.getNewPasswordConfirm())) {
            bindingResult.rejectValue("newPassword", "error.mismatch.password");
            bindingResult.rejectValue("newPasswordConfirm", "error.mismatch.password");
            return "user/updatePwForm";
        }

        //변경하고자 하는 비밃번호가 기존에 사용하던 비밀번호라면
        if (dbUser.getPassword().equals(updatePwForm.getNewPassword())) {
            bindingResult.rejectValue("currentPassword", "error.duplication.password");
            return "user/updatePwForm";
        }

        userDao.updatePassword(updatePwForm.getUserId(), updatePwForm.getNewPassword());
        User updatePwUser = userDao.selectUser(updatePwForm.getUserId());

        session.setAttribute(UserConst.SESSION_USER, new SessionUser(updatePwUser));

        return "redirect:/user/myPage";

    }

    @PostMapping("withdraw")
    public String withdraw(@RequestParam("password") String password, @Login SessionUser sessionUser, HttpSession session,
                           RedirectAttributes rttr) {


        if (sessionUser == null) {
            return "redirect:/home/home";
        }

        try {
            boolean isDeleted = userService.withdraw(sessionUser.getUserId(), password);

            if (!isDeleted) {
                rttr.addFlashAttribute("error", "pw");
                return "redirect:/user/editProfile";
            }

            session.invalidate();
            rttr.addFlashAttribute("msg", "탈퇴가 정상처리 됐습니다. 그동안 이용해주셔서 감사합니다.");
            return "redirect:/home/home";

        } catch (Exception e) {
            e.printStackTrace();
            rttr.addFlashAttribute("error", "system");
            return "redirect:/user/editProfile";
        }

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
                file.transferTo(new File(UserConst.UPLOAD_PROFILES_IMG_PATH, saveFileName));
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
                dbUser.getPhone(),
                dbUser.getName(),
                dbUser.getRole(),
                dbUser.getStatus(),
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

    @GetMapping("adminUserList")
    public String adminUserList(Model model) {
        model.addAttribute("userList", new ArrayList<>());
        model.addAttribute("currentPage", 1);
        return "user/adminUserList";
    }


    @GetMapping("adminCourseList") // 빈껍데기 컨트롤러 기능X
    public String adminCourseList(@RequestParam(defaultValue = "1") int page, Model model) {
        model.addAttribute("courseList", new ArrayList<>());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", 1);
        return "user/adminCourseList";
    }




    @GetMapping("gradeManage")
    public String gradeManage(@RequestParam(defaultValue = "1") int page, Model model) {
        model.addAttribute("studentList", new ArrayList<>());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", 1);
        return "user/gradeManage";
    }

}
