package com.cdc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.cdc.model.GerontologiaConsulta;
import com.cdc.model.GerontologiaPaciente;
import com.cdc.util.ConexionDB;

public class GerontologiaDAO {

    private static final String SQL_LISTAR_PACIENTES = """
            SELECT
                id_paciente,
                nombre_completo,
                curp,
                fecha_nacimiento,
                TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad,
                celular,
                estado_paciente,
                fecha_creacion,
                fecha_actualizacion
            FROM gerontologia_paciente
            ORDER BY
                CASE estado_paciente
                    WHEN 'Activo' THEN 1
                    ELSE 2
                END,
                fecha_actualizacion DESC,
                nombre_completo ASC
            """;

    private static final String SQL_BUSCAR_PACIENTE_POR_ID = """
            SELECT
                id_paciente,
                nombre_completo,
                curp,
                fecha_nacimiento,
                TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad,
                celular,
                estado_paciente,
                fecha_creacion,
                fecha_actualizacion
            FROM gerontologia_paciente
            WHERE id_paciente = ?
            """;

    private static final String SQL_LISTAR_CONSULTAS_POR_PACIENTE = """
            SELECT
                id_consulta,
                id_paciente,
                fecha_consulta,
                nombre_paciente_snapshot,
                edad_paciente_snapshot,
                motivo_consulta,
                antecedentes,
                notas,
                fecha_creacion,
                fecha_actualizacion
            FROM gerontologia_consulta
            WHERE id_paciente = ?
            ORDER BY fecha_consulta DESC, id_consulta DESC
            """;

    private static final String SQL_CREAR_PACIENTE = """
            INSERT INTO gerontologia_paciente (
                nombre_completo,
                curp,
                celular,
                fecha_nacimiento,
                estado_paciente
            ) VALUES (?, ?, ?, ?, 'Activo')
            """;

    private static final String SQL_CAMBIAR_ESTADO_PACIENTE = """
            UPDATE gerontologia_paciente
            SET estado_paciente = ?
            WHERE id_paciente = ?
            """;

    private static final String SQL_EXISTE_PACIENTE_POR_CURP = """
            SELECT COUNT(*) AS total
            FROM gerontologia_paciente
            WHERE curp = ?
            """;

    private static final String SQL_BUSCAR_CONSULTA_POR_ID = """
            SELECT
                id_consulta,
                id_paciente,
                fecha_consulta,
                nombre_paciente_snapshot,
                edad_paciente_snapshot,
                motivo_consulta,
                antecedentes,
                notas,
                fecha_creacion,
                fecha_actualizacion
            FROM gerontologia_consulta
            WHERE id_consulta = ?
            """;

    private static final String SQL_CREAR_CONSULTA = """
            INSERT INTO gerontologia_consulta (
                id_paciente,
                nombre_paciente_snapshot,
                edad_paciente_snapshot,
                motivo_consulta,
                antecedentes,
                notas
            ) VALUES (?, ?, ?, ?, ?, ?)
            """;

    private static final String SQL_ACTUALIZAR_CONSULTA = """
            UPDATE gerontologia_consulta
            SET
                motivo_consulta = ?,
                antecedentes = ?,
                notas = ?
            WHERE id_consulta = ?
            """;

    private static final String SQL_ACTUALIZAR_FECHA_PACIENTE = """
            UPDATE gerontologia_paciente
            SET fecha_actualizacion = CURRENT_TIMESTAMP
            WHERE id_paciente = ?
            """;

    public List<GerontologiaPaciente> listarPacientes() {
        List<GerontologiaPaciente> pacientes = new ArrayList<>();

        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_PACIENTES);
                ResultSet resultSet = statement.executeQuery()
        ) {
            while (resultSet.next()) {
                pacientes.add(mapearPaciente(resultSet));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al listar pacientes de gerontología.", e);
        }

        return pacientes;
    }

    public GerontologiaPaciente buscarPacientePorId(int idPaciente) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_BUSCAR_PACIENTE_POR_ID)
        ) {
            statement.setInt(1, idPaciente);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapearPaciente(resultSet);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar paciente de gerontología.", e);
        }

        return null;
    }

    public List<GerontologiaConsulta> listarConsultasPorPaciente(int idPaciente) {
        List<GerontologiaConsulta> consultas = new ArrayList<>();

        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_CONSULTAS_POR_PACIENTE)
        ) {
            statement.setInt(1, idPaciente);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    consultas.add(mapearConsulta(resultSet));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al listar consultas de gerontología.", e);
        }

        return consultas;
    }

    public boolean existePacientePorCurp(String curp) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_EXISTE_PACIENTE_POR_CURP)
        ) {
            statement.setString(1, curp);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("total") > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al validar CURP de paciente.", e);
        }

        return false;
    }

    public boolean crearPaciente(GerontologiaPaciente paciente) {
        return crearPacienteRetornandoId(paciente) > 0;
    }

    public int crearPacienteRetornandoId(GerontologiaPaciente paciente) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        SQL_CREAR_PACIENTE,
                        Statement.RETURN_GENERATED_KEYS
                )
        ) {
            statement.setString(1, paciente.getNombreCompleto());
            statement.setString(2, paciente.getCurp());
            statement.setString(3, paciente.getCelular());
            statement.setDate(4, paciente.getFechaNacimiento());

            int filasAfectadas = statement.executeUpdate();

            if (filasAfectadas == 0) {
                return 0;
            }

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al crear paciente de gerontología.", e);
        }

        return 0;
    }

    public boolean cambiarEstadoPaciente(int idPaciente, String nuevoEstado) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_CAMBIAR_ESTADO_PACIENTE)
        ) {
            statement.setString(1, nuevoEstado);
            statement.setInt(2, idPaciente);

            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error al cambiar estado del paciente de gerontología.", e);
        }
    }

    public GerontologiaConsulta buscarConsultaPorId(int idConsulta) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_BUSCAR_CONSULTA_POR_ID)
        ) {
            statement.setInt(1, idConsulta);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapearConsulta(resultSet);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar consulta de gerontología.", e);
        }

        return null;
    }

    public boolean crearConsulta(GerontologiaConsulta consulta) {
        Connection connection = null;

        try {
            connection = ConexionDB.getConnection();
            connection.setAutoCommit(false);

            try (PreparedStatement statement = connection.prepareStatement(SQL_CREAR_CONSULTA)) {
                statement.setInt(1, consulta.getIdPaciente());
                statement.setString(2, consulta.getNombrePacienteSnapshot());
                statement.setInt(3, consulta.getEdadPacienteSnapshot());
                statement.setString(4, consulta.getMotivoConsulta());
                statement.setString(5, consulta.getAntecedentes());
                statement.setString(6, consulta.getNotas());

                boolean creada = statement.executeUpdate() > 0;

                if (creada) {
                    actualizarFechaPaciente(connection, consulta.getIdPaciente());
                }

                connection.commit();
                return creada;
            }
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackException) {
                    rollbackException.printStackTrace();
                }
            }

            throw new RuntimeException("Error al crear consulta de gerontología.", e);
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public boolean actualizarConsulta(GerontologiaConsulta consulta) {
        Connection connection = null;

        try {
            connection = ConexionDB.getConnection();
            connection.setAutoCommit(false);

            try (PreparedStatement statement = connection.prepareStatement(SQL_ACTUALIZAR_CONSULTA)) {
                statement.setString(1, consulta.getMotivoConsulta());
                statement.setString(2, consulta.getAntecedentes());
                statement.setString(3, consulta.getNotas());
                statement.setInt(4, consulta.getIdConsulta());

                boolean actualizada = statement.executeUpdate() > 0;

                if (actualizada) {
                    actualizarFechaPaciente(connection, consulta.getIdPaciente());
                }

                connection.commit();
                return actualizada;
            }
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackException) {
                    rollbackException.printStackTrace();
                }
            }

            throw new RuntimeException("Error al actualizar consulta de gerontología.", e);
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void actualizarFechaPaciente(Connection connection, int idPaciente) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(SQL_ACTUALIZAR_FECHA_PACIENTE)) {
            statement.setInt(1, idPaciente);
            statement.executeUpdate();
        }
    }

    private GerontologiaPaciente mapearPaciente(ResultSet resultSet) throws SQLException {
        GerontologiaPaciente paciente = new GerontologiaPaciente();

        paciente.setIdPaciente(resultSet.getInt("id_paciente"));
        paciente.setNombreCompleto(resultSet.getString("nombre_completo"));
        paciente.setCurp(resultSet.getString("curp"));
        paciente.setFechaNacimiento(resultSet.getDate("fecha_nacimiento"));
        paciente.setEdad(resultSet.getInt("edad"));
        paciente.setCelular(resultSet.getString("celular"));
        paciente.setEstadoPaciente(resultSet.getString("estado_paciente"));
        paciente.setFechaCreacion(resultSet.getTimestamp("fecha_creacion"));
        paciente.setFechaActualizacion(resultSet.getTimestamp("fecha_actualizacion"));

        return paciente;
    }

    private GerontologiaConsulta mapearConsulta(ResultSet resultSet) throws SQLException {
        GerontologiaConsulta consulta = new GerontologiaConsulta();

        consulta.setIdConsulta(resultSet.getInt("id_consulta"));
        consulta.setIdPaciente(resultSet.getInt("id_paciente"));
        consulta.setFechaConsulta(resultSet.getTimestamp("fecha_consulta"));
        consulta.setNombrePacienteSnapshot(resultSet.getString("nombre_paciente_snapshot"));
        consulta.setEdadPacienteSnapshot(resultSet.getInt("edad_paciente_snapshot"));
        consulta.setMotivoConsulta(resultSet.getString("motivo_consulta"));
        consulta.setAntecedentes(resultSet.getString("antecedentes"));
        consulta.setNotas(resultSet.getString("notas"));
        consulta.setFechaCreacion(resultSet.getTimestamp("fecha_creacion"));
        consulta.setFechaActualizacion(resultSet.getTimestamp("fecha_actualizacion"));

        return consulta;
    }
}