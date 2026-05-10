package com.cdc.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.ActividadDAO;
import com.cdc.model.Actividad;

@WebServlet("/actualizar-actividad")
public class ActualizarActividadServlet extends HttpServlet {

    private final ActividadDAO actividadDAO = new ActividadDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            int idActividad = Integer.parseInt(request.getParameter("idActividad"));
            String nombreActividad = request.getParameter("nombreActividad");
            String descripcionActividad = request.getParameter("descripcionActividad");
            int idInstructor = Integer.parseInt(request.getParameter("idInstructor"));
            String estadoActividad = request.getParameter("estadoActividad");

            Actividad actividad = new Actividad();
            actividad.setIdActividad(idActividad);
            actividad.setNombreActividad(nombreActividad);
            actividad.setDescripcionActividad(
                    descripcionActividad != null && !descripcionActividad.isBlank()
                            ? descripcionActividad
                            : null
            );
            actividad.setIdInstructor(idInstructor);
            actividad.setEstadoActividad(estadoActividad);

            actividadDAO.actualizarActividad(actividad);

            response.sendRedirect(request.getContextPath() + "/actividades?id=" + idActividad);

        } catch (Exception e) {
            throw new ServletException("Error al actualizar actividad.", e);
        }
    }
}