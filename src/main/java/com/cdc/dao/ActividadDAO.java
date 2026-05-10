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
                COUNT(DISTINCT CASE 
                    WHEN ins.estado_inscripcion = 'Activa'
                    AND al.estado_alumno = 'Activo'
                    THEN ins.id_alumno 
                END) AS total_inscritos,
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
            LEFT JOIN alumno al ON al.id_alumno = ins.id_alumno
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
                COUNT(DISTINCT CASE 
                    WHEN ins.estado_inscripcion = 'Activa'
                    AND al.estado_alumno = 'Activo'
                    THEN ins.id_alumno 
                END) AS total_inscritos,
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
            LEFT JOIN alumno al ON al.id_alumno = ins.id_alumno
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
            AND al.estado_alumno = 'Activo'
            GROUP BY al.id_alumno, al.nombre_completo, al.celular
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

    private static final String SQL_LISTAR_HORARIOS_POR_ACTIVIDAD = """
            SELECT
                id_actividad,
                dia_semana,
                hora_inicio,
                hora_fin
            FROM horario_actividad
            WHERE id_actividad = ?
            ORDER BY
                CASE dia_semana
                    WHEN 'Lunes' THEN 1
                    WHEN 'Martes' THEN 2
                    WHEN 'Miércoles' THEN 3
                    WHEN 'Jueves' THEN 4
                    WHEN 'Viernes' THEN 5
                    WHEN 'Sábado' THEN 6
                    WHEN 'Domingo' THEN 7
                END,
                hora_inicio
            """;

    private static final String SQL_ELIMINAR_HORARIOS_ACTIVIDAD = """
            DELETE FROM horario_actividad
            WHERE id_actividad = ?
            """;

    private static final String SQL_ACTUALIZAR_ACTIVIDAD = """
            UPDATE actividad
            SET nombre_actividad = ?,
                descripcion_actividad = ?,
                id_instructor = ?,
                estado_actividad = ?
            WHERE id_actividad = ?
            """;

    private static final String SQL_INSCRIBIR_ALUMNO_VALIDADO = """
            INSERT INTO inscripcion (
                id_alumno,
                id_actividad,
                estado_inscripcion
            )
            SELECT ?, ?, 'Activa'
            WHERE EXISTS (
                SELECT 1
                FROM actividad
                WHERE id_actividad = ?
                AND estado_actividad = 'Activa'
            )
            AND EXISTS (
                SELECT 1
                FROM alumno
                WHERE id_alumno = ?
                AND estado_alumno = 'Activo'
            )
            AND NOT EXISTS (
                SELECT 1
                FROM inscripcion
                WHERE id_alumno = ?
                AND id_actividad = ?
            )
            """;

    private static final String SQL_REACTIVAR_INSCRIPCION_VALIDADA = """
            UPDATE inscripcion
            SET estado_inscripcion = 'Activa'
            WHERE id_alumno = ?
            AND id_actividad = ?
            AND estado_inscripcion <> 'Activa'
            AND EXISTS (
                SELECT 1
                FROM actividad
                WHERE id_actividad = ?
                    AND estado_actividad = 'Activa'
            )
            AND EXISTS (
                SELECT 1
                FROM alumno
                WHERE id_alumno = ?
                    AND estado_alumno = 'Activo'
            )
            """;

    private static final String SQL_CANCELAR_INSCRIPCION_ACTIVA = """
            UPDATE inscripcion
            SET estado_inscripcion = 'Cancelada'
            WHERE id_alumno = ?
            AND id_actividad = ?
            AND estado_inscripcion = 'Activa'
            """;

    private static final String SQL_ACTUALIZAR_ASISTENCIA_EXISTENTE = """
            UPDATE asistencia
            SET asistio = ?,
                id_admin = ?
            WHERE id_alumno = ?
            AND id_actividad = ?
            AND fecha_asistencia = ?
            """;

    private static final String SQL_INSERTAR_ASISTENCIA = """
            INSERT INTO asistencia (
                id_alumno,
                id_actividad,
                fecha_asistencia,
                asistio,
                id_admin
            )
            VALUES (?, ?, ?, ?, ?)
            """;

    private static final String SQL_EXISTE_ASISTENCIA_ACTIVIDAD_FECHA = """
            SELECT COUNT(*) AS total
            FROM asistencia
            WHERE id_actividad = ?
            AND fecha_asistencia = ?
            """;

    private static final String SQL_CAMBIAR_ESTADO_ACTIVIDAD = """
            UPDATE actividad
            SET estado_actividad = ?
            WHERE id_actividad = ?
            """;

    private static final String SQL_LISTAR_IDS_PRESENTES_ASISTENCIA = """
            SELECT id_alumno
            FROM asistencia
            WHERE id_actividad = ?
            AND fecha_asistencia = ?
            AND asistio = 1
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

    public List<HorarioActividad> listarHorariosPorActividad(int idActividad) {
        List<HorarioActividad> horarios = new ArrayList<>();

        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_HORARIOS_POR_ACTIVIDAD)
        ) {
            statement.setInt(1, idActividad);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    HorarioActividad horario = new HorarioActividad();
                    horario.setIdActividad(resultSet.getInt("id_actividad"));
                    horario.setDiaSemana(resultSet.getString("dia_semana"));
                    horario.setHoraInicio(resultSet.getTime("hora_inicio"));
                    horario.setHoraFin(resultSet.getTime("hora_fin"));

                    horarios.add(horario);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar horarios de la actividad.", e);
        }

        return horarios;
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

    public boolean actualizarActividadConHorarios(Actividad actividad, List<HorarioActividad> horarios) {
        Connection connection = null;

        try {
            connection = ConexionDB.getConnection();
            connection.setAutoCommit(false);

            try (
                    PreparedStatement actividadStmt = connection.prepareStatement(SQL_ACTUALIZAR_ACTIVIDAD);
                    PreparedStatement eliminarHorariosStmt = connection.prepareStatement(SQL_ELIMINAR_HORARIOS_ACTIVIDAD);
                    PreparedStatement insertarHorarioStmt = connection.prepareStatement(SQL_INSERTAR_HORARIO)
            ) {
                actividadStmt.setString(1, actividad.getNombreActividad());
                actividadStmt.setString(2, actividad.getDescripcionActividad());
                actividadStmt.setInt(3, actividad.getIdInstructor());
                actividadStmt.setString(4, actividad.getEstadoActividad());
                actividadStmt.setInt(5, actividad.getIdActividad());

                boolean actividadActualizada = actividadStmt.executeUpdate() > 0;

                if (!actividadActualizada) {
                    connection.rollback();
                    return false;
                }

                eliminarHorariosStmt.setInt(1, actividad.getIdActividad());
                eliminarHorariosStmt.executeUpdate();

                for (HorarioActividad horario : horarios) {
                    insertarHorarioStmt.setInt(1, actividad.getIdActividad());
                    insertarHorarioStmt.setString(2, horario.getDiaSemana());
                    insertarHorarioStmt.setTime(3, horario.getHoraInicio());
                    insertarHorarioStmt.setTime(4, horario.getHoraFin());
                    insertarHorarioStmt.addBatch();
                }

                insertarHorarioStmt.executeBatch();

                connection.commit();
                return true;
            }

        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            throw new RuntimeException("Error al actualizar actividad con horarios.", e);

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

    public int inscribirAlumnosEnActividad(int idActividad, List<Integer> idsAlumnos) {
        int totalInscritos = 0;

        Connection connection = null;

        try {
            connection = ConexionDB.getConnection();
            connection.setAutoCommit(false);

            try (
                    PreparedStatement reactivarStatement = connection.prepareStatement(SQL_REACTIVAR_INSCRIPCION_VALIDADA);
                    PreparedStatement insertarStatement = connection.prepareStatement(SQL_INSCRIBIR_ALUMNO_VALIDADO)
            ) {
                for (Integer idAlumno : idsAlumnos) {
                    reactivarStatement.setInt(1, idAlumno);
                    reactivarStatement.setInt(2, idActividad);
                    reactivarStatement.setInt(3, idActividad);
                    reactivarStatement.setInt(4, idAlumno);

                    int filasReactivadas = reactivarStatement.executeUpdate();

                    if (filasReactivadas > 0) {
                        totalInscritos += filasReactivadas;
                        continue;
                    }

                    insertarStatement.setInt(1, idAlumno);
                    insertarStatement.setInt(2, idActividad);

                    insertarStatement.setInt(3, idActividad);
                    insertarStatement.setInt(4, idAlumno);
                    insertarStatement.setInt(5, idAlumno);
                    insertarStatement.setInt(6, idActividad);

                    totalInscritos += insertarStatement.executeUpdate();
                }
            }

            connection.commit();
            return totalInscritos;

        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            throw new RuntimeException("Error al inscribir alumnos en la actividad.", e);

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

    public boolean retirarAlumnoDeActividad(int idActividad, int idAlumno) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_CANCELAR_INSCRIPCION_ACTIVA)
        ) {
            statement.setInt(1, idAlumno);
            statement.setInt(2, idActividad);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error al retirar alumno de la actividad.", e);
        }
    }

    public void registrarAsistencia(
            int idActividad,
            java.sql.Date fechaAsistencia,
            List<Integer> idsPresentes,
            List<Integer> idsTodosInscritos,
            int idAdmin
    ) {
        Connection connection = null;

        try {
            connection = ConexionDB.getConnection();
            connection.setAutoCommit(false);

            try (
                    PreparedStatement actualizarStmt = connection.prepareStatement(SQL_ACTUALIZAR_ASISTENCIA_EXISTENTE);
                    PreparedStatement insertarStmt = connection.prepareStatement(SQL_INSERTAR_ASISTENCIA)
            ) {
                for (Integer idAlumno : idsTodosInscritos) {
                    boolean asistio = idsPresentes != null && idsPresentes.contains(idAlumno);

                    actualizarStmt.setBoolean(1, asistio);
                    actualizarStmt.setInt(2, idAdmin);
                    actualizarStmt.setInt(3, idAlumno);
                    actualizarStmt.setInt(4, idActividad);
                    actualizarStmt.setDate(5, fechaAsistencia);

                    int filasActualizadas = actualizarStmt.executeUpdate();

                    if (filasActualizadas == 0) {
                        insertarStmt.setInt(1, idAlumno);
                        insertarStmt.setInt(2, idActividad);
                        insertarStmt.setDate(3, fechaAsistencia);
                        insertarStmt.setBoolean(4, asistio);
                        insertarStmt.setInt(5, idAdmin);

                        insertarStmt.executeUpdate();
                    }
                }

                connection.commit();
            }

        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            throw new RuntimeException("Error al registrar asistencia.", e);

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

    public boolean existeAsistenciaRegistrada(int idActividad, java.sql.Date fechaAsistencia) {
        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_EXISTE_ASISTENCIA_ACTIVIDAD_FECHA)
        ) {
            statement.setInt(1, idActividad);
            statement.setDate(2, fechaAsistencia);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("total") > 0;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al validar asistencia existente.", e);
        }

        return false;
    }

    public List<Integer> listarIdsPresentesAsistencia(int idActividad, java.sql.Date fechaAsistencia) {
        List<Integer> idsPresentes = new ArrayList<>();

        try (
                Connection connection = ConexionDB.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_LISTAR_IDS_PRESENTES_ASISTENCIA)
        ) {
            statement.setInt(1, idActividad);
            statement.setDate(2, fechaAsistencia);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    idsPresentes.add(resultSet.getInt("id_alumno"));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar alumnos presentes de la asistencia.", e);
        }

        return idsPresentes;
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