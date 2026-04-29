<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actividades - CDC Plan Chac</title>

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
            <a href="<%= request.getContextPath() %>/index.jsp" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span class="nav-label">Dashboard</span>
            </a>

            <a href="<%= request.getContextPath() %>/actividades.jsp" class="nav-item active">
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
                    <h1 class="page-title">Actividades</h1>
                    <p class="page-subtitle">Administra talleres, horarios, alumnos y asistencia</p>
                </div>
            </div>

            <div class="topbar-right">
                <button class="activity-primary-btn" type="button" data-bs-toggle="modal" data-bs-target="#modalNuevaActividad">
                    <i class="bi bi-plus-lg"></i>
                    <span>Nueva actividad</span>
                </button>
            </div>
        </header>

        <main class="content">
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

                <select id="activityOrderSelect" class="toolbar-select">
                    <option value="nombre">Ordenar por nombre</option>
                    <option value="inscritos">Ordenar por inscritos</option>
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
                        <article class="activity-item selected" data-activity-id="1">
                            <div class="activity-item-icon">
                                <i class="bi bi-palette-fill"></i>
                            </div>

                            <div class="activity-item-body">
                                <div class="activity-item-top">
                                    <h4>Manualidades</h4>
                                    <span class="status-badge active">Activa</span>
                                </div>
                                <p class="activity-item-instructor">Instructor: Ana López</p>
                                <p class="activity-item-schedule"> 2 horarios registrados</p>
                                <p class="activity-item-meta">14 inscritos</p>
                            </div>
                        </article>

                        <article class="activity-item" data-activity-id="2">
                            <div class="activity-item-icon">
                                <i class="bi bi-trophy-fill"></i>
                            </div>

                            <div class="activity-item-body">
                                <div class="activity-item-top">
                                    <h4>Boxeo</h4>
                                    <span class="status-badge active">Activa</span>
                                </div>
                                <p class="activity-item-instructor">Instructor: Carlos Hernández</p>
                                <p class="activity-item-schedule"> 2 horarios registrados</p>
                                <p class="activity-item-meta">18 inscritos</p>
                            </div>
                        </article>

                        <article class="activity-item" data-activity-id="3">
                            <div class="activity-item-icon">
                                <i class="bi bi-laptop-fill"></i>
                            </div>

                            <div class="activity-item-body">
                                <div class="activity-item-top">
                                    <h4>Computación</h4>
                                    <span class="status-badge active">Activa</span>
                                </div>
                                <p class="activity-item-instructor">Instructor: Diego Ramírez</p>
                                <p class="activity-item-schedule"> 2 horarios registrados</p>
                                <p class="activity-item-meta">12 inscritos</p>
                            </div>
                        </article>

                        <article class="activity-item" data-activity-id="4">
                            <div class="activity-item-icon">
                                <i class="bi bi-music-note-beamed"></i>
                            </div>

                            <div class="activity-item-body">
                                <div class="activity-item-top">
                                    <h4>Música</h4>
                                    <span class="status-badge active">Activa</span>
                                </div>
                                <p class="activity-item-instructor">Instructor: Luis Morales</p>
                                <p class="activity-item-schedule"> 2 horarios registrados</p>
                                <p class="activity-item-meta">10 inscritos</p>
                            </div>
                        </article>
                    </div>
                </section>

                <!-- Columna derecha -->
                <section class="activities-detail-column">
                    <!-- Detalle de actividad -->
                    <section class="activity-detail-card">
                        <div class="activity-detail-main">
                            <div class="activity-detail-icon">
                                <i class="bi bi-palette-fill"></i>
                            </div>

                            <div class="activity-detail-info">
                                <div class="activity-detail-title-row">
                                    <h2 id="activityDetailName">Manualidades</h2>
                                    <span class="status-badge active" id="activityDetailStatus">Activa</span>
                                </div>

                                <div class="activity-detail-grid">
                                    <div class="detail-item">
                                        <span class="detail-label">Instructor</span>
                                        <span class="detail-value" id="activityDetailInstructor">Ana López</span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Horarios</span>
                                        <span class="detail-value" id="activityDetailSchedule">Lun 10:00 - 12:00 / Mié 16:00 - 18:00</span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Descripción</span>
                                        <span class="detail-value" id="activityDetailDescription">Taller creativo para desarrollar habilidades manuales y expresión artística.</span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Inscritos</span>
                                        <span class="detail-value" id="activityDetailCount">14</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="activity-actions">
                            <button class="action-btn secondary" type="button" data-bs-toggle="modal" data-bs-target="#modalEditarActividad">
                                <i class="bi bi-pencil-square"></i>
                                <span>Editar</span>
                            </button>

                            <button class="action-btn secondary" type="button" data-bs-toggle="modal" data-bs-target="#modalAgregarAlumno">
                                <i class="bi bi-person-plus-fill"></i>
                                <span>Agregar alumno</span>
                            </button>

                            <button class="action-btn primary" type="button" data-bs-toggle="modal" data-bs-target="#modalAsistencia">
                                <i class="bi bi-check2-square"></i>
                                <span>Pasar asistencia</span>
                            </button>

                            <button class="action-btn danger-outline" type="button">
                                <i class="bi bi-pause-circle"></i>
                                <span>Desactivar</span>
                            </button>
                        </div>
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
                                <tr>
                                    <td>Carla Gómez</td>
                                    <td>999 123 4567</td>
                                    <td>8</td>
                                    <td>
                                        <button class="table-icon-btn student-view-btn" title="Ver alumno" data-bs-toggle="modal" data-bs-target="#modalAlumnoDetalle">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>José Pérez</td>
                                    <td>999 234 5678</td>
                                    <td>7</td>
                                    <td>
                                        <button class="table-icon-btn student-view-btn" title="Ver alumno" data-bs-toggle="modal" data-bs-target="#modalAlumnoDetalle">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Andrea Ruiz</td>
                                    <td>999 345 6789</td>
                                    <td>6</td>
                                    <td>
                                        <button class="table-icon-btn student-view-btn" title="Ver alumno" data-bs-toggle="modal" data-bs-target="#modalAlumnoDetalle">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Mateo Chan</td>
                                    <td>999 456 7890</td>
                                    <td>5</td>
                                    <td>
                                        <button class="table-icon-btn student-view-btn" title="Ver alumno" data-bs-toggle="modal" data-bs-target="#modalAlumnoDetalle">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Sofía Castillo</td>
                                    <td>999 567 8901</td>
                                    <td>4</td>
                                    <td>
                                        <button class="table-icon-btn student-view-btn" title="Ver alumno" data-bs-toggle="modal" data-bs-target="#modalAlumnoDetalle">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <!-- Calendario resumido -->
                    <section class="calendar-summary-card">
                        <div class="section-header">
                            <h3>Calendario resumido</h3>
                            <a href="#" class="section-link">Ver calendario completo</a>
                        </div>

                        <div class="calendar-summary-grid">
                            <div class="calendar-day-column">
                                <span class="calendar-day-name">Lun</span>
                                <div class="calendar-chip">10:00 Manualidades</div>
                                <div class="calendar-chip muted">16:00 Computación</div>
                            </div>

                            <div class="calendar-day-column">
                                <span class="calendar-day-name">Mar</span>
                                <div class="calendar-chip">17:00 Boxeo</div>
                            </div>

                            <div class="calendar-day-column">
                                <span class="calendar-day-name">Mié</span>
                                <div class="calendar-chip">16:00 Manualidades</div>
                                <div class="calendar-chip muted">15:00 Música</div>
                            </div>

                            <div class="calendar-day-column">
                                <span class="calendar-day-name">Jue</span>
                                <div class="calendar-chip">17:00 Boxeo</div>
                            </div>

                            <div class="calendar-day-column">
                                <span class="calendar-day-name">Vie</span>
                                <div class="calendar-chip muted">12:00 Computación</div>
                                <div class="calendar-chip muted">15:00 Música</div>
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
            <div class="modal-header">
                <h5 class="modal-title">Nueva actividad</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group full">
                        <label for="activityName">Nombre de la actividad</label>
                        <input type="text" id="activityName" class="form-control" placeholder="Ej. Manualidades">
                    </div>

                    <div class="form-group full">
                        <label for="activityInstructor">Instructor</label>
                        <select id="activityInstructor" class="form-select">
                            <option selected disabled>Selecciona un instructor</option>
                            <option>Ana López</option>
                            <option>Carlos Hernández</option>
                            <option>Diego Ramírez</option>
                        </select>
                    </div>

                    <div class="form-group full">
                        <label for="activityDescription">Descripción (opcional)</label>
                        <textarea id="activityDescription" class="form-control" rows="3" placeholder="Describe brevemente la actividad"></textarea>
                    </div>
                </div>

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
                            <select class="form-select">
                                <option>Lunes</option>
                                <option>Martes</option>
                                <option>Miércoles</option>
                                <option>Jueves</option>
                                <option>Viernes</option>
                                <option>Sábado</option>
                            </select>

                            <input type="time" class="form-control" value="10:00">
                            <input type="time" class="form-control" value="12:00">

                            <button type="button" class="table-icon-btn remove-schedule-btn" title="Quitar horario">
                                <i class="bi bi-trash"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn activity-primary-btn modal-save-btn">Guardar</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Editar actividad -->
<div class="modal fade" id="modalEditarActividad" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content custom-modal">
            <div class="modal-header">
                <h5 class="modal-title">Editar actividad</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <p class="modal-note">Aquí irá el mismo formulario de creación, pero cargado con los datos de la actividad seleccionada.</p>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn activity-primary-btn modal-save-btn">Guardar cambios</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Agregar alumno -->
<div class="modal fade" id="modalAgregarAlumno" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content custom-modal">
            <div class="modal-header">
                <h5 class="modal-title">Agregar alumno a la actividad</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="toolbar-search modal-search">
                    <i class="bi bi-search"></i>
                    <input type="text" placeholder="Buscar alumno registrado">
                </div>

                <div class="assign-students-list">
                    <label class="assign-student-item">
                        <input type="checkbox">
                        <span>Carla Gómez</span>
                    </label>

                    <label class="assign-student-item">
                        <input type="checkbox">
                        <span>José Pérez</span>
                    </label>

                    <label class="assign-student-item">
                        <input type="checkbox">
                        <span>Andrea Ruiz</span>
                    </label>

                    <label class="assign-student-item">
                        <input type="checkbox">
                        <span>Mateo Chan</span>
                    </label>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn activity-primary-btn modal-save-btn">Agregar seleccionados</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Asistencia -->
<div class="modal fade" id="modalAsistencia" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content custom-modal">
            <div class="modal-header">
                <h5 class="modal-title">Pasar asistencia</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="attendance-header">
                    <div>
                        <strong>Actividad:</strong> Manualidades
                    </div>
                    <div>
                        <label for="attendanceDate"><strong>Fecha:</strong></label>
                        <input type="date" id="attendanceDate" class="form-control attendance-date-input">
                    </div>
                </div>

                <div class="attendance-list">
                    <label class="attendance-item">
                        <input type="checkbox" checked>
                        <span>Carla Gómez</span>
                    </label>

                    <label class="attendance-item">
                        <input type="checkbox" checked>
                        <span>José Pérez</span>
                    </label>

                    <label class="attendance-item">
                        <input type="checkbox" checked>
                        <span>Andrea Ruiz</span>
                    </label>

                    <label class="attendance-item">
                        <input type="checkbox">
                        <span>Mateo Chan</span>
                    </label>

                    <label class="attendance-item">
                        <input type="checkbox" checked>
                        <span>Sofía Castillo</span>
                    </label>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn activity-primary-btn modal-save-btn">Guardar asistencia</button>
            </div>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
<script src="<%= request.getContextPath() %>/js/actividades.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>