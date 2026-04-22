package dto.user;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import java.time.LocalDate;

@Getter
@Setter
@ToString
public class UserEditForm {

    //현재 이미지 보여줄거
    private String currentProfileImg;

    //마이페이지에서 이미지 변경시,
    private MultipartFile profileImg;
    private String userId;

    @NotBlank(message = "{error.required.name}")
    @Pattern(regexp = UserPattern.NAME_PATTERN, message = "{error.input.name}")
    private String name;

    @NotBlank(message = "{error.required.email}")
    @Email(regexp = UserPattern.EMAIL_PATTERN, message = "{error.input.password}")
    private String email;


    @NotBlank( message = "{error.required.phoneNo}")
    @Pattern(regexp = UserPattern.PHONE_PATTERN, message = "{error.input.phone}")
    private String phone;

    //최소 8자 이상, 영문자와 숫자 최소 1개씩 포함
    @NotBlank(message = "{error.required.password}")
    private String password;

    private LocalDate updatedAt;      // 비밀번호 마지막 변경 시간


    public UserEditForm(){}

    public UserEditForm(String currentProfileImg, String userId, String name, String email, String phone, String password) {
        this.currentProfileImg = currentProfileImg;
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.password = password;
    }
}
