package com.cdc.model;

import java.sql.Time;

public class CalendarioActividad {
    private int idActividad;
    private String nombreActividad;
    private String estadoActividad;
    private int idInstructor;
    private String nombreInstructor;
    private int idHorarioActividad;
    private String diaSemana;
    private Time horaInicio;
    private Time horaFin;
    private int ordenDia;

    public int getIdActividad() {
        return idActividad;
    }

    public void setIdActividad(int idActividad) {
        this.idActividad = idActividad;
    }

    public String getNombreActividad() {
        return nombreActividad;
    }

    public void setNombreActividad(String nombreActividad) {
        this.nombreActividad = nombreActividad;
    }

    public String getEstadoActividad() {
        return estadoActividad;
    }

    public void setEstadoActividad(String estadoActividad) {
        this.estadoActividad = estadoActividad;
    }

    public int getIdInstructor() {
        return idInstructor;
    }

    public void setIdInstructor(int idInstructor) {
        this.idInstructor = idInstructor;
    }

    public String getNombreInstructor() {
        return nombreInstructor;
    }

    public void setNombreInstructor(String nombreInstructor) {
        this.nombreInstructor = nombreInstructor;
    }

    public int getIdHorarioActividad() {
        return idHorarioActividad;
    }

    public void setIdHorarioActividad(int idHorarioActividad) {
        this.idHorarioActividad = idHorarioActividad;
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

    public int getOrdenDia() {
        return ordenDia;
    }

    public void setOrdenDia(int ordenDia) {
        this.ordenDia = ordenDia;
    }
}