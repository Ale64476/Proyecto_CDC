package com.cdc.model;

public class ReporteActividad {
    private int idActividad;
    private String nombreActividad;
    private String instructor;
    private String horarios;
    private int cantidadInscritos;
    private String estadoActividad;

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

    public String getInstructor() {
        return instructor;
    }

    public void setInstructor(String instructor) {
        this.instructor = instructor;
    }

    public String getHorarios() {
        return horarios;
    }

    public void setHorarios(String horarios) {
        this.horarios = horarios;
    }

    public int getCantidadInscritos() {
        return cantidadInscritos;
    }

    public void setCantidadInscritos(int cantidadInscritos) {
        this.cantidadInscritos = cantidadInscritos;
    }

    public String getEstadoActividad() {
        return estadoActividad;
    }

    public void setEstadoActividad(String estadoActividad) {
        this.estadoActividad = estadoActividad;
    }
}