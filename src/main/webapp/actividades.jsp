<%@ page import="java.util.List" %>
<%@ page import="com.cdc.model.Actividad" %>
<%@ page import="com.cdc.model.Alumno" %>
<%@ page import="com.cdc.model.AlumnoInscritoActividad" %>
<%@ page import="com.cdc.model.Instructor" %>
<%@ page import="com.cdc.model.CalendarioActividad" %>
<%@ page import="com.cdc.model.HorarioActividad" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Actividad> listaActividades = (List<Actividad>) request.getAttribute("listaActividades");
    Actividad actividadSeleccionada = (Actividad) request.getAttribute("actividadSeleccionada");
    List<AlumnoInscritoActividad> alumnosInscritos =
            (List<AlumnoInscritoActividad>) request.getAttribute("alumnosInscritos");
    List<Alumno> alumnosDisponibles =
            (List<Alumno>) request.getAttribute("alumnosDisponibles");
    List<Instructor> instructoresActivos =
            (List<Instructor>) request.getAttribute("instructoresActivos");
    List<CalendarioActividad> actividadesCalendario =
            (List<CalendarioActividad>) request.getAttribute("actividadesCalendario");
    List<HorarioActividad> horariosSeleccionados =
        (List<HorarioActividad>) request.getAttribute("horariosSeleccionados");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Talleres - CDC Plan Chac</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS global -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css?v=<%= System.currentTimeMillis() %>">
    <!-- CSS de actividades -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/actividades.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>

<div class="app-shell">
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-top">
            <button type="button" class="brand-toggle" id="menuToggle" aria-label="Expandir o colapsar menú" aria-expanded="true">
                <span class="brand-mark">CDC</span>
                <span class="brand-text">
                    <span class="brand-title">Plan Chac</span>
                    <span class="brand-subtitle">Centro comunitario</span>
                </span>
            </button>
        </div>

        <nav class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/dashboard" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span class="nav-label">Dashboard</span>
            </a>

            <a href="<%= request.getContextPath() %>/actividades" class="nav-item active">
                <i class="bi bi-calendar3"></i>
                <span class="nav-label">Talleres</span>
            </a>

            <a href="<%= request.getContextPath() %>/alumnos" class="nav-item">
                <i class="bi bi-people-fill"></i>
                <span class="nav-label">Alumnos</span>
            </a>

            <a href="<%= request.getContextPath() %>/reportes" class="nav-item">
                <i class="bi bi-file-earmark-bar-graph-fill"></i>
                <span class="nav-label">Reportes</span>
            </a>

            <a href="<%= request.getContextPath() %>/gerontologia" class="nav-item">
                <i class="bi bi-heart-pulse-fill"></i>
                <span class="nav-label">Gerontología</span>
            </a>
        </nav>
    </aside>

    <div class="main-panel">
        <header class="topbar">
            <div class="topbar-left">
                <div>
                    <h1 class="page-title">Talleres</h1>
                    <p class="page-subtitle">Administra talleres, horarios, alumnos y asistencia</p>
                </div>
            </div>

            <div class="topbar-right">
                <button class="activity-primary-btn" type="button" data-bs-toggle="modal" data-bs-target="#modalNuevoTaller">
                    <i class="bi bi-plus-lg"></i>
                    <span>Nuevo taller</span>
                </button>
            </div>
        </header>

        <main class="content">

            <%
                String tipoMensaje = request.getParameter("tipoMensaje");
                String mensaje = request.getParameter("mensaje");

                String textoMensaje = null;

                if (mensaje != null) {
                    switch (mensaje) {
                        case "actividad_guardada":
                            textoMensaje = "Actividad guardada correctamente.";
                            break;
                        case "actividad_actualizada":
                            textoMensaje = "Actividad actualizada correctamente.";
                            break;
                        case "actividad_no_actualizada":
                            textoMensaje = "No se pudo actualizar la actividad.";
                            break;
                        case "actividad_nombre_obligatorio":
                            textoMensaje = "El nombre de la actividad es obligatorio.";
                            break;
                        case "actividad_nombre_invalido":
                            textoMensaje = "El nombre de la actividad debe tener al menos 3 caracteres.";
                            break;
                        case "actividad_instructor_obligatorio":
                            textoMensaje = "Debes seleccionar un instructor.";
                            break;
                        case "actividad_instructor_invalido":
                            textoMensaje = "El instructor seleccionado no es válido.";
                            break;
                        case "actividad_estado_invalido":
                            textoMensaje = "El estado de la actividad no es válido.";
                            break;
                        case "actividad_horario_obligatorio":
                            textoMensaje = "Debes registrar al menos un horario para la actividad.";
                            break;
                        case "actividad_horario_incompleto":
                            textoMensaje = "Revisa los horarios. Hay un día, hora de inicio o fin incompleto.";
                            break;
                        case "actividad_dia_invalido":
                            textoMensaje = "Uno de los días seleccionados no es válido.";
                            break;
                        case "actividad_hora_invalida":
                            textoMensaje = "La hora de inicio debe ser menor que la hora de fin.";
                            break;
                        case "actividad_hora_formato_invalido":
                            textoMensaje = "Uno de los horarios no tiene un formato válido.";
                            break;
                        case "actividad_id_invalido":
                            textoMensaje = "El identificador de la actividad no es válido.";
                            break;

                        case "asistencia_registrada":
                            textoMensaje = "Asistencia registrada correctamente.";
                            break;
                        case "asistencia_actualizada":
                            textoMensaje = "La asistencia existente fue actualizada correctamente.";
                            break;
                        case "asistencia_actividad_invalida":
                            textoMensaje = "La actividad seleccionada no es válida.";
                            break;
                        case "asistencia_actividad_inactiva":
                            textoMensaje = "No puedes registrar asistencia en una actividad inactiva.";
                            break;
                        case "asistencia_fecha_obligatoria":
                            textoMensaje = "Debes seleccionar una fecha para registrar asistencia.";
                            break;
                        case "asistencia_fecha_futura":
                            textoMensaje = "No puedes registrar asistencia con una fecha futura.";
                            break;
                        case "asistencia_sin_alumnos":
                            textoMensaje = "No hay alumnos activos inscritos para registrar asistencia.";
                            break;
                        case "asistencia_datos_invalidos":
                            textoMensaje = "Los datos de asistencia no son válidos.";
                            break;

                        case "error_sistema":
                            textoMensaje = "Ocurrió un error interno. Revisa la consola de Tomcat.";
                            break;

                        case "inscripcion_exitosa":
                            textoMensaje = "Alumno(s) inscrito(s) correctamente.";
                            break;
                        case "inscripcion_parcial":
                            textoMensaje = "Se inscribieron algunos alumnos. Otros fueron omitidos porque ya estaban inscritos o no estaban activos.";
                            break;
                        case "inscripcion_no_realizada":
                            textoMensaje = "No se realizó ninguna inscripción. Revisa que la actividad esté activa y que los alumnos no estén inscritos previamente.";
                            break;
                        case "inscripcion_actividad_invalida":
                            textoMensaje = "La actividad seleccionada no es válida.";
                            break;
                        case "inscripcion_actividad_inactiva":
                            textoMensaje = "No puedes inscribir alumnos en una actividad inactiva.";
                            break;
                        case "inscripcion_sin_alumnos":
                            textoMensaje = "Debes seleccionar al menos un alumno para inscribir.";
                            break;
                        case "inscripcion_alumnos_invalidos":
                            textoMensaje = "Los alumnos seleccionados no son válidos.";
                            break;
                        case "inscripcion_datos_invalidos":
                            textoMensaje = "Los datos de inscripción no son válidos.";
                            break;

                        case "retiro_exitoso":
                            textoMensaje = "Alumno retirado de la actividad correctamente. Su historial se conservará.";
                            break;
                        case "retiro_no_realizado":
                            textoMensaje = "No se pudo retirar al alumno. Puede que ya no tenga una inscripción activa.";
                            break;
                        case "retiro_datos_invalidos":
                            textoMensaje = "Los datos para retirar al alumno no son válidos.";
                            break;
                        case "retiro_actividad_invalida":
                            textoMensaje = "La actividad seleccionada no es válida.";
                            break;
                        case "retiro_actividad_inactiva":
                            textoMensaje = "No puedes retirar alumnos de una actividad inactiva.";
                            break;

                        case "actividad_desactivada":
                            textoMensaje = "Actividad desactivada correctamente. Ya no permitirá inscripciones ni asistencia.";
                            break;
                        case "actividad_reactivada":
                            textoMensaje = "Actividad reactivada correctamente. Ya permite inscripciones y asistencia nuevamente.";
                            break;
                        case "estado_actividad_id_invalido": 
                            textoMensaje = "El identificador de la actividad no es válido.";
                            break;
                        case "estado_actividad_invalido":
                            textoMensaje = "El nuevo estado de la actividad no es válido.";
                            break;
                        case "estado_actividad_no_encontrada":
                            textoMensaje = "No se encontró la actividad seleccionada.";
                            break;
                        case "estado_actividad_sin_cambios":
                            textoMensaje = "La actividad ya tenía ese estado.";
                            break;
                        case "estado_actividad_no_actualizado":
                            textoMensaje = "No se pudo actualizar el estado de la actividad.";
                            break;

                        default:
                            textoMensaje = null;
                    }
                }

                if (textoMensaje != null) {
            %>
                <div class="cdc-toast <%= "exito".equalsIgnoreCase(tipoMensaje) ? "cdc-toast-success" : "cdc-toast-error" %>">
                    <div class="cdc-toast-icon">
                        <%= "exito".equalsIgnoreCase(tipoMensaje) ? "✓" : "!" %>
                    </div>

                    <div class="cdc-toast-content">
                        <strong>
                            <%= "exito".equalsIgnoreCase(tipoMensaje) ? "Operación exitosa" : "Revisa la información" %>
                        </strong>
                        <span><%= textoMensaje %></span>
                    </div>

                    <button type="button" class="cdc-toast-close" onclick="this.parentElement.style.display='none'">
                        ×
                    </button>
                </div>
            <%
                }
            %>

            <!-- Barra de control -->
            <section class="activities-toolbar">
                <div class="toolbar-search">
                    <i class="bi bi-search"></i>
                    <input type="text" id="searchActivityInput" placeholder="Buscar actividad">
                </div>

                <select id="activityStatusFilter" class="toolbar-select">
                    <option value="activas">Estado: Activas</option>
                    <option value="todas">Estado: Todas</option>
                    <option value="inactivas">Estado: Inactivas</option>
                </select>

            </section>

            <!-- Layout principal -->
            <section class="activities-layout">
                <!-- Columna izquierda -->
                <section class="activities-list-card">
                    <div class="section-header">
                        <h3>Listado de actividades</h3>
                    </div>
                    <div class="activities-list" id="activitiesList">
                        <%
                            if (listaActividades != null && !listaActividades.isEmpty()) {
                                for (Actividad actividad : listaActividades) {
                                    boolean seleccionada = actividadSeleccionada != null
                                            && actividadSeleccionada.getIdActividad() == actividad.getIdActividad();

                                    String claseEstado = actividad.getEstadoActividad().equalsIgnoreCase("Inactiva")
                                            ? "inactive"
                                            : "active";
                        %>
                        <article class="activity-item activity-list-item <%= seleccionada ? "selected" : "" %>"
                                data-activity-id="<%= actividad.getIdActividad() %>"
                                onclick="window.location.href='<%= request.getContextPath() %>/actividades?id=<%= actividad.getIdActividad() %>'">
                            <div class="activity-item-icon">
                                <i class="bi bi-journal-richtext"></i>
                            </div>

                            <div class="activity-item-body">
                                <div class="activity-item-top">
                                    <h4><%= actividad.getNombreActividad() %></h4>
                                    <span class="status-badge <%= claseEstado %>"><%= actividad.getEstadoActividad() %></span>
                                </div>
                                <p class="activity-item-instructor">Instructor: <%= actividad.getNombreInstructor() %></p>
                                <p class="activity-item-schedule">
                                    <%= actividad.getHorariosResumen() != null ? actividad.getHorariosResumen() : "Sin horario" %>
                                </p>
                                <p class="activity-item-meta"><%= actividad.getTotalInscritos() %> inscritos</p>
                            </div>
                        </article>
                        <%
                                }
                            } else {
                        %>
                        <p>No hay actividades registradas.</p>
                        <%
                            }
                        %>
                    </div>
                </section>

                <!-- Columna derecha -->
                <section class="activities-detail-column">
                    <!-- Detalle de actividad -->
                    <section class="activity-detail-card">
                        <div class="activity-detail-main">
                            <div class="activity-detail-icon">
                                <i class="bi bi-journal-richtext"></i>
                            </div>

                            <div class="activity-detail-info">
                                <div class="activity-detail-title-row">
                                    <h2 id="activityDetailName">
                                        <%= actividadSeleccionada != null ? actividadSeleccionada.getNombreActividad() : "Sin actividad" %>
                                    </h2>
                                    <span class="status-badge <%= (actividadSeleccionada != null && actividadSeleccionada.getEstadoActividad().equalsIgnoreCase("Inactiva")) ? "inactive" : "active" %>" id="activityDetailStatus">
                                        <%= actividadSeleccionada != null ? actividadSeleccionada.getEstadoActividad() : "N/D" %>
                                    </span>
                                </div>

                                <div class="activity-detail-grid">
                                    <div class="detail-item">
                                        <span class="detail-label">Instructor</span>
                                        <span class="detail-value" id="activityDetailInstructor">
                                            <%= actividadSeleccionada != null ? actividadSeleccionada.getNombreInstructor() : "" %>
                                        </span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Horarios</span>
                                        <span class="detail-value" id="activityDetailSchedule">
                                            <%= actividadSeleccionada != null ? actividadSeleccionada.getHorariosResumen() : "" %>
                                        </span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Descripción</span>
                                        <span class="detail-value" id="activityDetailDescription">
                                            <%= (actividadSeleccionada != null && actividadSeleccionada.getDescripcionActividad() != null && !actividadSeleccionada.getDescripcionActividad().isBlank())
                                                    ? actividadSeleccionada.getDescripcionActividad()
                                                    : "Sin descripción registrada." %>
                                        </span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Inscritos</span>
                                        <span class="detail-value" id="activityDetailCount">
                                            <%= actividadSeleccionada != null ? actividadSeleccionada.getTotalInscritos() : 0 %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%
                            boolean actividadActiva = actividadSeleccionada != null
                                    && "Activa".equalsIgnoreCase(actividadSeleccionada.getEstadoActividad());

                            String mensajeConfirmacionEstado = actividadActiva
                                    ? "¿Seguro que deseas desactivar esta actividad? Seguirá existiendo en el historial, pero dejará de operar como activa."
                                    : "¿Seguro que deseas reactivar esta actividad? Volverá a estar disponible en el sistema.";

                            String nuevoEstadoActividad = actividadActiva ? "Inactiva" : "Activa";
                            String claseBotonEstado = actividadActiva ? "danger" : "secondary";
                            String iconoBotonEstado = actividadActiva ? "bi-slash-circle" : "bi-arrow-clockwise";
                            String textoBotonEstado = actividadActiva ? "Desactivar" : "Reactivar";
                        %>

                        <div class="activity-actions">
                            <button class="action-btn secondary"
                                    type="button"
                                    data-bs-toggle="modal"
                                    data-bs-target="#modalEditarActividad">
                                <i class="bi bi-pencil-square"></i>
                                <span>Editar</span>
                            </button>

                            <% if (actividadActiva) { %>
                                <button class="action-btn secondary"
                                        type="button"
                                        data-bs-toggle="modal"
                                        data-bs-target="#modalAgregarAlumno">
                                    <i class="bi bi-person-plus-fill"></i>
                                    <span>Agregar alumno</span>
                                </button>

                                <button class="action-btn primary"
                                        type="button"
                                        data-bs-toggle="modal"
                                        data-bs-target="#modalAsistencia">
                                    <i class="bi bi-check2-square"></i>
                                    <span>Pasar asistencia</span>
                                </button>
                            <% } else { %>
                                <button class="action-btn disabled-action"
                                        type="button"
                                        disabled
                                        title="Esta actividad está inactiva. Reactívala para agregar alumnos.">
                                    <i class="bi bi-person-plus-fill"></i>
                                    <span>Agregar alumno</span>
                                </button>

                                <button class="action-btn disabled-action"
                                        type="button"
                                        disabled
                                        title="Esta actividad está inactiva. Reactívala para pasar asistencia.">
                                    <i class="bi bi-check2-square"></i>
                                    <span>Pasar asistencia</span>
                                </button>
                            <% } %>

                            <form method="post"
                                action="<%= request.getContextPath() %>/cambiar-estado-actividad"
                                class="js-confirm-submit"
                                data-confirm-title="<%= actividadActiva ? "Desactivar actividad" : "Reactivar actividad" %>"
                                data-confirm-message="<%= mensajeConfirmacionEstado %>"
                                data-confirm-confirm-text="<%= textoBotonEstado %>"
                                data-confirm-danger="<%= actividadActiva ? "true" : "false" %>"
                                style="display: inline;">
                                <input type="hidden" name="idActividad"
                                    value="<%= actividadSeleccionada != null ? actividadSeleccionada.getIdActividad() : 0 %>">

                                <input type="hidden" name="nuevoEstado"
                                    value="<%= nuevoEstadoActividad %>">

                                <button type="submit"
                                        class="action-btn <%= claseBotonEstado %>">
                                    <i class="bi <%= iconoBotonEstado %>"></i>
                                    <span><%= textoBotonEstado %></span>
                                </button>
                            </form>
                        </div>

                        <% if (!actividadActiva) { %>
                            <div class="inactive-activity-notice">
                                <i class="bi bi-info-circle"></i>
                                <div>
                                    <strong>Actividad inactiva</strong>
                                    <span>No permite inscripciones ni asistencia. Puedes reactivarla cuando sea necesario.</span>
                                </div>
                            </div>
                        <% } %>
                    </section>

                    <!-- Alumnos inscritos -->
                    <section class="students-card">
                        <div class="section-header section-header-wrap">
                            <h3>Alumnos inscritos</h3>

                            <div class="students-controls">
                                <input type="text" id="searchStudentInput" class="students-search" placeholder="Buscar alumno">

                                <select id="studentOrderSelect" class="toolbar-select small">
                                    <option value="asistencias">Ordenar por asistencias del mes</option>
                                    <option value="nombre">Ordenar por nombre</option>
                                </select>
                            </div>
                        </div>

                        <div class="students-table-wrapper">
                            <table class="students-table">
                                <thead>
                                <tr>
                                    <th>Alumno</th>
                                    <th>Contacto</th>
                                    <th>Asistencias del mes</th>
                                    <th>Acciones</th>
                                </tr>
                                </thead>
                                <tbody id="studentsTableBody">
                                <%
                                    if (alumnosInscritos != null && !alumnosInscritos.isEmpty()) {
                                        for (AlumnoInscritoActividad alumno : alumnosInscritos) {
                                %>
                                <tr>
                                    <td><%= alumno.getNombreCompleto() %></td>
                                    <td><%= alumno.getCelular() %></td>
                                    <td><%= alumno.getAsistenciasDelMes() %></td>
                                    <td>
                                        <button class="table-icon-btn student-view-btn" title="Ver alumno" data-bs-toggle="modal" data-bs-target="#modalAlumnoDetalle">
                                            <i class="bi bi-eye"></i>
                                        </button>

                                        <% if (actividadActiva) { %>
                                            <form method="post"
                                                action="<%= request.getContextPath() %>/retirar-alumno-actividad"
                                                class="js-confirm-submit"
                                                data-confirm-title="Retirar alumno"
                                                data-confirm-message="¿Seguro que deseas retirar a <%= alumno.getNombreCompleto() %> de esta actividad? Su historial se conservará."
                                                data-confirm-confirm-text="Retirar alumno"
                                                data-confirm-danger="true"
                                                style="display:inline;">

                                                <input type="hidden"
                                                    name="idActividad"
                                                    value="<%= actividadSeleccionada != null ? actividadSeleccionada.getIdActividad() : 0 %>">

                                                <input type="hidden"
                                                    name="idAlumno"
                                                    value="<%= alumno.getIdAlumno() %>">

                                                <button type="submit"
                                                        class="table-icon-btn danger"
                                                        title="Retirar alumno">
                                                    <i class="bi bi-person-dash"></i>
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <button type="button"
                                                    class="table-icon-btn disabled-table-action"
                                                    disabled
                                                    title="No puedes retirar alumnos mientras la actividad esté inactiva.">
                                                <i class="bi bi-person-dash"></i>
                                            </button>
                                        <% } %>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="4">No hay alumnos inscritos en esta actividad.</td>
                                </tr>
                                <%
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <!-- Calendario resumido -->
                    <section class="calendar-summary-card">
                        <div class="section-header">
                            <h3>Calendario resumido</h3>
                            <a href="<%= request.getContextPath() %>/calendario" class="calendar-link">Ver calendario completo</a>
                        </div>

                        <div class="mini-calendar">
                            <div class="day-column">
                                <span class="day-name">Lun</span>
                                <%
                                    int lunesCount = 0;
                                    if (actividadesCalendario != null) {
                                        for (CalendarioActividad item : actividadesCalendario) {
                                            if ("Lunes".equalsIgnoreCase(item.getDiaSemana()) && lunesCount < 3) {
                                %>
                                <div class="slot active"><%= item.getHoraInicio().toString().substring(0, 5) %> <%= item.getNombreActividad() %></div>
                                <%
                                                lunesCount++;
                                            }
                                        }
                                    }
                                    while (lunesCount < 3) {
                                %>
                                <div class="slot empty"></div>
                                <%
                                        lunesCount++;
                                    }
                                %>
                            </div>

                            <div class="day-column">
                                <span class="day-name">Mar</span>
                                <%
                                    int martesCount = 0;
                                    if (actividadesCalendario != null) {
                                        for (CalendarioActividad item : actividadesCalendario) {
                                            if ("Martes".equalsIgnoreCase(item.getDiaSemana()) && martesCount < 3) {
                                %>
                                <div class="slot active"><%= item.getHoraInicio().toString().substring(0, 5) %> <%= item.getNombreActividad() %></div>
                                <%
                                                martesCount++;
                                            }
                                        }
                                    }
                                    while (martesCount < 3) {
                                %>
                                <div class="slot empty"></div>
                                <%
                                        martesCount++;
                                    }
                                %>
                            </div>

                            <div class="day-column">
                                <span class="day-name">Mié</span>
                                <%
                                    int miercolesCount = 0;
                                    if (actividadesCalendario != null) {
                                        for (CalendarioActividad item : actividadesCalendario) {
                                            if ("Miércoles".equalsIgnoreCase(item.getDiaSemana()) && miercolesCount < 3) {
                                %>
                                <div class="slot active"><%= item.getHoraInicio().toString().substring(0, 5) %> <%= item.getNombreActividad() %></div>
                                <%
                                                miercolesCount++;
                                            }
                                        }
                                    }
                                    while (miercolesCount < 3) {
                                %>
                                <div class="slot empty"></div>
                                <%
                                        miercolesCount++;
                                    }
                                %>
                            </div>

                            <div class="day-column">
                                <span class="day-name">Jue</span>
                                <%
                                    int juevesCount = 0;
                                    if (actividadesCalendario != null) {
                                        for (CalendarioActividad item : actividadesCalendario) {
                                            if ("Jueves".equalsIgnoreCase(item.getDiaSemana()) && juevesCount < 3) {
                                %>
                                <div class="slot active"><%= item.getHoraInicio().toString().substring(0, 5) %> <%= item.getNombreActividad() %></div>
                                <%
                                                juevesCount++;
                                            }
                                        }
                                    }
                                    while (juevesCount < 3) {
                                %>
                                <div class="slot empty"></div>
                                <%
                                        juevesCount++;
                                    }
                                %>
                            </div>

                            <div class="day-column">
                                <span class="day-name">Vie</span>
                                <%
                                    int viernesCount = 0;
                                    if (actividadesCalendario != null) {
                                        for (CalendarioActividad item : actividadesCalendario) {
                                            if ("Viernes".equalsIgnoreCase(item.getDiaSemana()) && viernesCount < 3) {
                                %>
                                <div class="slot active"><%= item.getHoraInicio().toString().substring(0, 5) %> <%= item.getNombreActividad() %></div>
                                <%
                                                viernesCount++;
                                            }
                                        }
                                    }
                                    while (viernesCount < 3) {
                                %>
                                <div class="slot empty"></div>
                                <%
                                        viernesCount++;
                                    }
                                %>
                            </div>
                        </div>
                    </section>
                </section>
            </section>
        </main>
    </div>
</div>

<!-- Modal: Nueva actividad -->
<div class="modal fade" id="modalNuevaActividad" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content custom-modal">
            <form method="post" action="<%= request.getContextPath() %>/guardar-actividad">
                <div class="modal-header">
                    <h5 class="modal-title">Nueva actividad</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <div class="form-grid">
                        <div class="form-group full">
                            <label for="activityName">Nombre de la actividad</label>
                            <input type="text" id="activityName" name="nombreActividad" class="form-control" placeholder="Ej. Manualidades" required>
                        </div>

                        <div class="form-group full">
                            <label for="activityInstructor">Instructor</label>
                            <select id="activityInstructor" name="idInstructor" class="form-select" required>
                                <option selected disabled value="">Selecciona un instructor</option>
                                <%
                                    if (instructoresActivos != null) {
                                        for (Instructor instructor : instructoresActivos) {
                                %>
                                <option value="<%= instructor.getIdInstructor() %>"><%= instructor.getNombreCompleto() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group full">
                            <label for="activityDescription">Descripción (opcional)</label>
                            <textarea id="activityDescription" name="descripcionActividad" class="form-control" rows="3" placeholder="Describe brevemente la actividad"></textarea>
                        </div>
                    </div>

                    <input type="hidden" name="estadoActividad" value="Activa">

                    <div class="schedule-builder">
                        <div class="schedule-builder-header">
                            <h6>Horarios</h6>
                            <button type="button" class="small-inline-btn" id="addScheduleRowBtn">
                                <i class="bi bi-plus-lg"></i>
                                <span>Agregar horario</span>
                            </button>
                        </div>

                        <div id="scheduleRows">
                            <div class="schedule-row">
                                <select class="form-select" name="diaSemana">
                                    <option>Lunes</option>
                                    <option>Martes</option>
                                    <option>Miércoles</option>
                                    <option>Jueves</option>
                                    <option>Viernes</option>
                                    <option>Sábado</option>
                                </select>

                                <input type="time" class="form-control" name="horaInicio" value="10:00">
                                <input type="time" class="form-control" name="horaFin" value="12:00">

                                <button type="button" class="table-icon-btn remove-schedule-btn" title="Quitar horario">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn activity-primary-btn modal-save-btn">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Editar actividad -->
<div class="modal fade" id="modalEditarActividad" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content custom-modal">
            <form method="post" action="<%= request.getContextPath() %>/actualizar-actividad">
                <div class="modal-header">
                    <h5 class="modal-title">Editar actividad</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="idActividad"
                           value="<%= actividadSeleccionada != null ? actividadSeleccionada.getIdActividad() : 0 %>">

                    <div class="activity-form-grid">
                        <div class="form-group">
                            <label for="editActivityName">Nombre de la actividad</label>
                            <input type="text"
                                   id="editActivityName"
                                   name="nombreActividad"
                                   class="form-control"
                                   value="<%= actividadSeleccionada != null ? actividadSeleccionada.getNombreActividad() : "" %>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="editActivityInstructor">Instructor</label>
                            <select id="editActivityInstructor" name="idInstructor" class="form-select" required>
                                <option disabled value="">Selecciona un instructor</option>
                                <%
                                    if (instructoresActivos != null) {
                                        for (Instructor instructor : instructoresActivos) {
                                            boolean selectedInstructor =
                                                    actividadSeleccionada != null &&
                                                    actividadSeleccionada.getIdInstructor() == instructor.getIdInstructor();
                                %>
                                <option value="<%= instructor.getIdInstructor() %>" <%= selectedInstructor ? "selected" : "" %>>
                                    <%= instructor.getNombreCompleto() %>
                                </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group full">
                            <label for="editActivityDescription">Descripción</label>
                            <textarea id="editActivityDescription"
                                      name="descripcionActividad"
                                      class="form-control"
                                      rows="3"
                                      placeholder="Describe brevemente la actividad"><%= actividadSeleccionada != null && actividadSeleccionada.getDescripcionActividad() != null ? actividadSeleccionada.getDescripcionActividad() : "" %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="editActivityStatus">Estado</label>
                            <select id="editActivityStatus" name="estadoActividad" class="form-select" required>
                                <option value="Activa" <%= actividadSeleccionada != null && "Activa".equalsIgnoreCase(actividadSeleccionada.getEstadoActividad()) ? "selected" : "" %>>Activa</option>
                                <option value="Inactiva" <%= actividadSeleccionada != null && "Inactiva".equalsIgnoreCase(actividadSeleccionada.getEstadoActividad()) ? "selected" : "" %>>Inactiva</option>
                            </select>
                        </div>
                    </div>

                    <div class="schedule-builder">
                        <div class="schedule-builder-header">
                            <h6>Horarios</h6>
                            <button type="button" class="small-inline-btn" id="addEditScheduleRowBtn">
                                <i class="bi bi-plus-lg"></i>
                                <span>Agregar horario</span>
                            </button>
                        </div>

                        <div id="editScheduleRows">
                            <%
                                if (horariosSeleccionados != null && !horariosSeleccionados.isEmpty()) {
                                    for (HorarioActividad horario : horariosSeleccionados) {
                                        String diaHorario = horario.getDiaSemana();
                                        String horaInicioHorario = horario.getHoraInicio() != null
                                                ? horario.getHoraInicio().toString().substring(0, 5)
                                                : "10:00";
                                        String horaFinHorario = horario.getHoraFin() != null
                                                ? horario.getHoraFin().toString().substring(0, 5)
                                                : "12:00";
                            %>
                            <div class="schedule-row">
                                <select class="form-select" name="diaSemana">
                                    <option value="Lunes" <%= "Lunes".equalsIgnoreCase(diaHorario) ? "selected" : "" %>>Lunes</option>
                                    <option value="Martes" <%= "Martes".equalsIgnoreCase(diaHorario) ? "selected" : "" %>>Martes</option>
                                    <option value="Miércoles" <%= "Miércoles".equalsIgnoreCase(diaHorario) ? "selected" : "" %>>Miércoles</option>
                                    <option value="Jueves" <%= "Jueves".equalsIgnoreCase(diaHorario) ? "selected" : "" %>>Jueves</option>
                                    <option value="Viernes" <%= "Viernes".equalsIgnoreCase(diaHorario) ? "selected" : "" %>>Viernes</option>
                                    <option value="Sábado" <%= "Sábado".equalsIgnoreCase(diaHorario) ? "selected" : "" %>>Sábado</option>
                                </select>

                                <input type="time" class="form-control" name="horaInicio" value="<%= horaInicioHorario %>">
                                <input type="time" class="form-control" name="horaFin" value="<%= horaFinHorario %>">

                                <button type="button" class="table-icon-btn remove-schedule-btn" title="Quitar horario">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                            <%
                                    }
                                } else {
                            %>
                            <div class="schedule-row">
                                <select class="form-select" name="diaSemana">
                                    <option value="Lunes">Lunes</option>
                                    <option value="Martes">Martes</option>
                                    <option value="Miércoles">Miércoles</option>
                                    <option value="Jueves">Jueves</option>
                                    <option value="Viernes">Viernes</option>
                                    <option value="Sábado">Sábado</option>
                                </select>

                                <input type="time" class="form-control" name="horaInicio" value="10:00">
                                <input type="time" class="form-control" name="horaFin" value="12:00">

                                <button type="button" class="table-icon-btn remove-schedule-btn" title="Quitar horario">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn activity-primary-btn modal-save-btn">Guardar cambios</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Agregar alumno -->
<div class="modal fade" id="modalAgregarAlumno" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content custom-modal">
            <form method="post" action="<%= request.getContextPath() %>/inscribir-alumnos-actividad">
                <div class="modal-header">
                    <h5 class="modal-title">Agregar alumno a la actividad</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="idActividad"
                           value="<%= actividadSeleccionada != null ? actividadSeleccionada.getIdActividad() : 0 %>">

                    <div class="toolbar-search modal-search">
                        <i class="bi bi-search"></i>
                        <input type="text" id="buscarAlumnoDisponible" placeholder="Buscar alumno registrado">
                    </div>

                    <div class="assign-students-list" id="listaAlumnosDisponibles">
                        <%
                            if (alumnosDisponibles != null && !alumnosDisponibles.isEmpty()) {
                                for (Alumno alumno : alumnosDisponibles) {
                        %>
                        <label class="assign-student-item alumno-disponible-item">
                            <input type="checkbox" name="idsAlumnos" value="<%= alumno.getIdAlumno() %>">
                            <span>
                                <strong><%= alumno.getNombreCompleto() %></strong><br>
                                <small><%= alumno.getCelular() %></small>
                            </span>
                        </label>
                        <%
                                }
                            } else {
                        %>
                        <p>No hay alumnos disponibles para inscribir en esta actividad.</p>
                        <%
                            }
                        %>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn activity-primary-btn modal-save-btn">Agregar seleccionados</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Pasar asistencia -->
<div class="modal fade" id="modalAsistencia" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content custom-modal">
            <form method="post" action="<%= request.getContextPath() %>/registrar-asistencia">
                <div class="modal-header">
                    <h5 class="modal-title">Pasar asistencia</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="idActividad"
                           value="<%= actividadSeleccionada != null ? actividadSeleccionada.getIdActividad() : 0 %>">

                    <div class="form-group">
                        <label for="attendanceDate">Fecha</label>
                        <input type="date" id="attendanceDate" name="fechaAsistencia" class="form-control" required>
                        <div id="attendanceExistingNotice" class="attendance-existing-notice hidden">
                            <i class="bi bi-info-circle"></i>
                            <div>
                                <strong>Esta asistencia ya fue registrada.</strong>
                                <span>Puedes modificar los alumnos marcados y guardar los cambios.</span>
                            </div>
                        </div>
                    </div>

                    <div class="attendance-list mt-3">
                        <%
                            if (alumnosInscritos != null && !alumnosInscritos.isEmpty()) {
                                for (AlumnoInscritoActividad alumno : alumnosInscritos) {
                        %>
                        <label class="attendance-item">
                            <input type="checkbox" name="idsPresentes" value="<%= alumno.getIdAlumno() %>">
                            <span>
                                <strong><%= alumno.getNombreCompleto() %></strong><br>
                                <small><%= alumno.getCelular() %></small>
                            </span>
                        </label>
                        <%
                                }
                            } else {
                        %>
                        <p>No hay alumnos inscritos en esta actividad.</p>
                        <%
                            }
                        %>
                    </div>

                    <p class="modal-note mt-3">
                        Los alumnos marcados se registrarán como asistentes. Los no marcados se guardarán como ausentes.
                    </p>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn activity-primary-btn modal-save-btn">Guardar asistencia</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Detalle rápido de alumno -->
<div class="modal fade" id="modalAlumnoDetalle" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content custom-modal">
            <div class="modal-header">
                <h5 class="modal-title">Detalle del alumno</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="student-quick-view">
                    <div class="student-avatar-large">CG</div>

                    <div class="student-quick-info">
                        <h4>Carla Gómez</h4>
                        <p><strong>Teléfono:</strong> 999 123 4567</p>
                        <p><strong>Actividad:</strong> Manualidades</p>
                        <p><strong>Asistencias del mes:</strong> 8</p>
                        <p><strong>Estado:</strong> Activa en el taller</p>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cerrar</button>
                <button type="button" class="btn activity-primary-btn modal-save-btn">Ir a Alumnos</button>
            </div>
        </div>
    </div>
</div>

            <div id="cdcMiniModal" class="cdc-mini-modal oculto">
    <div class="cdc-mini-card">
        <button type="button" class="cdc-mini-close" id="cdcMiniClose">×</button>

        <div class="cdc-mini-icon" id="cdcMiniIcon">
            !
        </div>

        <div class="cdc-mini-content">
            <h3 id="cdcMiniTitle">Revisa la información</h3>
            <p id="cdcMiniMessage">Hay un dato inválido.</p>
        </div>

        <div class="cdc-mini-actions">
            <button type="button" class="cdc-mini-btn cdc-mini-btn-secondary oculto" id="cdcMiniCancel">
                Cancelar
            </button>

            <button type="button" class="cdc-mini-btn cdc-mini-btn-danger oculto" id="cdcMiniConfirm">
                Confirmar
            </button>

            <button type="button" class="cdc-mini-btn" id="cdcMiniOk">
                Entendido
            </button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
<script src="<%= request.getContextPath() %>/js/actividades.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>