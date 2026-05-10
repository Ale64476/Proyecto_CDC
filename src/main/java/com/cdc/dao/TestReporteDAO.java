package com.cdc.dao;

import java.util.List;

import com.cdc.model.ReporteActividad;
import com.cdc.model.ReporteAlumno;
import com.cdc.model.ReporteAlumnoActividad;
import com.cdc.model.ReporteAsistenciaActividad;

public class TestReporteDAO {
    public static void main(String[] args) {
        ReporteDAO reporteDAO = new ReporteDAO();

        List<ReporteAlumno> alumnos = reporteDAO.listarReporteAlumnos();
        System.out.println("Reporte alumnos: " + alumnos.size());

        List<ReporteActividad> actividades = reporteDAO.listarReporteActividades();
        System.out.println("Reporte actividades: " + actividades.size());

        List<ReporteAlumnoActividad> alumnosActividad = reporteDAO.listarReporteAlumnosPorActividad();
        System.out.println("Reporte alumnos por actividad: " + alumnosActividad.size());

        List<ReporteAsistenciaActividad> asistencia = reporteDAO.listarReporteAsistenciaPorActividad();
        System.out.println("Reporte asistencia por actividad: " + asistencia.size());
    }
}