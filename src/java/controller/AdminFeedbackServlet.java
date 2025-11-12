package controller;

import dao.FeedbackDAO;
import model.Feedback;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.util.List;

/**
 * Servlet dành cho admin xem danh sách các phản hồi người dùng gửi.
 */
@WebServlet(name = "AdminFeedbackServlet", urlPatterns = "/admin/feedbacks")
public class AdminFeedbackServlet extends HttpServlet {
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

 
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        List<Feedback> feedbacks = feedbackDAO.getAll();
        req.setAttribute("feedbacks", feedbacks);
        req.getRequestDispatcher("/admin/feedback.jsp").forward(req, resp);
    }
}
