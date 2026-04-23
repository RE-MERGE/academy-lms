package exception;

public class UnauthorizedException extends RuntimeException {

    public UnauthorizedException() {
        super("권한이 없습니다.");
    }

    public UnauthorizedException(String message) {
        super(message);
    }
}
