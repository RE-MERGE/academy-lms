package service;

import dao.BoardDao;
import dto.board.*;
import dto.user.UserRole;
import exception.PostAccessDeniedException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class BoardService {

    @Autowired
    BoardDao boardDao;
    @Value("${page.size}")
    private int PAGE_SIZE;
    @Value("${page.block-size}")
    private int BLOCK_SIZE;
    @Value("${file.upload.path}")
    String uploadPath;

    public PostDetail detailPost(int boardNo) {
        return boardDao.detailPost(boardNo);
    }

    public void insertPost(PostCreate board, int writerNo) {
        MultipartFile uploadFile = board.getUploadFile();

        if (uploadFile != null && !uploadFile.isEmpty()) {
            // 디렉토리 없으면 자동 생성
            File dir = new File(uploadPath);
            if (!dir.exists()) {
                dir.mkdirs(); // ← 이게 없으면 저장 실패
            }

            String originalName = uploadFile.getOriginalFilename();
            String savedName = UUID.randomUUID() + "_" + originalName;
            File dest = new File(uploadPath + File.separator + savedName);
            try {
                uploadFile.transferTo(dest);
            } catch (IOException e) {
                throw new RuntimeException("파일 저장 실패", e);
            }
            board.setFileUrl(savedName);
        }

        boardDao.insertPost(board, writerNo);
    }

    public void updatePost(PostUpdate postUpdate) {
        MultipartFile uploadFile = postUpdate.getUploadFile();

        if (uploadFile != null && !uploadFile.isEmpty()) {
            // 기존 파일 삭제
            String oldFileUrl = postUpdate.getFileUrl();
            if (oldFileUrl != null) {
                File oldFile = new File(uploadPath + oldFileUrl);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }

            // 새 파일 저장
            String savedName = UUID.randomUUID() + "_" + uploadFile.getOriginalFilename();
            File dest = new File(uploadPath + File.separator + savedName);
            try {
                uploadFile.transferTo(dest);
            } catch (IOException e) {
                throw new RuntimeException("파일 저장 실패", e);
            }
            postUpdate.setFileUrl(savedName);
        }

        boardDao.updatePost(postUpdate);
    }

    public void deletePost(String boardNo, int userNo, UserRole role) {
        PostDetail post = boardDao.detailPost(Integer.parseInt(boardNo));
        if (role != UserRole.ADMIN && post.getWriterNo() != userNo) {
            throw new PostAccessDeniedException();
        }
        boardDao.deletePost(boardNo);
    }

    public Map<String, Object> getBoardList(Integer courseNo, String boardType, String keyword,
                                            String searchType, int page) {
        int totalCount = boardDao.getTotalCount(boardType, keyword, searchType);
        PageInfo pageInfo = new PageInfo(page, totalCount, PAGE_SIZE, BLOCK_SIZE);

        BoardListRequest dto = new BoardListRequest();
        dto.setCourseNo(courseNo);
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

    public void viewCount(int boardNo) {
        boardDao.viewCount(boardNo);
    }
}
