package service;

import dao.BoardDao;
import dto.board.*;
import dto.user.UserRole;
import exception.PostAccessDeniedException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BoardService {

    @Autowired
    BoardDao boardDao;
    @Value("${page.size}")
    private int PAGE_SIZE;
    @Value("${page.block-size}")
    private int BLOCK_SIZE;

    public void insertPost(PostCreate board, int writerNo, UserRole role) {
        // 공지 게시판은 PROFESSOR, ADMIN만 작성 가능
//        if ("NOTICE".equals(board.getBoardType())) {
//            if (role != role.PROFESSOR && role.ADMIN) {
//                throw new PostAccessDeniedException("공지 게시판 작성 권한이 없습니다.");
//            }
//        }
        boardDao.insertPost(board, writerNo);
    }

    public PostDetail postDetail(int boardNo) {
        return boardDao.postDetail(boardNo);
    }


    public void updatePost(PostUpdate postUpdate, int userNo) {
        PostDetail post = boardDao.postDetail(postUpdate.getBoardNo());
        if (post.getWriterNo() != userNo) {
            throw new PostAccessDeniedException();
        }
        boardDao.updatePost(postUpdate);
    }

    public void deletePost(String boardNo, int userNo) {
        PostDetail post = boardDao.postDetail(Integer.parseInt(boardNo));
        if (post.getWriterNo() != userNo) {
            throw new PostAccessDeniedException();
        }
        boardDao.deletePost(boardNo);
    }

    public Map<String, Object> getBoardList(String boardType, String keyword,
                                            String searchType, int page) {
        int totalCount = boardDao.getTotalCount(boardType, keyword, searchType);
        PageInfo pageInfo = new PageInfo(page, totalCount, PAGE_SIZE, BLOCK_SIZE);

        BoardListRequest dto = new BoardListRequest();
        dto.setBoardType(boardType);
        dto.setKeyword(keyword);
        dto.setSearchType(searchType);
        dto.setOffset(pageInfo.getOffset());
        dto.setPageSize(PAGE_SIZE);

        List<PostList> postList = boardDao.getList(dto);

        // rowNum 세팅
        int rowNum = totalCount - pageInfo.getOffset();
        for (PostList post : postList) {
            post.setRowNum(rowNum--);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("postList", postList);
        result.put("pageInfo", pageInfo);
        return result;
    }
}
