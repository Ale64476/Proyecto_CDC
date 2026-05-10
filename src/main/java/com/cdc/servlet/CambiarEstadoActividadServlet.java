package com.cdc.servlet;

import java.io.IOException;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.ActividadDAO;
import com.cdc.model.Actividad;
import com.cdc.util.MensajeRedirect;

@WebServlet("/cambiar-estado-actividad")
public class CambiarEstadoActividadServlet extends HttpServlet {

    private static final Set<String> ESTADOS_VALIDOS = Set.of("Activa", "Inactiva");

    private final ActividadDAO actividadDAO = new ActividadDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer idActividad = null;

        try {
            String idActividadStr = request.getParameter("idActividad");
            String nuevoEstado = request.getParameter("nuevoEstado");

            if (idActividadStr == null || idActividadStr.isBlank()) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        null,
                        "error",
                        "estado_actividad_id_invalido"
                ));
                return;
            }

            idActividad = Integer.parseInt(idActividadStr);

            if (idActividad <= 0) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        null,
                        "error",
                        "estado_actividad_id_invalido"
                ));
                return;
            }

            if (nuevoEstado == null || !ESTADOS_VALIDOS.contains(nuevoEstado)) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "estado_actividad_invalido"
                ));
                return;
            }

            Actividad actividad = actividadDAO.buscarPorId(idActividad);

            if (actividad == null) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        null,
                        "error",
                        "estado_actividad_no_encontrada"
                ));
                return;
            }

            if (nuevoEstado.equalsIgnoreCase(actividad.getEstadoActividad())) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "estado_actividad_sin_cambios"
                ));
                return;
            }

            boolean actualizado = actividadDAO.cambiarEstadoActividad(idActividad, nuevoEstado);

            if (actualizado) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "exito",
                        "Activa".equalsIgnoreCase(nuevoEstado)
                                ? "actividad_reactivada"
                                : "actividad_desactivada"
                ));
            } else {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "estado_actividad_no_actualizado"
                ));
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.actividades(
                    request,
                    idActividad,
                    "error",
                    "estado_actividad_id_invalido"
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