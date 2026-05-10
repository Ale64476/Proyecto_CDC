package com.cdc.model;

import java.sql.Timestamp;

public class Actividad {
    private int idActividad;
    private String nombreActividad;
    private String descripcionActividad;
    private int idInstructor;
    private String nombreInstructor;
    private String estadoActividad;
    private Timestamp fechaCreacion;
    private Timestamp fechaDesactivacion;
    private int totalInscritos;
    private String horariosResumen;

    public Actividad() {
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

    public String getDescripcionActividad() {
        return descripcionActividad;
    }

    public void setDescripcionActividad(String descripcionActividad) {
        this.descripcionActividad = descripcionActividad;
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

    public String getEstadoActividad() {
        return estadoActividad;
    }

    public void setEstadoActividad(String estadoActividad) {
        this.estadoActividad = estadoActividad;
    }

    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public Timestamp getFechaDesactivacion() {
        return fechaDesactivacion;
    }

    public void setFechaDesactivacion(Timestamp fechaDesactivacion) {
        this.fechaDesactivacion = fechaDesactivacion;
    }

    public int getTotalInscritos() {
        return totalInscritos;
    }

    public void setTotalInscritos(int totalInscritos) {
        this.totalInscritos = totalInscritos;
    }

    public String getHorariosResumen() {
        return horariosResumen;
    }

    public void setHorariosResumen(String horariosResumen) {
        this.horariosResumen = horariosResumen;
    }
}