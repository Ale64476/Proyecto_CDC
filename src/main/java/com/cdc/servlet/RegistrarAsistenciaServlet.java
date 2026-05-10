package com.cdc.servlet;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.ActividadDAO;
import com.cdc.model.AlumnoInscritoActividad;

@WebServlet("/registrar-asistencia")
public class RegistrarAsistenciaServlet extends HttpServlet {

    private final ActividadDAO actividadDAO = new ActividadDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idActividad = Integer.parseInt(request.getParameter("idActividad"));
            Date fechaAsistencia = Date.valueOf(request.getParameter("fechaAsistencia"));

            String[] presentesArray = request.getParameterValues("idsPresentes");
            List<Integer> idsPresentes = new ArrayList<>();

            if (presentesArray != null) {
                for (String id : presentesArray) {
                    idsPresentes.add(Integer.parseInt(id));
                }
            }

            List<AlumnoInscritoActividad> alumnosInscritos = actividadDAO.listarAlumnosInscritos(idActividad);
            List<Integer> idsTodosInscritos = new ArrayList<>();

            for (AlumnoInscritoActividad alumno : alumnosInscritos) {
                idsTodosInscritos.add(alumno.getIdAlumno());
            }

            int idAdmin = 1; // temporal, mientras no conectemos login real

            actividadDAO.registrarAsistencia(idActividad, fechaAsistencia, idsPresentes, idsTodosInscritos, idAdmin);

            response.sendRedirect(request.getContextPath() + "/actividades?id=" + idActividad);

        } catch (Exception e) {
            throw new ServletException("Error al registrar asistencia.", e);
        }
    }
}