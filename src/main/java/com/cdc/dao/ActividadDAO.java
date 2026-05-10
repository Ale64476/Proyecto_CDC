package com.cdc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.cdc.model.Actividad;
import com.cdc.model.AlumnoInscritoActividad;
import com.cdc.model.HorarioActividad;
import com.cdc.util.ConexionDB;


public class ActividadDAO {

    private static final String SQL_LISTAR_TODAS = """
            SELECT
                a.id_actividad,
                a.nombre_actividad,
                a.descripcion_actividad,
                a.id_instructor,
                i.nombre_completo AS nombre_instructor,
                a.estado_actividad,
                a.fecha_creacion,
                a.fecha_desactivacion,
                COUNT(DISTINCT CASE WHEN ins.estado_inscripcion = 'Activa' THEN ins.id_alumno END) AS total_inscritos,
                COALESCE(
                    GROUP_CONCAT(
                        DISTINCT CONCAT(
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
                ) AS horarios_resumen
            FROM actividad a
            JOIN instructor i ON i.id_instructor = a.id_instructor
            LEFT JOIN inscripcion ins ON ins.id_actividad = a.id_actividad
            LEFT JOIN horario_actividad h ON h.id_actividad = a.id_actividad
            GROUP BY
                a.id_actividad,
                a.nombre_actividad,
                a.descripcion_actividad,
                a.id_instructor,
                i.nombre_completo,
                a.estado_actividad,
                a.fecha_creacion,
                a.fecha_desactivacion
            ORDER BY a.nombre_actividad ASC
            """;

    private static final String SQL_BUSCAR_POR_ID = """
            SELECT
                a.id_actividad,
                a.nombre_actividad,
                a.descripcion_actividad,
                a.id_instructor,
                i.nombre_completo AS nombre_instructor,
                a.estado_actividad,
                a.fecha_creacion,
                a.fecha_desactivacion,
                COUNT(DISTINCT CASE WHEN ins.estado_inscripcion = 'Activa' THEN ins.id_alumno END) AS total_inscritos,
                COALESCE(
                    GROUP_CONCAT(
                        DISTINCT CONCAT(
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
                ) AS horarios_resumen
            FROM actividad a
            JOIN instructor i ON i.id_instructor = a.id_instructor
            LEFT JOIN inscripcion ins ON ins.id_actividad = a.id_actividad
            LEFT JOIN horario_actividad h ON h.id_actividad = a.id_actividad
            WHERE a.id_actividad = ?
            GROUP BY
                a.id_actividad,
                a.nombre_actividad,
                a.descripcion_actividad,
                a.id_instructor,
                i.nombre_completo,
                a.estado_actividad,
                a.fecha_creacion,
                a.fecha_desactivacion
            """;

    private static final String SQL_ALUMNOS_INSCRITOS = """
            SELECT
                al.id_alumno,
                al.nombre_completo,
                al.celular,
                COUNT(
                    CASE
                        WHEN asis.asistio = 1
                         AND MONTH(asis.fecha_asistencia) = MONTH(CURDATE())
                         AND YEAR(asis.fecha_asistencia) = YEAR(CURDATE())
                        THEN 1
                    END
                ) AS asistencias_del_mes
            FROM inscripcion ins
            JOIN alumno al ON al.id_alumno = ins.id_alumno
            LEFT JOIN asistencia asis
                ON asis.id_alumno = ins.id_alumno
               AND asis.id_actividad = ins.id_actividad
            WHERE ins.id_actividad = ?
              AND ins.estado_inscripcion = 'Activa'
            GROUP BY
                al.id_alumno,
                al.nombre_completo,
                al.celular
            ORDER BY al.nombre_completo ASC
            """;

    private static final String SQL_INSERTAR_ACTIVIDAD = """
            INSERT INTO actividad (
                nombre_actividad,
                descripcion_actividad,
                id_instructor,
                estado_actividad
            )
            VALUES (?, ?, ?, ?)
            """;

    private static final String SQL_INSERTAR_HORARIO = """
            INSERT INTO horario_actividad (
                id_actividad,
                dia_semana,
                hora_inicio,
                hora_fin
            )
            VALUES (?, ?, ?, ?)
            """;

    private static final String SQL_ACTUALIZAR_ACTIVIDAD = """
            UPDATE actividad
            SET nombre_actividad = ?,
                descripcion_actividad = ?,
                id_instructor = ?,
                estado_actividad = ?
            WHERE id_actividad = ?
            """;

    private static final String SQL_INSCRIBIR_ALUMNO = """
            INSERT INTO inscripcion (
                id_alumno,
                id_actividad,
                estado_inscripcion
            )
            VALUES (?, ?, 'Activa')
            """;

    private static final String SQL_REGISTRAR_ASISTENCIA = """
            INSERT INTO asistencia (
                id_alumno,
                id_actividad,
                fecha_asistencia,
                asistio,
                id_admin
            )
            VALUES (?, ?, ?, ?, ?)
            """;

    private static final String SQL_CAMBIAR_ESTADO_ACTIVIDAD = """
            UPDATE actividad
            SET estado_actividad = ?
            WHERE id_actividad = ?
            """;

    public List<Actividad> listarTodas() {
        List<Actividad> actividades = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_TODAS);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                actividades.add(mapearActividad(resultSet));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar actividades.", e);
        }

        return actividades;
    }

    public Actividad buscarPorId(int idActividad) {
        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_BUSCAR_POR_ID)) {

            statement.setInt(1, idActividad);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapearActividad(resultSet);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar actividad por id.", e);
        }

        return null;
    }

    public List<AlumnoInscritoActividad> listarAlumnosInscritos(int idActividad) {
        List<AlumnoInscritoActividad> alumnos = new ArrayList<>();

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL_ALUMNOS_INSCRITOS)) {

            statement.setInt(1, idActividad);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    AlumnoInscritoActividad alumno = new AlumnoInscritoActividad();
                    alumno.setIdAlumno(resultSet.getInt("id_alumno"));
                    alumno.setNombreCompleto(resultSet.getString("nombre_completo"));
                    alumno.setCelular(resultSet.getString("celular"));
                    alumno.setAsistenciasDelMes(resultSet.getInt("asistencias_del_mes"));
                    alumnos.add(alumno);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar alumnos inscritos de la actividad.", e);
        }

        return alumnos;
    }

    public int insertarActividadConHorarios(Actividad actividad, List<HorarioActividad> horarios) {
        Connection connection = null;
        PreparedStatement actividadStmt = null;
        PreparedStatement horarioStmt = null;
        ResultSet generatedKeys = null;

        try {
            connection = ConexionDB.getConnection();
            connection.setAutoCommit(false);

            actividadStmt = connection.prepareStatement(SQL_INSERTAR_ACTIVIDAD, Statement.RETURN_GENERATED_KEYS);
            actividadStmt.setString(1, actividad.getNombreActividad());
            actividadStmt.setString(2, actividad.getDescripcionActividad());
            actividadStmt.setInt(3, actividad.getIdInstructor());
            actividadStmt.setString(4, actividad.getEstadoActividad());

            int filasAfectadas = actividadStmt.executeUpdate();
            if (filasAfectadas == 0) {
                throw new SQLException("No se pudo insertar la actividad.");
            }

            generatedKeys = actividadStmt.getGeneratedKeys();
            if (!generatedKeys.next()) {
                throw new SQLException("No se pudo obtener el id de la actividad insertada.");
            }

            int idActividadGenerada = generatedKeys.getInt(1);

            horarioStmt = connection.prepareStatement(SQL_INSERTAR_HORARIO);
            for (HorarioActividad horario : horarios) {
                horarioStmt.setInt(1, idActividadGenerada);
                horarioStmt.setString(2, horario.getDiaSemana());
                horarioStmt.setTime(3, horario.getHoraInicio());
                horarioStmt.setTime(4, horario.getHoraFin());
                horarioStmt.addBatch();
            }

            horarioStmt.executeBatch();
            connection.commit();

            return idActividadGenerada;

        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw new RuntimeException("Error al insertar actividad con horarios.", e);
        } finally {
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (actividadStmt != null) actividadStmt.close();
                if (horarioStmt != null) horarioStmt.close();
                if (connection != null) {
                    connection.setAutoCommit(true);
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean actualizarActividad(Actividad actividad) {
        try (Connection connection = ConexionDB.getConnection();
            PreparedStatement statement = connection.prepareStatement(SQL_ACTUALIZAR_ACTIVIDAD)) {

            statement.setString(1, actividad.getNombreActividad());
            statement.setString(2, actividad.getDescripcionActividad());
            statement.setInt(3, actividad.getIdInstructor());
            statement.setString(4, actividad.getEstadoActividad());
            statement.setInt(5, actividad.getIdActividad());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar actividad.", e);
        }
    }

    public void inscribirAlumnosEnActividad(int idActividad, List<Integer> idsAlumnos) {
        try (Connection connection = ConexionDB.getConnection();
            PreparedStatement statement = connection.prepareStatement(SQL_INSCRIBIR_ALUMNO)) {

            for (Integer idAlumno : idsAlumnos) {
                statement.setInt(1, idAlumno);
                statement.setInt(2, idActividad);
                statement.addBatch();
            }

            statement.executeBatch();

        } catch (SQLException e) {
            throw new RuntimeException("Error al inscribir alumnos en la actividad.", e);
        }
    }

    public void registrarAsistencia(int idActividad, java.sql.Date fechaAsistencia,
                                List<Integer> idsPresentes,
                                List<Integer> idsTodosInscritos,
                                int idAdmin) {
        try (Connection connection = ConexionDB.getConnection();
            PreparedStatement statement = connection.prepareStatement(SQL_REGISTRAR_ASISTENCIA)) {

            for (Integer idAlumno : idsTodosInscritos) {
                boolean asistio = idsPresentes != null && idsPresentes.contains(idAlumno);

                statement.setInt(1, idAlumno);
                statement.setInt(2, idActividad);
                statement.setDate(3, fechaAsistencia);
                statement.setBoolean(4, asistio);
                statement.setInt(5, idAdmin);
                statement.addBatch();
            }

            statement.executeBatch();

        } catch (SQLException e) {
            throw new RuntimeException("Error al registrar asistencia.", e);
        }
    }

    public boolean cambiarEstadoActividad(int idActividad, String nuevoEstado) {
        try (Connection connection = ConexionDB.getConnection();
            PreparedStatement statement = connection.prepareStatement(SQL_CAMBIAR_ESTADO_ACTIVIDAD)) {

            statement.setString(1, nuevoEstado);
            statement.setInt(2, idActividad);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al cambiar estado de la actividad.", e);
        }
    }

    private Actividad mapearActividad(ResultSet resultSet) throws SQLException {
        Actividad actividad = new Actividad();
        actividad.setIdActividad(resultSet.getInt("id_actividad"));
        actividad.setNombreActividad(resultSet.getString("nombre_actividad"));
        actividad.setDescripcionActividad(resultSet.getString("descripcion_actividad"));
        actividad.setIdInstructor(resultSet.getInt("id_instructor"));
        actividad.setNombreInstructor(resultSet.getString("nombre_instructor"));
        actividad.setEstadoActividad(resultSet.getString("estado_actividad"));
        actividad.setFechaCreacion(resultSet.getTimestamp("fecha_creacion"));
        actividad.setFechaDesactivacion(resultSet.getTimestamp("fecha_desactivacion"));
        actividad.setTotalInscritos(resultSet.getInt("total_inscritos"));
        actividad.setHorariosResumen(resultSet.getString("horarios_resumen"));
        return actividad;
    }
}