package dto.user;

public interface UserPattern {

    public static final String PASSWORD_PATTERN = "^$|^(?=.*[A-Za-z])(?=.*\\d).{8,}$";
    public static final String PHONE_PATTERN = "^$|^01(?:0|1|[6-9])-(?:\\d{3}|\\d{4})-\\d{4}$";
    public static final String EMAIL_PATTERN = "^$|^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    public static final String NAME_PATTERN = "^$|^[가-힣a-zA-Z]{2,10}$";
}
