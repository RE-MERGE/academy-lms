package sitemesh;

import javax.servlet.annotation.WebFilter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

@WebFilter("/*")
public class SitemeshFilter extends ConfigurableSiteMeshFilter{
	// Connection Pool
    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder){
        builder.addDecoratorPath("/*", "layout.jsp")
                .addExcludedPath("/ajax/*") // 요청 url이 /ajax/ 인 모든 요청에 대해서 layout 적용 안하도록 설정
                .addExcludedPath("/user/idsearch*")
                .addExcludedPath("/user/pwsearch*")
                .addExcludedPath("/home/home");
    }
    
}
