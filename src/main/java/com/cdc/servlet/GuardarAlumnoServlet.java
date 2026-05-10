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

@WebServlet("/guardar-alumno")
public class GuardarAlumnoServlet extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombreCompleto = request.getParameter("nombreCompleto");
        String fechaNacimientoStr = request.getParameter("fechaNacimiento");
        String curp = request.getParameter("curp");
        String domicilio = request.getParameter("domicilio");
        String celular = request.getParameter("celular");
        String estadoAlumno = request.getParameter("estadoAlumno");

        try {
            Alumno alumno = new Alumno();
            alumno.setNombreCompleto(nombreCompleto);
            alumno.setFechaNacimiento(Date.valueOf(fechaNacimientoStr));
            alumno.setCurp(curp);
            alumno.setDomicilio(domicilio);
            alumno.setCelular(celular);
            alumno.setEstadoAlumno(estadoAlumno);

            alumnoDAO.insertarAlumno(alumno);

            response.sendRedirect(request.getContextPath() + "/alumnos");

        } catch (Exception e) {
            throw new ServletException("Error al guardar alumno.", e);
        }
    }
}