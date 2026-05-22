<%@ page import="java.util.List" %>
<%@ page import="com.cdc.model.DashboardResumen" %>
<%@ page import="com.cdc.model.ActividadProxima" %>
<%@ page import="com.cdc.model.Aviso" %>
<%@ page import="com.cdc.model.CalendarioActividad" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    DashboardResumen resumenDashboard = (DashboardResumen) request.getAttribute("resumenDashboard");
    List<ActividadProxima> proximasActividades =
            (List<ActividadProxima>) request.getAttribute("proximasActividades");
    List<Aviso> avisosDashboard =
            (List<Aviso>) request.getAttribute("avisosDashboard");
    List<CalendarioActividad> actividadesCalendario =
            (List<CalendarioActividad>) request.getAttribute("actividadesCalendario");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CDC Plan Chac</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS propio -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css?v=<%= System.currentTimeMillis() %>">
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
            <a href="<%= request.getContextPath() %>/dashboard" class="nav-item active">
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
                    <h1 class="page-title">Dashboard</h1>
                    <p class="page-subtitle">Centro comunitario Plan Chac</p>
                </div>
            </div>

            <div class="topbar-right">
                <span class="date-chip" id="currentDate">--/--/----</span>
            </div>
        </header>

        <main class="content">
            <section class="stats-grid">
                <article class="metric-card">
                    <div class="metric-icon">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <div>
                        <p class="metric-label">Alumnos registrados</p>
                        <h2 class="metric-value">
                            <%= resumenDashboard != null ? resumenDashboard.getTotalAlumnosRegistrados() : 0 %>
                        </h2>
                    </div>
                </article>

                <article class="metric-card">
                    <div class="metric-icon">
                        <i class="bi bi-journal-richtext"></i>
                    </div>
                    <div>
                        <p class="metric-label">Talleres activos</p>
                        <h2 class="metric-value">
                            <%= resumenDashboard != null ? resumenDashboard.getTotalActividadesActivas() : 0 %>
                        </h2>
                    </div>
                </article>

                <article class="metric-card">
                    <div class="metric-icon">
                        <i class="bi bi-calendar-check-fill"></i>
                    </div>
                    <div>
                        <p class="metric-label">Talleres de hoy</p>
                        <h2 class="metric-value">
                            <%= resumenDashboard != null ? resumenDashboard.getActividadesDeHoy() : 0 %>
                        </h2>
                    </div>
                </article>

                <article class="metric-card">
                    <div class="metric-icon">
                        <i class="bi bi-person-check-fill"></i>
                    </div>
                    <div>
                        <p class="metric-label">Asistencias hoy</p>
                        <h2 class="metric-value">
                            <%= resumenDashboard != null ? resumenDashboard.getAsistenciasRegistradasHoy() : 0 %>
                        </h2>
                    </div>
                </article>
            </section>

            <section class="dashboard-grid">
                <article class="panel-card">
                    <div class="panel-header">
                        <h3>Calendario resumido</h3>
                        <a href="<%= request.getContextPath() %>/calendario" class="calendar-link">Ver completo</a>
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
                            <div class="slot active"><%= item.getNombreActividad() %></div>
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
                            <div class="slot active"><%= item.getNombreActividad() %></div>
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
                            <div class="slot active"><%= item.getNombreActividad() %></div>
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
                            <div class="slot active"><%= item.getNombreActividad() %></div>
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
                            <div class="slot active"><%= item.getNombreActividad() %></div>
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
                </article>

                <article class="panel-card">
                    <div class="panel-header">
                        <h3>Talleres de hoy</h3>
                    </div>

                    <ul class="activity-list">
                    <%
                        if (proximasActividades != null && !proximasActividades.isEmpty()) {
                            java.time.LocalTime horaActual = java.time.LocalTime.now();

                            for (ActividadProxima actividad : proximasActividades) {
                                java.time.LocalTime inicio = actividad.getHoraInicio() != null
                                        ? actividad.getHoraInicio().toLocalTime()
                                        : null;
                                java.time.LocalTime fin = actividad.getHoraFin() != null
                                        ? actividad.getHoraFin().toLocalTime()
                                        : null;

                                String estadoActividad = "Próxima";
                                String claseEstadoActividad = "status-upcoming";

                                if (inicio != null && fin != null) {
                                    if (!horaActual.isBefore(inicio) && !horaActual.isAfter(fin)) {
                                        estadoActividad = "En curso";
                                        claseEstadoActividad = "status-current";
                                    } else if (horaActual.isAfter(fin)) {
                                        estadoActividad = "Finalizada";
                                        claseEstadoActividad = "status-finished";
                                    }
                                }
                    %>
                        <li class="activity-list-item">
                            <span class="activity-time">
                                <%= actividad.getHoraInicio() != null ? actividad.getHoraInicio().toString().substring(0,5) : "--:--" %>
                            </span>

                            <div class="activity-main-info">
                                <strong><%= actividad.getNombreActividad() %></strong>
                                <small><%= actividad.getDiaSemana() %> · <%= actividad.getInstructor() %></small>
                            </div>

                            <span class="activity-state-badge <%= claseEstadoActividad %>">
                                <%= estadoActividad %>
                            </span>
                        </li>
                    <%
                            }
                        } else {
                    %>
                        <li class="activity-list-item">
                            <span class="activity-time">--:--</span>
                            <div class="activity-main-info">
                                <strong>Sin talleres programadas hoy</strong>
                                <small>No hay registros para el día actual</small>
                            </div>
                        </li>
                    <%
                        }
                    %>
                    </ul>
                </article>

                <article class="panel-card">
                    <div class="panel-header">
                        <h3>Accesos rápidos</h3>
                    </div>

                    <div class="quick-actions">
                        <button class="quick-btn">
                            <i class="bi bi-person-plus-fill"></i>
                            <span>Registrar alumno</span>
                        </button>

                        <button class="quick-btn">
                            <i class="bi bi-calendar-plus-fill"></i>
                            <span>Crear taller</span>
                        </button>

                        <button class="quick-btn">
                            <i class="bi bi-check2-square"></i>
                            <span>Pasar asistencia</span>
                        </button>

                        <button class="quick-btn">
                            <i class="bi bi-box-arrow-up-right"></i>
                            <span>Ver reportes</span>
                        </button>
                    </div>
                </article>

                <section class="panel-card">
                    <div class="panel-header">
                        <h3>Respaldo de base de datos</h3>
                    </div>

                    <div class="backup-panel">
                        <div class="backup-info">
                            <i class="fa-solid fa-database"></i>
                            <div>
                                <strong>Backup del sistema</strong>
                                <p>Descarga una copia de seguridad en formato SQL de la base de datos centrocomunitario.</p>
                            </div>
                        </div>

                        <a href="<%= request.getContextPath() %>/descargar-backup" class="backup-btn">
                            <i class="fa-solid fa-download"></i>
                            Descargar backup
                        </a>

                        <form action="<%= request.getContextPath() %>/importar-backup"
                            method="post"
                            enctype="multipart/form-data"
                            class="backup-import-form"
                            onsubmit="return confirm('Esta acción restaurará la base de datos usando el archivo seleccionado. Se recomienda descargar un backup antes de continuar. ¿Deseas continuar?');">

                            <label for="archivoBackup" class="backup-file-label">
                                <i class="fa-solid fa-file-import"></i>
                                Importar backup SQL
                            </label>

                            <input type="file"
                                id="archivoBackup"
                                name="archivoBackup"
                                accept=".sql"
                                required>

                            <button type="submit" class="backup-btn backup-btn-secondary">
                                <i class="fa-solid fa-upload"></i>
                                Restaurar backup
                            </button>
                        </form>

                        <p class="backup-note">
                            Recomendado antes de hacer cambios importantes o antes de restaurar información.
                        </p>
                    </div>
                </section>
            </section>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>