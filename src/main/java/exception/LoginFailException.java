package exception;

public class LoginFailException extends RuntimeException {

    private String errorCode;

    public LoginFailException(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getErrorCode() {
        return errorCode;
    }
}
