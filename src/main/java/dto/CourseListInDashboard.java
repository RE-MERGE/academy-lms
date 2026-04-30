package dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CourseListInDashboard {

    private int course_no;
    private String course_name;    // 강의 이름
    private String professor_name; // 교수 이름
    private String day_of_week;     // 강의 요일
    private String status;        // 강의 상태 (APPROVED, PENDING)
    private LocalDateTime start_time;        // 강의 상태 (APPROVED, PENDING)
    private LocalDateTime end_time;        // 강의 상태 (APPROVED, PENDING)
}
