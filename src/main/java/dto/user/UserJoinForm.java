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

    private static final String USERID_PATTERN = "^$|^[a-zA-Z][a-zA-Z0-9]{3,14}$";
    private static final String PASSWORD_PATTERN = "^$|^(?=.*[A-Za-z])(?=.*\\d).{8,}$";
    private static final String PHONE_PATTERN = "^$|^01(?:0|1|[6-9])-(?:\\d{3}|\\d{4})-\\d{4}$";
    private static final String EMAIL_PATTERN = "^$|^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    private static final String NAME_PATTERN = "^$|^[가-힣a-zA-Z]{2,10}$";

    @NotBlank(message = "{error.required.name}")
    @Pattern(regexp = NAME_PATTERN, message = "{error.input.name}")
    private String name;


    @NotBlank(message = "{error.required.userId}")
    @Pattern(regexp = USERID_PATTERN,  message = "{error.input.userId}")
    private String userId;

    //최소 8자 이상, 영문자와 숫자 최소 1개씩 포함
    @NotBlank(message = "{error.required.password}")
    @Pattern(regexp = PASSWORD_PATTERN, message = "{error.input.password}")
    private String password;

    @NotBlank(message = "{error.required.password}")
    private String passwordConfirm;

    @NotBlank(message = "{error.required.email}")
    @Email(regexp = EMAIL_PATTERN, message = "{error.input.password}")
    private String email;

    @NotBlank( message = "{error.required.phoneNo}")
    @Pattern(regexp = PHONE_PATTERN, message = "{error.input.phone}")
    private String phone;

    private String role;
    private MultipartFile profileImg;
}
