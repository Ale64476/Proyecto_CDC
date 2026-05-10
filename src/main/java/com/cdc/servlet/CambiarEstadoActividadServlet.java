package com.cdc.servlet;

import com.cdc.dao.ActividadDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/cambiar-estado-actividad")
public class CambiarEstadoActividadServlet extends HttpServlet {

    private final ActividadDAO actividadDAO = new ActividadDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idActividad = Integer.parseInt(request.getParameter("idActividad"));
            String nuevoEstado = request.getParameter("nuevoEstado");

            actividadDAO.cambiarEstadoActividad(idActividad, nuevoEstado);

            response.sendRedirect(request.getContextPath() + "/actividades?id=" + idActividad);

        } catch (Exception e) {
            throw new ServletException("Error al cambiar estado de la actividad.", e);
        }
    }
}