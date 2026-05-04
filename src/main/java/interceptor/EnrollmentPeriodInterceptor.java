package interceptor;

import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.time.DayOfWeek;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

import dto.user.SessionUser;
import dto.user.UserRole;
import dto.user.UserConst;

public class EnrollmentPeriodInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        SessionUser sessionUser = (SessionUser) request.getSession().getAttribute(UserConst.SESSION_USER);

        // 로그인 안 했거나 STUDENT가 아니면 통과
        if (sessionUser == null || sessionUser.getRole() != UserRole.STUDENT) {
            return true;
        }

        // 수강신청 기간 체크
        if (!isEnrollmentPeriod()) {
        	response.setContentType("text/html; charset=UTF-8");
        	response.getWriter().write(
        	    "<script>alert('수강신청 기간이 아닙니다.'); location.href='" 
        	    + request.getContextPath() + "/dashboard/dashboard';</script>"
        	);
        	return false;
        }

        return true;
    }

    private boolean isEnrollmentPeriod() {
        LocalDate today = LocalDate.now();
        int year = today.getYear();

        // 1학기 예비: 2월 둘째주 월요일 ~ 그 다음주 일요일
        LocalDate sem1PreStart = getSecondMonday(year, 2);
        LocalDate sem1PreEnd   = sem1PreStart.plusDays(13); // 2주 (월~일)

        // 1학기 본: 3월 2일(주말이면 다음 월요일) ~ 1주일
        LocalDate sem1MainStart = getWeekdayStart(year, 3, 2);
        LocalDate sem1MainEnd   = sem1MainStart.plusDays(6);

        // 2학기 예비: 8월 둘째주 월요일 ~ 그 다음주 일요일
        LocalDate sem2PreStart = getSecondMonday(year, 8);
        LocalDate sem2PreEnd   = sem2PreStart.plusDays(13);

        // 2학기 본: 9월 1일(주말이면 다음 월요일) ~ 1주일
        LocalDate sem2MainStart = getWeekdayStart(year, 9, 1);
        LocalDate sem2MainEnd   = sem2MainStart.plusDays(6);

        return isBetween(today, sem1PreStart, sem1PreEnd)
            || isBetween(today, sem1MainStart, sem1MainEnd)
            || isBetween(today, sem2PreStart, sem2PreEnd)
            || isBetween(today, sem2MainStart, sem2MainEnd);
    }

    /** 해당 연도/월의 둘째주 월요일 */
    private LocalDate getSecondMonday(int year, int month) {
        LocalDate firstMonday = LocalDate.of(year, month, 1)
            .with(TemporalAdjusters.nextOrSame(DayOfWeek.MONDAY));
        return firstMonday.plusWeeks(1);
    }

    /** 해당 날짜가 주말이면 다음 월요일 반환 */
    private LocalDate getWeekdayStart(int year, int month, int day) {
        LocalDate date = LocalDate.of(year, month, day);
        DayOfWeek dow = date.getDayOfWeek();
        if (dow == DayOfWeek.SATURDAY) return date.plusDays(2);
        if (dow == DayOfWeek.SUNDAY)   return date.plusDays(1);
        return date;
    }

    /** start ~ end 사이인지 (양 끝 포함) */
    private boolean isBetween(LocalDate target, LocalDate start, LocalDate end) {
        return !target.isBefore(start) && !target.isAfter(end);
    }
}
