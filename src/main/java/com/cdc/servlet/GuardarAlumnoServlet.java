package com.cdc.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.AlumnoDAO;
import com.cdc.model.Alumno;
import com.cdc.util.AlumnoValidator;
import com.cdc.util.MensajeRedirect;

@WebServlet("/guardar-alumno")
public class GuardarAlumnoServlet extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombreCompleto = AlumnoValidator.limpiar(request.getParameter("nombreCompleto"));
        String fechaNacimientoStr = AlumnoValidator.limpiar(request.getParameter("fechaNacimiento"));
        String curp = AlumnoValidator.normalizarCurp(request.getParameter("curp"));
        String domicilio = AlumnoValidator.limpiar(request.getParameter("domicilio"));
        String celular = AlumnoValidator.normalizarCelular(request.getParameter("celular"));
        String estadoAlumno = AlumnoValidator.limpiar(request.getParameter("estadoAlumno"));

        String errorValidacion = AlumnoValidator.validarAlumno(
                nombreCompleto,
                fechaNacimientoStr,
                curp,
                celular,
                domicilio,
                estadoAlumno
        );

        if (errorValidacion != null) {
            response.sendRedirect(MensajeRedirect.alumnos(request, null, "error", errorValidacion));
            return;
        }

        try {
            Alumno alumno = new Alumno();
            alumno.setNombreCompleto(nombreCompleto);
            alumno.setFechaNacimiento(AlumnoValidator.convertirFecha(fechaNacimientoStr));
            alumno.setCurp(curp);
            alumno.setDomicilio(domicilio);
            alumno.setCelular(celular);
            alumno.setEstadoAlumno(estadoAlumno);

            boolean guardado = alumnoDAO.insertarAlumno(alumno);

            if (guardado) {
                response.sendRedirect(MensajeRedirect.alumnos(request, null, "exito", "alumno_guardado"));
            } else {
                response.sendRedirect(MensajeRedirect.alumnos(request, null, "error", "alumno_no_guardado"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(MensajeRedirect.alumnos(request, null, "error", "error_sistema"));
        }
    }
}