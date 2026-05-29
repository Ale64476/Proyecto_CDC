package com.cdc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cdc.model.ReporteActividad;
import com.cdc.model.ReporteAlumno;
import com.cdc.model.ReporteAlumnoActividad;
import com.cdc.model.ReporteAsistenciaActividad;
import com.cdc.model.ReporteGerontologiaPaciente;
import com.cdc.util.ConexionDB;

public class ReporteDAO {

    private static final String SQL_REPORTE_ALUMNOS = """
            SELECT id_alumno, nombre_completo, fecha_nacimiento, curp, domicilio,
                   celular, estado_alumno, fecha_baja
            FROM vw_reporte_alumnos
            ORDER BY nombre_completo ASC
            """;

    private static final String SQL_REPORTE_ACTIVIDADES = """
            SELECT id_actividad, nombre_actividad, instructor, horarios,
                   cantidad_inscritos, estado_actividad
            FROM vw_reporte_actividades
            ORDER BY nombre_actividad ASC
            """;

    private static final String SQL_REPORTE_ALUMNOS_POR_ACTIVIDAD = """
            SELECT id_alumno, nombre_alumno, celular, estado_alumno, id_actividad,
                nombre_actividad, instructor, asistencias_del_mes
            FROM vw_reporte_alumnos_por_actividad
            """;

    private static final String SQL_REPORTE_ASISTENCIA_POR_ACTIVIDAD = """
            SELECT nombre_alumno, nombre_actividad, fecha_asistencia,
                   asistio, fecha_registro_asistencia, registrado_por
            FROM vw_reporte_asistencia_por_actividad
           
            """;

    private static final String SQL_REPORTE_GERONTOLOGIA_PACIENTES = """
            SELECT
                p.nombre_completo,
                p.curp,
                p.celular,
                p.fecha_nacimiento,
                TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad,
                p.estado_paciente,
                COUNT(c.id_consulta) AS total_consultas,
                MAX(c.fecha_consulta) AS ultima_consulta,
                p.fecha_creacion,
                p.fecha_actualizacion
            FROM gerontologia_paciente p
            LEFT JOIN gerontologia_consulta c ON p.id_paciente = c.id_paciente
            """;

    public List<ReporteAlumno> listarReporteAlumnos(String estadoAlumno) {
        List<ReporteAlumno> lista = new ArrayList<>();
                String sql = SQL_REPORTE_ALUMNOS;

        if (estadoAlumno != null && !estadoAlumno.isBlank()) {
            sql = """
                SELECT id_alumno, nombre_completo, fecha_nacimiento, curp, domicilio, celular, estado_alumno, fecha_baja
                FROM vw_reporte_alumnos
                WHERE estado_alumno = ?
                ORDER BY nombre_completo ASC
            """;
        }

        try (Connection connection = ConexionDB.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)) {

            if (estadoAlumno != null && !estadoAlumno.isBlank()) {
                statement.setString(1, estadoAlumno);
            }

    try (ResultSet resultSet = statement.executeQuery()) {

        

            while (resultSet.next()) {
                ReporteAlumno item = new ReporteAlumno();
                item.setIdAlumno(resultSet.getInt("id_alumno"));
                item.setNombreCompleto(resultSet.getString("nombre_completo"));
                item.setFechaNacimiento(resultSet.getDate("fecha_nacimiento"));
                item.setCurp(resultSet.getString("curp"));
                item.setDomicilio(resultSet.getString("domicilio"));
                item.setCelular(resultSet.getString("celular"));
                item.setEstadoAlumno(resultSet.getString("estado_alumno"));
                item.setFechaBaja(resultSet.getTimestamp("fecha_baja"));
                lista.add(item);
            }

        }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener reporte de alumnos.", e);
        }

        return lista;
    }

    public List<ReporteActividad> listarReporteActividades(String estadoTaller) {
        List<ReporteActividad> lista = new ArrayList<>();

       String sql = SQL_REPORTE_ACTIVIDADES;

        if (estadoTaller != null && !estadoTaller.isBlank()) {
            sql = """
                SELECT id_actividad, nombre_actividad, instructor, horarios, cantidad_inscritos, estado_actividad
                FROM vw_reporte_actividades
                WHERE estado_actividad = ?
                ORDER BY nombre_actividad ASC
            """;
        }

        try (Connection connection = ConexionDB.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)) {

            if (estadoTaller != null && !estadoTaller.isBlank()) {
                statement.setString(1, estadoTaller);
            }

        try (ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                ReporteActividad item = new ReporteActividad();
                item.setIdActividad(resultSet.getInt("id_actividad"));
                item.setNombreActividad(resultSet.getString("nombre_actividad"));
                item.setInstructor(resultSet.getString("instructor"));
                item.setHorarios(resultSet.getString("horarios"));
                item.setCantidadInscritos(resultSet.getInt("cantidad_inscritos"));
                item.setEstadoActividad(resultSet.getString("estado_actividad"));
                lista.add(item);
            }
        }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener reporte de talleres.", e);
        }

        return lista;
    }

    public List<ReporteAlumnoActividad> listarReporteAlumnosPorActividad(String idActividad, String estadoAlumno) {
        List<ReporteAlumnoActividad> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SQL_REPORTE_ALUMNOS_POR_ACTIVIDAD);
        List<Object> parametros = new ArrayList<>();

        sql.append(" WHERE 1 = 1 ");

        if (idActividad != null && !idActividad.trim().isEmpty() && !"0".equals(idActividad)) {
            sql.append(" AND id_actividad = ? ");
            parametros.add(Integer.parseInt(idActividad));
        }

        if (estadoAlumno != null 
                && !estadoAlumno.trim().isEmpty() 
                && !"Todos".equalsIgnoreCase(estadoAlumno)) {
            sql.append(" AND estado_alumno = ? ");
            parametros.add(estadoAlumno);
        }

        if (idActividad != null && !idActividad.trim().isEmpty() && !"0".equals(idActividad)) {
            sql.append(" ORDER BY nombre_alumno ASC ");
        } else {
            sql.append(" ORDER BY nombre_actividad ASC, nombre_alumno ASC ");
        }

        try (Connection connection = ConexionDB.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < parametros.size(); i++) {
                ps.setObject(i + 1, parametros.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReporteAlumnoActividad reporte = new ReporteAlumnoActividad();

                    reporte.setIdAlumno(rs.getInt("id_alumno"));
                    reporte.setNombreAlumno(rs.getString("nombre_alumno"));
                    reporte.setCelular(rs.getString("celular"));
                    reporte.setEstadoAlumno(rs.getString("estado_alumno"));
                    reporte.setIdActividad(rs.getInt("id_actividad"));
                    reporte.setNombreActividad(rs.getString("nombre_actividad"));
                    reporte.setInstructor(rs.getString("instructor"));
                    reporte.setAsistenciasDelMes(rs.getInt("asistencias_del_mes"));

                    lista.add(reporte);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener reporte de alumnos por taller.", e);
        }

        return lista;
    }

    public List<ReporteAsistenciaActividad> listarReporteAsistenciaPorActividad(String idActividad, String fechaInicio, String fechaFin) {
        List<ReporteAsistenciaActividad> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder(SQL_REPORTE_ASISTENCIA_POR_ACTIVIDAD);
        List<Object> parametros = new ArrayList<>();

        if (idActividad != null && !idActividad.isBlank()) {
            sql.append(" WHERE id_actividad = ?");
            parametros.add(Integer.parseInt(idActividad));
        }

        if (fechaInicio != null && !fechaInicio.isBlank()) {
            sql.append(parametros.isEmpty() ? " WHERE fecha >= ?" : " AND fecha >= ?");
            parametros.add(fechaInicio);
        }

        if (fechaFin != null && !fechaFin.isBlank()) {
            sql.append(parametros.isEmpty() ? " WHERE fecha <= ?" : " AND fecha <= ?");
            parametros.add(fechaFin);
        }

        sql.append(" ORDER BY fecha_asistencia DESC, nombre_actividad ASC, nombre_alumno ASC");

        try (Connection connection = ConexionDB.getConnection();
        PreparedStatement statement = connection.prepareStatement(sql.toString())) {

        for (int i = 0; i < parametros.size(); i++) {
            statement.setObject(i + 1, parametros.get(i));
        }

        try (ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                ReporteAsistenciaActividad item = new ReporteAsistenciaActividad();
                item.setNombreAlumno(resultSet.getString("nombre_alumno"));
                item.setNombreActividad(resultSet.getString("nombre_actividad"));
                item.setFechaAsistencia(resultSet.getDate("fecha_asistencia"));
                item.setAsistio(resultSet.getBoolean("asistio"));
                item.setFechaRegistroAsistencia(resultSet.getTimestamp("fecha_registro_asistencia"));
                item.setRegistradoPor(resultSet.getString("registrado_por"));
                lista.add(item);
            }

        }

    } catch (SQLException e) {
        throw new RuntimeException("Error al obtener reporte de asistencia por taller.", e);
    }

        return lista;
    }

    public List<ReporteGerontologiaPaciente> listarReportePacientesGerontologia(
            String estadoPaciente,
            String fechaInicio,
            String fechaFin
    ) {
        List<ReporteGerontologiaPaciente> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SQL_REPORTE_GERONTOLOGIA_PACIENTES);
        List<Object> parametros = new ArrayList<>();

        sql.append(" WHERE 1 = 1 ");

        if (estadoPaciente != null
                && !estadoPaciente.trim().isEmpty()
                && !"Todos".equalsIgnoreCase(estadoPaciente)) {
            sql.append(" AND p.estado_paciente = ? ");
            parametros.add(estadoPaciente);
        }

        if (fechaInicio != null && !fechaInicio.trim().isEmpty()) {
            sql.append(" AND DATE(p.fecha_creacion) >= ? ");
            parametros.add(fechaInicio);
        }

        if (fechaFin != null && !fechaFin.trim().isEmpty()) {
            sql.append(" AND DATE(p.fecha_creacion) <= ? ");
            parametros.add(fechaFin);
        }

        sql.append("""
                GROUP BY
                    p.id_paciente,
                    p.nombre_completo,
                    p.curp,
                    p.celular,
                    p.fecha_nacimiento,
                    p.estado_paciente,
                    p.fecha_creacion,
                    p.fecha_actualizacion
                ORDER BY p.fecha_actualizacion DESC, p.nombre_completo ASC
                """);

        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql.toString())
        ) {
            for (int i = 0; i < parametros.size(); i++) {
                statement.setObject(i + 1, parametros.get(i));
            }

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    ReporteGerontologiaPaciente item = new ReporteGerontologiaPaciente();

                    item.setNombreCompleto(resultSet.getString("nombre_completo"));
                    item.setCurp(resultSet.getString("curp"));
                    item.setCelular(resultSet.getString("celular"));
                    item.setFechaNacimiento(resultSet.getDate("fecha_nacimiento"));
                    item.setEdad(resultSet.getInt("edad"));
                    item.setEstadoPaciente(resultSet.getString("estado_paciente"));
                    item.setTotalConsultas(resultSet.getInt("total_consultas"));
                    item.setUltimaConsulta(resultSet.getTimestamp("ultima_consulta"));
                    item.setFechaCreacion(resultSet.getTimestamp("fecha_creacion"));
                    item.setFechaActualizacion(resultSet.getTimestamp("fecha_actualizacion"));

                    lista.add(item);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener reporte de pacientes de gerontología.", e);
        }
        return lista;
    }
}