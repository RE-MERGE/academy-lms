package dto.user;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotBlank;

@Getter
@Setter
public class LoginForm {

    @NotBlank(message = "{error.required.userId}")
    private String userId;

    @NotBlank(message = "{error.required.password}")
    private String password;

}
