package dto.user.login;

import dto.user.UserPattern;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;

@Getter
@Setter
public class UpdatePwForm {

    private String userId;

    @NotBlank(message = "{error.required.password}")
    private String currentPassword;

    @NotBlank(message = "{error.required.password}")
    @Pattern(regexp = UserPattern.PASSWORD_PATTERN, message = "{error.input.password}")
    private String newPassword;

    @NotBlank(message = "{error.required.password}")
    private String newPasswordConfirm;


}
