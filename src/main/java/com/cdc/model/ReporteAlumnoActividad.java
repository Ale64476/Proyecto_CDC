package com.cdc.model;

public class ReporteAlumnoActividad {
    private int idAlumno;
    private String nombreAlumno;
    private String celular;
    private int idActividad;
    private String nombreActividad;
    private String instructor;
    private int asistenciasDelMes;
    private String estadoAlumno;

    public String getEstadoAlumno() {
        return estadoAlumno;
    }

    public void setEstadoAlumno(String estadoAlumno) {
        this.estadoAlumno = estadoAlumno;
    }

    public int getIdAlumno() {
        return idAlumno;
    }

    public void setIdAlumno(int idAlumno) {
        this.idAlumno = idAlumno;
    }

    public String getNombreAlumno() {
        return nombreAlumno;
    }

    public void setNombreAlumno(String nombreAlumno) {
        this.nombreAlumno = nombreAlumno;
    }

    public String getCelular() {
        return celular;
    }

    public void setCelular(String celular) {
        this.celular = celular;
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

    public String getInstructor() {
        return instructor;
    }

    public void setInstructor(String instructor) {
        this.instructor = instructor;
    }

    public int getAsistenciasDelMes() {
        return asistenciasDelMes;
    }

    public void setAsistenciasDelMes(int asistenciasDelMes) {
        this.asistenciasDelMes = asistenciasDelMes;
    }
}