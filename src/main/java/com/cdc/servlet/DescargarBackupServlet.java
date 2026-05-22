package com.cdc.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.util.ConexionDB;

@WebServlet("/descargar-backup")
public class DescargarBackupServlet extends HttpServlet {

    private static final String NOMBRE_BD = "centrocomunitario";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fecha = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String nombreArchivo = "backup_" + NOMBRE_BD + "_" + fecha + ".sql";

        try (Connection conn = ConexionDB.getConnection()) {
            StringWriter stringWriter = new StringWriter();

            try (PrintWriter out = new PrintWriter(stringWriter)) {
                generarBackup(conn, out);
            }

            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/sql; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + nombreArchivo + "\"");
            response.getWriter().write(stringWriter.toString());

        } catch (Exception e) {
            response.reset();
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().write("Error al generar el backup: " + e.getMessage());
        }
    }

    private void generarBackup(Connection conn, PrintWriter out) throws Exception {
        List<String> tablas = obtenerObjetos(conn, "BASE TABLE");
        List<String> vistas = obtenerObjetos(conn, "VIEW");

        out.println("-- Backup completo de la base de datos " + NOMBRE_BD);
        out.println("-- Generado desde Proyecto_CDC");
        out.println("-- Fecha: " + LocalDateTime.now());
        out.println();

        out.println("CREATE DATABASE IF NOT EXISTS `" + NOMBRE_BD + "`");
        out.println("CHARACTER SET utf8mb4");
        out.println("COLLATE utf8mb4_spanish_ci;");
        out.println();
        out.println("USE `" + NOMBRE_BD + "`;");
        out.println();

        out.println("SET NAMES utf8mb4;");
        out.println("SET CHARACTER SET utf8mb4;");
        out.println("SET FOREIGN_KEY_CHECKS=0;");
        out.println();

        out.println("-- Eliminación de vistas");
        for (String vista : vistas) {
            out.println("DROP VIEW IF EXISTS `" + vista + "`;");
        }
        out.println();

        out.println("-- Eliminación de tablas");
        for (String tabla : tablas) {
            out.println("DROP TABLE IF EXISTS `" + tabla + "`;");
        }
        out.println();

        out.println("-- Creación de tablas");
        for (String tabla : tablas) {
            escribirCreateTabla(conn, out, tabla);
            out.println();
        }

        out.println("-- Datos de tablas");
        for (String tabla : tablas) {
            escribirDatosTabla(conn, out, tabla);
            out.println();
        }

        out.println("SET FOREIGN_KEY_CHECKS=1;");
        out.println();

        out.println("-- Creación de vistas");
        for (String vista : vistas) {
            escribirCreateVista(conn, out, vista);
            out.println();
        }
    }

    private List<String> obtenerObjetos(Connection conn, String tipo) throws Exception {
        List<String> objetos = new ArrayList<>();

        String sql = "SHOW FULL TABLES WHERE Table_type = '" + tipo + "'";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                objetos.add(rs.getString(1));
            }
        }

        return objetos;
    }

    private void escribirCreateTabla(Connection conn, PrintWriter out, String tabla) throws Exception {
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SHOW CREATE TABLE `" + tabla + "`")) {

            if (rs.next()) {
                out.println(rs.getString(2) + ";");
            }
        }
    }

    private void escribirCreateVista(Connection conn, PrintWriter out, String vista) throws Exception {
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SHOW CREATE VIEW `" + vista + "`")) {

            if (rs.next()) {
                String createView = rs.getString(2);
                createView = limpiarDefinerVista(createView);
                out.println(createView + ";");
            }
        }
    }

    private String limpiarDefinerVista(String createView) {
        return createView.replaceFirst(
                "(?is)^CREATE\\s+(?:ALGORITHM\\s*=\\s*\\S+\\s+)?(?:DEFINER\\s*=\\s*`[^`]+`@`[^`]+`\\s+)?(?:SQL\\s+SECURITY\\s+(?:DEFINER|INVOKER)\\s+)?VIEW",
                "CREATE VIEW"
        );
    }

    private void escribirDatosTabla(Connection conn, PrintWriter out, String tabla) throws Exception {
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM `" + tabla + "`")) {

            ResultSetMetaData meta = rs.getMetaData();
            int columnas = meta.getColumnCount();

            while (rs.next()) {
                StringBuilder sql = new StringBuilder();

                sql.append("INSERT INTO `").append(tabla).append("` (");

                for (int i = 1; i <= columnas; i++) {
                    if (i > 1) {
                        sql.append(", ");
                    }
                    sql.append("`").append(meta.getColumnName(i)).append("`");
                }

                sql.append(") VALUES (");

                for (int i = 1; i <= columnas; i++) {
                    if (i > 1) {
                        sql.append(", ");
                    }

                    sql.append(formatearValorSql(rs, meta, i));
                }

                sql.append(");");
                out.println(sql);
            }
        }
    }

    private String formatearValorSql(ResultSet rs, ResultSetMetaData meta, int columna) throws Exception {
        Object valor = rs.getObject(columna);

        if (valor == null) {
            return "NULL";
        }

        int tipo = meta.getColumnType(columna);

        if (valor instanceof Boolean) {
            return ((Boolean) valor) ? "1" : "0";
        }

        if (esTipoNumerico(tipo)) {
            return rs.getString(columna);
        }

        if (tipo == Types.BINARY || tipo == Types.VARBINARY || tipo == Types.LONGVARBINARY || tipo == Types.BLOB) {
            byte[] bytes = rs.getBytes(columna);
            if (bytes == null) {
                return "NULL";
            }
            return "0x" + convertirHex(bytes);
        }

        return "'" + escaparSql(rs.getString(columna)) + "'";
    }

    private boolean esTipoNumerico(int tipo) {
        return tipo == Types.INTEGER
                || tipo == Types.BIGINT
                || tipo == Types.SMALLINT
                || tipo == Types.TINYINT
                || tipo == Types.FLOAT
                || tipo == Types.DOUBLE
                || tipo == Types.REAL
                || tipo == Types.DECIMAL
                || tipo == Types.NUMERIC;
    }

    private String convertirHex(byte[] bytes) {
        StringBuilder hex = new StringBuilder();

        for (byte b : bytes) {
            hex.append(String.format("%02X", b));
        }

        return hex.toString();
    }

    private String escaparSql(String valor) {
        if (valor == null) {
            return "";
        }

        return valor
                .replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
}