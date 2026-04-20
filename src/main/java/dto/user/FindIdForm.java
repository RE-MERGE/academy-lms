package dto.user;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;

@Getter
@Setter
public class FindIdForm {

    private static final String NAME_PATTERN = "^$|^[가-힣a-zA-Z]{2,10}$";
    private static final String PHONE_PATTERN = "^$|^01(?:0|1|[6-9])-(?:\\d{3}|\\d{4})-\\d{4}$";
    private static final String EMAIL_PATTERN = "^$|^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";


    @NotBlank(message = "{error.required.name}")
    @Pattern(regexp = NAME_PATTERN, message = "{error.input.name}")
    private String name;

    @NotBlank(message = "{error.required.email}")
    @Email(regexp = EMAIL_PATTERN, message = "{error.input.email}")
    private String email;

    @NotBlank( message = "{error.required.phoneNo}")
    @Pattern(regexp = PHONE_PATTERN, message = "{error.input.phone}")
    private String phone;
}
