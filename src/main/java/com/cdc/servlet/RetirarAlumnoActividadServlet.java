package com.cdc.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.ActividadDAO;
import com.cdc.model.Actividad;
import com.cdc.util.MensajeRedirect;

@WebServlet("/retirar-alumno-actividad")
public class RetirarAlumnoActividadServlet extends HttpServlet {

    private final ActividadDAO actividadDAO = new ActividadDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer idActividad = null;

        try {
            String idActividadStr = request.getParameter("idActividad");
            String idAlumnoStr = request.getParameter("idAlumno");

            if (idActividadStr == null || idActividadStr.isBlank()
                    || idAlumnoStr == null || idAlumnoStr.isBlank()) {

                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        null,
                        "error",
                        "retiro_datos_invalidos"
                ));
                return;
            }

            idActividad = Integer.parseInt(idActividadStr);
            int idAlumno = Integer.parseInt(idAlumnoStr);

            if (idActividad <= 0 || idAlumno <= 0) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "retiro_datos_invalidos"
                ));
                return;
            }

            Actividad actividad = actividadDAO.buscarPorId(idActividad);

            if (actividad == null) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        null,
                        "error",
                        "retiro_actividad_invalida"
                ));
                return;
            }

            if (!"Activa".equalsIgnoreCase(actividad.getEstadoActividad())) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "retiro_actividad_inactiva"
                ));
                return;
            }

            boolean retirado = actividadDAO.retirarAlumnoDeActividad(idActividad, idAlumno);

            if (retirado) {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "exito",
                        "retiro_exitoso"
                ));
            } else {
                response.sendRedirect(MensajeRedirect.actividades(
                        request,
                        idActividad,
                        "error",
                        "retiro_no_realizado"
                ));
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.actividades(
                    request,
                    idActividad,
                    "error",
                    "retiro_datos_invalidos"
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