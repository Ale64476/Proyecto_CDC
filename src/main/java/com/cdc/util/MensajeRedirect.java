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

    url.append(request.getContextPath()).append("/actividades?");

    if (idActividad != null && idActividad > 0) {
        url.append("id=").append(idActividad).append("&");
    }

    url.append("tipoMensaje=").append(codificar(tipo));
    url.append("&mensaje=").append(codificar(mensaje));

    return url.toString();
}

    private static String codificar(String valor) {
        return URLEncoder.encode(valor, StandardCharsets.UTF_8);
    }
}