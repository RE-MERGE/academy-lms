package dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class EnrollmentPending {
    private int course_no;
    private String course_name;
    private String student_name;
    private String day_of_week;
}