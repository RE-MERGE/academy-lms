package dto;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Attendance {
	private int attendance_no;
    private int enrollment_no;
    private LocalDate attendance_date;
    private String status;
}
