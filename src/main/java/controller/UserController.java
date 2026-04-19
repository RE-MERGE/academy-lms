package controller;

import dto.user.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import service.UserService;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;

@Controller
@RequestMapping("user")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("joinForm")
    public String joinForm(Model model) {
        model.addAttribute(UserConst.USER_JOIN_FORM, new UserJoinForm());
        return "user/joinForm";
    }

    @PostMapping("login")
    public String login() {

    //비교 로직
        return "home/test";
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

        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
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


}
