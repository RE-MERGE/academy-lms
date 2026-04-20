package config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
// @PropertySource = “naver-login 파일 위치 등록”
@PropertySource("classpath:naver-login.properties")
@Getter
@Setter
public class NaverLoginConfig {

    @Value("${naver.client.id}")
    private String clientId;

    @Value("${naver.client.secret}")
    private String clientSecret;

    @Value("${naver.redirect.uri}")
    private String redirectUri;

    //네이버 로그인 화면으로 보내줄 인증 요청 URL 생성
    public String getNaverAuthorizeUrl(String state) {
        return "https://nid.naver.com/oauth2.0/authorize"
                + "?response_type=code"
                + "&client_id=" + clientId
                + "&redirect_uri=" + redirectUri
                + "&state=" + state;  // state는 보안을 위한 랜덤 문자열 (일단 임의값)
    }

    //엑세스 토컨 요청 URL
    public String getNaverTokenUrl(String code, String state) {
        return "https://nid.naver.com/oauth2.0/token"
                + "?grant_type=authorization_code"
                + "&client_id=" + clientId
                + "&client_secret=" + clientSecret
                + "&code=" + code
                + "&state=" + state;
    }
}
