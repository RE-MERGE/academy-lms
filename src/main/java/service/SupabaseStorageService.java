package service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
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
}
