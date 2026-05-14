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
                            <option value="alumnos" <%= "alumnos".equals(tipoReporteSeleccionado) ? "selected" : "" %>>Reporte de alumnos</option>
                            <option value="actividades" <%= "actividades".equals(tipoReporteSeleccionado) ? "selected" : "" %>>Reporte de talleres</option>
                            <option value="alumnos_por_actividad" <%= "alumnos_por_actividad".equals(tipoReporteSeleccionado) ? "selected" : "" %>>Alumnos por taller</option>
                            <option value="asistencia_por_actividad" <%= "asistencia_por_actividad".equals(tipoReporteSeleccionado) ? "selected" : "" %>>Asistencia por taller</option>
                        </select>
                    </div>

                    <div class="form-group dynamic-filter filter-student-status">
                        <label for="studentStatusReport">Estado</label>
                        <select id="studentStatusReport" class="form-select">
                            <option value="todos">Todos</option>
                            <option value="activos">Activos</option>
                            <option value="inactivos">Inactivos</option>
                        </select>
                    </div>

                    <div class="form-group dynamic-filter filter-activity-status hidden-filter">
                        <label for="activityStatusReport">Estado</label>
                        <select id="activityStatusReport" class="form-select">
                            <option value="todas">Todas</option>
                            <option value="activas">Activas</option>
                            <option value="inactivas">Inactivas</option>
                        </select>
                    </div>

                    <div class="form-group dynamic-filter filter-activity-select hidden-filter">
                        <label for="activityReportSelect">Taller</label>
                        <select id="activityReportSelect" class="form-select">
                            <option value="manualidades">Manualidades</option>
                            <option value="boxeo">Boxeo</option>
                            <option value="computacion">Computación</option>
                            <option value="musica">Música</option>
                        </select>
                    </div>

                    <div class="form-group dynamic-filter filter-instructor hidden-filter">
                        <label for="instructorReportSelect">Instructor</label>
                        <select id="instructorReportSelect" class="form-select">
                            <option value="todos">Todos</option>
                            <option value="ana_lopez">Ana López</option>
                            <option value="carlos_hernandez">Carlos Hernández</option>
                            <option value="diego_ramirez">Diego Ramírez</option>
                            <option value="luis_morales">Luis Morales</option>
                        </select>
                    </div>

                    <div class="form-group dynamic-filter filter-date-from hidden-filter">
                        <label for="reportDateFrom">Fecha desde</label>
                        <input type="date" id="reportDateFrom" class="form-control">
                    </div>

                    <div class="form-group dynamic-filter filter-date-to hidden-filter">
                        <label for="reportDateTo">Fecha hasta</label>
                        <input type="date" id="reportDateTo" class="form-control">
                    </div>

                    <div class="form-group dynamic-filter filter-search-student">
                        <label for="reportStudentSearch">Buscar alumno</label>
                        <input type="text" id="reportStudentSearch" class="form-control" placeholder="Ej. Carla Gómez">
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