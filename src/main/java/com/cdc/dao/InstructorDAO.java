package com.cdc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cdc.model.Instructor;
import com.cdc.util.ConexionDB;

public class InstructorDAO {

    private static final String SQL_LISTAR_TODOS = """
            SELECT
                id_instructor,
                nombre_completo,
                celular,
                estado_instructor
            FROM instructor
            ORDER BY
                CASE estado_instructor
                    WHEN 'Activo' THEN 1
                    ELSE 2
                END,
                nombre_completo ASC
            """;

    private static final String SQL_LISTAR_ACTIVOS = """
            SELECT
                id_instructor,
                nombre_completo,
                celular,
                estado_instructor
            FROM instructor
            WHERE estado_instructor = 'Activo'
            ORDER BY nombre_completo ASC
            """;

    private static final String SQL_BUSCAR_POR_ID = """
            SELECT
                id_instructor,
                nombre_completo,
                celular,
                estado_instructor
            FROM instructor
            WHERE id_instructor = ?
            """;

    private static final String SQL_INSERTAR = """
            INSERT INTO instructor (
                nombre_completo,
                celular,
                estado_instructor
            )
            VALUES (?, ?, 'Activo')
            """;

    private static final String SQL_ACTUALIZAR = """
            UPDATE instructor
            SET nombre_completo = ?,
                celular = ?
            WHERE id_instructor = ?
            """;

    private static final String SQL_CAMBIAR_ESTADO = """
            UPDATE instructor
            SET estado_instructor = ?
            WHERE id_instructor = ?
            """;

    public List<Instructor> listarTodos() {
        List<Instructor> instructores = new ArrayList<>();

        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_TODOS);
                ResultSet resultSet = statement.executeQuery()
        ) {
            while (resultSet.next()) {
                instructores.add(mapearInstructor(resultSet));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar instructores.", e);
        }

        return instructores;
    }

    public List<Instructor> listarActivos() {
        List<Instructor> instructores = new ArrayList<>();

        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_ACTIVOS);
                ResultSet resultSet = statement.executeQuery()
        ) {
            while (resultSet.next()) {
                instructores.add(mapearInstructor(resultSet));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar instructores activos.", e);
        }

        return instructores;
    }

    public Instructor buscarPorId(int idInstructor) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_BUSCAR_POR_ID)
        ) {
            statement.setInt(1, idInstructor);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapearInstructor(resultSet);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar instructor por id.", e);
        }

        return null;
    }

    public boolean insertarInstructor(Instructor instructor) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_INSERTAR)
        ) {
            statement.setString(1, instructor.getNombreCompleto());
            statement.setString(2, instructor.getCelular());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al insertar instructor.", e);
        }
    }

    public boolean actualizarInstructor(Instructor instructor) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_ACTUALIZAR)
        ) {
            statement.setString(1, instructor.getNombreCompleto());
            statement.setString(2, instructor.getCelular());
            statement.setInt(3, instructor.getIdInstructor());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar instructor.", e);
        }
    }

    public boolean cambiarEstadoInstructor(int idInstructor, String nuevoEstado) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_CAMBIAR_ESTADO)
        ) {
            statement.setString(1, nuevoEstado);
            statement.setInt(2, idInstructor);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al cambiar estado del instructor.", e);
        }
    }

    private Instructor mapearInstructor(ResultSet resultSet) throws SQLException {
        Instructor instructor = new Instructor();
        instructor.setIdInstructor(resultSet.getInt("id_instructor"));
        instructor.setNombreCompleto(resultSet.getString("nombre_completo"));
        instructor.setCelular(resultSet.getString("celular"));
        instructor.setEstadoInstructor(resultSet.getString("estado_instructor"));
        return instructor;
    }
}