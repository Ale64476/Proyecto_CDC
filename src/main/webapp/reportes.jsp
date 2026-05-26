<%@ page import="java.util.List" %>
<%@ page import="com.cdc.model.ReporteAlumno" %>
<%@ page import="com.cdc.model.ReporteActividad" %>
<%@ page import="com.cdc.model.ReporteAlumnoActividad" %>
<%@ page import="com.cdc.model.ReporteAsistenciaActividad" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String tipoReporteSeleccionado = (String) request.getAttribute("tipoReporteSeleccionado");
    if (tipoReporteSeleccionado == null || tipoReporteSeleccionado.isBlank()) {
        tipoReporteSeleccionado = "alumnos";
    }
    String estadoAlumnoSeleccionado = (String) request.getAttribute("estadoAlumnoSeleccionado");
    String estadoTallerSeleccionado = (String) request.getAttribute("estadoTallerSeleccionado");
    String idActividadSeleccionada = (String) request.getAttribute("idActividadSeleccionada");
    String fechaInicioSeleccionada = (String) request.getAttribute("fechaInicioSeleccionada");
    String fechaFinSeleccionada = (String) request.getAttribute("fechaFinSeleccionada");

    String nombreTipoReporte = (String) request.getAttribute("nombreTipoReporte");
    Integer totalRegistrosReporte = (Integer) request.getAttribute("totalRegistrosReporte");

    List<ReporteAlumno> reporteAlumnos =
            (List<ReporteAlumno>) request.getAttribute("reporteAlumnos");
    List<ReporteActividad> reporteActividades =
            (List<ReporteActividad>) request.getAttribute("reporteActividades");
    List<ReporteAlumnoActividad> reporteAlumnosActividad =
            (List<ReporteAlumnoActividad>) request.getAttribute("reporteAlumnosActividad");
    List<ReporteAsistenciaActividad> reporteAsistencia =
            (List<ReporteAsistenciaActividad>) request.getAttribute("reporteAsistencia");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes - CDC Plan Chac</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS global -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css?v=<%= System.currentTimeMillis() %>">
    <!-- CSS compartido -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/talleres.css?v=<%= System.currentTimeMillis() %>">
    <!-- CSS de reportes -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reportes.css?v=<%= System.currentTimeMillis() %>">
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

            <a href="<%= request.getContextPath() %>/talleres" class="nav-item">
                <i class="bi bi-calendar3"></i>
                <span class="nav-label">Talleres</span>
            </a>

            <a href="<%= request.getContextPath() %>/alumnos" class="nav-item">
                <i class="bi bi-people-fill"></i>
                <span class="nav-label">Alumnos</span>
            </a>

            <a href="<%= request.getContextPath() %>/instructores" class="nav-item">
                <i class="bi bi-person-badge-fill"></i>
                <span class="nav-label">Instructores</span>
            </a>

            <a href="<%= request.getContextPath() %>/eventos" class="nav-item">
                <i class="bi bi-megaphone-fill"></i>
                <span class="nav-label">Eventos</span>
            </a>
            
            <a href="<%= request.getContextPath() %>/reportes" class="nav-item active">
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
                    <h1 class="page-title">Reportes</h1>
                    <p class="page-subtitle">Consulta y exporta información del centro comunitario</p>
                </div>
            </div>

            <div class="topbar-right">
                <button class="activity-primary-btn" type="button" id="exportExcelBtn">
                    <i class="bi bi-file-earmark-excel-fill"></i>
                    <span>Exportar a Excel</span>
                </button>
            </div>
        </header>

        <main class="content">
            <!-- Configuración -->
            <section class="report-config-card">
                <form method="get" action="<%= request.getContextPath() %>/reportes">
                <div class="section-header">
                    <h3>Configuración del reporte</h3>
                </div>

                <div class="report-config-grid">
                    <div class="form-group">
                        <label for="reportType">Tipo de reporte</label>
                        <select id="reportType" name="tipo" class="form-select">
                            <option value="alumnos" <%= "alumnos".equals(tipoReporteSeleccionado) ? "selected" : "" %>>Alumnos del centro</option>
                            <option value="actividades" <%= "actividades".equals(tipoReporteSeleccionado) ? "selected" : "" %>>Talleres disponibles</option>
                            <option value="alumnos_por_actividad" <%= "alumnos_por_actividad".equals(tipoReporteSeleccionado) ? "selected" : "" %>>Alumnos por taller</option>
                            <option value="asistencia_por_actividad" <%= "asistencia_por_actividad".equals(tipoReporteSeleccionado) ? "selected" : "" %>>Asistencia por taller</option>
                        </select>
                    </div>

                    <div class="form-group dynamic-filter filter-activity-select hidden-filter">
                        <label for="activityReportSelect">Taller</label>
                        <select id="activityReportSelect" name="idActividad" class="form-select">
                        <option value="" <%= idActividadSeleccionada == null || idActividadSeleccionada.isBlank() ? "selected" : "" %>>Todos los talleres</option>
                        <option value="1" <%= "1".equals(idActividadSeleccionada) ? "selected" : "" %>>Manualidades</option>
                        <option value="2" <%= "2".equals(idActividadSeleccionada) ? "selected" : "" %>>Boxeo</option>
                        <option value="3" <%= "3".equals(idActividadSeleccionada) ? "selected" : "" %>>Computación</option>
                        <option value="4" <%= "4".equals(idActividadSeleccionada) ? "selected" : "" %>>Música</option>
                        <option value="5" <%= "5".equals(idActividadSeleccionada) ? "selected" : "" %>>Corte de cabello</option>
                    </select>
                    </div>

                    <div class="form-group dynamic-filter filter-student-status hidden-filter">
                        <label for="studentStatusReport">Estado del alumno</label>
                        <select id="studentStatusReport" name="estadoAlumno" class="form-select">
                            <option value="" <%= estadoAlumnoSeleccionado == null || estadoAlumnoSeleccionado.isBlank() ? "selected" : "" %>>Todos</option>
                            <option value="Activo" <%= "Activo".equals(estadoAlumnoSeleccionado) ? "selected" : "" %>>Activo</option>
                            <option value="Inactivo" <%= "Inactivo".equals(estadoAlumnoSeleccionado) ? "selected" : "" %>>Inactivo</option>
                            <option value="Baja" <%= "Baja".equals(estadoAlumnoSeleccionado) ? "selected" : "" %>>Baja</option>
                        </select>
                    </div>

                    <div class="form-group dynamic-filter filter-activity-status hidden-filter">
                        <label for="activityStatusReport">Estado de taller</label>
                        <select id="activityStatusReport" name="estadoTaller" class="form-select">
                            <option value="" <%= estadoTallerSeleccionado == null || estadoTallerSeleccionado.isBlank() ? "selected" : "" %>>Todos</option>
                            <option value="Activa" <%= "Activa".equals(estadoTallerSeleccionado) ? "selected" : "" %>>Activo</option>
                            <option value="Inactiva" <%= "Inactiva".equals(estadoTallerSeleccionado) ? "selected" : "" %>>Inactivo</option>

                        </select>
                    </div>

                    <div class="form-group dynamic-filter filter-activity-select hidden-filter">
                        <label for="activityReportSelect">Taller</label>
                        <select id="activityReportSelect" name="idActividad" class="form-select">
                        <option value="" <%= idActividadSeleccionada == null || idActividadSeleccionada.isBlank() ? "selected" : "" %>>Todos los talleres</option>
                        <option value="1" <%= "1".equals(idActividadSeleccionada) ? "selected" : "" %>>Manualidades</option>
                        <option value="2" <%= "2".equals(idActividadSeleccionada) ? "selected" : "" %>>Boxeo</option>
                        <option value="3" <%= "3".equals(idActividadSeleccionada) ? "selected" : "" %>>Computación</option>
                        <option value="4" <%= "4".equals(idActividadSeleccionada) ? "selected" : "" %>>Música</option>
                        <option value="5" <%= "5".equals(idActividadSeleccionada) ? "selected" : "" %>>Corte de cabello</option>
                    </select>
                    </div>


                    <div class="form-group dynamic-filter filter-date-from hidden-filter">
                        <label for="reportDateFrom">Fecha desde</label>
                        <input type="date" id="reportDateFrom" name="fechaInicio" class="form-control" value="<%= fechaInicioSeleccionada != null ? fechaInicioSeleccionada : "" %>">
                    </div>

                    <div class="form-group dynamic-filter filter-date-to hidden-filter">
                        <label for="reportDateTo">Fecha hasta</label>
                        <input type="date" id="reportDateTo" name="fechaFin" class="form-control" value="<%= fechaFinSeleccionada != null ? fechaFinSeleccionada : "" %>">
                    </div>


                </div>

                <div class="report-actions">
                    <button type="button" class="action-btn secondary" id="clearFiltersBtn" onclick="window.location.href='<%= request.getContextPath() %>/reportes'">
                        <i class="bi bi-eraser"></i>
                        <span>Limpiar filtros</span>
                    </button>

                    <button type="submit" class="action-btn primary" id="generatePreviewBtn">
                        <i class="bi bi-search"></i>
                        <span>Generar vista previa</span>
                    </button>
                </div>
                </form>
            </section>

            <!-- Resumen -->
            <section class="report-summary-grid">
                <article class="report-summary-card">
                    <span class="report-summary-label">Tipo de reporte</span>
                    <strong class="report-summary-value" id="summaryReportType">
                        <%= nombreTipoReporte != null ? nombreTipoReporte : "Reporte de alumnos" %>
                    </strong>
                </article>

                <article class="report-summary-card">
                    <span class="report-summary-label">Registros encontrados</span>
                    <strong class="report-summary-value" id="summaryRecords">
                        <%= totalRegistrosReporte != null ? totalRegistrosReporte : 0 %>
                    </strong>
                </article>

                <article class="report-summary-card">
                    <span class="report-summary-label">Filtros aplicados</span>
                    <strong class="report-summary-value" id="summaryFilters">1</strong>
                </article>
            </section>

            <!-- Vista previa -->
            <section class="report-preview-card">
                <div class="section-header">
                    <h3>Vista previa</h3>
                </div>

                <div class="report-preview-table-wrapper">
                    <!-- alumnos -->
                    <table class="report-preview-table preview-table <%= "alumnos".equals(tipoReporteSeleccionado) ? "active-preview" : "" %>" id="previewAlumnos">
                        <thead>
                        <tr>
                            <th>Nombre</th>
                            <th>Fecha de nacimiento</th>
                            <th>CURP</th>
                            <th>Domicilio</th>
                            <th>Celular</th>
                            <th>Estado</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (reporteAlumnos != null && !reporteAlumnos.isEmpty()) {
                                for (ReporteAlumno item : reporteAlumnos) {
                        %>
                        <tr>
                            <td><%= item.getNombreCompleto() %></td>
                            <td><%= item.getFechaNacimiento() %></td>
                            <td><%= item.getCurp() %></td>
                            <td><%= item.getDomicilio() %></td>
                            <td><%= item.getCelular() %></td>
                            <td><%= item.getEstadoAlumno() %></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="6">No hay datos disponibles.</td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>

                    <!-- Talleres -->
                    <table class="report-preview-table preview-table <%= "actividades".equals(tipoReporteSeleccionado) ? "active-preview" : "" %>" id="previewActividades">
                        <thead>
                        <tr>
                            <th>Taller</th>
                            <th>Instructor</th>
                            <th>Horarios</th>
                            <th>Inscritos</th>
                            <th>Estado</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (reporteActividades != null && !reporteActividades.isEmpty()) {
                                for (ReporteActividad item : reporteActividades) {
                        %>
                        <tr>
                            <td><%= item.getNombreActividad() %></td>
                            <td><%= item.getInstructor() %></td>
                            <td><%= item.getHorarios() %></td>
                            <td><%= item.getCantidadInscritos() %></td>
                            <td><%= item.getEstadoActividad() %></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="5">No hay datos disponibles.</td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>

                    <!-- alumnos por Taller -->
                    <table class="report-preview-table preview-table <%= "alumnos_por_actividad".equals(tipoReporteSeleccionado) ? "active-preview" : "" %>" id="previewAlumnosActividad">
                        <thead>
                        <tr>
                            <th>Alumno</th>
                            <th>Celular</th>
                            <th>Taller</th>
                            <th>Instructor</th>
                            <th>Asistencias del mes</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (reporteAlumnosActividad != null && !reporteAlumnosActividad.isEmpty()) {
                                for (ReporteAlumnoActividad item : reporteAlumnosActividad) {
                        %>
                        <tr>
                            <td><%= item.getNombreAlumno() %></td>
                            <td><%= item.getCelular() %></td>
                            <td><%= item.getNombreActividad() %></td>
                            <td><%= item.getInstructor() %></td>
                            <td><%= item.getAsistenciasDelMes() %></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="5">No hay datos disponibles.</td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>

                    <!-- asistencia por Taller -->
                    <table class="report-preview-table preview-table <%= "asistencia_por_actividad".equals(tipoReporteSeleccionado) ? "active-preview" : "" %>" id="previewAsistenciaActividad">
                        <thead>
                        <tr>
                            <th>Alumno</th>
                            <th>Taller</th>
                            <th>Fecha</th>
                            <th>Asistencia</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (reporteAsistencia != null && !reporteAsistencia.isEmpty()) {
                                for (ReporteAsistenciaActividad item : reporteAsistencia) {
                        %>
                        <tr>
                            <td><%= item.getNombreAlumno() %></td>
                            <td><%= item.getNombreActividad() %></td>
                            <td><%= item.getFechaAsistencia() %></td>
                            <td><%= item.isAsistio() ? "Asistió" : "Ausente" %></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="4">No hay datos disponibles.</td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
<script src="<%= request.getContextPath() %>/js/reportes.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>