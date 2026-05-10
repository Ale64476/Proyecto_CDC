package com.cdc.servlet;

import java.io.IOException;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.AlumnoDAO;
import com.cdc.model.Alumno;

@WebServlet("/actualizar-alumno")
public class ActualizarAlumnoServlet extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            int idAlumno = Integer.parseInt(request.getParameter("idAlumno"));

            Alumno alumno = new Alumno();
            alumno.setIdAlumno(idAlumno);
            alumno.setNombreCompleto(request.getParameter("nombreCompleto"));
            alumno.setFechaNacimiento(Date.valueOf(request.getParameter("fechaNacimiento")));
            alumno.setCurp(request.getParameter("curp"));
            alumno.setDomicilio(request.getParameter("domicilio"));
            alumno.setCelular(request.getParameter("celular"));
            alumno.setEstadoAlumno(request.getParameter("estadoAlumno"));

            alumnoDAO.actualizarAlumno(alumno);

            response.sendRedirect(request.getContextPath() + "/alumnos?id=" + idAlumno);

        } catch (Exception e) {
            throw new ServletException("Error al actualizar alumno.", e);
        }
    }
}