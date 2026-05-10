package com.cdc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cdc.model.ActividadAlumnoDetalle;
import com.cdc.model.Alumno;
import com.cdc.util.ConexionDB;

public class AlumnoDAO {

    private static final String SQL_LISTAR_TODOS = """
            SELECT id_alumno, nombre_completo, fecha_nacimiento, curp, domicilio,
                   celular, estado_alumno, fecha_baja, fecha_registro
            FROM alumno
            ORDER BY nombre_completo ASC
            """;

    private static final String SQL_BUSCAR_POR_ID = """
            SELECT id_alumno, nombre_completo, fecha_nacimiento, curp, domicilio,
                   celular, estado_alumno, fecha_baja, fecha_registro
            FROM alumno
            WHERE id_alumno = ?
            """;

    private static final String SQL_ACTIVIDADES_POR_ALUMNO = """
            SELECT
                ac.id_actividad,
                ac.nombre_actividad,
                i.nombre_completo AS nombre_instructor,
                COALESCE(
                    GROUP_CONCAT(
                        CONCAT(
                            h.dia_semana, ' ',
                            TIME_FORMAT(h.hora_inicio, '%H:%i'),
                            ' - ',
                            TIME_FORMAT(h.hora_fin, '%H:%i')
                        )
                        ORDER BY
                            CASE h.dia_semana
                                WHEN 'Lunes' THEN 1
                                WHEN 'Martes' THEN 2
                                WHEN 'Miércoles' THEN 3
                                WHEN 'Jueves' THEN 4
                                WHEN 'Viernes' THEN 5
                                WHEN 'Sábado' THEN 6
                                WHEN 'Domingo' THEN 7
                            END,
                            h.hora_inicio
                        SEPARATOR ' / '
                    ),
                    'Sin horario'
                ) AS horarios,
                COUNT(
                    CASE
                        WHEN asis.asistio = 1
                         AND MONTH(asis.fecha_asistencia) = MONTH(CURDATE())
                         AND YEAR(asis.fecha_asistencia) = YEAR(CURDATE())
                        THEN 1
                    END
                ) AS asistencias_del_mes,
                ac.estado_actividad
            FROM inscripcion ins
            JOIN actividad ac ON ac.id_actividad = ins.id_actividad
            JOIN instructor i ON i.id_instructor = ac.id_instructor
            LEFT JOIN horario_actividad h ON h.id_actividad = ac.id_actividad
            LEFT JOIN asistencia asis
                ON asis.id_alumno = ins.id_alumno
               AND asis.id_actividad = ins.id_actividad
            WHERE ins.id_alumno = ?
              AND ins.estado_inscripcion = 'Activa'
            GROUP BY
                ac.id_actividad,
                ac.nombre_actividad,
                i.nombre_completo,
                ac.estado_actividad
            ORDER BY ac.nombre_actividad ASC
            """;

    private static final String SQL_LISTAR_DISPONIBLES_PARA_ACTIVIDAD = """
            SELECT
                a.id_alumno,
                a.nombre_completo,
                a.fecha_nacimiento,
                a.curp,
                a.domicilio,
                a.celular,
                a.estado_alumno,
                a.fecha_baja,
                a.fecha_registro
            FROM alumno a
            WHERE a.estado_alumno = 'Activo'
            AND a.id_alumno NOT IN (
                SELECT i.id_alumno
                FROM inscripcion i
                WHERE i.id_actividad = ?
                    AND i.estado_inscripcion = 'Activa'
            )
            ORDER BY a.nombre_completo ASC
            """;

    private static final String SQL_INSERTAR = """
            INSERT INTO alumno (
                nombre_completo,
                fecha_nacimiento,
                curp,
                domicilio,
                celular,
                estado_alumno
            )
            VALUES (?, ?, ?, ?, ?, ?)
            """;

    private static final String SQL_ACTUALIZAR = """
            UPDATE alumno
            SET nombre_completo = ?,
                fecha_nacimiento = ?,
                curp = ?,
                domicilio = ?,
                celular = ?,
                estado_alumno = ?
            WHERE id_alumno = ?
            """;

    private static final String SQL_CAMBIAR_ESTADO = """
            UPDATE alumno
            SET estado_alumno = ?
            WHERE id_alumno = ?
            """;

    public List<Alumno> listarTodos() {
        List<Alumno> alumnos = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_TODOS);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                alumnos.add(mapearAlumno(resultSet));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar alumnos.", e);
        }

        return alumnos;
    }

    public Alumno buscarPorId(int idAlumno) {
        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_BUSCAR_POR_ID)) {

            statement.setInt(1, idAlumno);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapearAlumno(resultSet);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar alumno por id.", e);
        }

        return null;
    }

    public List<ActividadAlumnoDetalle> listarActividadesPorAlumno(int idAlumno) {
        List<ActividadAlumnoDetalle> actividades = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_ACTIVIDADES_POR_ALUMNO)) {

            statement.setInt(1, idAlumno);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    ActividadAlumnoDetalle actividad = new ActividadAlumnoDetalle();
                    actividad.setIdActividad(resultSet.getInt("id_actividad"));
                    actividad.setNombreActividad(resultSet.getString("nombre_actividad"));
                    actividad.setNombreInstructor(resultSet.getString("nombre_instructor"));
                    actividad.setHorarios(resultSet.getString("horarios"));
                    actividad.setAsistenciasDelMes(resultSet.getInt("asistencias_del_mes"));
                    actividad.setEstadoActividad(resultSet.getString("estado_actividad"));

                    actividades.add(actividad);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar actividades del alumno.", e);
        }

        return actividades;
    }

    public List<Alumno> listarDisponiblesParaActividad(int idActividad) {
        List<Alumno> alumnos = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
            PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_DISPONIBLES_PARA_ACTIVIDAD)) {

            statement.setInt(1, idActividad);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    alumnos.add(mapearAlumno(resultSet));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar alumnos disponibles para la actividad.", e);
        }

        return alumnos;
    }

    public boolean insertarAlumno(Alumno alumno) {
        try (Connection connection = ConexionDB.getConnection();
            PreparedStatement statement = connection.prepareStatement(SQL_INSERTAR)) {

            statement.setString(1, alumno.getNombreCompleto());
            statement.setDate(2, alumno.getFechaNacimiento());
            statement.setString(3, alumno.getCurp());
            statement.setString(4, alumno.getDomicilio());
            statement.setString(5, alumno.getCelular());
            statement.setString(6, alumno.getEstadoAlumno());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al insertar alumno.", e);
        }
    }

    public boolean actualizarAlumno(Alumno alumno) {
        try (Connection connection = ConexionDB.getConnection();
            PreparedStatement statement = connection.prepareStatement(SQL_ACTUALIZAR)) {

            statement.setString(1, alumno.getNombreCompleto());
            statement.setDate(2, alumno.getFechaNacimiento());
            statement.setString(3, alumno.getCurp());
            statement.setString(4, alumno.getDomicilio());
            statement.setString(5, alumno.getCelular());
            statement.setString(6, alumno.getEstadoAlumno());
            statement.setInt(7, alumno.getIdAlumno());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar alumno.", e);
        }
    }

    public boolean cambiarEstadoAlumno(int idAlumno, String nuevoEstado) {
        try (Connection connection = ConexionDB.getConnection();
            PreparedStatement statement = connection.prepareStatement(SQL_CAMBIAR_ESTADO)) {

            statement.setString(1, nuevoEstado);
            statement.setInt(2, idAlumno);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al cambiar estado del alumno.", e);
        }
    }

    private Alumno mapearAlumno(ResultSet resultSet) throws SQLException {
        Alumno alumno = new Alumno();

        alumno.setIdAlumno(resultSet.getInt("id_alumno"));
        alumno.setNombreCompleto(resultSet.getString("nombre_completo"));
        alumno.setFechaNacimiento(resultSet.getDate("fecha_nacimiento"));
        alumno.setCurp(resultSet.getString("curp"));
        alumno.setDomicilio(resultSet.getString("domicilio"));
        alumno.setCelular(resultSet.getString("celular"));
        alumno.setEstadoAlumno(resultSet.getString("estado_alumno"));
        alumno.setFechaBaja(resultSet.getDate("fecha_baja"));
        alumno.setFechaRegistro(resultSet.getDate("fecha_registro"));

        return alumno;
    }
}