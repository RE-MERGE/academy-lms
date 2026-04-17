package dto.user;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

@Getter
@Setter
@ToString
//회원가입용 클래스
public class UserForm {

    private static final String PASSWORD_PATTERN = "\"^(?=.*[A-Za-z])(?=.*\\\\d).{8,}$\"";

    @NotBlank(message = "{error.required.name}")
    private String name;

    @NotBlank(message = "{error.required.userId}")
    @Size(min = 4, max = 15, message = "{error.input.user}")
    private String userId;


    //최소 8자 이상, 영문자와 숫자 최소 1개씩 포함
    @NotBlank(message = "{error.required.password}")
    @Pattern(regexp = PASSWORD_PATTERN, message = "{error.input.check}")
    private String password;

    @NotBlank(message = "{error.required.password}")
    private String passwordConfirm;

    @NotBlank(message = "{error.required.email}")
    @Email(message = "{error.input.check}")
    private String email;

    @NotBlank(message = "{error.required.phoneNo}")
    private String phone;

    private String role;
    private MultipartFile profileImg;
}
