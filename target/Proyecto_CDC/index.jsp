<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            <a href="<%= request.getContextPath() %>/index.jsp" class="nav-item active">
                <i class="bi bi-grid-1x2-fill"></i>
                <span class="nav-label">Dashboard</span>
            </a>

            <a href="#" class="nav-item">
                <i class="bi bi-calendar3"></i>
                <span class="nav-label">Actividades</span>
            </a>

            <a href="#" class="nav-item">
                <i class="bi bi-people-fill"></i>
                <span class="nav-label">Alumnos</span>
            </a>

            <a href="#" class="nav-item">
                <i class="bi bi-file-earmark-bar-graph-fill"></i>
                <span class="nav-label">Reportes</span>
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
                        <h2 class="metric-value">150</h2>
                    </div>
                </article>

                <article class="metric-card">
                    <div class="metric-icon">
                        <i class="bi bi-journal-richtext"></i>
                    </div>
                    <div>
                        <p class="metric-label">Talleres activos</p>
                        <h2 class="metric-value">20</h2>
                    </div>
                </article>

                <article class="metric-card">
                    <div class="metric-icon">
                        <i class="bi bi-calendar-check-fill"></i>
                    </div>
                    <div>
                        <p class="metric-label">Actividades de hoy</p>
                        <h2 class="metric-value">3</h2>
                    </div>
                </article>

                <article class="metric-card">
                    <div class="metric-icon">
                        <i class="bi bi-person-check-fill"></i>
                    </div>
                    <div>
                        <p class="metric-label">Asistencias hoy</p>
                        <h2 class="metric-value">48</h2>
                    </div>
                </article>
            </section>

            <section class="dashboard-grid">
                <article class="panel-card">
                    <div class="panel-header">
                        <h3>Calendario resumido</h3>
                        <a href="#" class="panel-link">Ver completo</a>
                    </div>

                    <div class="mini-calendar">
                        <div class="day-column">
                            <span class="day-name">Lun</span>
                            <div class="slot empty"></div>
                            <div class="slot active">Arte</div>
                            <div class="slot empty"></div>
                        </div>

                        <div class="day-column">
                            <span class="day-name">Mar</span>
                            <div class="slot active">Música</div>
                            <div class="slot empty"></div>
                            <div class="slot active">Computación</div>
                        </div>

                        <div class="day-column">
                            <span class="day-name">Mié</span>
                            <div class="slot empty"></div>
                            <div class="slot active">Boxeo</div>
                            <div class="slot empty"></div>
                        </div>

                        <div class="day-column">
                            <span class="day-name">Jue</span>
                            <div class="slot active">Pintura</div>
                            <div class="slot empty"></div>
                            <div class="slot empty"></div>
                        </div>

                        <div class="day-column">
                            <span class="day-name">Vie</span>
                            <div class="slot empty"></div>
                            <div class="slot active">Danza</div>
                            <div class="slot active">Lectura</div>
                        </div>
                    </div>
                </article>

                <article class="panel-card">
                    <div class="panel-header">
                        <h3>Próximas actividades</h3>
                    </div>

                    <ul class="activity-list">
                        <li>
                            <span class="activity-time">10:00</span>
                            <div>
                                <strong>Taller de pintura</strong>
                                <small>Sala 1</small>
                            </div>
                        </li>
                        <li>
                            <span class="activity-time">12:00</span>
                            <div>
                                <strong>Curso de computación</strong>
                                <small>Aula digital</small>
                            </div>
                        </li>
                        <li>
                            <span class="activity-time">16:00</span>
                            <div>
                                <strong>Actividad deportiva</strong>
                                <small>Cancha</small>
                            </div>
                        </li>
                        <li>
                            <span class="activity-time">18:00</span>
                            <div>
                                <strong>Reunión comunitaria</strong>
                                <small>Salón principal</small>
                            </div>
                        </li>
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
                            <span>Crear actividad</span>
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

                <article class="panel-card">
                    <div class="panel-header">
                        <h3>Avisos</h3>
                    </div>

                    <ul class="alerts-list">
                        <li class="alert-item warning">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                            <span>Taller de arte con cupo limitado.</span>
                        </li>
                        <li class="alert-item danger">
                            <i class="bi bi-clock-fill"></i>
                            <span>Actividad próxima sin asistencia registrada.</span>
                        </li>
                        <li class="alert-item info">
                            <i class="bi bi-people-fill"></i>
                            <span>Taller de música sin alumnos inscritos.</span>
                        </li>
                    </ul>
                </article>
            </section>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>