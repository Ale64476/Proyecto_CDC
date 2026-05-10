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

    private static final String SQL_LISTAR_ACTIVOS = """
            SELECT id_instructor, nombre_completo, celular, estado_instructor
            FROM instructor
            WHERE estado_instructor = 'Activo'
            ORDER BY nombre_completo ASC
            """;

    public List<Instructor> listarActivos() {
        List<Instructor> instructores = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_ACTIVOS);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Instructor instructor = new Instructor();
                instructor.setIdInstructor(resultSet.getInt("id_instructor"));
                instructor.setNombreCompleto(resultSet.getString("nombre_completo"));
                instructor.setCelular(resultSet.getString("celular"));
                instructor.setEstadoInstructor(resultSet.getString("estado_instructor"));
                instructores.add(instructor);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar instructores activos.", e);
        }

        return instructores;
    }
}