package com.cdc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cdc.model.ActividadProxima;
import com.cdc.model.Aviso;
import com.cdc.model.DashboardResumen;
import com.cdc.util.ConexionDB;

public class DashboardDAO {

    private static final String SQL_RESUMEN = """
            SELECT
                total_alumnos_registrados,
                total_actividades_activas,
                actividades_de_hoy,
                asistencias_registradas_hoy
            FROM vw_dashboard_resumen
            """;

    private static final String SQL_PROXIMAS_ACTIVIDADES = """
            SELECT
                id_actividad,
                nombre_actividad,
                instructor,
                dia_semana,
                hora_inicio,
                hora_fin
            FROM vw_dashboard_actividades_hoy
            ORDER BY hora_inicio ASC
            LIMIT 4
            """;

    private static final String SQL_AVISOS = """
            SELECT
                id_aviso,
                titulo,
                mensaje,
                estado_aviso,
                fecha_creacion,
                fecha_inicio,
                fecha_fin
            FROM vw_dashboard_avisos
            LIMIT 5
            """;

    public DashboardResumen obtenerResumen() {
        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_RESUMEN);
             ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                DashboardResumen resumen = new DashboardResumen();
                resumen.setTotalAlumnosRegistrados(resultSet.getInt("total_alumnos_registrados"));
                resumen.setTotalActividadesActivas(resultSet.getInt("total_actividades_activas"));
                resumen.setActividadesDeHoy(resultSet.getInt("actividades_de_hoy"));
                resumen.setAsistenciasRegistradasHoy(resultSet.getInt("asistencias_registradas_hoy"));
                return resumen;
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener resumen del dashboard.", e);
        }

        return null;
    }

    public List<ActividadProxima> listarProximasActividades() {
        List<ActividadProxima> actividades = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_PROXIMAS_ACTIVIDADES);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                ActividadProxima actividad = new ActividadProxima();
                actividad.setIdActividad(resultSet.getInt("id_actividad"));
                actividad.setNombreActividad(resultSet.getString("nombre_actividad"));
                actividad.setInstructor(resultSet.getString("instructor"));
                actividad.setDiaSemana(resultSet.getString("dia_semana"));
                actividad.setHoraInicio(resultSet.getTime("hora_inicio"));
                actividad.setHoraFin(resultSet.getTime("hora_fin"));
                actividades.add(actividad);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar próximas actividades.", e);
        }

        return actividades;
    }

    public List<Aviso> listarAvisos() {
        List<Aviso> avisos = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_AVISOS);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Aviso aviso = new Aviso();
                aviso.setIdAviso(resultSet.getInt("id_aviso"));
                aviso.setTitulo(resultSet.getString("titulo"));
                aviso.setMensaje(resultSet.getString("mensaje"));
                aviso.setEstadoAviso(resultSet.getString("estado_aviso"));
                aviso.setFechaCreacion(resultSet.getTimestamp("fecha_creacion"));
                aviso.setFechaInicio(resultSet.getTimestamp("fecha_inicio"));
                aviso.setFechaFin(resultSet.getTimestamp("fecha_fin"));
                avisos.add(aviso);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar avisos del dashboard.", e);
        }

        return avisos;
    }
}