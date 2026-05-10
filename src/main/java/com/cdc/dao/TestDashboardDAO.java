package com.cdc.dao;

import java.util.List;

import com.cdc.model.ActividadProxima;
import com.cdc.model.Aviso;
import com.cdc.model.DashboardResumen;

public class TestDashboardDAO {
    public static void main(String[] args) {
        DashboardDAO dashboardDAO = new DashboardDAO();

        DashboardResumen resumen = dashboardDAO.obtenerResumen();
        if (resumen != null) {
            System.out.println("=== RESUMEN DASHBOARD ===");
            System.out.println("Alumnos registrados: " + resumen.getTotalAlumnosRegistrados());
            System.out.println("Actividades activas: " + resumen.getTotalActividadesActivas());
            System.out.println("Actividades de hoy: " + resumen.getActividadesDeHoy());
            System.out.println("Asistencias registradas hoy: " + resumen.getAsistenciasRegistradasHoy());
        }

        List<ActividadProxima> actividades = dashboardDAO.listarProximasActividades();
        System.out.println("\n=== PRÓXIMAS ACTIVIDADES ===");
        for (ActividadProxima actividad : actividades) {
            System.out.println(
                    actividad.getNombreActividad() + " - " +
                    actividad.getInstructor() + " - " +
                    actividad.getDiaSemana() + " " +
                    actividad.getHoraInicio() + " a " +
                    actividad.getHoraFin()
            );
        }

        List<Aviso> avisos = dashboardDAO.listarAvisos();
        System.out.println("\n=== AVISOS ===");
        for (Aviso aviso : avisos) {
            System.out.println(aviso.getTitulo() + " - " + aviso.getMensaje());
        }
    }
}