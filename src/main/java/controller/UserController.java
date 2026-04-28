package controller;

import config.NaverLoginConfig;
import dto.user.*;
import dto.user.login.Login;
import dto.user.login.UpdatePwForm;
import dto.user.mypage.MyPageData;
import exception.LoginFailException;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import service.FileService;
import service.NaverLoginService;
import service.UserService;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final NaverLoginConfig naverLoginConfig;
    private final NaverLoginService naverLoginService;
    private final MailSender mailSender;
    private final BCryptPasswordEncoder passwordEncoder;
    private final FileService fileService;

    @GetMapping("joinForm")
    public String joinForm(Model model) {
        model.addAttribute(UserConst.USER_JOIN_FORM, new UserJoinForm());
        return "user/joinForm";
    }

    @PostMapping("join")
    public String join(@Validated UserJoinForm userJoinForm, BindingResult bindingResult,
                       RedirectAttributes rttr) {

        validatePasswordMatch(userJoinForm, bindingResult);

        if (bindingResult.hasErrors()) {
            return "user/joinForm";
        }

        User dbUser = userService.selectUser(userJoinForm.getUserId());

        //아이디가 중복인 경우
        if (dbUser != null) {
            bindingResult.rejectValue("userId","error.duplication.userId");
            return "user/joinForm";
        }

        //이메일이 중복인 경우
        if (userService.selectUserIdByEmail(userJoinForm.getEmail()) != null) {
            bindingResult.rejectValue("email", "error.duplication.email");
            return "user/joinForm";
        }

        //비밀번호 값이 틀리거나, 없는 경우
        if (userJoinForm.getPassword() == null || userJoinForm.getPasswordConfirm() == null ||
                !userJoinForm.getPassword().equals(userJoinForm.getPasswordConfirm())) {
            bindingResult.reject("password","error.mismatch.password");
            return "user/joinForm";
        }

        User joinUser = userService.createUser(userJoinForm);

        userService.join(joinUser);
        rttr.addFlashAttribute("msg", "회원가입이 완료됐습니다. 관리자 승인 후 이용 가능합니다");

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
        return "redirect:/home/home";
    }

    @PostMapping("login")
    public String login(@Valid LoginForm loginForm, BindingResult bindingResult,
                         HttpSession session, @RequestParam(defaultValue = "/home/dashboard") String redirectURL) {

        if (bindingResult.hasErrors()) {
            return "home/home";
        }

        try {
            SessionUser sessionUser = userService.login(loginForm.getUserId(), loginForm.getPassword());
            userService.updateLastLogin(loginForm.getUserId());
            session.setAttribute(UserConst.SESSION_USER, sessionUser);
            return "redirect:" + redirectURL;

        } catch (LoginFailException e) {
            bindingResult.reject(e.getErrorCode());
            return "home/home";
        }

    }

    @GetMapping("myPage")
    public String myPage(@Login SessionUser sessionUser, Model model) {

        String semester = getSemester();

        MyPageData data = userService.getMyPageData(sessionUser, semester);

        model.addAttribute("courseList", data.getCourseList());
        model.addAttribute("myGradeList", data.getGradeList());
        model.addAttribute("semester", semester);
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

        String findUserId = userService.selectUserIdByEmail(findIdForm.getEmail());

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

        String findPassword = userService.selectUserPassword(findPwForm.getUserId(), findPwForm.getEmail(), findPwForm.getPhone());

        if (findPassword == null || findPassword.trim().isEmpty()) {

            bindingResult.reject("error.mismatch.info");
            model.addAttribute("findIdForm", new FindIdForm());
            model.addAttribute("activeTab", "pw");
            return "home/findAccount";
        }

        String tempPassword = UUID.randomUUID().toString().substring(0, 8);

        userService.updatePassword(findPwForm.getUserId(), passwordEncoder.encode(tempPassword));

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
            return "redirect:/home/home";
        }

        // 액세스 토큰 요청
        SessionUser sessionUser = naverLoginService.processNaverLogin(code, state);
        session.setAttribute(UserConst.SESSION_USER, sessionUser);

        return "redirect:/home/dashboard";
    }

    @GetMapping("editProfile")
    public String editForm(Model model, @Login SessionUser sessionUser) {

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

        User dbUser = userService.selectUser(sessionUser.getUserId());

        if (dbUser == null) {
            return "redirect:/home/home";
        }

        if (!sessionUser.isNaverUser() && !passwordEncoder.matches(userEditForm.getPassword(), dbUser.getPassword())) {
            bindingResult.rejectValue("password", "error.mismatch.password");
            return "user/editProfile";
        }

        if (userEditForm.getProfileImg() != null && !userEditForm.getProfileImg().isEmpty()) {
            String newProfileImgName = fileService.saveProfileImage(userEditForm.getProfileImg());
            userEditForm.setCurrentProfileImg(newProfileImgName);
            userService.updateProfileImg(userEditForm.getUserId(), userEditForm.getCurrentProfileImg());
        } else {
            userEditForm.setCurrentProfileImg(sessionUser.getProfileImg());
        }

        userService.updateInfo(userEditForm);

        session.setAttribute(UserConst.SESSION_USER, new SessionUser(userService.selectUser(sessionUser.getUserId())));

        return "redirect:/user/myPage";
    }

    @GetMapping("updatePwForm")
    public String updatePwForm(Model model, @Login SessionUser sessionUser) {

        if(sessionUser.isNaverUser()) {
            return "redirect:/user/myPage";
        }

        UpdatePwForm updatePwForm = new UpdatePwForm();
        updatePwForm.setUserId(sessionUser.getUserId());

        model.addAttribute("updatePwForm", updatePwForm);
        return "user/updatePwForm";
    }

    @PostMapping("updatePassword")
    public String changePassword(@Validated UpdatePwForm updatePwForm,
                                 BindingResult bindingResult, @Login SessionUser sessionUser,
                                 HttpSession session) {

        if (bindingResult.hasErrors()) {
            return "user/updatePwForm";
        }

        if(sessionUser.isNaverUser()) {
            return "redirect:/user/myPage";
        }

        User dbUser = userService.selectUser(updatePwForm.getUserId());

        //입력한 비밀번호와 현재 비밀번호가 일치하지 않으면
        if (!passwordEncoder.matches(updatePwForm.getCurrentPassword(), dbUser.getPassword())) {
            bindingResult.rejectValue("currentPassword", "error.mismatch.password");
            return "user/updatePwForm";
        }

        //변경하고자 하는 비밃번호가 기존에 사용하던 비밀번호라면
        if (passwordEncoder.matches(updatePwForm.getNewPassword(), dbUser.getPassword())) {
            bindingResult.rejectValue("currentPassword", "error.duplication.password");
            return "user/updatePwForm";
        }

        userService.updatePassword(updatePwForm.getUserId(), passwordEncoder.encode(updatePwForm.getNewPassword()));

        session.setAttribute(UserConst.SESSION_USER, new SessionUser(userService.selectUser(updatePwForm.getUserId())));

        return "redirect:/user/myPage";

    }

    @PostMapping("withdraw")
    public String withdraw(@RequestParam("password") String password, @Login SessionUser sessionUser, HttpSession session,
                           RedirectAttributes rttr) {

        if (sessionUser == null) {
            return "redirect:/home/home";
        }

        try {
            boolean isDeleted;

            if (sessionUser.isNaverUser()) {
                userService.updateStatus(sessionUser.getUserId(), UserStatus.DELETE);
                isDeleted = true;
            } else {
                isDeleted = userService.withdraw(sessionUser.getUserId(), password);
            }

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

    private static void validatePasswordMatch(UserJoinForm userJoinForm, BindingResult bindingResult) {

        if(bindingResult.hasFieldErrors("passwordConfirm")) return;

        if (userJoinForm.getPassword() != null && userJoinForm.getPasswordConfirm() != null) {
            if (!userJoinForm.getPassword().equals(userJoinForm.getPasswordConfirm())) {
                bindingResult.rejectValue("passwordConfirm", "error.mismatch.password", null);
            }
        }
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

}
