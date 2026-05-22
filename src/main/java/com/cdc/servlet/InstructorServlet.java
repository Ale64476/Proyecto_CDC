package com.cdc.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.InstructorDAO;
import com.cdc.model.Instructor;

@WebServlet("/instructores")
public class InstructorServlet extends HttpServlet {

    private final InstructorDAO instructorDAO = new InstructorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Instructor> instructores = instructorDAO.listarTodos();
        request.setAttribute("listaInstructores", instructores);

        Instructor instructorSeleccionado = null;

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isBlank()) {
            try {
                int idInstructor = Integer.parseInt(idParam);
                instructorSeleccionado = instructorDAO.buscarPorId(idInstructor);
            } catch (NumberFormatException e) {
                instructorSeleccionado = null;
            }
        }

        if (instructorSeleccionado == null && instructores != null && !instructores.isEmpty()) {
            instructorSeleccionado = instructores.get(0);
        }

        request.setAttribute("instructorSeleccionado", instructorSeleccionado);

        request.getRequestDispatcher("/instructores.jsp").forward(request, response);
    }
}