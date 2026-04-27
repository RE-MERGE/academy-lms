package dto.user;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;

@Getter
@Setter
@ToString
//회원가입용 클래스
public class UserJoinForm {

    @NotBlank(message = "{error.required.name}")
    @Pattern(regexp = UserPattern.NAME_PATTERN, message = "{error.input.name}")
    private String name;


    @NotBlank(message = "{error.required.userId}")
    @Pattern(regexp = UserPattern.USERID_PATTERN,  message = "{error.input.userId}")
    private String userId;

    //최소 8자 이상, 영문자와 숫자 최소 1개씩 포함
    @NotBlank(message = "{error.required.password}")
    @Pattern(regexp = UserPattern.PASSWORD_PATTERN, message = "{error.input.password}")
    private String password;

    @NotBlank(message = "{error.required.password}")
    private String passwordConfirm;

    @NotBlank(message = "{error.required.email}")
    @Email(regexp = UserPattern.EMAIL_PATTERN, message = "{error.input.password}")
    private String email;

    @NotBlank( message = "{error.required.phoneNo}")
    @Pattern(regexp = UserPattern.PHONE_PATTERN, message = "{error.input.phone}")
    private String phone;

    private String role;
    private MultipartFile profileImg;
}
