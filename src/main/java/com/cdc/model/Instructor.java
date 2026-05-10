package com.cdc.model;

public class Instructor {
    private int idInstructor;
    private String nombreCompleto;
    private String celular;
    private String estadoInstructor;

    public int getIdInstructor() {
        return idInstructor;
    }

    public void setIdInstructor(int idInstructor) {
        this.idInstructor = idInstructor;
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

    public String getEstadoInstructor() {
        return estadoInstructor;
    }

    public void setEstadoInstructor(String estadoInstructor) {
        this.estadoInstructor = estadoInstructor;
    }
}