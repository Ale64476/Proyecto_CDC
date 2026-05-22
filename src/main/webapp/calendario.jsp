<%@ page import="java.util.List" %>
<%@ page import="com.cdc.model.CalendarioActividad" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<CalendarioActividad> actividadesCalendario =
            (List<CalendarioActividad>) request.getAttribute("actividadesCalendario");
    String diaActual = (String) request.getAttribute("diaActual");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendario completo - CDC Plan Chac</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/calendario.css?v=<%= System.currentTimeMillis() %>">
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
            <div class="topbar-left topbar-left-calendar">
                <a href="<%= request.getContextPath() %>/dashboard" class="back-link">
                    <i class="bi bi-arrow-left"></i>
                    <span>Volver</span>
                </a>

                <div>
                    <h1 class="page-title">Calendario completo</h1>
                    <p class="page-subtitle">Horario semanal del centro comunitario</p>
                </div>
            </div>
        </header>

        <main class="content">
            <section class="calendar-full-card">
                <div class="calendar-week-grid">
                    <div class="calendar-day-panel">
                        <div class="calendar-day-header <%= "Lunes".equalsIgnoreCase(diaActual) ? "today" : "" %>">Lunes</div>
                        <div class="calendar-day-body">
                            <%
                                if (actividadesCalendario != null) {
                                    for (CalendarioActividad item : actividadesCalendario) {
                                        if ("Lunes".equalsIgnoreCase(item.getDiaSemana())) {
                            %>
                            <article class="calendar-event-card <%= "Inactiva".equalsIgnoreCase(item.getEstadoActividad()) ? "inactive" : "" %>">
                                <div class="calendar-event-time">
                                    <%= item.getHoraInicio() != null ? item.getHoraInicio().toString().substring(0, 5) : "--:--" %>
                                    -
                                    <%= item.getHoraFin() != null ? item.getHoraFin().toString().substring(0, 5) : "--:--" %>
                                </div>
                                <h4><%= item.getNombreActividad() %></h4>
                                <p><%= item.getNombreInstructor() %></p>
                            </article>
                            <%
                                        }
                                    }
                                }
                            %>
                        </div>
                    </div>

                    <div class="calendar-day-panel">
                        <div class="calendar-day-header <%= "Martes".equalsIgnoreCase(diaActual) ? "today" : "" %>">Martes</div>
                        <div class="calendar-day-body">
                            <%
                                if (actividadesCalendario != null) {
                                    for (CalendarioActividad item : actividadesCalendario) {
                                        if ("Martes".equalsIgnoreCase(item.getDiaSemana())) {
                            %>
                            <article class="calendar-event-card <%= "Inactiva".equalsIgnoreCase(item.getEstadoActividad()) ? "inactive" : "" %>">
                                <div class="calendar-event-time">
                                    <%= item.getHoraInicio() != null ? item.getHoraInicio().toString().substring(0, 5) : "--:--" %>
                                    -
                                    <%= item.getHoraFin() != null ? item.getHoraFin().toString().substring(0, 5) : "--:--" %>
                                </div>
                                <h4><%= item.getNombreActividad() %></h4>
                                <p><%= item.getNombreInstructor() %></p>
                            </article>
                            <%
                                        }
                                    }
                                }
                            %>
                        </div>
                    </div>

                    <div class="calendar-day-panel">
                        <div class="calendar-day-header <%= "Miércoles".equalsIgnoreCase(diaActual) ? "today" : "" %>">Miércoles</div>
                        <div class="calendar-day-body">
                            <%
                                if (actividadesCalendario != null) {
                                    for (CalendarioActividad item : actividadesCalendario) {
                                        if ("Miércoles".equalsIgnoreCase(item.getDiaSemana())) {
                            %>
                            <article class="calendar-event-card <%= "Inactiva".equalsIgnoreCase(item.getEstadoActividad()) ? "inactive" : "" %>">
                                <div class="calendar-event-time">
                                    <%= item.getHoraInicio() != null ? item.getHoraInicio().toString().substring(0, 5) : "--:--" %>
                                    -
                                    <%= item.getHoraFin() != null ? item.getHoraFin().toString().substring(0, 5) : "--:--" %>
                                </div>
                                <h4><%= item.getNombreActividad() %></h4>
                                <p><%= item.getNombreInstructor() %></p>
                            </article>
                            <%
                                        }
                                    }
                                }
                            %>
                        </div>
                    </div>

                    <div class="calendar-day-panel">
                        <div class="calendar-day-header <%= "Jueves".equalsIgnoreCase(diaActual) ? "today" : "" %>">Jueves</div>
                        <div class="calendar-day-body">
                            <%
                                if (actividadesCalendario != null) {
                                    for (CalendarioActividad item : actividadesCalendario) {
                                        if ("Jueves".equalsIgnoreCase(item.getDiaSemana())) {
                            %>
                            <article class="calendar-event-card <%= "Inactiva".equalsIgnoreCase(item.getEstadoActividad()) ? "inactive" : "" %>">
                                <div class="calendar-event-time">
                                    <%= item.getHoraInicio() != null ? item.getHoraInicio().toString().substring(0, 5) : "--:--" %>
                                    -
                                    <%= item.getHoraFin() != null ? item.getHoraFin().toString().substring(0, 5) : "--:--" %>
                                </div>
                                <h4><%= item.getNombreActividad() %></h4>
                                <p><%= item.getNombreInstructor() %></p>
                            </article>
                            <%
                                        }
                                    }
                                }
                            %>
                        </div>
                    </div>

                    <div class="calendar-day-panel">
                        <div class="calendar-day-header <%= "Viernes".equalsIgnoreCase(diaActual) ? "today" : "" %>">Viernes</div>
                        <div class="calendar-day-body">
                            <%
                                if (actividadesCalendario != null) {
                                    for (CalendarioActividad item : actividadesCalendario) {
                                        if ("Viernes".equalsIgnoreCase(item.getDiaSemana())) {
                            %>
                            <article class="calendar-event-card <%= "Inactiva".equalsIgnoreCase(item.getEstadoActividad()) ? "inactive" : "" %>">
                                <div class="calendar-event-time">
                                    <%= item.getHoraInicio() != null ? item.getHoraInicio().toString().substring(0, 5) : "--:--" %>
                                    -
                                    <%= item.getHoraFin() != null ? item.getHoraFin().toString().substring(0, 5) : "--:--" %>
                                </div>
                                <h4><%= item.getNombreActividad() %></h4>
                                <p><%= item.getNombreInstructor() %></p>
                            </article>
                            <%
                                        }
                                    }
                                }
                            %>
                        </div>
                    </div>

                    <div class="calendar-day-panel">
                        <div class="calendar-day-header <%= "Sábado".equalsIgnoreCase(diaActual) ? "today" : "" %>">Sábado</div>
                        <div class="calendar-day-body">
                            <%
                                if (actividadesCalendario != null) {
                                    for (CalendarioActividad item : actividadesCalendario) {
                                        if ("Sábado".equalsIgnoreCase(item.getDiaSemana())) {
                            %>
                            <article class="calendar-event-card <%= "Inactiva".equalsIgnoreCase(item.getEstadoActividad()) ? "inactive" : "" %>">
                                <div class="calendar-event-time">
                                    <%= item.getHoraInicio() != null ? item.getHoraInicio().toString().substring(0, 5) : "--:--" %>
                                    -
                                    <%= item.getHoraFin() != null ? item.getHoraFin().toString().substring(0, 5) : "--:--" %>
                                </div>
                                <h4><%= item.getNombreActividad() %></h4>
                                <p><%= item.getNombreInstructor() %></p>
                            </article>
                            <%
                                        }
                                    }
                                }
                            %>
                        </div>
                    </div>
                </div>
            </section>
        </main>
    </div>
</div>

<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>