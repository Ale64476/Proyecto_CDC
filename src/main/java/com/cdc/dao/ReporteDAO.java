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
            SELECT id_alumno, nombre_alumno, celular, id_actividad,
                   nombre_actividad, instructor, asistencias_del_mes
            FROM vw_reporte_alumnos_por_actividad
            ORDER BY nombre_actividad ASC, nombre_alumno ASC
            """;

    private static final String SQL_REPORTE_ASISTENCIA_POR_ACTIVIDAD = """
            SELECT nombre_alumno, nombre_actividad, fecha_asistencia,
                   asistio, fecha_registro_asistencia, registrado_por
            FROM vw_reporte_asistencia_por_actividad
            ORDER BY fecha_asistencia DESC, nombre_actividad ASC, nombre_alumno ASC
            """;

    public List<ReporteAlumno> listarReporteAlumnos() {
        List<ReporteAlumno> lista = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_REPORTE_ALUMNOS);
             ResultSet resultSet = statement.executeQuery()) {

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

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener reporte de alumnos.", e);
        }

        return lista;
    }

    public List<ReporteActividad> listarReporteActividades() {
        List<ReporteActividad> lista = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_REPORTE_ACTIVIDADES);
             ResultSet resultSet = statement.executeQuery()) {

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

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener reporte de actividades.", e);
        }

        return lista;
    }

    public List<ReporteAlumnoActividad> listarReporteAlumnosPorActividad() {
        List<ReporteAlumnoActividad> lista = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_REPORTE_ALUMNOS_POR_ACTIVIDAD);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                ReporteAlumnoActividad item = new ReporteAlumnoActividad();
                item.setIdAlumno(resultSet.getInt("id_alumno"));
                item.setNombreAlumno(resultSet.getString("nombre_alumno"));
                item.setCelular(resultSet.getString("celular"));
                item.setIdActividad(resultSet.getInt("id_actividad"));
                item.setNombreActividad(resultSet.getString("nombre_actividad"));
                item.setInstructor(resultSet.getString("instructor"));
                item.setAsistenciasDelMes(resultSet.getInt("asistencias_del_mes"));
                lista.add(item);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener reporte de alumnos por actividad.", e);
        }

        return lista;
    }

    public List<ReporteAsistenciaActividad> listarReporteAsistenciaPorActividad() {
        List<ReporteAsistenciaActividad> lista = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_REPORTE_ASISTENCIA_POR_ACTIVIDAD);
             ResultSet resultSet = statement.executeQuery()) {

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

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener reporte de asistencia por actividad.", e);
        }

        return lista;
    }
}