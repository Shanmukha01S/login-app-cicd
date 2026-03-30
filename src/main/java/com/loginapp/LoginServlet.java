package com.loginapp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if ("admin".equals(username) && "admin123".equals(password)) {
            request.setAttribute("username", username);
            request.getRequestDispatcher("welcome.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Invalid username or password!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
