package com.cdc.dao;

import java.util.List;

import com.cdc.model.CalendarioActividad;

public class TestCalendarioDAO {
    public static void main(String[] args) {
        CalendarioDAO calendarioDAO = new CalendarioDAO();
        List<CalendarioActividad> actividades = calendarioDAO.listarCalendarioCompleto();

        System.out.println("Total registros calendario: " + actividades.size());

        for (CalendarioActividad actividad : actividades) {
            System.out.println(
                    actividad.getDiaSemana() + " - " +
                    actividad.getHoraInicio() + " - " +
                    actividad.getNombreActividad() + " - " +
                    actividad.getNombreInstructor()
            );
        }
    }
}