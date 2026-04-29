package service;

import dao.CourseDao;
import dao.EnrollmentDao;
import dao.UserDao;
import dto.Course;
import dto.user.*;
import dto.user.grade.MyGrade;
import dto.user.grade.MyGradeRow;
import dto.user.mypage.MyPageData;
import dto.user.mypage.TimetableData;
import dto.user.mypage.TimetableResult;
import dto.user.mypage.UserDetailForAdmin;
import exception.LoginFailException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserDao dao;
    private final MailService mailService;
    private final FileService fileService;
    private final CourseDao courseDao;
    private final EnrollmentDao enrollmentDao;
    private final BCryptPasswordEncoder passwordEncoder;

    public void join(UserJoinForm form) {

        validateDuplicateUser(form);

        User user = createUser(form);
        dao.join(user);
    }

    private void validateDuplicateUser(UserJoinForm form) {

        if (selectUser(form.getUserId()) != null) {
            throw new IllegalStateException("이미 존재하는 아이디입니다.");
        }

        if (selectUserIdByEmail(form.getEmail()) != null) {
            throw new IllegalStateException("이미 존재하는 이메일입니다");
        }
    }

    public User selectUser(String userId) {
        return dao.selectUser(userId);
    }

    public boolean withdraw(String userId, String password) {

        User dbUser = dao.selectUser(userId);

        if (dbUser != null && passwordEncoder.matches(password, dbUser.getPassword())) {
            dao.updateStatus(userId, UserStatus.DELETE);
            return true;
        }

        return false;
    }

    public MyPageData getMyPageData(SessionUser sessionUser, String semester) {
        int userNo = sessionUser.getUserNo();
        UserRole role = sessionUser.getRole();

        return switch (role) {
            case STUDENT -> buildStudentData(userNo, semester);
            case PROFESSOR -> buildProfessorData(userNo, semester);
            case ADMIN -> buildAdminData(semester);
        };
    }

    public MyPageData getMyPageData(UserDetailForAdmin targetUser, String semester) {
        int userNo = targetUser.getUserNo();
        UserRole role = targetUser.getRole();

        return switch (role) {
            case STUDENT -> buildStudentData(userNo, semester);
            case PROFESSOR -> buildProfessorData(userNo, semester);
            case ADMIN -> buildAdminData(semester);
        };
    }


    private MyPageData buildStudentData(int userNo, String semester) {
        List<Course> courseList = courseDao.getStudentCourseList(userNo, semester);
        List<MyGrade> gradeList = enrollmentDao.getStudentMyGradeList(userNo);

        System.err.println("courseList size: " + courseList.size());
        courseList.forEach(c -> System.err.println(c.getCourse_name() + " " + c.getDay_of_week() + " " + c.getStart_time()));

        return MyPageData.builder()
                .courseList(courseList)
                .gradeList(gradeList)
                .gradeRows(convertToGradeRows(gradeList))
                .timeTableData(buildTimetableData(courseList))
                .build();
    }

    private MyPageData buildAdminData(String semester) {

        return MyPageData.builder()
                .courseList(courseDao.getListWithProfessorName(semester))
                .gradeList(enrollmentDao.getAllStudentGrades())
                .build();
    }

    private MyPageData buildProfessorData(int userNo, String semester) {

        List<Course> courseList = courseDao.getProfessorMyCourseMap(userNo, semester);

        return MyPageData.builder()
                .courseList(courseList)
                .gradeList(enrollmentDao.getProfessorMyGradeList(userNo, semester))
                .timeTableData(buildTimetableData(courseList)) // 추가
                .build();
    }

    private List<MyGradeRow> convertToGradeRows(List<MyGrade> gradeList) {

        Map<String, MyGradeRow> rowMap = new LinkedHashMap<>();

        for (MyGrade grade : gradeList) {

            String key = grade.getCourseName();

            rowMap.putIfAbsent(key, new MyGradeRow());
            MyGradeRow row = rowMap.get(grade.getCourseName());
            row.setCourseName(grade.getCourseName());
            row.setCourseType(grade.getCourseType());

            if ("MIDTERM".equals(grade.getExamType())) {
                row.setMidterm(grade);
            } else if ("FINAL".equals(grade.getExamType())) {
                row.setFinalExam(grade);
            } else {
                row.setAttendance(grade);
            }
        }
        return new ArrayList<>(rowMap.values());
    }

    public String selectUserIdByEmail(String email) {
        return dao.selectUserIdByEmail(email);
    }

    public String selectUserPassword(String userId, String email,  String phone) {
        return dao.selectUserPassword(userId, email, phone);
    }

    public void updatePassword(String userId, String tempPassword) {
        dao.updatePassword(userId, tempPassword);
    }

    public void updateProfileImg(String userId, String currentProfileImg) {
        dao.updateProfileImg(userId, currentProfileImg);
    }

    public void updateInfo(UserEditForm userEditForm) {
        dao.updateInfo(userEditForm);
    }

    public void updateStatus(String userId, UserStatus delete) {
        dao.updateStatus(userId, delete);
    }

    public SessionUser login(String userId, String password) {

        User dbUser = dao.selectUser(userId);

        if (dbUser == null) {
            throw new LoginFailException("error.loginFail");
        }

        //장기 미접속 확인
        lockIfInactive(dbUser);

        //계정 상태 확인
        validateStatus(dbUser);

        //비밀번호 검증
        validatePassword(userId, password, dbUser);

        dao.resetLockCount(userId);
        return new SessionUser(dbUser);
    }

    private void validatePassword(String userId, String password, User dbUser) {

        if (!passwordEncoder.matches(password, dbUser.getPassword())) {
            int newCount = dbUser.getLock_count() + 1;

            if (newCount >= 5) {
                dao.updateStatus(userId, UserStatus.LOCKED);
                dao.resetLockCount(userId);
                throw new LoginFailException("error.status.locked");
            }
            dao.updateLockCount(userId, newCount);
            throw new LoginFailException("error.loginFail");
        }
    }

    private void validateStatus(User dbUser) {

        if (dbUser.getStatus() == UserStatus.LOCKED) {
            throw new LoginFailException("error.status.locked");
        }

        if (dbUser.getStatus() != UserStatus.ACTIVE) {
            throw new LoginFailException("error.status.notActive");
        }
    }

    private void lockIfInactive(User dbUser) {

        if(dbUser.getLastLoginAt() == null) return;

        long daysSinceLastLogin = ChronoUnit.DAYS.between(
                dbUser.getLastLoginAt(), LocalDate.now()
        );

        if (daysSinceLastLogin >= 90) {
            dao.updateStatus(dbUser.getUserId(), UserStatus.LOCKED);
            throw new LoginFailException("error.account.locked.inactive");
        }
    }

    @Transactional
    public void processForgotPassword(String userId, String email, String phone) {

        String selectedUser = dao.selectUserPassword(userId, email, phone);

        if (selectedUser == null || selectedUser.trim().isEmpty()) {
            throw new IllegalArgumentException("error.mismatch.info");
        }

        String tempPassword = UUID.randomUUID().toString().substring(0, 8);
        dao.updatePassword(userId, passwordEncoder.encode(tempPassword));

        mailService.sendTempPasswordEmail(email, tempPassword);
    }


    private int getUserCode() {

        int currentYear = LocalDate.now().getYear();
        Integer lastUserCode = dao.getLastUserCode();

        if (lastUserCode == null) {
            return currentYear * 10000 + 1;
        }

        int lastYear = lastUserCode / 10000;

        if (currentYear > lastYear) {
            return currentYear * 10000 + 1;
        } else {
            return lastUserCode + 1;
        }

    }

    public User createUser(UserJoinForm userJoinForm) {
        String profileImage = "";

        if (userJoinForm.getProfileImg() != null && !userJoinForm.getProfileImg().isEmpty()) {
            profileImage = fileService.saveProfileImage(userJoinForm.getProfileImg());
        }

        int findUserCode = getUserCode();

        User joinUser = new User();
        joinUser.setUserCode(findUserCode);
        joinUser.setUserId(userJoinForm.getUserId());
        joinUser.setPassword(passwordEncoder.encode(userJoinForm.getPassword()));
        joinUser.setName(userJoinForm.getName());
        joinUser.setEmail(userJoinForm.getEmail());
        joinUser.setPhone(userJoinForm.getPhone());
        joinUser.setRole(UserRole.valueOf(userJoinForm.getRole().toUpperCase()));
        joinUser.setStatus(UserStatus.PENDING);
        joinUser.setProfileImg(profileImage);
        joinUser.setCreatedAt(LocalDateTime.now());
        joinUser.setLast_password_changed(LocalDate.now());
        joinUser.setLock_count(0);
        joinUser.setLastLoginAt(LocalDate.now());
        joinUser.setUpdatedAt(LocalDate.now());

        return joinUser;
    }

    public void updateLastLogin(String userId) {
        dao.updateLastLogin(userId);
    }

    public String getSemester() {

        String year = String.valueOf(LocalDate.now().getYear());
        int month = LocalDate.now().getMonthValue();

        String semester = "-";

        if (month <= 6) {
            month = 1;
        } else {
            month = 2;
        }

        return year += semester += String.valueOf(month);
    }

	public Integer getProfNo(int code) {
		return dao.getProfNo(code);
	}

	public int getUserCodeByProfNo(int professor_no) {
		return dao.getUserCode(professor_no);
	}

    private TimetableResult buildTimetableData(List<Course> courseList) {

        if (courseList == null || courseList.isEmpty()) {
            return new TimetableResult(Collections.emptyList(), 9, 17);
        }

        int minHour = 9;
        int maxHour = 17;

        return new TimetableResult(buildTimetableCells(courseList, minHour), minHour, maxHour);
    }

    public List<TimetableData> buildTimetableCells(List<Course> courseList, int minHour) {
        Map<String, Integer> dayCol = Map.of(
                "월", 1, "화", 2, "수", 3, "목", 4, "금", 5
        );

        List<TimetableData> cells = new ArrayList<>();

        for (Course course : courseList) {
            if (course.getDay_of_week() == null || course.getDay_of_week().isEmpty()) continue; // 추가
            String[] days = course.getDay_of_week().split(",");

            for (String day : days) {
                day = day.trim();

                System.err.println("day='" + day + "' length=" + day.length() + " colIndex=" + dayCol.getOrDefault(day, 2));

                int startHour = parseHour(course.getStart_time());
                int endHour = parseHour(course.getEnd_time());

                TimetableData cell = new TimetableData();
                cell.setCourseNo(course.getCourse_no());
                cell.setCourseName(course.getCourse_name());
                cell.setRoomInfo(course.getRoom_info());
                cell.setDayOfWeek(day);
                cell.setRowStart(startHour - minHour + 1);
                cell.setRowSpan(endHour - startHour);
                cell.setColIndex(dayCol.getOrDefault(day, 2));
                cells.add(cell);
            }
        }

        cells.forEach(c -> System.err.println(
                c.getCourseName() + " rowStart=" + c.getRowStart() + " rowSpan=" + c.getRowSpan() + " colIndex=" + c.getColIndex()
        ));

        return cells;
    }

    // "11:00:00" → 11
    private int parseHour(String time) {
        if (time == null) return 9;
        return Integer.parseInt(time.split(":")[0]);
    }

    public String getNameByUserCode(int userCode) {
        return dao.getNameByUserCode(userCode);
    }


}
