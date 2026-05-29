package com.cdc.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import com.cdc.model.GoogleFormResponse;
import com.cdc.util.GoogleConfig;

public class GoogleFormService {

private static final String APPS_SCRIPT_URL = GoogleConfig.get("apps.script.url");
private static final String SECRET_KEY = GoogleConfig.get("apps.script.secret");

    public GoogleFormResponse generarFormularioEvento(
            String nombreEvento,
            String descripcionEvento,
            String fechaEvento,
            String horaInicio,
            String horaFin,
            String lugar,
            String responsable
    ) {
        GoogleFormResponse respuesta = new GoogleFormResponse();

        try {
            String json = construirJson(
                    nombreEvento,
                    descripcionEvento,
                    fechaEvento,
                    horaInicio,
                    horaFin,
                    lugar,
                    responsable
            );

            String respuestaJson = enviarPost(json);

            return convertirRespuesta(respuestaJson);

        } catch (Exception e) {
            respuesta.setOk(false);
            respuesta.setMensaje("Error al generar formulario de Google: " + e.getMessage());
            return respuesta;
        }
    }

    private String enviarPost(String json) throws IOException {
        URL url = new URL(APPS_SCRIPT_URL);
        HttpURLConnection conexion = (HttpURLConnection) url.openConnection();

        conexion.setRequestMethod("POST");
        conexion.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conexion.setRequestProperty("Accept", "application/json");
        conexion.setDoOutput(true);
        conexion.setConnectTimeout(15000);
        conexion.setReadTimeout(30000);

        byte[] cuerpo = json.getBytes(StandardCharsets.UTF_8);

        try (OutputStream os = conexion.getOutputStream()) {
            os.write(cuerpo);
        }

        int codigoRespuesta = conexion.getResponseCode();

        InputStream streamRespuesta;

        if (codigoRespuesta >= 200 && codigoRespuesta < 300) {
            streamRespuesta = conexion.getInputStream();
        } else {
            streamRespuesta = conexion.getErrorStream();
        }

        String textoRespuesta = leerStream(streamRespuesta);

        if (codigoRespuesta < 200 || codigoRespuesta >= 300) {
            throw new IOException("HTTP " + codigoRespuesta + ": " + textoRespuesta);
        }

        return textoRespuesta;
    }

    private String leerStream(InputStream stream) throws IOException {
        if (stream == null) {
            return "";
        }

        StringBuilder sb = new StringBuilder();

        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(stream, StandardCharsets.UTF_8))) {

            String linea;

            while ((linea = br.readLine()) != null) {
                sb.append(linea);
            }
        }

        return sb.toString();
    }

    private String construirJson(
            String nombreEvento,
            String descripcionEvento,
            String fechaEvento,
            String horaInicio,
            String horaFin,
            String lugar,
            String responsable
    ) {
        return "{"
                + "\"secret\":\"" + escaparJson(SECRET_KEY) + "\","
                + "\"nombreEvento\":\"" + escaparJson(nombreEvento) + "\","
                + "\"descripcionEvento\":\"" + escaparJson(descripcionEvento) + "\","
                + "\"fechaEvento\":\"" + escaparJson(fechaEvento) + "\","
                + "\"horaInicio\":\"" + escaparJson(horaInicio) + "\","
                + "\"horaFin\":\"" + escaparJson(horaFin) + "\","
                + "\"lugar\":\"" + escaparJson(lugar) + "\","
                + "\"responsable\":\"" + escaparJson(responsable) + "\""
                + "}";
    }

    private String escaparJson(String valor) {
        if (valor == null) {
            return "";
        }

        return valor
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private GoogleFormResponse convertirRespuesta(String json) {
        GoogleFormResponse respuesta = new GoogleFormResponse();

        respuesta.setOk(Boolean.parseBoolean(extraerValor(json, "ok")));
        respuesta.setMensaje(extraerValor(json, "mensaje"));
        respuesta.setFormId(extraerValor(json, "formId"));
        respuesta.setFormUrl(extraerValor(json, "formUrl"));
        respuesta.setFormEditUrl(extraerValor(json, "formEditUrl"));
        respuesta.setSheetId(extraerValor(json, "sheetId"));
        respuesta.setSheetUrl(extraerValor(json, "sheetUrl"));

        return respuesta;
    }

    private String extraerValor(String json, String campo) {
        if (json == null || json.isBlank()) {
            return "";
        }

        String patronTexto = "\"" + campo + "\":\"";
        int inicioTexto = json.indexOf(patronTexto);

        if (inicioTexto >= 0) {
            inicioTexto += patronTexto.length();
            StringBuilder valor = new StringBuilder();
            boolean escapando = false;

            for (int i = inicioTexto; i < json.length(); i++) {
                char c = json.charAt(i);

                if (escapando) {
                    switch (c) {
                        case 'n':
                            valor.append('\n');
                            break;
                        case 'r':
                            valor.append('\r');
                            break;
                        case 't':
                            valor.append('\t');
                            break;
                        case '"':
                            valor.append('"');
                            break;
                        case '\\':
                            valor.append('\\');
                            break;
                        default:
                            valor.append(c);
                            break;
                    }
                    escapando = false;
                } else if (c == '\\') {
                    escapando = true;
                } else if (c == '"') {
                    return valor.toString();
                } else {
                    valor.append(c);
                }
            }
        }

        String patronBoolean = "\"" + campo + "\":";
        int inicioBoolean = json.indexOf(patronBoolean);

        if (inicioBoolean >= 0) {
            inicioBoolean += patronBoolean.length();

            int fin = json.indexOf(",", inicioBoolean);

            if (fin == -1) {
                fin = json.indexOf("}", inicioBoolean);
            }

            if (fin > inicioBoolean) {
                return json.substring(inicioBoolean, fin).trim();
            }
        }

        return "";
    }
}