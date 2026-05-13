<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerontología - CDC Plan Chac</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/gerontologia.css?v=<%= System.currentTimeMillis() %>">
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

            <a href="<%= request.getContextPath() %>/actividades" class="nav-item">
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

            <a href="<%= request.getContextPath() %>/gerontologia" class="nav-item active">
                <i class="bi bi-heart-pulse-fill"></i>
                <span class="nav-label">Gerontología</span>
            </a>
        </nav>
    </aside>

    <div class="main-panel">
        <header class="topbar">
            <div class="topbar-left">
                <div>
                    <h1 class="page-title">Gerontología</h1>
                    <p class="page-subtitle">Seguimiento y gestión de expedientes de adultos mayores</p>
                </div>
            </div>

            <div class="topbar-right">
                <button type="button"
                        class="gero-primary-btn gero-main-action"
                        data-bs-toggle="modal"
                        data-bs-target="#modalNuevoExpediente">
                    <i class="bi bi-plus-lg"></i>
                    Nuevo expediente
                </button>
            </div>
        </header>

        <main class="content">
            <section class="gero-toolbar">
                <div class="gero-toolbar-left">
                    <div class="gero-search">
                        <i class="bi bi-search"></i>
                        <input type="text" id="buscarExpediente" placeholder="Buscar expediente">
                    </div>

                    <select id="filtroExpediente" class="gero-select">
                        <option value="Activo">Activos</option>
                        <option value="Archivado">Archivados</option>
                        <option value="Todos">Todos</option>
                    </select>
                </div>


            </section>

            <section class="gero-layout">
                <aside class="gero-list-card">
                    <div class="section-header">
                        <h3>Expedientes</h3>
                        <span id="contadorExpedientes" class="gero-count">0</span>
                    </div>

                    <div id="listaExpedientes" class="gero-expedientes-list"></div>
                </aside>

                <section class="gero-detail-column">
                    <article class="gero-patient-card">
                        <div class="gero-patient-avatar" id="expedienteIniciales">--</div>

                        <div class="gero-patient-info">
                            <div class="gero-patient-title-row">
                                <h2 id="expedienteNombre">Selecciona un expediente</h2>
                                <span id="expedienteEstado" class="status-badge active">Activo</span>
                            </div>

                            <div class="gero-patient-meta">
                                <span>
                                    <i class="bi bi-person"></i>
                                    <strong id="expedienteEdad">-- años</strong>
                                </span>

                                <span>
                                    <i class="bi bi-clock-history"></i>
                                    Última actualización:
                                    <strong id="expedienteActualizacion">--</strong>
                                </span>
                            </div>
                        </div>

                        <div class="gero-patient-actions">
                            <button type="button" class="gero-primary-btn compact" id="btnNuevaConsulta">
                                <i class="bi bi-plus-lg"></i>
                                Nueva consulta
                            </button>

                            <button type="button" class="gero-outline-danger-btn" id="btnArchivarExpediente">
                                <i class="bi bi-archive"></i>
                                <span>Archivar expediente</span>
                            </button>
                        </div>
                    </article>

                    <section class="gero-consultas-card">
                        <div class="gero-consultas-list-panel">
                            <div class="section-header">
                                <h3>Consultas</h3>
                            </div>

                            <div id="listaConsultas" class="gero-consultas-list"></div>
                        </div>

                        <div class="gero-consulta-detail-panel">
                            <div class="gero-consulta-detail-header">
                                <h3 id="consultaPanelTitulo">Detalle de la consulta</h3>

                                <div class="gero-consulta-actions" id="consultaActions">
                                    <button type="button" class="table-icon-btn" id="btnEditarConsulta" title="Editar consulta">
                                        <i class="bi bi-pencil"></i>
                                    </button>

                                    <button type="button" class="table-icon-btn danger" id="btnEliminarConsulta" title="Eliminar consulta">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>

                            <div id="consultaVista" class="gero-consulta-view">
                                <div class="gero-detail-grid">
                                    <div class="gero-detail-item">
                                        <span>Fecha y hora</span>
                                        <strong id="consultaFecha">--</strong>
                                    </div>

                                    <div class="gero-detail-item">
                                        <span>Paciente</span>
                                        <strong id="consultaPaciente">--</strong>
                                    </div>

                                    <div class="gero-detail-item">
                                        <span>Edad</span>
                                        <strong id="consultaEdad">--</strong>
                                    </div>
                                </div>

                                <div class="gero-clinical-block">
                                    <h4>Motivo de consulta</h4>
                                    <p id="consultaMotivo">Selecciona una consulta para ver su detalle.</p>
                                </div>

                                <div class="gero-clinical-block">
                                    <h4>Antecedentes</h4>
                                    <p id="consultaAntecedentes">--</p>
                                </div>

                                <div class="gero-clinical-block">
                                    <h4>Notas</h4>
                                    <p id="consultaNotas">--</p>
                                </div>
                            </div>

                            <form id="consultaForm" class="gero-consulta-form oculto">
                                <div class="gero-form-note">
                                    <i class="bi bi-clipboard2-pulse"></i>
                                    <div>
                                        <strong id="consultaFormPaciente">Paciente</strong>
                                        <span id="consultaFormMeta">Edad y fecha</span>
                                    </div>
                                </div>

                                <div class="form-group full">
                                    <label for="consultaMotivoInput">Motivo de consulta</label>
                                    <textarea id="consultaMotivoInput" class="form-control" rows="3" required></textarea>
                                </div>

                                <div class="form-group full">
                                    <label for="consultaAntecedentesInput">Antecedentes</label>
                                    <textarea id="consultaAntecedentesInput" class="form-control" rows="3"></textarea>
                                </div>

                                <div class="form-group full">
                                    <label for="consultaNotasInput">Notas</label>
                                    <textarea id="consultaNotasInput" class="form-control" rows="4"></textarea>
                                </div>

                                <div class="gero-form-actions">
                                    <button type="button" class="gero-secondary-btn" id="btnCancelarConsulta">
                                        Cancelar
                                    </button>

                                    <button type="submit" class="gero-primary-btn compact">
                                        Guardar consulta
                                    </button>
                                </div>
                            </form>

                            <div id="consultaEmptyState" class="gero-empty-state oculto">
                                <i class="bi bi-journal-medical"></i>
                                <h3>Sin consultas registradas</h3>
                                <p>Usa el botón “Nueva consulta” para agregar el primer seguimiento del expediente.</p>
                            </div>
                        </div>
                    </section>
                </section>
            </section>
        </main>
    </div>
</div>

<div class="modal fade" id="modalNuevoExpediente" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content custom-modal">
            <div class="modal-header">
                <div>
                    <h5 class="modal-title">Nuevo expediente</h5>
                    <p class="modal-note">Selecciona un alumno registrado para crear su expediente de gerontología.</p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="form-group full">
                    <label for="alumnoExpedienteSelect">Alumno</label>
                    <select id="alumnoExpedienteSelect" class="form-select">
                        <option value="">Selecciona un alumno</option>
                    </select>
                </div>

                <div id="alumnoPreview" class="gero-student-preview oculto">
                    <div class="gero-patient-avatar small" id="previewIniciales">--</div>
                    <div>
                        <strong id="previewNombre">Nombre del alumno</strong>
                        <span id="previewEdad">-- años</span>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="gero-secondary-btn" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="gero-primary-btn compact" id="btnCrearExpediente">
                    Crear expediente
                </button>
            </div>
        </div>
    </div>
</div>

<div id="geroConfirmModal" class="cdc-mini-modal oculto">
    <div class="cdc-mini-card">
        <button type="button" class="cdc-mini-close" id="geroConfirmClose">×</button>

        <div class="cdc-mini-icon">
            !
        </div>

        <div class="cdc-mini-content">
            <h3 id="geroConfirmTitle">Confirmar acción</h3>
            <p id="geroConfirmMessage">¿Deseas continuar?</p>
        </div>

        <div class="cdc-mini-actions">
            <button type="button" class="cdc-mini-btn cdc-mini-btn-secondary" id="geroConfirmCancel">
                Cancelar
            </button>

            <button type="button" class="cdc-mini-btn cdc-mini-btn-danger" id="geroConfirmAccept">
                Confirmar
            </button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
<script src="<%= request.getContextPath() %>/js/gerontologia.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>