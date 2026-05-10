package com.cdc.servlet;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.ActividadDAO;
import com.cdc.model.Actividad;
import com.cdc.model.AlumnoInscritoActividad;
import com.cdc.util.MensajeRedirect;

@WebServlet("/registrar-asistencia")
public class RegistrarAsistenciaServlet extends HttpServlet {

    private final ActividadDAO actividadDAO = new ActividadDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer idActividad = null;

        try {
            String idActividadStr = request.getParameter("idActividad");

            if (idActividadStr == null || idActividadStr.isBlank()) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        null,
                        "error",
                        "asistencia_actividad_invalida"
                ));
                return;
            }

            idActividad = Integer.parseInt(idActividadStr);

            if (idActividad <= 0) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        null,
                        "error",
                        "asistencia_actividad_invalida"
                ));
                return;
            }

            Actividad actividad = actividadDAO.buscarPorId(idActividad);

            if (actividad == null) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        null,
                        "error",
                        "asistencia_actividad_invalida"
                ));
                return;
            }

            if (!"Activa".equalsIgnoreCase(actividad.getEstadoActividad())) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "asistencia_actividad_inactiva"
                ));
                return;
            }

            String fechaAsistenciaStr = request.getParameter("fechaAsistencia");

            if (fechaAsistenciaStr == null || fechaAsistenciaStr.isBlank()) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "asistencia_fecha_obligatoria"
                ));
                return;
            }

            LocalDate fechaLocal = LocalDate.parse(fechaAsistenciaStr);

            if (fechaLocal.isAfter(LocalDate.now())) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "asistencia_fecha_futura"
                ));
                return;
            }

            Date fechaAsistencia = Date.valueOf(fechaLocal);

            String[] presentesArray = request.getParameterValues("idsPresentes");

            List<Integer> idsPresentes = new ArrayList<>();

            if (presentesArray != null) {
                for (String id : presentesArray) {
                    idsPresentes.add(Integer.parseInt(id));
                }
            }

            List<AlumnoInscritoActividad> alumnosInscritos =
                    actividadDAO.listarAlumnosInscritos(idActividad);

            if (alumnosInscritos == null || alumnosInscritos.isEmpty()) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "asistencia_sin_alumnos"
                ));
                return;
            }

            List<Integer> idsTodosInscritos = new ArrayList<>();

            for (AlumnoInscritoActividad alumno : alumnosInscritos) {
                idsTodosInscritos.add(alumno.getIdAlumno());
            }

            boolean yaExistiaAsistencia = actividadDAO.existeAsistenciaRegistrada(
                    idActividad,
                    fechaAsistencia
            );

            int idAdmin = 1; // temporal, mientras no conectemos login real

            actividadDAO.registrarAsistencia(
                    idActividad,
                    fechaAsistencia,
                    idsPresentes,
                    idsTodosInscritos,
                    idAdmin
            );

            response.sendRedirect(MensajeRedirect.actividades(
                    request,
                    idActividad,
                    "exito",
                    yaExistiaAsistencia ? "asistencia_actualizada" : "asistencia_registrada"
            ));

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.actividades(
                    request,
                    idActividad,
                    "error",
                    "asistencia_datos_invalidos"
            ));
        }
    }
}