package com.cdc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cdc.model.CalendarioActividad;
import com.cdc.util.ConexionDB;

public class CalendarioDAO {

    private static final String SQL_LISTAR_CALENDARIO = """
        SELECT
            id_actividad,
            nombre_actividad,
            estado_actividad,
            id_instructor,
            nombre_instructor,
            id_horario_actividad,
            dia_semana,
            hora_inicio,
            hora_fin,
            orden_dia
        FROM vw_calendario_completo
        WHERE estado_actividad = 'Activa'
        ORDER BY orden_dia ASC, hora_inicio ASC, nombre_actividad ASC
        """;

    public List<CalendarioActividad> listarCalendarioCompleto() {
        List<CalendarioActividad> lista = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_CALENDARIO);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                CalendarioActividad item = new CalendarioActividad();
                item.setIdActividad(resultSet.getInt("id_actividad"));
                item.setNombreActividad(resultSet.getString("nombre_actividad"));
                item.setEstadoActividad(resultSet.getString("estado_actividad"));
                item.setIdInstructor(resultSet.getInt("id_instructor"));
                item.setNombreInstructor(resultSet.getString("nombre_instructor"));
                item.setIdHorarioActividad(resultSet.getInt("id_horario_actividad"));
                item.setDiaSemana(resultSet.getString("dia_semana"));
                item.setHoraInicio(resultSet.getTime("hora_inicio"));
                item.setHoraFin(resultSet.getTime("hora_fin"));
                item.setOrdenDia(resultSet.getInt("orden_dia"));
                lista.add(item);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar calendario completo.", e);
        }

        return lista;
    }
}