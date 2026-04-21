package service;

import dao.BoardDao;
import dto.board.*;
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
    private int pageSize;
    @Value("${page.block-size}")
    private int blockSize;

    public Map<String, Object> page(int page, int totalCount) {
        Map<String, Object> result = new HashMap<>();

        // 전체 페이지 수 계산
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);

        // 시작 페이지
        int startPage = ((page - 1) / blockSize) * blockSize + 1;

        // 끝 페이지
        int endPage = startPage + blockSize - 1;

        // 마지막 페이지 보정
        if (endPage > totalPage) {
            endPage = totalPage;
        }

        // 이전 / 다음 블럭 여부
        boolean prev = startPage > 1;
        boolean next = endPage < totalPage;

        // 결과 담기
        result.put("page", page);
        result.put("startPage", startPage);
        result.put("endPage", endPage);
        result.put("totalPage", totalPage);
        result.put("prev", prev);
        result.put("next", next);

        return result;
    }

    public void insertPost(PostCreate board, int writerNo) {
        boardDao.insertPost(board, writerNo);
    }

    public List<PostList> postList(Integer courseNo, String boardType) {
        return boardDao.postList(courseNo, boardType);
    }

    public PostDetail postDetail(int boardNo) {
        return boardDao.postDetail(boardNo);
    }
}
