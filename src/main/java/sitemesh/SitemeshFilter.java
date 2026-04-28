package sitemesh;

import javax.servlet.annotation.WebFilter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

@WebFilter("/*")
public class SitemeshFilter extends ConfigurableSiteMeshFilter {
    // Connection Pool
    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {

        builder.addDecoratorPath("/*", "layout.jsp")
                .addExcludedPath("/ajax/*") // 요청 url이 /ajax/ 인 모든 요청에 대해서 layout 적용 안하도록 설정
                .addExcludedPath("/home/findAccount")
                .addExcludedPath("/home/home")
                .addExcludedPath("/user/joinForm")
                .addExcludedPath("/user/findId")
                .addExcludedPath("/user/findPw")
                .addExcludedPath("/user/login")
                .addExcludedPath("/user/join")
                .addExcludedPath("/user/logout")
        		.addExcludedPath("/course/profScore")
        		.addExcludedPath("/course/stuScore");
    }
}
