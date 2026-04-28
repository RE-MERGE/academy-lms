package service;

import config.NaverLoginConfig;
import dao.UserDao;
import dto.user.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class NaverLoginService {

    private final NaverLoginConfig naverLoginConfig;
    private final RestTemplate restTemplate;
    private final UserDao userDao;
    private final BCryptPasswordEncoder passwordEncoder;

    public String getAccessToken(String code, String state) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", naverLoginConfig.getClientId());
        params.add("client_secret", naverLoginConfig.getClientSecret());
        params.add("code", code);
        params.add("state", state);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
        ResponseEntity<Map> response = restTemplate.postForEntity(
                "https://nid.naver.com/oauth2.0/token", request, Map.class);

        return (String) response.getBody().get("access_token");
    }

    public Map<String, Object> getUserInfo(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity entity = new HttpEntity(headers);

        ResponseEntity<Map> response = restTemplate.exchange(
                "https://openapi.naver.com/v1/nid/me", HttpMethod.GET, entity, Map.class);

        return (Map<String, Object>) response.getBody().get("response");
    }

    public SessionUser processNaverLogin(String code, String state) {

        String accessToken = getAccessToken(code, state);

        // 사용자 정보 요청
        Map<String, Object> userInfo = getUserInfo(accessToken);

        String naverId = (String) userInfo.get("id");
        String name = (String) userInfo.get("name");
        String email = (String) userInfo.get("email");

        User dbUser = userDao.selectUserByNaverId(UserConst.NAVER_LOGIN_USER + naverId);

        if (dbUser == null) {
            dbUser = new User();
            dbUser.setUserId(UserConst.NAVER_LOGIN_USER + naverId);
            dbUser.setName(name);
            dbUser.setEmail(email != null ? email : "");
            dbUser.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
            dbUser.setRole(UserRole.STUDENT);
            dbUser.setStatus(UserStatus.ACTIVE); // 네이버 로그인은 바로 활성화
            dbUser.setProfileImg(UserConst.DEFAULT_PROFILE_IMG);
            dbUser.setCreatedAt(LocalDateTime.now());
            dbUser.setLast_password_changed(LocalDate.now());
            dbUser.setLock_count(0);
            dbUser.setLastLoginAt(LocalDate.now());
            dbUser.setUserCode(userDao.getLastUserCode() + 1);

            userDao.join(dbUser);
        }

        return new SessionUser(dbUser);

    }

}
