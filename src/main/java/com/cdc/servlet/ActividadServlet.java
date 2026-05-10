package com.cdc.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.ActividadDAO;
import com.cdc.dao.AlumnoDAO;
import com.cdc.dao.CalendarioDAO;
import com.cdc.dao.InstructorDAO;
import com.cdc.model.Actividad;
import com.cdc.model.Alumno;
import com.cdc.model.AlumnoInscritoActividad;
import com.cdc.model.CalendarioActividad;
import com.cdc.model.Instructor;

@WebServlet("/actividades")
public class ActividadServlet extends HttpServlet {

    private final ActividadDAO actividadDAO = new ActividadDAO();
    private final InstructorDAO instructorDAO = new InstructorDAO();
    private final AlumnoDAO alumnoDAO = new AlumnoDAO();
    private final CalendarioDAO calendarioDAO = new CalendarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Actividad> actividades = actividadDAO.listarTodas();
        request.setAttribute("listaActividades", actividades);

        List<Instructor> instructoresActivos = instructorDAO.listarActivos();
        request.setAttribute("instructoresActivos", instructoresActivos);

        List<CalendarioActividad> actividadesCalendario = calendarioDAO.listarCalendarioCompleto();
        request.setAttribute("actividadesCalendario", actividadesCalendario);

        Actividad actividadSeleccionada = null;
        List<AlumnoInscritoActividad> alumnosInscritos = null;
        List<Alumno> alumnosDisponibles = null;

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isBlank()) {
            try {
                int idActividad = Integer.parseInt(idParam);
                actividadSeleccionada = actividadDAO.buscarPorId(idActividad);

                if (actividadSeleccionada != null) {
                    alumnosInscritos = actividadDAO.listarAlumnosInscritos(idActividad);
                    alumnosDisponibles = alumnoDAO.listarDisponiblesParaActividad(idActividad);
                }
            } catch (NumberFormatException e) {
                actividadSeleccionada = null;
            }
        }

        if (actividadSeleccionada == null && !actividades.isEmpty()) {
            actividadSeleccionada = actividades.get(0);
            alumnosInscritos = actividadDAO.listarAlumnosInscritos(actividadSeleccionada.getIdActividad());
            alumnosDisponibles = alumnoDAO.listarDisponiblesParaActividad(actividadSeleccionada.getIdActividad());
        }

        request.setAttribute("actividadSeleccionada", actividadSeleccionada);
        request.setAttribute("alumnosInscritos", alumnosInscritos);
        request.setAttribute("alumnosDisponibles", alumnosDisponibles);

        request.getRequestDispatcher("/actividades.jsp").forward(request, response);
    }
}