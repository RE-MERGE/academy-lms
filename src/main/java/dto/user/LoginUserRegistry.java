package dto.user;

import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@Component
public class LoginUserRegistry {

    private final Set<String> loggedInUsers = Collections.synchronizedSet(new HashSet<>());

    public boolean isLoggedIn(String userId) {
        return loggedInUsers.contains(userId);
    }

    public void login(String userId) {
        loggedInUsers.add(userId);
    }

    public void logout(String userId) {
        loggedInUsers.remove(userId);
    }
}
