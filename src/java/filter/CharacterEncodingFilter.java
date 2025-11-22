package filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Filter thiết lập UTF-8 cho request/response mà không ghi đè Content-Type của
 * các tài nguyên binary (PDF, ảnh, v.v.).
 */
public class CharacterEncodingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // Thiết lập encoding sớm
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpResp = (HttpServletResponse) response;

        String uri = httpReq.getRequestURI(); // /LightWebProject_new/quote/download ...

        // Chỉ set Content-Type mặc định cho các trang HTML nếu không phải các endpoint trả về PDF hoặc static file khác
        if (!isBinaryOrPdf(uri) && httpResp.getContentType() == null) {
            // Không ép với PDF, JSON, JS, CSS, images...
            httpResp.setContentType("text/html; charset=UTF-8");
        }

        chain.doFilter(request, response);
    }

    private boolean isBinaryOrPdf(String uri) {
        if (uri == null) {
            return false;
        }
        String lower = uri.toLowerCase();
        // Các đường dẫn phục vụ PDF (quote), invoice preview HTML vẫn là text/html
        if (lower.contains("/quote")) {
            return true; // vì servlet tự set application/pdf
        }        // Các đuôi binary phổ biến
        return lower.endsWith(".pdf")
                || lower.endsWith(".png")
                || lower.endsWith(".jpg")
                || lower.endsWith(".jpeg")
                || lower.endsWith(".gif")
                || lower.endsWith(".webp")
                || lower.endsWith(".svg")
                || lower.endsWith(".js")
                || lower.endsWith(".css")
                || lower.endsWith(".ico")
                || lower.endsWith(".json");
    }
}
