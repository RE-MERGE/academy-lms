package dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Course {
	private int course_no;
	private int professor_no;
    private String course_name;
    private String course_type;
    private String room_info;
    private String day_of_week;
    private String start_time;
    private String end_time;
    private int max_students;
    private String status;
    private LocalDateTime created_at;
    private String semester;
    private int credits;
    private int counts;
}
