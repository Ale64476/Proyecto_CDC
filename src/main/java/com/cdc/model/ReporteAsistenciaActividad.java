package com.cdc.model;

import java.sql.Date;
import java.sql.Timestamp;

public class ReporteAsistenciaActividad {
    private String nombreAlumno;
    private String nombreActividad;
    private Date fechaAsistencia;
    private boolean asistio;
    private Timestamp fechaRegistroAsistencia;
    private String registradoPor;

    public String getNombreAlumno() {
        return nombreAlumno;
    }

    public void setNombreAlumno(String nombreAlumno) {
        this.nombreAlumno = nombreAlumno;
    }

    public String getNombreActividad() {
        return nombreActividad;
    }

    public void setNombreActividad(String nombreActividad) {
        this.nombreActividad = nombreActividad;
    }

    public Date getFechaAsistencia() {
        return fechaAsistencia;
    }

    public void setFechaAsistencia(Date fechaAsistencia) {
        this.fechaAsistencia = fechaAsistencia;
    }

    public boolean isAsistio() {
        return asistio;
    }

    public void setAsistio(boolean asistio) {
        this.asistio = asistio;
    }

    public Timestamp getFechaRegistroAsistencia() {
        return fechaRegistroAsistencia;
    }

    public void setFechaRegistroAsistencia(Timestamp fechaRegistroAsistencia) {
        this.fechaRegistroAsistencia = fechaRegistroAsistencia;
    }

    public String getRegistradoPor() {
        return registradoPor;
    }

    public void setRegistradoPor(String registradoPor) {
        this.registradoPor = registradoPor;
    }
}