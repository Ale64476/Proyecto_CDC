package com.cdc.model;

public class DashboardResumen {
    private int totalAlumnosRegistrados;
    private int totalActividadesActivas;
    private int actividadesDeHoy;
    private int asistenciasRegistradasHoy;

    public DashboardResumen() {
    }

    public int getTotalAlumnosRegistrados() {
        return totalAlumnosRegistrados;
    }

    public void setTotalAlumnosRegistrados(int totalAlumnosRegistrados) {
        this.totalAlumnosRegistrados = totalAlumnosRegistrados;
    }

    public int getTotalActividadesActivas() {
        return totalActividadesActivas;
    }

    public void setTotalActividadesActivas(int totalActividadesActivas) {
        this.totalActividadesActivas = totalActividadesActivas;
    }

    public int getActividadesDeHoy() {
        return actividadesDeHoy;
    }

    public void setActividadesDeHoy(int actividadesDeHoy) {
        this.actividadesDeHoy = actividadesDeHoy;
    }

    public int getAsistenciasRegistradasHoy() {
        return asistenciasRegistradasHoy;
    }

    public void setAsistenciasRegistradasHoy(int asistenciasRegistradasHoy) {
        this.asistenciasRegistradasHoy = asistenciasRegistradasHoy;
    }
}