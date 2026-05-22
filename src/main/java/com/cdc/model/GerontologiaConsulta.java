package com.cdc.model;

import java.sql.Timestamp;

public class GerontologiaConsulta {

    private int idConsulta;
    private int idPaciente;

    private Timestamp fechaConsulta;

    private String nombrePacienteSnapshot;
    private int edadPacienteSnapshot;

    private String motivoConsulta;
    private String antecedentes;
    private String notas;

    private Timestamp fechaCreacion;
    private Timestamp fechaActualizacion;

    public GerontologiaConsulta() {
    }

    public int getIdConsulta() {
        return idConsulta;
    }

    public void setIdConsulta(int idConsulta) {
        this.idConsulta = idConsulta;
    }

    public int getIdPaciente() {
        return idPaciente;
    }

    public void setIdPaciente(int idPaciente) {
        this.idPaciente = idPaciente;
    }

    public Timestamp getFechaConsulta() {
        return fechaConsulta;
    }

    public void setFechaConsulta(Timestamp fechaConsulta) {
        this.fechaConsulta = fechaConsulta;
    }

    public String getNombrePacienteSnapshot() {
        return nombrePacienteSnapshot;
    }

    public void setNombrePacienteSnapshot(String nombrePacienteSnapshot) {
        this.nombrePacienteSnapshot = nombrePacienteSnapshot;
    }

    public int getEdadPacienteSnapshot() {
        return edadPacienteSnapshot;
    }

    public void setEdadPacienteSnapshot(int edadPacienteSnapshot) {
        this.edadPacienteSnapshot = edadPacienteSnapshot;
    }

    public String getMotivoConsulta() {
        return motivoConsulta;
    }

    public void setMotivoConsulta(String motivoConsulta) {
        this.motivoConsulta = motivoConsulta;
    }

    public String getAntecedentes() {
        return antecedentes;
    }

    public void setAntecedentes(String antecedentes) {
        this.antecedentes = antecedentes;
    }

    public String getNotas() {
        return notas;
    }

    public void setNotas(String notas) {
        this.notas = notas;
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
