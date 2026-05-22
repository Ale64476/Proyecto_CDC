package com.cdc.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.cdc.util.ConexionDB;
import com.cdc.util.MensajeRedirect;

@WebServlet("/importar-backup")
@MultipartConfig(
        maxFileSize = 20 * 1024 * 1024,
        maxRequestSize = 25 * 1024 * 1024
)
public class ImportarBackupServlet extends HttpServlet {

    private static final String[] VISTAS_OBLIGATORIAS = {
            "vw_actividad_detalle",
            "vw_calendario_completo",
            "vw_catalogo_instructores",
            "vw_dashboard_actividades_hoy",
            "vw_dashboard_avisos",
            "vw_dashboard_proximas_actividades",
            "vw_dashboard_resumen",
            "vw_reporte_actividades",
            "vw_reporte_alumnos",
            "vw_reporte_alumnos_por_actividad",
            "vw_reporte_asistencia_por_actividad"
    };

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part archivo = request.getPart("archivoBackup");

        if (archivo == null || archivo.getSize() == 0) {
            response.sendRedirect(MensajeRedirect.dashboard(request, "error", "Selecciona un archivo SQL válido."));
            return;
        }

        String nombreArchivo = archivo.getSubmittedFileName();

        if (nombreArchivo == null || !nombreArchivo.toLowerCase(Locale.ROOT).endsWith(".sql")) {
            response.sendRedirect(MensajeRedirect.dashboard(request, "error", "Solo se permiten archivos con extensión .sql."));
            return;
        }

        try {
            String contenidoSql = leerArchivoSql(archivo);
            validarBackupCompleto(contenidoSql);
            ejecutarScriptSql(contenidoSql);

            response.sendRedirect(MensajeRedirect.dashboard(request, "exito", "Backup importado correctamente."));
        } catch (Exception e) {
            response.sendRedirect(MensajeRedirect.dashboard(request, "error", "Error al importar backup: " + e.getMessage()));
        }
    }

    private String leerArchivoSql(Part archivo) throws IOException {
        StringBuilder contenido = new StringBuilder();

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(archivo.getInputStream(), StandardCharsets.UTF_8))) {

            String linea;

            while ((linea = reader.readLine()) != null) {
                contenido.append(linea).append("\n");
            }
        }

        return contenido.toString();
    }

    private void validarBackupCompleto(String contenidoSql) {
        if (contenidoSql == null || contenidoSql.trim().isEmpty()) {
            throw new IllegalArgumentException("El archivo SQL está vacío.");
        }

        String normalizado = contenidoSql.toLowerCase(Locale.ROOT);

        if (!normalizado.contains("create database")
                || !normalizado.contains("centrocomunitario")
                || !normalizado.contains("use `centrocomunitario`")) {
            throw new IllegalArgumentException("El archivo no parece ser un backup completo de centrocomunitario.");
        }

        if (!normalizado.contains("create view")) {
            throw new IllegalArgumentException("El backup no contiene vistas. No se puede restaurar porque el sistema depende de vistas.");
        }

        for (String vista : VISTAS_OBLIGATORIAS) {
            if (!normalizado.contains(vista.toLowerCase(Locale.ROOT))) {
                throw new IllegalArgumentException("El backup está incompleto. Falta la vista: " + vista);
            }
        }
    }

    private void ejecutarScriptSql(String contenidoSql) throws Exception {
        List<String> sentencias = dividirSentenciasSql(contenidoSql);

        try (Connection conn = ConexionDB.getConnection();
             Statement stmt = conn.createStatement()) {

            for (String sentencia : sentencias) {
                String sql = sentencia.trim();

                if (sql.isEmpty()) {
                    continue;
                }

                stmt.execute(sql);
            }
        }
    }

    private List<String> dividirSentenciasSql(String contenidoSql) {
        List<String> sentencias = new ArrayList<>();
        StringBuilder actual = new StringBuilder();

        boolean enComillaSimple = false;
        boolean enComillaDoble = false;
        boolean enBacktick = false;
        boolean enComentarioLinea = false;
        boolean enComentarioBloque = false;
        boolean escape = false;

        for (int i = 0; i < contenidoSql.length(); i++) {
            char c = contenidoSql.charAt(i);
            char siguiente = (i + 1 < contenidoSql.length()) ? contenidoSql.charAt(i + 1) : '\0';

            if (enComentarioLinea) {
                actual.append(c);

                if (c == '\n') {
                    enComentarioLinea = false;
                }

                continue;
            }

            if (enComentarioBloque) {
                actual.append(c);

                if (c == '*' && siguiente == '/') {
                    actual.append(siguiente);
                    i++;
                    enComentarioBloque = false;
                }

                continue;
            }

            if (!enComillaSimple && !enComillaDoble && !enBacktick) {
                if (c == '-' && siguiente == '-') {
                    actual.append(c);
                    actual.append(siguiente);
                    i++;
                    enComentarioLinea = true;
                    continue;
                }

                if (c == '#') {
                    actual.append(c);
                    enComentarioLinea = true;
                    continue;
                }

                if (c == '/' && siguiente == '*') {
                    actual.append(c);
                    actual.append(siguiente);
                    i++;
                    enComentarioBloque = true;
                    continue;
                }
            }

            if ((enComillaSimple || enComillaDoble) && escape) {
                actual.append(c);
                escape = false;
                continue;
            }

            if ((enComillaSimple || enComillaDoble) && c == '\\') {
                actual.append(c);
                escape = true;
                continue;
            }

            if (c == '\'' && !enComillaDoble && !enBacktick) {
                enComillaSimple = !enComillaSimple;
                actual.append(c);
                continue;
            }

            if (c == '"' && !enComillaSimple && !enBacktick) {
                enComillaDoble = !enComillaDoble;
                actual.append(c);
                continue;
            }

            if (c == '`' && !enComillaSimple && !enComillaDoble) {
                enBacktick = !enBacktick;
                actual.append(c);
                continue;
            }

            if (c == ';' && !enComillaSimple && !enComillaDoble && !enBacktick) {
                sentencias.add(actual.toString());
                actual.setLength(0);
                continue;
            }

            actual.append(c);
        }

        String restante = actual.toString().trim();

        if (!restante.isEmpty()) {
            sentencias.add(restante);
        }

        return sentencias;
    }
}