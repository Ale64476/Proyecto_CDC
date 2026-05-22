package com.cdc.util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpServletRequest;

public final class MensajeRedirect {

    private MensajeRedirect() {
    }

    public static String alumnos(HttpServletRequest request, Integer idAlumno, String tipo, String mensaje) {
        StringBuilder url = new StringBuilder();

        url.append(request.getContextPath()).append("/alumnos?");

        if (idAlumno != null && idAlumno > 0) {
            url.append("id=").append(idAlumno).append("&");
        }

        url.append("tipoMensaje=").append(codificar(tipo));
        url.append("&mensaje=").append(codificar(mensaje));

        return url.toString();
    }

    public static String actividades(HttpServletRequest request, Integer idActividad, String tipo, String mensaje) {
        StringBuilder url = new StringBuilder();

        url.append(request.getContextPath()).append("/talleres?");

        if (idActividad != null && idActividad > 0) {
            url.append("id=").append(idActividad).append("&");
    }

    url.append("tipoMensaje=").append(codificar(tipo));
    url.append("&mensaje=").append(codificar(mensaje));

    return url.toString();
    }

    public static String instructores(HttpServletRequest request, Integer idInstructor, String tipo, String mensaje) {
        StringBuilder url = new StringBuilder();

        url.append(request.getContextPath()).append("/instructores?");

        if (idInstructor != null && idInstructor > 0) {
            url.append("id=").append(idInstructor).append("&");
        }

        url.append("tipoMensaje=").append(codificar(tipo));
        url.append("&mensaje=").append(codificar(mensaje));

        return url.toString();
    }

    public static String gerontologia(HttpServletRequest request, Integer idPaciente, String tipo, String mensaje) {
        StringBuilder url = new StringBuilder();

        url.append(request.getContextPath()).append("/gerontologia?");

        if (idPaciente != null && idPaciente > 0) {
            url.append("id=").append(idPaciente).append("&");
        }

        url.append("tipoMensaje=").append(codificar(tipo));
        url.append("&mensaje=").append(codificar(mensaje));

        return url.toString();
    }

    public static String eventos(HttpServletRequest request, Integer idEvento, String tipo, String mensaje) {
        StringBuilder url = new StringBuilder();

        url.append(request.getContextPath()).append("/eventos?");

        if (idEvento != null && idEvento > 0) {
            url.append("id=").append(idEvento).append("&");
        }

        url.append("tipoMensaje=").append(codificar(tipo));
        url.append("&mensaje=").append(codificar(mensaje));

        return url.toString();
    }

    private static String codificar(String valor) {
        return URLEncoder.encode(valor, StandardCharsets.UTF_8);
    }
}