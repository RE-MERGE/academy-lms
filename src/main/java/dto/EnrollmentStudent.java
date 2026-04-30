package dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class EnrollmentStudent {
    private int enrollmentNo;
    private int studentNo;
    private String userCode;
    private String name;
    private String email;
    private String phone;
    private String status;  // PENDING, APPROVED
}