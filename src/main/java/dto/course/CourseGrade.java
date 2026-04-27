package dto.course;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CourseGrade {
	private int grade_no;
	private int enrollment_no;
	private int score;
	private String type;
	private String alphabet;
}
