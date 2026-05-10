package com.cdc.dao;

import java.util.List;

import com.cdc.model.Actividad;
import com.cdc.model.AlumnoInscritoActividad;

public class TestActividadDAO {
    public static void main(String[] args) {
        ActividadDAO actividadDAO = new ActividadDAO();

        List<Actividad> actividades = actividadDAO.listarTodas();
        System.out.println("Total actividades: " + actividades.size());

        for (Actividad actividad : actividades) {
            System.out.println(actividad.getIdActividad() + " - " +
                    actividad.getNombreActividad() + " - " +
                    actividad.getNombreInstructor() + " - " +
                    actividad.getHorariosResumen());
        }

        if (!actividades.isEmpty()) {
            int idActividad = actividades.get(0).getIdActividad();
            List<AlumnoInscritoActividad> alumnos = actividadDAO.listarAlumnosInscritos(idActividad);

            System.out.println("\nAlumnos inscritos en actividad " + idActividad + ": " + alumnos.size());
            for (AlumnoInscritoActividad alumno : alumnos) {
                System.out.println(alumno.getNombreCompleto() + " - " +
                        alumno.getCelular() + " - " +
                        alumno.getAsistenciasDelMes());
            }
        }
    }
}