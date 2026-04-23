package service;

import dao.CommentDao;
import dao.mapper.CommentMapper;
import dto.board.Comment;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentDao commentDao;

    // 댓글 목록 (원댓글 아래 대댓글 조립)
    public List<Comment> getCommentTree(int boardNo) {
        List<Comment> flat = commentDao.selectByBoardNo(boardNo);
        Map<Integer, Comment> rootMap = new LinkedHashMap<>();
        List<Comment> result = new ArrayList<>();

        if (flat == null) return result;

        for (Comment c : flat) {
            // depth가 0이면 무조건 원댓글로 처리
            if (c.getDepth() == 0) {
                c.setReplies(new ArrayList<>());
                rootMap.put(c.getCommentNo(), c);
                result.add(c);
            }
            // depth가 0이 아닌 대댓글일 때만 부모 찾기
            else {
                Integer rNo = c.getRootNo();
                if (rNo != null && rootMap.containsKey(rNo)) {
                    Comment root = rootMap.get(rNo);
                    root.getReplies().add(c);
                }
            }
        }
        return result;
    }

    // 원댓글 등록
    @Transactional
    public void writeComment(Comment dto) {
        commentDao.insertRoot(dto);
        commentDao.updateRootNo(dto.getCommentNo()); // root_no = 자기 PK
    }

    // 대댓글 등록
    @Transactional
    public void writeReply(Comment dto) {
        commentDao.insertReply(dto);
    }

    // 댓글 삭제
    @Transactional
    public boolean deleteComment(int commentNo, int requesterNo, boolean isAdmin) {
        int affected = isAdmin
            ? commentDao.deleteByAdmin(commentNo)
            : commentDao.deleteByWriter(commentNo, requesterNo);
        return affected > 0;
    }
}
