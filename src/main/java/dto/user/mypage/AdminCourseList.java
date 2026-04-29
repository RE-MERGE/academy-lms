package dto.user.mypage;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AdminCourseList {

    private int course_no;
    private String course_name;
    private String course_type;
    private String classroom;       // room_info
    private String day_of_week;
    private String start_time;
    private String end_time;
    private int credits;
    private int max_students;
    private String status;
    private String apply_date;      // created_at
    private String semester;
    private String prof_name;       // USERS.name
    private String user_code;     // USERS.user_code
    private String curriculum_pdf;
}