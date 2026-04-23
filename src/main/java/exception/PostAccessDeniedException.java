package exception;

public class PostAccessDeniedException extends RuntimeException{
    public PostAccessDeniedException() {
        super("해당 게시글에 대한 권한이 없습니다.");
    }

    public PostAccessDeniedException(String message) {
        super(message);
    }

    public PostAccessDeniedException(String message, Throwable cause) {
        super(message, cause);
    }
}
