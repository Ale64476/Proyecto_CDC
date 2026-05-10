package com.cdc.model;

public class AlumnoInscritoActividad {
    private int idAlumno;
    private String nombreCompleto;
    private String celular;
    private int asistenciasDelMes;

    public AlumnoInscritoActividad() {
    }

    public int getIdAlumno() {
        return idAlumno;
    }

    public void setIdAlumno(int idAlumno) {
        this.idAlumno = idAlumno;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getCelular() {
        return celular;
    }

    public void setCelular(String celular) {
        this.celular = celular;
    }

    public int getAsistenciasDelMes() {
        return asistenciasDelMes;
    }

    public void setAsistenciasDelMes(int asistenciasDelMes) {
        this.asistenciasDelMes = asistenciasDelMes;
    }
}