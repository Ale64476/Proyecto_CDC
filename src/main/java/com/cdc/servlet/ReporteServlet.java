package com.cdc.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.ReporteDAO;
import com.cdc.model.ReporteActividad;
import com.cdc.model.ReporteAlumno;
import com.cdc.model.ReporteAlumnoActividad;
import com.cdc.model.ReporteAsistenciaActividad;

@WebServlet("/reportes")
public class ReporteServlet extends HttpServlet {

    private final ReporteDAO reporteDAO = new ReporteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tipo = request.getParameter("tipo");
        if (tipo == null || tipo.isBlank()) {
            tipo = "alumnos";
        }

        List<ReporteAlumno> reporteAlumnos = reporteDAO.listarReporteAlumnos();
        List<ReporteActividad> reporteActividades = reporteDAO.listarReporteActividades();
        List<ReporteAlumnoActividad> reporteAlumnosActividad = reporteDAO.listarReporteAlumnosPorActividad();
        List<ReporteAsistenciaActividad> reporteAsistencia = reporteDAO.listarReporteAsistenciaPorActividad();

        request.setAttribute("tipoReporteSeleccionado", tipo);
        request.setAttribute("reporteAlumnos", reporteAlumnos);
        request.setAttribute("reporteActividades", reporteActividades);
        request.setAttribute("reporteAlumnosActividad", reporteAlumnosActividad);
        request.setAttribute("reporteAsistencia", reporteAsistencia);

        int totalRegistros = switch (tipo) {
            case "actividades" -> reporteActividades.size();
            case "alumnos_por_actividad" -> reporteAlumnosActividad.size();
            case "asistencia_por_actividad" -> reporteAsistencia.size();
            default -> reporteAlumnos.size();
        };

        String nombreTipo = switch (tipo) {
            case "actividades" -> "Reporte de actividades";
            case "alumnos_por_actividad" -> "Alumnos por actividad";
            case "asistencia_por_actividad" -> "Asistencia por actividad";
            default -> "Reporte de alumnos";
        };

        request.setAttribute("totalRegistrosReporte", totalRegistros);
        request.setAttribute("nombreTipoReporte", nombreTipo);

        request.getRequestDispatcher("/reportes.jsp").forward(request, response);
    }
}