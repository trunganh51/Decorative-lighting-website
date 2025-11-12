package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(urlPatterns = {"/*"}, filterName = "CharacterEncodingFilter")
public class CharacterEncodingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Set UTF-8 encoding FIRST
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        httpResponse.setContentType("text/html; charset=UTF-8");
        
        // Log search parameters for debugging
        String keyword = request.getParameter("keyword");
        if (keyword != null) {
            System.out.println("🔍 FILTER - Original keyword: [" + keyword + "]");
            System.out.println("🔍 FILTER - Keyword length: " + keyword.length());
            System.out.println("🔍 FILTER - Keyword bytes: " + java.util.Arrays.toString(keyword.getBytes("UTF-8")));
        }
        
        chain.doFilter(request, response);
    }
}