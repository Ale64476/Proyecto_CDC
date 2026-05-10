package com.cdc.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.ActividadDAO;
import com.cdc.model.Actividad;
import com.cdc.model.HorarioActividad;
import com.cdc.util.ActividadValidator;
import com.cdc.util.MensajeRedirect;

@WebServlet("/actualizar-actividad")
public class ActualizarActividadServlet extends HttpServlet {

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
                        "actividad_id_invalido"
                ));
                return;
            }

            idActividad = Integer.parseInt(idActividadStr);

            if (idActividad <= 0) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        null,
                        "error",
                        "actividad_id_invalido"
                ));
                return;
            }

            String nombreActividad = ActividadValidator.limpiar(request.getParameter("nombreActividad"));
            String descripcionActividad = ActividadValidator.limpiar(request.getParameter("descripcionActividad"));
            String idInstructorStr = ActividadValidator.limpiar(request.getParameter("idInstructor"));
            String estadoActividad = ActividadValidator.limpiar(request.getParameter("estadoActividad"));

            String[] diasSemana = request.getParameterValues("diaSemana");
            String[] horasInicio = request.getParameterValues("horaInicio");
            String[] horasFin = request.getParameterValues("horaFin");

            String errorActividad = ActividadValidator.validarActividad(
                    nombreActividad,
                    idInstructorStr,
                    estadoActividad
            );

            if (errorActividad != null) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        errorActividad
                ));
                return;
            }

            String errorHorarios = ActividadValidator.validarHorarios(
                    diasSemana,
                    horasInicio,
                    horasFin
            );

            if (errorHorarios != null) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        errorHorarios
                ));
                return;
            }

            Actividad actividad = new Actividad();
            actividad.setIdActividad(idActividad);
            actividad.setNombreActividad(nombreActividad);
            actividad.setDescripcionActividad(!descripcionActividad.isBlank() ? descripcionActividad : null);
            actividad.setIdInstructor(ActividadValidator.convertirEntero(idInstructorStr));
            actividad.setEstadoActividad(estadoActividad);

            List<HorarioActividad> horarios = ActividadValidator.construirHorarios(
                    diasSemana,
                    horasInicio,
                    horasFin
            );

            boolean actualizado = actividadDAO.actualizarActividadConHorarios(actividad, horarios);

            if (actualizado) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "exito",
                        "actividad_actualizada"
                ));
            } else {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "actividad_no_actualizada"
                ));
            }

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