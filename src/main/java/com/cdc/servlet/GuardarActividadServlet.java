package com.cdc.servlet;

import java.io.IOException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.ActividadDAO;
import com.cdc.model.Actividad;
import com.cdc.model.HorarioActividad;

@WebServlet("/guardar-actividad")
public class GuardarActividadServlet extends HttpServlet {

    private final ActividadDAO actividadDAO = new ActividadDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            String nombreActividad = request.getParameter("nombreActividad");
            String descripcionActividad = request.getParameter("descripcionActividad");
            int idInstructor = Integer.parseInt(request.getParameter("idInstructor"));
            String estadoActividad = request.getParameter("estadoActividad");

            String[] diasSemana = request.getParameterValues("diaSemana");
            String[] horasInicio = request.getParameterValues("horaInicio");
            String[] horasFin = request.getParameterValues("horaFin");

            Actividad actividad = new Actividad();
            actividad.setNombreActividad(nombreActividad);
            actividad.setDescripcionActividad(
                    descripcionActividad != null && !descripcionActividad.isBlank()
                            ? descripcionActividad
                            : null
            );
            actividad.setIdInstructor(idInstructor);
            actividad.setEstadoActividad(estadoActividad);

            List<HorarioActividad> horarios = new ArrayList<>();

            if (diasSemana != null && horasInicio != null && horasFin != null) {
                for (int i = 0; i < diasSemana.length; i++) {
                    if (diasSemana[i] != null && !diasSemana[i].isBlank()
                            && horasInicio[i] != null && !horasInicio[i].isBlank()
                            && horasFin[i] != null && !horasFin[i].isBlank()) {

                        HorarioActividad horario = new HorarioActividad();
                        horario.setDiaSemana(diasSemana[i]);
                        horario.setHoraInicio(Time.valueOf(horasInicio[i] + ":00"));
                        horario.setHoraFin(Time.valueOf(horasFin[i] + ":00"));
                        horarios.add(horario);
                    }
                }
            }

            int idNuevaActividad = actividadDAO.insertarActividadConHorarios(actividad, horarios);

            response.sendRedirect(request.getContextPath() + "/actividades?id=" + idNuevaActividad);

        } catch (Exception e) {
            throw new ServletException("Error al guardar actividad.", e);
        }
    }
}