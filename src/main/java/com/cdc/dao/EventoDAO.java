package com.cdc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.cdc.model.Evento;
import com.cdc.model.GoogleFormResponse;
import com.cdc.util.ConexionDB;

public class EventoDAO {

    public boolean actualizarDatosGoogleFormulario(int idEvento, GoogleFormResponse respuesta) {
        String sql = """
            UPDATE evento
            SET url_formulario = ?,
                google_form_id = ?,
                url_hoja_respuestas = ?,
                google_sheet_id = ?
            WHERE id_evento = ?
            """;

        try (Connection conn = ConexionDB.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, respuesta.getFormUrl());
            ps.setString(2, respuesta.getFormId());
            ps.setString(3, respuesta.getSheetUrl());
            ps.setString(4, respuesta.getSheetId());
            ps.setInt(5, idEvento);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar datos de Google Forms del evento.", e);
        }
    }

    private static final String SQL_LISTAR_EVENTOS = """
            SELECT
                id_evento,
                nombre_evento,
                descripcion_evento,
                fecha_evento,
                hora_inicio,
                hora_fin,
                lugar,
                responsable,
                estado_evento,
                texto_publicacion,
                url_formulario,
                google_form_id,
                url_hoja_respuestas,
                google_sheet_id,
                fecha_creacion,
                fecha_actualizacion
            FROM evento
            ORDER BY
                CASE estado_evento
                    WHEN 'Borrador' THEN 1
                    WHEN 'Publicado' THEN 2
                    WHEN 'Finalizado' THEN 3
                    ELSE 4
                END,
                fecha_evento DESC,
                hora_inicio DESC
            """;

    private static final String SQL_BUSCAR_EVENTO_POR_ID = """
            SELECT
                id_evento,
                nombre_evento,
                descripcion_evento,
                fecha_evento,
                hora_inicio,
                hora_fin,
                lugar,
                responsable,
                estado_evento,
                texto_publicacion,
                url_formulario,
                google_form_id,
                url_hoja_respuestas,
                google_sheet_id,
                fecha_creacion,
                fecha_actualizacion
            FROM evento
            WHERE id_evento = ?
            """;

    private static final String SQL_INSERTAR_EVENTO = """
            INSERT INTO evento (
                nombre_evento,
                descripcion_evento,
                fecha_evento,
                hora_inicio,
                hora_fin,
                lugar,
                responsable,
                estado_evento,
                texto_publicacion,
                url_formulario,
                google_form_id,
                url_hoja_respuestas,
                google_sheet_id
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, 'Borrador', ?, ?, ?, ?, ?)
            """;

    private static final String SQL_ACTUALIZAR_EVENTO = """
            UPDATE evento
            SET nombre_evento = ?,
                descripcion_evento = ?,
                fecha_evento = ?,
                hora_inicio = ?,
                hora_fin = ?,
                lugar = ?,
                responsable = ?,
                texto_publicacion = ?,
                url_formulario = ?,
                google_form_id = ?,
                url_hoja_respuestas = ?,
                google_sheet_id = ?
            WHERE id_evento = ?
            """;

    private static final String SQL_CAMBIAR_ESTADO_EVENTO = """
            UPDATE evento
            SET estado_evento = ?
            WHERE id_evento = ?
            """;

    public List<Evento> listarEventos() {
        List<Evento> eventos = new ArrayList<>();

        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_EVENTOS);
                ResultSet resultSet = statement.executeQuery()
        ) {
            while (resultSet.next()) {
                eventos.add(mapearEvento(resultSet));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar eventos.", e);
        }

        return eventos;
    }

    public Evento buscarPorId(int idEvento) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_BUSCAR_EVENTO_POR_ID)
        ) {
            statement.setInt(1, idEvento);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapearEvento(resultSet);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar evento por id.", e);
        }

        return null;
    }

    public int insertarEvento(Evento evento) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        SQL_INSERTAR_EVENTO,
                        Statement.RETURN_GENERATED_KEYS
                )
        ) {
            prepararStatementEvento(statement, evento);
            int filas = statement.executeUpdate();

            if (filas == 0) {
                return 0;
            }

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al insertar evento.", e);
        }

        return 0;
    }

    public boolean actualizarEvento(Evento evento) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_ACTUALIZAR_EVENTO)
        ) {
            prepararStatementEvento(statement, evento);
            statement.setInt(13, evento.getIdEvento());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar evento.", e);
        }
    }

    public boolean cambiarEstadoEvento(int idEvento, String nuevoEstado) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_CAMBIAR_ESTADO_EVENTO)
        ) {
            statement.setString(1, nuevoEstado);
            statement.setInt(2, idEvento);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al cambiar estado del evento.", e);
        }
    }

    private void prepararStatementEvento(PreparedStatement statement, Evento evento) throws SQLException {
        statement.setString(1, evento.getNombreEvento());
        statement.setString(2, evento.getDescripcionEvento());
        statement.setDate(3, evento.getFechaEvento());
        statement.setTime(4, evento.getHoraInicio());

        if (evento.getHoraFin() != null) {
            statement.setTime(5, evento.getHoraFin());
        } else {
            statement.setNull(5, java.sql.Types.TIME);
        }

        statement.setString(6, evento.getLugar());
        statement.setString(7, evento.getResponsable());
        statement.setString(8, evento.getTextoPublicacion());
        statement.setString(9, evento.getUrlFormulario());
        statement.setString(10, evento.getGoogleFormId());
        statement.setString(11, evento.getUrlHojaRespuestas());
        statement.setString(12, evento.getGoogleSheetId());
    }

    private Evento mapearEvento(ResultSet resultSet) throws SQLException {
        Evento evento = new Evento();

        evento.setIdEvento(resultSet.getInt("id_evento"));
        evento.setNombreEvento(resultSet.getString("nombre_evento"));
        evento.setDescripcionEvento(resultSet.getString("descripcion_evento"));
        evento.setFechaEvento(resultSet.getDate("fecha_evento"));
        evento.setHoraInicio(resultSet.getTime("hora_inicio"));
        evento.setHoraFin(resultSet.getTime("hora_fin"));
        evento.setLugar(resultSet.getString("lugar"));
        evento.setResponsable(resultSet.getString("responsable"));
        evento.setEstadoEvento(resultSet.getString("estado_evento"));
        evento.setTextoPublicacion(resultSet.getString("texto_publicacion"));
        evento.setUrlFormulario(resultSet.getString("url_formulario"));
        evento.setGoogleFormId(resultSet.getString("google_form_id"));
        evento.setUrlHojaRespuestas(resultSet.getString("url_hoja_respuestas"));
        evento.setGoogleSheetId(resultSet.getString("google_sheet_id"));
        evento.setFechaCreacion(resultSet.getTimestamp("fecha_creacion"));
        evento.setFechaActualizacion(resultSet.getTimestamp("fecha_actualizacion"));

        return evento;
    }
}