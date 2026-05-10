package com.cdc.util;

import java.sql.Time;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import com.cdc.model.HorarioActividad;

public final class ActividadValidator {

    private static final Set<String> ESTADOS_VALIDOS = Set.of(
            "Activa",
            "Inactiva"
    );

    private static final Set<String> DIAS_VALIDOS = Set.of(
            "Lunes",
            "Martes",
            "Miércoles",
            "Jueves",
            "Viernes",
            "Sábado"
    );

    private ActividadValidator() {
    }

    public static String validarActividad(
            String nombreActividad,
            String idInstructor,
            String estadoActividad
    ) {
        nombreActividad = limpiar(nombreActividad);
        idInstructor = limpiar(idInstructor);
        estadoActividad = limpiar(estadoActividad);

        if (nombreActividad.isBlank()) {
            return "actividad_nombre_obligatorio";
        }

        if (nombreActividad.length() < 3) {
            return "actividad_nombre_invalido";
        }

        if (idInstructor.isBlank()) {
            return "actividad_instructor_obligatorio";
        }

        try {
            int id = Integer.parseInt(idInstructor);

            if (id <= 0) {
                return "actividad_instructor_invalido";
            }
        } catch (Exception e) {
            return "actividad_instructor_invalido";
        }

        if (!ESTADOS_VALIDOS.contains(estadoActividad)) {
            return "actividad_estado_invalido";
        }

        return null;
    }

    public static String validarHorarios(
            String[] diasSemana,
            String[] horasInicio,
            String[] horasFin
    ) {
        if (diasSemana == null || horasInicio == null || horasFin == null) {
            return "actividad_horario_obligatorio";
        }

        if (diasSemana.length == 0 || horasInicio.length == 0 || horasFin.length == 0) {
            return "actividad_horario_obligatorio";
        }

        if (diasSemana.length != horasInicio.length || diasSemana.length != horasFin.length) {
            return "actividad_horario_incompleto";
        }

        int horariosValidos = 0;

        for (int i = 0; i < diasSemana.length; i++) {
            String dia = limpiar(diasSemana[i]);
            String horaInicio = limpiar(horasInicio[i]);
            String horaFin = limpiar(horasFin[i]);

            if (dia.isBlank() && horaInicio.isBlank() && horaFin.isBlank()) {
                continue;
            }

            if (dia.isBlank() || horaInicio.isBlank() || horaFin.isBlank()) {
                return "actividad_horario_incompleto";
            }

            if (!DIAS_VALIDOS.contains(dia)) {
                return "actividad_dia_invalido";
            }

            try {
                LocalTime inicio = LocalTime.parse(horaInicio);
                LocalTime fin = LocalTime.parse(horaFin);

                if (!inicio.isBefore(fin)) {
                    return "actividad_hora_invalida";
                }
            } catch (Exception e) {
                return "actividad_hora_formato_invalido";
            }

            horariosValidos++;
        }

        if (horariosValidos == 0) {
            return "actividad_horario_obligatorio";
        }

        return null;
    }

    public static List<HorarioActividad> construirHorarios(
            String[] diasSemana,
            String[] horasInicio,
            String[] horasFin
    ) {
        List<HorarioActividad> horarios = new ArrayList<>();

        if (diasSemana == null || horasInicio == null || horasFin == null) {
            return horarios;
        }

        for (int i = 0; i < diasSemana.length; i++) {
            String dia = limpiar(diasSemana[i]);
            String horaInicio = limpiar(horasInicio[i]);
            String horaFin = limpiar(horasFin[i]);

            if (dia.isBlank() || horaInicio.isBlank() || horaFin.isBlank()) {
                continue;
            }

            HorarioActividad horario = new HorarioActividad();
            horario.setDiaSemana(dia);
            horario.setHoraInicio(Time.valueOf(horaInicio + ":00"));
            horario.setHoraFin(Time.valueOf(horaFin + ":00"));

            horarios.add(horario);
        }

        return horarios;
    }

    public static String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }

    public static Integer convertirEntero(String valor) {
        return Integer.parseInt(limpiar(valor));
    }
}