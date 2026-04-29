package service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class SupabaseStorageService {

    @Value("${supabase.url}")
    private String supabaseUrl;

    @Value("${supabase.key}")
    private String supabaseKey;

    @Value("${supabase.bucket}")
    private String bucket;

    public String uploadPdf(MultipartFile file, String semester) throws Exception {
        if (file == null || file.isEmpty()) return null;
        byte[] bytes = file.getBytes();
        if (!isPdf(bytes)) {
            throw new IllegalArgumentException("올바른 PDF 파일이 아닙니다.");
        }
        
        String fileName = "file_" + System.currentTimeMillis() + ".pdf";
        String path = semester + "/" + fileName;

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
        	    .uri(URI.create(supabaseUrl + "/storage/v1/object/" + bucket + "/" + path))
        	    .header("apikey", supabaseKey)          // ← Authorization 대신 apikey 헤더로
        	    .header("Content-Type", "application/pdf")
        	    .header("x-upsert", "true")
        	    .POST(HttpRequest.BodyPublishers.ofByteArray(file.getBytes()))
        	    .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new IOException("Supabase 업로드 실패: " + response.body());
        }

        // 공개 접근 URL 반환
        return supabaseUrl + "/storage/v1/object/public/" + bucket + "/" + path;
    }
    public String uploadImg(MultipartFile file) throws Exception {
        if (file == null || file.isEmpty()) return null;

        String originalFilename = file.getOriginalFilename();
        String ext = originalFilename != null && originalFilename.contains(".")
                ? originalFilename.substring(originalFilename.lastIndexOf("."))  // ".jpg", ".png" 등
                : "";

        byte[] bytes = file.getBytes();
        if (!matchesMagicBytes(bytes, ALLOWED_IMAGE_SIGNATURES.get(ext))) {
            throw new IllegalArgumentException("올바른 이미지 파일이 아닙니다.");
        }
        String fileName = "img_" + System.currentTimeMillis() + ext;
        String path = "profile" + "/" + fileName;

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(supabaseUrl + "/storage/v1/object/" + bucket + "/" + path))
                .header("apikey", supabaseKey)
                .header("Content-Type", file.getContentType())  // image/jpeg, image/png 자동
                .header("x-upsert", "true")
                .POST(HttpRequest.BodyPublishers.ofByteArray(file.getBytes()))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new IOException("Supabase 업로드 실패: " + response.body());
        }

        return supabaseUrl + "/storage/v1/object/public/" + bucket + "/" + path;
    }
    
    private boolean isPdf(byte[] bytes) {
        // PDF는 항상 %PDF- 로 시작 (hex: 25 50 44 46 2D)
        return bytes.length > 4
            && bytes[0] == 0x25  // %
            && bytes[1] == 0x50  // P
            && bytes[2] == 0x44  // D
            && bytes[3] == 0x46  // F
            && bytes[4] == 0x2D; // -
    }
    private static final Map<String, byte[]> ALLOWED_IMAGE_SIGNATURES = Map.of(
    	    ".jpg",  new byte[]{(byte)0xFF, (byte)0xD8, (byte)0xFF},
    	    ".jpeg", new byte[]{(byte)0xFF, (byte)0xD8, (byte)0xFF},
    	    ".jfif", new byte[]{(byte)0xFF, (byte)0xD8, (byte)0xFF},
    	    ".png",  new byte[]{(byte)0x89, 0x50, 0x4E, 0x47}
    	);
    private boolean matchesMagicBytes(byte[] fileBytes, byte[] signature) {
        if (fileBytes.length < signature.length) return false;
        for (int i = 0; i < signature.length; i++) {
            if (fileBytes[i] != signature[i]) return false;
        }
        return true;
    }
}
