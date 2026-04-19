package dto.user;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class LoginUser {

    private int userNo;
    private String userId;
    private String name;
    private UserRole role;
    private String profileImg;
}
