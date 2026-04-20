package config;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.*;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.validation.Validator;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;
import org.springframework.web.servlet.i18n.FixedLocaleResolver;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import java.util.Locale;
import java.util.Properties;

@Configuration
@PropertySource("classpath:application.properties") // @PropertySource = “properties 파일 위치 등록”
@ComponentScan(basePackages = {"controller", "dto", "service", "dao", "aop","handler", "config"})
@EnableAspectJAutoProxy
@EnableWebMvc
public class MvcConfig implements WebMvcConfigurer {
    @Bean
    public HandlerMapping handlerMapping() {
        RequestMappingHandlerMapping hm = new RequestMappingHandlerMapping();
        hm.setOrder(0);
        return hm;
    }

    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver vr = new InternalResourceViewResolver();
        vr.setPrefix("/WEB-INF/view/");
        vr.setSuffix(".jsp");
        return vr;
    }

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    @Bean
    public MultipartResolver multipartResolver() {
        CommonsMultipartResolver mr = new CommonsMultipartResolver();
        mr.setMaxInMemorySize(1024 * 1024);
        mr.setMaxUploadSize(1024 * 1024);
        return mr;
    }

    //예외처리 객체 : 예외발생시 예외 처리해 주는 객체
    @Bean
    public SimpleMappingExceptionResolver exceptionHandler() {
        SimpleMappingExceptionResolver ser = new SimpleMappingExceptionResolver();
        Properties pr = new Properties();
        pr.put("exception.ShopException", "exception");
        ser.setExceptionMappings(pr);
        return ser;
    }

    // 메시지를 코드값으로 처리하기 위한 설정
    //setBasenames에 errors.properties 추가
    @Bean
    public MessageSource messageSource() {
        ResourceBundleMessageSource ms = new ResourceBundleMessageSource();
        ms.setBasenames("messages", "errors");
        ms.setDefaultEncoding("UTF-8");
        return ms;
    }

    //@Validated 사용하기 위해 설정 추가
    @Bean
    public LocalValidatorFactoryBean validator() {
        LocalValidatorFactoryBean bean = new LocalValidatorFactoryBean();
        bean.setValidationMessageSource(messageSource());
        return bean;
    }

    //@Validated 사용하기 위해 설정 추가
    @Override
    public Validator getValidator() {
        return validator();
    }

    // 인터셉터관련 설정
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
//        registry.addInterceptor(new BoardIntercepter()) 
//                .addPathPatterns("/board/write")
    }

    @Bean
    public LocaleResolver localeResolver() {
        FixedLocaleResolver resolver = new FixedLocaleResolver();
        resolver.setDefaultLocale(Locale.KOREA);
        return resolver;
    }

    // properties 파일(application.properties)을 읽어서
    // @Value("${...}") 같은 문법을 사용할 수 있게 해주는 설정 Bean
    @Bean
    public static PropertySourcesPlaceholderConfigurer propertyConfig() {

        // PropertySourcesPlaceholderConfigurer 객체 생성
        // 👉 얘가 properties 파일을 읽고
        // 👉 ${page.size} 같은 값을 실제 값(10)으로 바꿔주는 역할
        return new PropertySourcesPlaceholderConfigurer();
    }

    //네이버
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}