package com.cdc.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.AlumnoDAO;

@WebServlet("/cambiar-estado-alumno")
public class CambiarEstadoAlumnoServlet extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idAlumno = Integer.parseInt(request.getParameter("idAlumno"));
            String nuevoEstado = request.getParameter("nuevoEstado");

            alumnoDAO.cambiarEstadoAlumno(idAlumno, nuevoEstado);

            response.sendRedirect(request.getContextPath() + "/alumnos?id=" + idAlumno);

        } catch (Exception e) {
            throw new ServletException("Error al cambiar estado del alumno.", e);
        }
    }
}