package controller;

import dto.board.Comment;
import dto.user.SessionUser;
import dto.user.UserRole;
import dto.user.login.Login;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import service.CommentService;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/comment")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;

    // ── 댓글 목록 조회 ────────────────────────────────────────────
    @GetMapping("/list")
    public ResponseEntity<?> list(@RequestParam int boardNo) {
        List<Comment> tree = commentService.getCommentTree(boardNo);
        return ResponseEntity.ok(tree);
    }

    // ── 원댓글 등록 ───────────────────────────────────────────────
    @PostMapping("/write")
    public ResponseEntity<?> write(@RequestBody Comment dto, @Login SessionUser sessionUser,@RequestParam(required = false) String boardType) {
        if (sessionUser == null) {
            return ResponseEntity.status(401).body(Map.of("msg", "로그인이 필요합니다."));
        }
        if (dto.getContent() == null || dto.getContent().isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("msg", "내용을 입력해주세요."));
        }

        // 교수가 댓글 달면 답변완료
        if (sessionUser.getRole() == UserRole.PROFESSOR) {
            if ("QNA".equals(boardType)) {
                commentService.updateIsAnswered(dto.getBoardNo(), true);
            }
        }

        dto.setWriterNo(sessionUser.getUserNo());
        commentService.writeComment(dto);
        // 등록 후 최신 목록 반환
        return ResponseEntity.ok(commentService.getCommentTree(dto.getBoardNo()));
    }

    // ── 대댓글 등록 ───────────────────────────────────────────────
    @PostMapping("/reply")
    public ResponseEntity<?> reply(@RequestBody Comment dto, @Login SessionUser sessionUser) {
        if (sessionUser == null) {
            return ResponseEntity.status(401).body(Map.of("msg", "로그인이 필요합니다."));
        }
        if (dto.getContent() == null || dto.getContent().isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("msg", "내용을 입력해주세요."));
        }
        dto.setWriterNo(sessionUser.getUserNo());
        commentService.writeReply(dto);
        return ResponseEntity.ok(commentService.getCommentTree(dto.getBoardNo()));
    }

    // ── 댓글 삭제 ────────────────────────────────────────────────
    @DeleteMapping("/{commentNo}")
    public ResponseEntity<?> delete(
            @PathVariable int commentNo,
            @RequestParam int boardNo,
            @RequestParam(required = false) String boardType,
            @Login SessionUser sessionUser) {

        if (sessionUser == null) {
            return ResponseEntity.status(401).body(Map.of("msg", "로그인이 필요합니다."));
        }
        boolean isAdmin = UserRole.ADMIN.equals(sessionUser.getRole());
        boolean deleted = commentService.deleteComment(commentNo, sessionUser.getUserNo(), isAdmin);

        if (!deleted) {
            return ResponseEntity.status(403).body(Map.of("msg", "삭제 권한이 없습니다."));
        }

        // 교수 댓글 삭제하면 미답변으로
        if (sessionUser.getRole() == UserRole.PROFESSOR) {
            if ("QNA".equals(boardType)) {
                commentService.updateIsAnswered(boardNo, false);
            }
        }

        return ResponseEntity.ok(commentService.getCommentTree(boardNo));
    }
}
