package com.cdc.model;

import java.sql.Time;

public class HorarioActividad {
    private int idHorarioActividad;
    private int idActividad;
    private String diaSemana;
    private Time horaInicio;
    private Time horaFin;

    public int getIdHorarioActividad() {
        return idHorarioActividad;
    }

    public void setIdHorarioActividad(int idHorarioActividad) {
        this.idHorarioActividad = idHorarioActividad;
    }

    public int getIdActividad() {
        return idActividad;
    }

    public void setIdActividad(int idActividad) {
        this.idActividad = idActividad;
    }

    public String getDiaSemana() {
        return diaSemana;
    }

    public void setDiaSemana(String diaSemana) {
        this.diaSemana = diaSemana;
    }

    public Time getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(Time horaInicio) {
        this.horaInicio = horaInicio;
    }

    public Time getHoraFin() {
        return horaFin;
    }

    public void setHoraFin(Time horaFin) {
        this.horaFin = horaFin;
    }
}