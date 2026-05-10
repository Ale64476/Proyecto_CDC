package com.cdc.model;

import java.sql.Timestamp;

public class Aviso {
    private int idAviso;
    private String titulo;
    private String mensaje;
    private String estadoAviso;
    private Timestamp fechaCreacion;
    private Timestamp fechaInicio;
    private Timestamp fechaFin;

    public Aviso() {
    }

    public int getIdAviso() {
        return idAviso;
    }

    public void setIdAviso(int idAviso) {
        this.idAviso = idAviso;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public String getEstadoAviso() {
        return estadoAviso;
    }

    public void setEstadoAviso(String estadoAviso) {
        this.estadoAviso = estadoAviso;
    }

    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public Timestamp getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Timestamp fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Timestamp getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Timestamp fechaFin) {
        this.fechaFin = fechaFin;
    }
}