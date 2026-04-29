<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alumnos - CDC Plan Chac</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS global -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css?v=<%= System.currentTimeMillis() %>">
    <!-- CSS de alumnos -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/alumnos.css?v=<%= System.currentTimeMillis() %>">
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

            <a href="<%= request.getContextPath() %>/actividades.jsp" class="nav-item">
                <i class="bi bi-calendar3"></i>
                <span class="nav-label">Actividades</span>
            </a>

            <a href="<%= request.getContextPath() %>/alumnos.jsp" class="nav-item active">
                <i class="bi bi-people-fill"></i>
                <span class="nav-label">Alumnos</span>
            </a>

            <a href="<%= request.getContextPath() %>/reportes.jsp" class="nav-item">
                <i class="bi bi-file-earmark-bar-graph-fill"></i>
                <span class="nav-label">Reportes</span>
            </a>
        </nav>
    </aside>

    <div class="main-panel">
        <header class="topbar">
            <div class="topbar-left">
                <div>
                    <h1 class="page-title">Alumnos</h1>
                    <p class="page-subtitle">Administra el padrón de alumnos del centro comunitario</p>
                </div>
            </div>

            <div class="topbar-right">
                <button class="activity-primary-btn" type="button" data-bs-toggle="modal" data-bs-target="#modalNuevoAlumno">
                    <i class="bi bi-plus-lg"></i>
                    <span>Nuevo alumno</span>
                </button>
            </div>
        </header>

        <main class="content">
            <!-- Barra de control -->
            <section class="students-toolbar">
                <div class="toolbar-search">
                    <i class="bi bi-search"></i>
                    <input type="text" id="searchStudentListInput" placeholder="Buscar alumno">
                </div>

                <select id="studentStatusFilter" class="toolbar-select">
                    <option value="todos">Estado: Todos</option>
                    <option value="activos">Estado: Activos</option>
                    <option value="inactivos">Estado: Inactivos</option>
                </select>

                <select id="studentOrderFilter" class="toolbar-select">
                    <option value="nombre">Ordenar por nombre</option>
                    <option value="asistencias">Ordenar por asistencias del mes</option>
                </select>
            </section>

            <!-- Layout -->
            <section class="students-layout">
                <!-- Izquierda -->
                <section class="student-list-card">
                    <div class="section-header">
                        <h3>Listado de alumnos</h3>
                    </div>

                    <div class="student-list-scroll" id="studentList">
                        <article class="student-list-item selected" data-student-id="1">
                            <div class="student-list-avatar">CG</div>

                            <div class="student-list-body">
                                <div class="student-list-top">
                                    <h4>Carla Gómez</h4>
                                    <span class="status-badge active">Activa</span>
                                </div>
                                <p class="student-list-phone">999 123 4567</p>
                                <p class="student-list-meta">3 actividades inscritas</p>
                            </div>
                        </article>

                        <article class="student-list-item" data-student-id="2">
                            <div class="student-list-avatar">JP</div>

                            <div class="student-list-body">
                                <div class="student-list-top">
                                    <h4>José Pérez</h4>
                                    <span class="status-badge active">Activo</span>
                                </div>
                                <p class="student-list-phone">999 234 5678</p>
                                <p class="student-list-meta">2 actividades inscritas</p>
                            </div>
                        </article>

                        <article class="student-list-item" data-student-id="3">
                            <div class="student-list-avatar">AR</div>

                            <div class="student-list-body">
                                <div class="student-list-top">
                                    <h4>Andrea Ruiz</h4>
                                    <span class="status-badge active">Activa</span>
                                </div>
                                <p class="student-list-phone">999 345 6789</p>
                                <p class="student-list-meta">3 actividades inscritas</p>
                            </div>
                        </article>

                        <article class="student-list-item" data-student-id="4">
                            <div class="student-list-avatar">MC</div>

                            <div class="student-list-body">
                                <div class="student-list-top">
                                    <h4>Mateo Chan</h4>
                                    <span class="status-badge active">Activo</span>
                                </div>
                                <p class="student-list-phone">999 456 7890</p>
                                <p class="student-list-meta">1 actividad inscrita</p>
                            </div>
                        </article>

                        <article class="student-list-item" data-student-id="5">
                            <div class="student-list-avatar">SC</div>

                            <div class="student-list-body">
                                <div class="student-list-top">
                                    <h4>Sofía Castillo</h4>
                                    <span class="status-badge active">Activa</span>
                                </div>
                                <p class="student-list-phone">999 567 8901</p>
                                <p class="student-list-meta">2 actividades inscritas</p>
                            </div>
                        </article>

                        <article class="student-list-item" data-student-id="6">
                            <div class="student-list-avatar">LM</div>

                            <div class="student-list-body">
                                <div class="student-list-top">
                                    <h4>Lucía Martínez</h4>
                                    <span class="status-badge inactive">Inactiva</span>
                                </div>
                                <p class="student-list-phone">999 678 9012</p>
                                <p class="student-list-meta">0 actividades inscritas</p>
                            </div>
                        </article>
                    </div>
                </section>

                <!-- Derecha -->
                <section class="student-detail-column">
                    <!-- Ficha -->
                    <section class="student-detail-card">
                        <div class="student-detail-main">
                            <div class="student-detail-avatar" id="studentDetailAvatar">CG</div>

                            <div class="student-detail-info">
                                <div class="student-detail-title-row">
                                    <h2 id="studentDetailName">Carla Gómez</h2>
                                    <span class="status-badge active" id="studentDetailStatus">Activa</span>
                                </div>

                                <div class="student-detail-grid">
                                    <div class="detail-item">
                                        <span class="detail-label">Fecha de nacimiento</span>
                                        <span class="detail-value" id="studentDetailBirthDate">12/05/2009</span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Celular</span>
                                        <span class="detail-value" id="studentDetailPhone">999 123 4567</span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">CURP</span>
                                        <span class="detail-value" id="studentDetailCurp">GOGC090512MQRMLRA3</span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Actividades inscritas</span>
                                        <span class="detail-value" id="studentDetailActivitiesCount">3</span>
                                    </div>

                                    <div class="detail-item full">
                                        <span class="detail-label">Domicilio</span>
                                        <span class="detail-value" id="studentDetailAddress">Calle 24 #123, Col. Centro, Chetumal, Quintana Roo, C.P. 77000</span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Asistencias del mes</span>
                                        <span class="detail-value" id="studentDetailMonthAttendance">17</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="student-actions">
                            <button class="action-btn secondary" type="button" data-bs-toggle="modal" data-bs-target="#modalEditarAlumno">
                                <i class="bi bi-pencil-square"></i>
                                <span>Editar</span>
                            </button>

                            <button class="action-btn danger-outline" type="button">
                                <i class="bi bi-pause-circle"></i>
                                <span>Desactivar</span>
                            </button>
                        </div>
                    </section>

                    <!-- Actividades inscritas -->
                    <section class="student-activities-card">
                        <div class="section-header">
                            <h3>Actividades inscritas</h3>
                        </div>

                        <div class="student-activities-table-wrapper">
                            <table class="student-activities-table">
                                <thead>
                                <tr>
                                    <th>Actividad</th>
                                    <th>Instructor</th>
                                    <th>Horarios</th>
                                    <th>Asistencias del mes</th>
                                    <th>Estado</th>
                                </tr>
                                </thead>
                                <tbody id="studentActivitiesTableBody">
                                <tr>
                                    <td>Manualidades</td>
                                    <td>Ana López</td>
                                    <td>Lun 10:00 - 12:00 / Mié 16:00 - 18:00</td>
                                    <td>8</td>
                                    <td><span class="status-badge active">Activa</span></td>
                                </tr>
                                <tr>
                                    <td>Computación</td>
                                    <td>Diego Ramírez</td>
                                    <td>Vie 12:00 - 14:00</td>
                                    <td>5</td>
                                    <td><span class="status-badge active">Activa</span></td>
                                </tr>
                                <tr>
                                    <td>Música</td>
                                    <td>Luis Morales</td>
                                    <td>Mié 15:00 - 16:30 / Vie 15:00 - 16:30</td>
                                    <td>4</td>
                                    <td><span class="status-badge active">Activa</span></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </section>
            </section>
        </main>
    </div>
</div>

<!-- Modal: Nuevo alumno -->
<div class="modal fade" id="modalNuevoAlumno" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content custom-modal">
            <div class="modal-header">
                <h5 class="modal-title">Nuevo alumno</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="student-form-grid">
                    <div class="form-group">
                        <label for="studentName">Nombre completo</label>
                        <input type="text" id="studentName" class="form-control" placeholder="Ej. Carla Gómez">
                    </div>

                    <div class="form-group">
                        <label for="studentBirthDate">Fecha de nacimiento</label>
                        <input type="date" id="studentBirthDate" class="form-control">
                    </div>

                    <div class="form-group">
                        <label for="studentCurp">CURP</label>
                        <input type="text" id="studentCurp" class="form-control" placeholder="Ej. GOGC090512MQRMLRA3">
                    </div>

                    <div class="form-group">
                        <label for="studentPhone">Celular</label>
                        <input type="text" id="studentPhone" class="form-control" placeholder="Ej. 999 123 4567">
                    </div>

                    <div class="form-group full">
                        <label for="studentAddress">Domicilio</label>
                        <textarea id="studentAddress" class="form-control" rows="3" placeholder="Ej. Calle 24 #123, Col. Centro, Chetumal, Quintana Roo, C.P. 77000"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="studentStatus">Estado</label>
                        <select id="studentStatus" class="form-select">
                            <option>Activo</option>
                            <option>Inactivo</option>
                        </select>
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

<!-- Modal: Editar alumno -->
<div class="modal fade" id="modalEditarAlumno" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content custom-modal">
            <div class="modal-header">
                <h5 class="modal-title">Editar alumno</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <p class="modal-note">Aquí irá el mismo formulario de alta, pero cargado con los datos del alumno seleccionado.</p>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn activity-primary-btn modal-save-btn">Guardar cambios</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
<script src="<%= request.getContextPath() %>/js/alumnos.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>