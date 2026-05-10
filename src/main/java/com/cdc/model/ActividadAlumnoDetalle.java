package com.cdc.model;

public class ActividadAlumnoDetalle {
    private int idActividad;
    private String nombreActividad;
    private String nombreInstructor;
    private String horarios;
    private int asistenciasDelMes;
    private String estadoActividad;

    public ActividadAlumnoDetalle() {
    }

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

    public String getNombreInstructor() {
        return nombreInstructor;
    }

    public void setNombreInstructor(String nombreInstructor) {
        this.nombreInstructor = nombreInstructor;
    }

    public String getHorarios() {
        return horarios;
    }

    public void setHorarios(String horarios) {
        this.horarios = horarios;
    }

    public int getAsistenciasDelMes() {
        return asistenciasDelMes;
    }

    public void setAsistenciasDelMes(int asistenciasDelMes) {
        this.asistenciasDelMes = asistenciasDelMes;
    }

    public String getEstadoActividad() {
        return estadoActividad;
    }

    public void setEstadoActividad(String estadoActividad) {
        this.estadoActividad = estadoActividad;
    }
}