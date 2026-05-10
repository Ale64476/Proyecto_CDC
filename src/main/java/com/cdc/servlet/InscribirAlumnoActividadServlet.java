package com.cdc.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.ActividadDAO;
import com.cdc.model.Actividad;
import com.cdc.util.MensajeRedirect;

@WebServlet("/inscribir-alumnos-actividad")
public class InscribirAlumnoActividadServlet extends HttpServlet {

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
                        "inscripcion_actividad_invalida"
                ));
                return;
            }

            idActividad = Integer.parseInt(idActividadStr);

            if (idActividad <= 0) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        null,
                        "error",
                        "inscripcion_actividad_invalida"
                ));
                return;
            }

            Actividad actividad = actividadDAO.buscarPorId(idActividad);

            if (actividad == null) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        null,
                        "error",
                        "inscripcion_actividad_invalida"
                ));
                return;
            }

            if (!"Activa".equalsIgnoreCase(actividad.getEstadoActividad())) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "inscripcion_actividad_inactiva"
                ));
                return;
            }

            String[] alumnosSeleccionados = request.getParameterValues("idsAlumnos");

            if (alumnosSeleccionados == null || alumnosSeleccionados.length == 0) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "inscripcion_sin_alumnos"
                ));
                return;
            }

            Set<Integer> idsSinDuplicados = new LinkedHashSet<>();

            for (String idAlumnoStr : alumnosSeleccionados) {
                if (idAlumnoStr == null || idAlumnoStr.isBlank()) {
                    continue;
                }

                int idAlumno = Integer.parseInt(idAlumnoStr);

                if (idAlumno > 0) {
                    idsSinDuplicados.add(idAlumno);
                }
            }

            if (idsSinDuplicados.isEmpty()) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "inscripcion_alumnos_invalidos"
                ));
                return;
            }

            List<Integer> idsAlumnos = new ArrayList<>(idsSinDuplicados);

            int totalInscritos = actividadDAO.inscribirAlumnosEnActividad(idActividad, idsAlumnos);

            if (totalInscritos == idsAlumnos.size()) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "exito",
                        "inscripcion_exitosa"
                ));
                return;
            }

            if (totalInscritos > 0) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "exito",
                        "inscripcion_parcial"
                ));
                return;
            }

            response.sendRedirect(MensajeRedirect.actividades(
                    request,
                    idActividad,
                    "error",
                    "inscripcion_no_realizada"
            ));

        } catch (NumberFormatException e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.actividades(
                    request,
                    idActividad,
                    "error",
                    "inscripcion_datos_invalidos"
            ));

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.actividades(
                    request,
                    idActividad,
                    "error",
                    "error_sistema"
            ));
        }
    }
}