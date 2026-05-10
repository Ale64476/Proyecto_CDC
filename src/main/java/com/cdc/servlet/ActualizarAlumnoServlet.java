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

@WebServlet("/actualizar-alumno")
public class ActualizarAlumnoServlet extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer idAlumno = null;

        try {
            idAlumno = Integer.parseInt(request.getParameter("idAlumno"));
        } catch (Exception e) {
            response.sendRedirect(MensajeRedirect.alumnos(request, null, "error", "id_alumno_invalido"));
            return;
        }

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
            response.sendRedirect(MensajeRedirect.alumnos(request, idAlumno, "error", errorValidacion));
            return;
        }

        try {
            Alumno alumno = new Alumno();
            alumno.setIdAlumno(idAlumno);
            alumno.setNombreCompleto(nombreCompleto);
            alumno.setFechaNacimiento(AlumnoValidator.convertirFecha(fechaNacimientoStr));
            alumno.setCurp(curp);
            alumno.setDomicilio(domicilio);
            alumno.setCelular(celular);
            alumno.setEstadoAlumno(estadoAlumno);

            boolean actualizado = alumnoDAO.actualizarAlumno(alumno);

            if (actualizado) {
                response.sendRedirect(MensajeRedirect.alumnos(request, idAlumno, "exito", "alumno_actualizado"));
            } else {
                response.sendRedirect(MensajeRedirect.alumnos(request, idAlumno, "error", "alumno_no_actualizado"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(MensajeRedirect.alumnos(request, idAlumno, "error", "error_sistema"));
        }
    }
}