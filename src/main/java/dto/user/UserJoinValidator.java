package dto.user;

import org.springframework.stereotype.Component;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import service.UserService;

@Component
public class UserJoinValidator implements Validator {

    private final UserService userService;

    public UserJoinValidator(UserService userService) {
        this.userService = userService;
    }

    @Override
    public boolean supports(Class<?> clazz) {
        return UserJoinForm.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {

        UserJoinForm form = (UserJoinForm) target;

        validatePasswordMatch(form, errors);
        validateDuplicateId(form, errors);
        validateDuplicateEmail(form, errors);

    }

    private void validateDuplicateEmail(UserJoinForm form, Errors errors) {
        if (userService.selectUserIdByEmail(form.getEmail()) != null) {
            errors.rejectValue("email", "error.duplication.email");
        }
    }

    private void validateDuplicateId(UserJoinForm form, Errors errors) {
        if (userService.selectUser(form.getUserId()) != null) {
            errors.rejectValue("userId", "error.duplication.userId");
        }
    }



    private static void validatePasswordMatch(UserJoinForm userJoinForm, Errors errors) {

        if(errors.hasFieldErrors("passwordConfirm")) return;

        if (userJoinForm.getPassword() != null && userJoinForm.getPasswordConfirm() != null) {
            if (!userJoinForm.getPassword().equals(userJoinForm.getPasswordConfirm())) {
                errors.rejectValue("passwordConfirm", "error.mismatch.password", null);
            }
        }
    }
}
