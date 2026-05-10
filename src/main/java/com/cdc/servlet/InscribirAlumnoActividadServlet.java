package com.cdc.servlet;

import com.cdc.dao.ActividadDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/inscribir-alumnos-actividad")
public class InscribirAlumnoActividadServlet extends HttpServlet {

    private final ActividadDAO actividadDAO = new ActividadDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idActividad = Integer.parseInt(request.getParameter("idActividad"));
            String[] alumnosSeleccionados = request.getParameterValues("idsAlumnos");

            if (alumnosSeleccionados != null && alumnosSeleccionados.length > 0) {
                List<Integer> idsAlumnos = new ArrayList<>();

                for (String id : alumnosSeleccionados) {
                    idsAlumnos.add(Integer.parseInt(id));
                }

                actividadDAO.inscribirAlumnosEnActividad(idActividad, idsAlumnos);
            }

            response.sendRedirect(request.getContextPath() + "/actividades?id=" + idActividad);

        } catch (Exception e) {
            throw new ServletException("Error al inscribir alumnos en la actividad.", e);
        }
    }
}