package com.cdc.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Evento {

    private int idEvento;

    private String nombreEvento;
    private String descripcionEvento;

    private Date fechaEvento;
    private Time horaInicio;
    private Time horaFin;

    private String lugar;
    private String responsable;

    private String estadoEvento;

    private String textoPublicacion;

    private String urlFormulario;
    private String googleFormId;

    private String urlHojaRespuestas;
    private String googleSheetId;

    private String facebookPostId;

    private Timestamp fechaCreacion;
    private Timestamp fechaActualizacion;

    public Evento() {
    }

    public int getIdEvento() {
        return idEvento;
    }

    public void setIdEvento(int idEvento) {
        this.idEvento = idEvento;
    }

    public String getNombreEvento() {
        return nombreEvento;
    }

    public void setNombreEvento(String nombreEvento) {
        this.nombreEvento = nombreEvento;
    }

    public String getDescripcionEvento() {
        return descripcionEvento;
    }

    public void setDescripcionEvento(String descripcionEvento) {
        this.descripcionEvento = descripcionEvento;
    }

    public Date getFechaEvento() {
        return fechaEvento;
    }

    public void setFechaEvento(Date fechaEvento) {
        this.fechaEvento = fechaEvento;
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

    public String getLugar() {
        return lugar;
    }

    public void setLugar(String lugar) {
        this.lugar = lugar;
    }

    public String getResponsable() {
        return responsable;
    }

    public void setResponsable(String responsable) {
        this.responsable = responsable;
    }

    public String getEstadoEvento() {
        return estadoEvento;
    }

    public void setEstadoEvento(String estadoEvento) {
        this.estadoEvento = estadoEvento;
    }

    public String getTextoPublicacion() {
        return textoPublicacion;
    }

    public void setTextoPublicacion(String textoPublicacion) {
        this.textoPublicacion = textoPublicacion;
    }

    public String getUrlFormulario() {
        return urlFormulario;
    }

    public void setUrlFormulario(String urlFormulario) {
        this.urlFormulario = urlFormulario;
    }

    public String getGoogleFormId() {
        return googleFormId;
    }

    public void setGoogleFormId(String googleFormId) {
        this.googleFormId = googleFormId;
    }

    public String getUrlHojaRespuestas() {
        return urlHojaRespuestas;
    }

    public void setUrlHojaRespuestas(String urlHojaRespuestas) {
        this.urlHojaRespuestas = urlHojaRespuestas;
    }

    public String getGoogleSheetId() {
        return googleSheetId;
    }

    public void setGoogleSheetId(String googleSheetId) {
        this.googleSheetId = googleSheetId;
    }

    public String getFacebookPostId() {
        return facebookPostId;
    }

    public void setFacebookPostId(String facebookPostId) {
        this.facebookPostId = facebookPostId;
    }

    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public Timestamp getFechaActualizacion() {
        return fechaActualizacion;
    }

    public void setFechaActualizacion(Timestamp fechaActualizacion) {
        this.fechaActualizacion = fechaActualizacion;
    }
}