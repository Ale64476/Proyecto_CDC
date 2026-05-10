package com.cdc.servlet;

import java.io.IOException;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.AlumnoDAO;
import com.cdc.model.Alumno;
import com.cdc.util.MensajeRedirect;

@WebServlet("/cambiar-estado-alumno")
public class CambiarEstadoAlumnoServlet extends HttpServlet {

    private static final Set<String> ESTADOS_VALIDOS = Set.of(
            "Activo",
            "Inactivo",
            "Baja"
    );

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer idAlumno = null;

        try {
            String idAlumnoStr = request.getParameter("idAlumno");
            String nuevoEstado = request.getParameter("nuevoEstado");

            if (idAlumnoStr == null || idAlumnoStr.isBlank()) {
                response.sendRedirect(MensajeRedirect.alumnos(
                        request,
                        null,
                        "error",
                        "estado_alumno_id_invalido"
                ));
                return;
            }

            idAlumno = Integer.parseInt(idAlumnoStr);

            if (idAlumno <= 0) {
                response.sendRedirect(MensajeRedirect.alumnos(
                        request,
                        null,
                        "error",
                        "estado_alumno_id_invalido"
                ));
                return;
            }

            if (nuevoEstado == null || !ESTADOS_VALIDOS.contains(nuevoEstado)) {
                response.sendRedirect(MensajeRedirect.alumnos(
                        request,
                        idAlumno,
                        "error",
                        "estado_alumno_invalido"
                ));
                return;
            }

            Alumno alumno = alumnoDAO.buscarPorId(idAlumno);

            if (alumno == null) {
                response.sendRedirect(MensajeRedirect.alumnos(
                        request,
                        null,
                        "error",
                        "estado_alumno_no_encontrado"
                ));
                return;
            }

            if (nuevoEstado.equalsIgnoreCase(alumno.getEstadoAlumno())) {
                response.sendRedirect(MensajeRedirect.alumnos(
                        request,
                        idAlumno,
                        "error",
                        "estado_alumno_sin_cambios"
                ));
                return;
            }

            boolean actualizado = alumnoDAO.cambiarEstadoAlumno(idAlumno, nuevoEstado);

            if (actualizado) {
                response.sendRedirect(MensajeRedirect.alumnos(
                        request,
                        idAlumno,
                        "exito",
                        obtenerMensajeExito(nuevoEstado)
                ));
            } else {
                response.sendRedirect(MensajeRedirect.alumnos(
                        request,
                        idAlumno,
                        "error",
                        "estado_alumno_no_actualizado"
                ));
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.alumnos(
                    request,
                    idAlumno,
                    "error",
                    "estado_alumno_id_invalido"
            ));

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.alumnos(
                    request,
                    idAlumno,
                    "error",
                    "error_sistema"
            ));
        }
    }

    private String obtenerMensajeExito(String nuevoEstado) {
        if ("Activo".equalsIgnoreCase(nuevoEstado)) {
            return "alumno_reactivado";
        }

        if ("Inactivo".equalsIgnoreCase(nuevoEstado)) {
            return "alumno_inactivado";
        }

        return "alumno_dado_baja";
    }
}