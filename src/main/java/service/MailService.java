package service;

import lombok.RequiredArgsConstructor;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class MailService {

    private final MailSender mailSender;

    @Transactional
    public void sendTempPasswordEmail(String email, String tempPassword) {

        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("alswo818@naver.com");
        message.setTo(email);
        message.setSubject("[re-merge LMS] 임시 비밀번호 발급 ");
        message.setText("안녕하세요, [re-merge LMS]입니다. \n" +
                "요청하신 임시 비밀번호는 [ " + tempPassword + "] 입니다.\n" +
                "로그인 후 반드시 비밀번호를 변경해주세요.");

        mailSender.send(message);
    }

}
