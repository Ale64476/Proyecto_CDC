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
import com.cdc.model.ReporteGerontologiaPaciente;

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

        String estadoAlumno = request.getParameter("estadoAlumno");
        String estadoTaller = request.getParameter("estadoTaller");
        String idActividad = request.getParameter("idActividad");
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFin = request.getParameter("fechaFin");

        String estadoGerontologia = request.getParameter("estadoGerontologia");
        String fechaInicioGerontologia = request.getParameter("fechaInicioGerontologia");
        String fechaFinGerontologia = request.getParameter("fechaFinGerontologia");

        List<ReporteAlumno> reporteAlumnos = reporteDAO.listarReporteAlumnos(estadoAlumno);
        List<ReporteActividad> reporteActividades = reporteDAO.listarReporteActividades(estadoTaller);
        List<ReporteAlumnoActividad> reporteAlumnosActividad = reporteDAO.listarReporteAlumnosPorActividad(idActividad, estadoAlumno);
        List<ReporteAsistenciaActividad> reporteAsistencia = reporteDAO.listarReporteAsistenciaPorActividad(idActividad, fechaInicio, fechaFin);
        List<ReporteGerontologiaPaciente> reporteGerontologia = reporteDAO.listarReportePacientesGerontologia(
                estadoGerontologia,
                fechaInicioGerontologia,
                fechaFinGerontologia
        );
        
        request.setAttribute("tipoReporteSeleccionado", tipo);
        request.setAttribute("estadoAlumnoSeleccionado", estadoAlumno);
        request.setAttribute("estadoTallerSeleccionado", estadoTaller);
        request.setAttribute("idActividadSeleccionada", idActividad);
        request.setAttribute("fechaInicioSeleccionada", fechaInicio);
        request.setAttribute("fechaFinSeleccionada", fechaFin);
        request.setAttribute("estadoGerontologiaSeleccionado", estadoGerontologia);
        request.setAttribute("fechaInicioGerontologiaSeleccionada", fechaInicioGerontologia);
        request.setAttribute("fechaFinGerontologiaSeleccionada", fechaFinGerontologia);

        request.setAttribute("reporteAlumnos", reporteAlumnos);
        request.setAttribute("reporteActividades", reporteActividades);
        request.setAttribute("reporteAlumnosActividad", reporteAlumnosActividad);
        request.setAttribute("reporteAsistencia", reporteAsistencia);
        request.setAttribute("reporteGerontologia", reporteGerontologia);

        int totalRegistros = switch (tipo) {
            case "actividades" -> reporteActividades.size();
            case "alumnos_por_actividad" -> reporteAlumnosActividad.size();
            case "asistencia_por_actividad" -> reporteAsistencia.size();
            case "gerontologia" -> reporteGerontologia.size();
            default -> reporteAlumnos.size();
        };

        String nombreTipo = switch (tipo) {
            case "actividades" -> "Reporte de talleres";
            case "alumnos_por_actividad" -> "Alumnos por taller";
            case "asistencia_por_actividad" -> "Asistencia por taller";
            case "gerontologia" -> "Pacientes de Gerontología";
            default -> "Reporte de alumnos";
        };

        request.setAttribute("totalRegistrosReporte", totalRegistros);
        request.setAttribute("nombreTipoReporte", nombreTipo);

        request.getRequestDispatcher("/reportes.jsp").forward(request, response);
    }
}