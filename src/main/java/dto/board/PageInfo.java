package dto.board;

import lombok.Getter;

import java.util.Map;

@Getter
public class PageInfo {
    private final int currentPage;
    private final int totalPages;
    private final int startPage;
    private final int endPage;
    private final int prevBlock;
    private final int nextBlock;
    private final int offset;       // SQL용: (page-1) * pageSize

    public PageInfo(int currentPage, int totalCount, int pageSize, int blockSize) {
        this.currentPage = currentPage;

        this.totalPages   = (int) Math.ceil((double) totalCount / pageSize);
        this.offset       = (currentPage - 1) * pageSize;

        int currentBlock  = (int) Math.ceil((double) currentPage / blockSize);
        this.startPage    = (currentBlock - 1) * blockSize + 1;
        this.endPage      = Math.min(startPage + blockSize - 1, totalPages);
        this.prevBlock    = startPage - 1;
        this.nextBlock    = endPage + 1;
    }

    // PageInfo.java에 추가
    public Map<String, Object> toMap() {
        return Map.of(
                "currentPage", currentPage,
                "totalPages",  totalPages,
                "startPage",   startPage,
                "endPage",     endPage,
                "prevBlock",   prevBlock,
                "nextBlock",   nextBlock
        );
    }
}