package controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import dto.Course;
import dto.CourseListInDashboard;
import dto.board.PostDetail;
import dto.user.SessionUser;
import dto.user.UserRole;
import dto.user.login.Login;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import service.BoardService;
import service.CourseService;
import service.EnrollmentService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("dashboard")
public class DashboardController {

    @Autowired
    private BoardService boardService;

    @Autowired
    private CourseService courseService;

    @Autowired
    private EnrollmentService enrollmentService;

    @GetMapping("dashboard")
    public String dashboard(Model model, @Login SessionUser sessionUser) throws JsonProcessingException {

        List<PostDetail> noticeListInDashboard = boardService.getNoticeListInDashboard();
        List<PostDetail> freeListInDashboard = boardService.getFreeListInDashboard();

        if (sessionUser.getRole() == UserRole.STUDENT) {
            List<CourseListInDashboard> courseListInDashboard = courseService.getMyCourseInDashboard(sessionUser.getUserNo());
            model.addAttribute("courseListDashboard", courseListInDashboard);
        } else if (sessionUser.getRole() == UserRole.PROFESSOR) {
            List<Course> courseListInDashboard = courseService.getCourseListWithProfessorInDashboard(sessionUser.getUserNo());
            model.addAttribute("courseListDashboard", courseListInDashboard);
        } else if (sessionUser.getRole() == UserRole.ADMIN) {
            String semester = "2026-1";
            model.addAttribute("pendingEnrollmentList", enrollmentService.getPendingEnrollmentList());
            model.addAttribute("roomList", courseService.getRoomList(semester));

            List<Course> allCourses = courseService.getAllCoursesForTimetable(semester);
            // JSON으로 변환해서 넘기기
            ObjectMapper mapper = new ObjectMapper();
            model.addAttribute("adminRoomCoursesJson", mapper.writeValueAsString(allCourses));
        }

        model.addAttribute("noticeListInDashboard", noticeListInDashboard);
        model.addAttribute("freeListInDashboard", freeListInDashboard);

        return "home/dashboard";
    }

    @GetMapping("my-courses")
    @ResponseBody
    public Map<String, Object> getProfessorCourses(@Login SessionUser sessionUser) {
        Map<String, Object> response = new HashMap<>();
        if (sessionUser.getRole() == UserRole.PROFESSOR) {
            List<Course> list = courseService.getCourseListWithProfessorInDashboard(sessionUser.getUserNo());
            response.put("courses", list);
        }
        return response;
    }

}

