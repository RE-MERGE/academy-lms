package controller;

import config.NaverLoginConfig;
import dao.UserDao;
import dto.user.*;
import dto.user.login.Login;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
import java.net.http.HttpResponse;
import java.time.LocalDate;
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

            bindingResult.reject("error.loginFail", "아이디 또는 비밀번호가 맞지 않습니다.");

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

    @PostMapping("join")
    public String join(@Validated UserJoinForm userJoinForm,
                       BindingResult bindingResult,
                       HttpSession session) {

        //두 개의 비밀번호 일치 여부 확인
        validatePasswordMatch(userJoinForm, bindingResult);

        if (bindingResult.hasErrors()) {
            return "user/joinForm";
        }

        //DB에 저장할 user, DB에 저장(service 필요)
        User user = toUser(userJoinForm);
        userService.join(user);

        //로그인에 저장할 user
        LoginUser loginUser = toLoginUser(user);

        session.setAttribute(UserConst.LOGIN_USER, loginUser);

        return "redirect:/home/login";
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

        user.setCreatedAt(LocalDate.now());
        user.setUpdatedAt(LocalDate.now());
        user.setStatus(UserStatus.PEDING);
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

}
