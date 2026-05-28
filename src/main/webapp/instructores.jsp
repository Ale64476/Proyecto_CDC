<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cdc.model.Instructor" %>

<%
    List<Instructor> listaInstructores =
            (List<Instructor>) request.getAttribute("listaInstructores");

    Instructor instructorSeleccionado =
            (Instructor) request.getAttribute("instructorSeleccionado");

    String tipoMensaje = request.getParameter("tipoMensaje");
    String mensaje = request.getParameter("mensaje");

    String textoMensaje = null;

    if (mensaje != null) {
        switch (mensaje) {
            case "instructor_guardado":
                textoMensaje = "Instructor registrado correctamente.";
                break;
            case "instructor_no_guardado":
                textoMensaje = "No se pudo registrar el instructor.";
                break;
            case "instructor_actualizado":
                textoMensaje = "Instructor actualizado correctamente.";
                break;
            case "instructor_no_actualizado":
                textoMensaje = "No se pudo actualizar el instructor.";
                break;
            case "instructor_reactivado":
                textoMensaje = "Instructor reactivado correctamente. Ya puede asignarse a talleres.";
                break;
            case "instructor_desactivado":
                textoMensaje = "Instructor desactivado correctamente. Ya no aparecerá para nuevos talleres.";
                break;
            case "instructor_nombre_obligatorio":
                textoMensaje = "El nombre del instructor es obligatorio.";
                break;
            case "instructor_nombre_invalido":
                textoMensaje = "El nombre del instructor debe tener al menos 3 caracteres.";
                break;
            case "instructor_celular_obligatorio":
                textoMensaje = "El teléfono del instructor es obligatorio.";
                break;
            case "instructor_celular_invalido":
                textoMensaje = "El teléfono debe tener exactamente 10 dígitos.";
                break;
            case "instructor_id_invalido":
                textoMensaje = "El identificador del instructor no es válido.";
                break;
            case "instructor_no_encontrado":
                textoMensaje = "No se encontró el instructor seleccionado.";
                break;
            case "estado_instructor_id_invalido":
                textoMensaje = "El identificador del instructor no es válido.";
                break;
            case "estado_instructor_invalido":
                textoMensaje = "El nuevo estado del instructor no es válido.";
                break;
            case "estado_instructor_sin_cambios":
                textoMensaje = "El instructor ya tenía ese estado.";
                break;
            case "estado_instructor_no_actualizado":
                textoMensaje = "No se pudo actualizar el estado del instructor.";
                break;
            case "error_sistema":
                textoMensaje = "Ocurrió un error interno. Revisa la consola de Tomcat.";
                break;
            default:
                textoMensaje = null;
        }
    }

    boolean hayInstructor = instructorSeleccionado != null;
    boolean instructorActivo = hayInstructor
            && "Activo".equalsIgnoreCase(instructorSeleccionado.getEstadoInstructor());

    String nuevoEstadoInstructor = instructorActivo ? "Inactivo" : "Activo";
    String textoBotonEstado = instructorActivo ? "Desactivar" : "Reactivar";
    String iconoBotonEstado = instructorActivo ? "bi-slash-circle" : "bi-arrow-clockwise";
    String tituloConfirmacionEstado = instructorActivo ? "Desactivar instructor" : "Reactivar instructor";
    String mensajeConfirmacionEstado = instructorActivo
            ? "¿Seguro que deseas desactivar este instructor? Ya no aparecerá disponible al crear o editar talleres."
            : "¿Seguro que deseas reactivar este instructor? Volverá a estar disponible para asignarse a talleres.";
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Instructores - CDC Plan Chac</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/instructores.css?v=<%= System.currentTimeMillis() %>">
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

            <a href="<%= request.getContextPath() %>/instructores" class="nav-item active">
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
                    <h1 class="page-title">Instructores</h1>
                    <p class="page-subtitle">Registro y administración de instructores del centro comunitario</p>
                </div>
            </div>

            <div class="topbar-right">
                <button type="button"
                        class="instructor-primary-btn"
                        data-bs-toggle="modal"
                        data-bs-target="#modalNuevoInstructor">
                    <i class="bi bi-plus-lg"></i>
                    Nuevo instructor
                </button>
            </div>
        </header>

        <main class="content">
            <% if (textoMensaje != null) { %>
                <div class="cdc-toast <%= "exito".equalsIgnoreCase(tipoMensaje) ? "cdc-toast-success" : "cdc-toast-error" %>" id="cdcToast">
                    <div class="cdc-toast-icon">
                        <%= "exito".equalsIgnoreCase(tipoMensaje) ? "✓" : "!" %>
                    </div>
                    <div class="cdc-toast-content">
                        <strong><%= "exito".equalsIgnoreCase(tipoMensaje) ? "Operación exitosa" : "Revisa la información" %></strong>
                        <span><%= textoMensaje %></span>
                    </div>
                    <button type="button" class="cdc-toast-close" onclick="document.getElementById('cdcToast').remove()">×</button>
                </div>
            <% } %>

            <section class="instructors-toolbar">
                <div class="toolbar-search">
                    <i class="bi bi-search"></i>
                    <input type="text" id="buscarInstructor" placeholder="Buscar instructor">
                </div>
            </section>

            <section class="instructors-layout">
                <aside class="instructor-list-card">
                    <div class="section-header">
                        <h3>Lista de instructores</h3>
                        <span class="instructor-count" id="contadorInstructores">
                            <%= listaInstructores != null ? listaInstructores.size() : 0 %>
                        </span>
                    </div>

                    <div class="instructor-list-scroll" id="listaInstructores">
                        <%
                            if (listaInstructores != null && !listaInstructores.isEmpty()) {
                                for (Instructor instructor : listaInstructores) {
                                    boolean seleccionado = hayInstructor
                                            && instructorSeleccionado.getIdInstructor() == instructor.getIdInstructor();

                                    String estado = instructor.getEstadoInstructor();
                                    String estadoClase = "Activo".equalsIgnoreCase(estado) ? "active" : "inactive";
                        %>
                                    <a href="<%= request.getContextPath() %>/instructores?id=<%= instructor.getIdInstructor() %>"
                                       class="instructor-list-item <%= seleccionado ? "selected" : "" %>"
                                       data-nombre="<%= instructor.getNombreCompleto() != null ? instructor.getNombreCompleto().toLowerCase() : "" %>"
                                       data-celular="<%= instructor.getCelular() != null ? instructor.getCelular() : "" %>"
                                       data-estado="<%= estado %>">

                                        <div class="instructor-list-avatar">
                                            <%= obtenerIniciales(instructor.getNombreCompleto()) %>
                                        </div>

                                        <div class="instructor-list-body">
                                            <div class="instructor-list-top">
                                                <h4><%= instructor.getNombreCompleto() %></h4>
                                                <span class="status-badge <%= estadoClase %>"><%= estado %></span>
                                            </div>

                                            <p class="instructor-list-phone">
                                                <i class="bi bi-telephone"></i>
                                                <%= instructor.getCelular() %>
                                            </p>
                                        </div>
                                    </a>
                        <%
                                }
                            } else {
                        %>
                            <div class="instructor-empty-list">
                                <i class="bi bi-person-badge"></i>
                                <p>No hay instructores registrados.</p>
                            </div>
                        <%
                            }
                        %>
                    </div>

                    <div class="instructor-empty-filter oculto" id="instructorEmptyFilter">
                        No se encontraron instructores con los filtros seleccionados.
                    </div>
                </aside>

                <section class="instructor-detail-column">
                    <article class="instructor-detail-card">
                        <% if (hayInstructor) { %>
                            <div class="instructor-detail-main">
                                <div class="instructor-detail-avatar">
                                    <%= obtenerIniciales(instructorSeleccionado.getNombreCompleto()) %>
                                </div>

                                <div class="instructor-detail-info">
                                    <div class="instructor-detail-title-row">
                                        <h2><%= instructorSeleccionado.getNombreCompleto() %></h2>
                                        <span class="status-badge <%= instructorActivo ? "active" : "inactive" %>">
                                            <%= instructorSeleccionado.getEstadoInstructor() %>
                                        </span>
                                    </div>

                                    <div class="instructor-detail-grid">
                                        <div class="detail-item">
                                            <span class="detail-label">Teléfono</span>
                                            <span class="detail-value"><%= instructorSeleccionado.getCelular() %></span>
                                        </div>

                                        <div class="detail-item">
                                            <span class="detail-label">Estado</span>
                                            <span class="detail-value"><%= instructorSeleccionado.getEstadoInstructor() %></span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="instructor-actions">
                                <button type="button"
                                        class="action-btn primary"
                                        data-bs-toggle="modal"
                                        data-bs-target="#modalEditarInstructor">
                                    <i class="bi bi-pencil-square"></i>
                                    <span>Editar</span>
                                </button>

                                <form method="post"
                                      action="<%= request.getContextPath() %>/cambiar-estado-instructor"
                                      class="js-confirm-submit"
                                      data-confirm-title="<%= tituloConfirmacionEstado %>"
                                      data-confirm-message="<%= mensajeConfirmacionEstado %>"
                                      data-confirm-confirm-text="<%= textoBotonEstado %>"
                                      data-confirm-danger="<%= instructorActivo ? "true" : "false" %>"
                                      style="display: inline;">
                                    <input type="hidden" name="idInstructor" value="<%= instructorSeleccionado.getIdInstructor() %>">
                                    <input type="hidden" name="nuevoEstado" value="<%= nuevoEstadoInstructor %>">

                                    <button type="submit"
                                            class="action-btn <%= instructorActivo ? "danger-outline" : "secondary" %>">
                                        <i class="bi <%= iconoBotonEstado %>"></i>
                                        <span><%= textoBotonEstado %></span>
                                    </button>
                                </form>
                            </div>

                            <% if (!instructorActivo) { %>
                                <div class="inactive-instructor-notice">
                                    <i class="bi bi-info-circle"></i>
                                    <div>
                                        <strong>Instructor inactivo</strong>
                                        <span>No aparecerá disponible al crear o editar talleres. Puedes reactivarlo cuando sea necesario.</span>
                                    </div>
                                </div>
                            <% } %>
                        <% } else { %>
                            <div class="instructor-empty-detail">
                                <i class="bi bi-person-badge"></i>
                                <h3>Selecciona un instructor</h3>
                                <p>Cuando registres o selecciones un instructor, aquí aparecerá su información.</p>
                            </div>
                        <% } %>
                    </article>
                </section>
            </section>
        </main>
    </div>
</div>

<div class="modal fade" id="modalNuevoInstructor" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form method="post"
              action="<%= request.getContextPath() %>/guardar-instructor"
              class="modal-content custom-modal js-instructor-form">
            <div class="modal-header">
                <div>
                    <h5 class="modal-title">Nuevo instructor</h5>
                    <p class="modal-note">Registra los datos básicos del instructor.</p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="instructor-form-grid">
                    <div class="form-group full">
                        <label for="nuevoNombreInstructor">Nombre completo</label>
                        <input type="text"
                               class="form-control"
                               id="nuevoNombreInstructor"
                               name="nombreCompleto"
                               placeholder="Ej. Ana López"
                               required>
                    </div>

                    <div class="form-group full">
                        <label for="nuevoCelularInstructor">Teléfono</label>
                        <input type="text"
                               class="form-control"
                               id="nuevoCelularInstructor"
                               name="celular"
                               maxlength="10"
                               placeholder="10 dígitos"
                               required>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="action-btn secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="instructor-primary-btn compact">Guardar instructor</button>
            </div>
        </form>
    </div>
</div>

<% if (hayInstructor) { %>
<div class="modal fade" id="modalEditarInstructor" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form method="post"
              action="<%= request.getContextPath() %>/actualizar-instructor"
              class="modal-content custom-modal js-instructor-form">
            <input type="hidden" name="idInstructor" value="<%= instructorSeleccionado.getIdInstructor() %>">

            <div class="modal-header">
                <div>
                    <h5 class="modal-title">Editar instructor</h5>
                    <p class="modal-note">Actualiza los datos básicos del instructor.</p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="instructor-form-grid">
                    <div class="form-group full">
                        <label for="editarNombreInstructor">Nombre completo</label>
                        <input type="text"
                               class="form-control"
                               id="editarNombreInstructor"
                               name="nombreCompleto"
                               value="<%= instructorSeleccionado.getNombreCompleto() %>"
                               required>
                    </div>

                    <div class="form-group full">
                        <label for="editarCelularInstructor">Teléfono</label>
                        <input type="text"
                               class="form-control"
                               id="editarCelularInstructor"
                               name="celular"
                               maxlength="10"
                               value="<%= instructorSeleccionado.getCelular() %>"
                               required>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="action-btn secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="instructor-primary-btn compact">Guardar cambios</button>
            </div>
        </form>
    </div>
</div>
<% } %>

<div id="cdcMiniModal" class="cdc-mini-modal oculto">
    <div class="cdc-mini-card">
        <button type="button" class="cdc-mini-close" id="cdcMiniClose">×</button>

        <div class="cdc-mini-icon">!</div>

        <div class="cdc-mini-content">
            <h3 id="cdcMiniTitle">Revisa la información</h3>
            <p id="cdcMiniMessage">Hay información pendiente por corregir.</p>
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

<%!
    private String obtenerIniciales(String nombreCompleto) {
        if (nombreCompleto == null || nombreCompleto.isBlank()) {
            return "--";
        }

        String[] partes = nombreCompleto.trim().split("\\s+");

        if (partes.length >= 2) {
            return (partes[0].substring(0, 1) + partes[1].substring(0, 1)).toUpperCase();
        }

        return partes[0].substring(0, 1).toUpperCase();
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
<script src="<%= request.getContextPath() %>/js/instructores.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>