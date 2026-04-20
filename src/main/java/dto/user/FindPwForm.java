package dto.user;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

@Getter
@Setter
public class FindPwForm {

//    private static final String USERCODE_PATTERN = "^$|^[0-9]+$";
    private static final String USERID_PATTERN = "^$|^[a-zA-Z]+$";
    private static final String PHONE_PATTERN = "^$|^01(?:0|1|[6-9])-(?:\\d{3}|\\d{4})-\\d{4}$";
    private static final String EMAIL_PATTERN = "^$|^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

//    @NotBlank(message = "{error.required.name}")
//    @Pattern(regexp = USERCODE_PATTERN, message = "{error.input.userCode}")
//    private String UserCode;
    @NotBlank(message = "{error.required.userId}")
    @Pattern(regexp = USERID_PATTERN, message = "{error.input.userId}") // 영문만 허용
    private String userId;


    @NotBlank( message = "{error.required.phoneNo}")
    @Pattern(regexp = PHONE_PATTERN, message = "{error.input.phone}")
    private String phone;

    @NotBlank(message = "{error.required.email}")
    @Email(regexp = EMAIL_PATTERN, message = "{error.input.email}")
    private String email;
}
