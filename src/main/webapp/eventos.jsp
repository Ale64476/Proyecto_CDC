<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.Time" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.cdc.model.Evento" %>

<%
    List<Evento> listaEventos = (List<Evento>) request.getAttribute("listaEventos");
    Evento eventoSeleccionado = (Evento) request.getAttribute("eventoSeleccionado");

    String tipoMensaje = request.getParameter("tipoMensaje");
    String mensaje = request.getParameter("mensaje");

    String textoMensaje = null;

    if (mensaje != null) {
        switch (mensaje) {
            case "evento_guardado":
                textoMensaje = "Evento registrado correctamente como borrador.";
                break;
            case "evento_no_guardado":
                textoMensaje = "No se pudo registrar el evento.";
                break;
            case "evento_actualizado":
                textoMensaje = "Evento actualizado correctamente.";
                break;
            case "evento_no_actualizado":
                textoMensaje = "No se pudo actualizar el evento.";
                break;
            case "evento_nombre_obligatorio":
                textoMensaje = "El nombre del evento es obligatorio.";
                break;
            case "evento_nombre_invalido":
                textoMensaje = "El nombre del evento debe tener al menos 3 caracteres.";
                break;
            case "evento_descripcion_obligatoria":
                textoMensaje = "La descripción del evento es obligatoria.";
                break;
            case "evento_fecha_obligatoria":
                textoMensaje = "La fecha del evento es obligatoria.";
                break;
            case "evento_hora_inicio_obligatoria":
                textoMensaje = "La hora de inicio es obligatoria.";
                break;
            case "evento_hora_fin_invalida":
                textoMensaje = "La hora de fin debe ser posterior a la hora de inicio.";
                break;
            case "evento_lugar_obligatorio":
                textoMensaje = "El lugar del evento es obligatorio.";
                break;
            case "evento_responsable_obligatorio":
                textoMensaje = "El responsable del evento es obligatorio.";
                break;
            case "evento_id_invalido":
                textoMensaje = "El evento seleccionado no es válido.";
                break;
            case "evento_no_encontrado":
                textoMensaje = "No se encontró el evento seleccionado.";
                break;
            case "evento_estado_invalido":
                textoMensaje = "El estado del evento no es válido.";
                break;
            case "evento_estado_sin_cambios":
                textoMensaje = "El evento ya tenía ese estado.";
                break;
            case "evento_estado_no_actualizado":
                textoMensaje = "No se pudo actualizar el estado del evento.";
                break;
            case "evento_borrador":
                textoMensaje = "El evento volvió a estado Borrador.";
                break;
            case "evento_publicado":
                textoMensaje = "El evento fue marcado como Publicado.";
                break;
            case "evento_finalizado":
                textoMensaje = "El evento fue finalizado correctamente.";
                break;
            case "evento_cancelado":
                textoMensaje = "El evento fue cancelado correctamente.";
                break;
            case "evento_estado_actualizado":
                textoMensaje = "Estado del evento actualizado correctamente.";
                break;
            case "error_sistema":
                textoMensaje = "Ocurrió un error interno. Revisa la consola de Tomcat.";
                break;
            default:
                textoMensaje = null;
        }
    }

    boolean hayEvento = eventoSeleccionado != null;

    String estadoEvento = hayEvento ? eventoSeleccionado.getEstadoEvento() : "";
    String claseEstado = obtenerClaseEstado(estadoEvento);

    String siguienteEstadoPrincipal = null;
    String textoSiguienteEstado = null;
    String iconoSiguienteEstado = null;
    String tituloConfirmacionPrincipal = null;
    String mensajeConfirmacionPrincipal = null;

    if (hayEvento) {
        if ("Borrador".equalsIgnoreCase(estadoEvento)) {
            siguienteEstadoPrincipal = "Publicado";
            textoSiguienteEstado = "Marcar como publicado";
            iconoSiguienteEstado = "bi-megaphone";
            tituloConfirmacionPrincipal = "Publicar evento";
            mensajeConfirmacionPrincipal = "¿Deseas marcar este evento como publicado? Esto indica que ya fue difundido o está listo para compartirse.";
        } else if ("Publicado".equalsIgnoreCase(estadoEvento)) {
            siguienteEstadoPrincipal = "Finalizado";
            textoSiguienteEstado = "Finalizar evento";
            iconoSiguienteEstado = "bi-check2-circle";
            tituloConfirmacionPrincipal = "Finalizar evento";
            mensajeConfirmacionPrincipal = "¿Deseas finalizar este evento? Se conservará su información y enlaces.";
        } else if ("Cancelado".equalsIgnoreCase(estadoEvento)) {
            siguienteEstadoPrincipal = "Borrador";
            textoSiguienteEstado = "Reactivar borrador";
            iconoSiguienteEstado = "bi-arrow-clockwise";
            tituloConfirmacionPrincipal = "Reactivar evento";
            mensajeConfirmacionPrincipal = "¿Deseas regresar este evento a estado Borrador?";
        }
    }

    boolean puedeCancelar = hayEvento
            && !"Cancelado".equalsIgnoreCase(estadoEvento)
            && !"Finalizado".equalsIgnoreCase(estadoEvento);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Eventos - CDC Plan Chac</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/eventos.css?v=<%= System.currentTimeMillis() %>">
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

            <a href="<%= request.getContextPath() %>/eventos" class="nav-item active">
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
                    <h1 class="page-title">Eventos</h1>
                    <p class="page-subtitle">Gestión de eventos públicos, publicación y formularios de registro</p>
                </div>
            </div>

            <div class="topbar-right">
                <button type="button"
                        class="event-primary-btn"
                        data-bs-toggle="modal"
                        data-bs-target="#modalNuevoEvento">
                    <i class="bi bi-plus-lg"></i>
                    Nuevo evento
                </button>
            </div>
        </header>

        <main class="content">
            <%
            String codigoMensajeGoogleToast = request.getParameter("mensaje");

            if (textoMensaje == null && codigoMensajeGoogleToast != null) {
                if ("formulario_generado".equals(codigoMensajeGoogleToast)) {
                    textoMensaje = "Formulario de asistencia generado correctamente.";
                } else if ("formulario_google_error".equals(codigoMensajeGoogleToast)) {
                    textoMensaje = "No se pudo generar el formulario de asistencia en Google.";
                } else if ("formulario_guardado_error".equals(codigoMensajeGoogleToast)) {
                    textoMensaje = "El formulario fue creado, pero no se pudieron guardar los enlaces en el sistema.";
                } else if ("evento_ya_tiene_formulario".equals(codigoMensajeGoogleToast)) {
                    textoMensaje = "Este evento ya tiene un formulario registrado.";
                } else if ("evento_no_encontrado".equals(codigoMensajeGoogleToast)) {
                    textoMensaje = "No se encontró el evento seleccionado.";
                } else if ("evento_no_valido".equals(codigoMensajeGoogleToast)) {
                    textoMensaje = "El identificador del evento no es válido.";
                }
            }

            if (tipoMensaje == null || tipoMensaje.trim().isEmpty()) {
                tipoMensaje = "error";
            }
        %>

        <% if (textoMensaje != null) { %>
            <div class="cdc-toast <%= "exito".equalsIgnoreCase(tipoMensaje) ? "cdc-toast-success" : "cdc-toast-error" %>" id="cdcToast">
                <div class="cdc-toast-icon">
                    <%= "exito".equalsIgnoreCase(tipoMensaje) ? "✓" : "!" %>
                </div>
                <div class="cdc-toast-content">
                    <strong><%= "exito".equalsIgnoreCase(tipoMensaje) ? "Operación exitosa" : "Revisa la información" %></strong>
                    <span><%= esc(textoMensaje) %></span>
                </div>
                <button type="button" class="cdc-toast-close" onclick="document.getElementById('cdcToast').remove()">×</button>
            </div>
        <% } %>

            <section class="events-toolbar">
                <div class="toolbar-search">
                    <i class="bi bi-search"></i>
                    <input type="text" id="buscarEvento" placeholder="Buscar evento">
                </div>

                <select id="filtroEstadoEvento" class="toolbar-select">
                    <option value="Todos">Todos</option>
                    <option value="Borrador">Borrador</option>
                    <option value="Publicado">Publicado</option>
                    <option value="Finalizado">Finalizado</option>
                    <option value="Cancelado">Cancelado</option>
                </select>
            </section>

            <section class="events-layout">
                <aside class="event-list-card">
                    <div class="section-header">
                        <h3>Lista de eventos</h3>
                        <span class="event-count" id="contadorEventos">
                            <%= listaEventos != null ? listaEventos.size() : 0 %>
                        </span>
                    </div>

                    <div class="event-list-scroll" id="listaEventos">
                        <%
                            if (listaEventos != null && !listaEventos.isEmpty()) {
                                for (Evento evento : listaEventos) {
                                    boolean seleccionado = hayEvento
                                            && eventoSeleccionado.getIdEvento() == evento.getIdEvento();

                                    String estado = evento.getEstadoEvento();
                                    String estadoClaseItem = obtenerClaseEstado(estado);
                        %>
                                    <a href="<%= request.getContextPath() %>/eventos?id=<%= evento.getIdEvento() %>"
                                       class="event-list-item <%= seleccionado ? "selected" : "" %>"
                                       data-nombre="<%= attr(evento.getNombreEvento()) %>"
                                       data-responsable="<%= attr(evento.getResponsable()) %>"
                                       data-estado="<%= attr(estado) %>">

                                        <div class="event-list-icon">
                                            <i class="bi bi-calendar-event"></i>
                                        </div>

                                        <div class="event-list-body">
                                            <div class="event-list-top">
                                                <h4><%= esc(evento.getNombreEvento()) %></h4>
                                                <span class="status-badge <%= estadoClaseItem %>"><%= esc(estado) %></span>
                                            </div>

                                            <p class="event-list-date">
                                                <i class="bi bi-calendar3"></i>
                                                <%= formatoFecha(evento.getFechaEvento()) %>
                                                ·
                                                <%= formatoHora(evento.getHoraInicio()) %>
                                            </p>

                                            <p class="event-list-date">
                                                <i class="bi bi-person"></i>
                                                <%= esc(evento.getResponsable()) %>
                                            </p>
                                        </div>
                                    </a>
                        <%
                                }
                            } else {
                        %>
                            <div class="event-empty-list">
                                <i class="bi bi-megaphone"></i>
                                <p>No hay eventos registrados.</p>
                            </div>
                        <%
                            }
                        %>
                    </div>

                    <div class="event-empty-filter oculto" id="eventEmptyFilter">
                        No se encontraron eventos con los filtros seleccionados.
                    </div>
                </aside>

                <section class="event-detail-column">
                    <article class="event-detail-card">
                        <% if (hayEvento) { %>
                            <div class="event-detail-header">
                                <div>
                                    <div class="event-title-row">
                                        <h2><%= esc(eventoSeleccionado.getNombreEvento()) %></h2>
                                        <span class="status-badge <%= claseEstado %>">
                                            <%= esc(eventoSeleccionado.getEstadoEvento()) %>
                                        </span>
                                    </div>

                                    <p class="event-detail-subtitle">
                                        <i class="bi bi-geo-alt"></i>
                                        <%= esc(eventoSeleccionado.getLugar()) %>
                                    </p>
                                </div>

                                <div class="event-main-actions">
                                    <button type="button"
                                            class="event-primary-btn compact"
                                            data-bs-toggle="modal"
                                            data-bs-target="#modalEditarEvento">
                                        <i class="bi bi-pencil-square"></i>
                                        Editar
                                    </button>

                                    <% if (siguienteEstadoPrincipal != null) { %>
                                        <form method="post"
                                              action="<%= request.getContextPath() %>/cambiar-estado-evento"
                                              class="js-confirm-submit"
                                              data-confirm-title="<%= attr(tituloConfirmacionPrincipal) %>"
                                              data-confirm-message="<%= attr(mensajeConfirmacionPrincipal) %>"
                                              data-confirm-confirm-text="<%= attr(textoSiguienteEstado) %>"
                                              data-confirm-danger="false"
                                              style="display:inline;">
                                            <input type="hidden" name="idEvento" value="<%= eventoSeleccionado.getIdEvento() %>">
                                            <input type="hidden" name="nuevoEstado" value="<%= siguienteEstadoPrincipal %>">

                                            <button type="submit" class="event-secondary-btn">
                                                <i class="bi <%= iconoSiguienteEstado %>"></i>
                                                <%= textoSiguienteEstado %>
                                            </button>
                                        </form>
                                    <% } %>

                                    <% if (puedeCancelar) { %>
                                        <form method="post"
                                              action="<%= request.getContextPath() %>/cambiar-estado-evento"
                                              class="js-confirm-submit"
                                              data-confirm-title="Cancelar evento"
                                              data-confirm-message="¿Seguro que deseas cancelar este evento? La información se conservará."
                                              data-confirm-confirm-text="Cancelar evento"
                                              data-confirm-danger="true"
                                              style="display:inline;">
                                            <input type="hidden" name="idEvento" value="<%= eventoSeleccionado.getIdEvento() %>">
                                            <input type="hidden" name="nuevoEstado" value="Cancelado">

                                            <button type="submit" class="event-danger-outline-btn">
                                                <i class="bi bi-x-circle"></i>
                                                Cancelar
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                            </div>

                            <div class="event-info-grid">
                                <div class="event-info-item">
                                    <span>Fecha</span>
                                    <strong><%= formatoFecha(eventoSeleccionado.getFechaEvento()) %></strong>
                                </div>

                                <div class="event-info-item">
                                    <span>Horario</span>
                                    <strong>
                                        <%= formatoHora(eventoSeleccionado.getHoraInicio()) %>
                                        <% if (eventoSeleccionado.getHoraFin() != null) { %>
                                            - <%= formatoHora(eventoSeleccionado.getHoraFin()) %>
                                        <% } %>
                                    </strong>
                                </div>

                                <div class="event-info-item">
                                    <span>Responsable</span>
                                    <strong><%= esc(eventoSeleccionado.getResponsable()) %></strong>
                                </div>
                            </div>

                            <div class="event-section">
                                <h3>Descripción del evento</h3>
                                <p><%= esc(valorVacio(eventoSeleccionado.getDescripcionEvento())) %></p>
                            </div>

                            <div class="event-links-grid">
                                <div class="event-link-card">
                                    <span>Formulario de registro</span>

                                    <% if (tieneTexto(eventoSeleccionado.getUrlFormulario())) { %>
                                        <a href="<%= esc(eventoSeleccionado.getUrlFormulario()) %>" target="_blank" rel="noopener noreferrer">
                                            Abrir formulario
                                        </a>
                                    <% } else { %>
                                        <form action="<%= request.getContextPath() %>/eventos" method="post" class="google-form-action">
                                            <input type="hidden" name="accion" value="generarFormularioGoogle">
                                            <input type="hidden" name="idEvento" value="<%= eventoSeleccionado.getIdEvento() %>">

                                            <button type="submit" class="google-form-link">
                                                Generar formulario automático
                                            </button>
                                        </form>
                                    <% } %>
                                </div>

                                <div class="event-link-card">
                                    <span>Hoja de respuestas</span>
                                    <% if (tieneTexto(eventoSeleccionado.getUrlHojaRespuestas())) { %>
                                        <a href="<%= esc(eventoSeleccionado.getUrlHojaRespuestas()) %>" target="_blank" rel="noopener noreferrer">
                                            Abrir respuestas
                                        </a>
                                    <% } else { %>
                                        <strong>Pendiente</strong>
                                    <% } %>
                                </div>
                            </div>

                            <div class="event-publication-card">
                                <div class="event-publication-header">
                                    <div>
                                        <h3>Texto sugerido para Facebook</h3>
                                        <p>Listo para copiar y pegar en la publicación del evento.</p>
                                    </div>

                                    <div class="event-publication-actions">
                                        <button type="button"
                                                class="event-secondary-btn compact"
                                                id="btnCopiarPublicacion">
                                            <i class="bi bi-clipboard"></i>
                                            Copiar texto
                                        </button>

                                        <button type="button"
                                                class="event-secondary-btn compact"
                                                id="btnGenerarQR"
                                                data-url-formulario="<%= attr(eventoSeleccionado.getUrlFormulario()) %>"
                                                <%= tieneTexto(eventoSeleccionado.getUrlFormulario()) ? "" : "disabled" %>>
                                            <i class="bi bi-qr-code"></i>
                                            Generar QR
                                        </button>
                                    </div>
                                </div>

                                <pre id="textoPublicacion"><%= esc(valorVacio(eventoSeleccionado.getTextoPublicacion())) %></pre>
                            </div>

                            <div class="event-section event-note">
                                <i class="bi bi-info-circle"></i>
                                <div>
                                    <strong>Registros del evento</strong>
                                    <span>Por ahora los registros de asistentes se revisan desde la hoja de respuestas de Google Forms. La integración con Google Forms/Sheets queda preparada para una fase posterior.</span>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="event-empty-detail">
                                <i class="bi bi-megaphone"></i>
                                <h3>Sin evento seleccionado</h3>
                                <p>Crea o selecciona un evento para ver su información.</p>
                            </div>
                        <% } %>
                    </article>
                </section>
            </section>
        </main>
    </div>
</div>

<div class="modal fade" id="modalNuevoEvento" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <form method="post"
              action="<%= request.getContextPath() %>/guardar-evento"
              class="modal-content custom-modal js-event-form">
            <div class="modal-header">
                <div>
                    <h5 class="modal-title">Nuevo evento</h5>
                    <p class="modal-note">Los eventos se crean como borrador y pueden publicarse después.</p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="event-form-grid">
                    <div class="form-group full">
                        <label>Nombre del evento</label>
                        <input type="text" name="nombreEvento" class="form-control" placeholder="Ej. Día del Niño 2026" required>
                    </div>

                    <div class="form-group full">
                        <label>Descripción / Habrá</label>
                        <textarea name="descripcionEvento" class="form-control" rows="4" placeholder="Describe lo que habrá en el evento." required></textarea>
                    </div>

                    <div class="form-group">
                        <label>Fecha</label>
                        <input type="date" name="fechaEvento" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label>Hora inicio</label>
                        <input type="time" name="horaInicio" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label>Hora fin</label>
                        <input type="time" name="horaFin" class="form-control">
                    </div>

                    <div class="form-group">
                        <label>Lugar</label>
                        <input type="text" name="lugar" class="form-control" placeholder="Centro Comunitario Plan Chac" required>
                    </div>

                    <div class="form-group">
                        <label>Responsable</label>
                        <input type="text" name="responsable" class="form-control" placeholder="Nombre del responsable" required>
                    </div>

                    <div class="form-group full">
                        <label>URL del formulario</label>
                        <input type="url" name="urlFormulario" class="form-control" placeholder="https://forms.gle/...">
                    </div>

                    <div class="form-group full">
                        <label>URL de hoja de respuestas</label>
                        <input type="url" name="urlHojaRespuestas" class="form-control" placeholder="https://docs.google.com/spreadsheets/...">
                    </div>

                    <div class="form-group">
                        <label>Google Form ID</label>
                        <input type="text" name="googleFormId" class="form-control" placeholder="Opcional">
                    </div>

                    <div class="form-group">
                        <label>Google Sheet ID</label>
                        <input type="text" name="googleSheetId" class="form-control" placeholder="Opcional">
                    </div>

                    <div class="form-group">
                        <label>Facebook Post ID</label>
                        <input type="text" name="facebookPostId" class="form-control" placeholder="Futuro">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="event-secondary-btn" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="event-primary-btn compact">Guardar evento</button>
            </div>
        </form>
    </div>
</div>

<% if (hayEvento) { %>
<div class="modal fade" id="modalEditarEvento" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <form method="post"
              action="<%= request.getContextPath() %>/actualizar-evento"
              class="modal-content custom-modal js-event-form">
            <input type="hidden" name="idEvento" value="<%= eventoSeleccionado.getIdEvento() %>">

            <div class="modal-header">
                <div>
                    <h5 class="modal-title">Editar evento</h5>
                    <p class="modal-note">Actualiza la información del evento y sus enlaces.</p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="event-form-grid">
                    <div class="form-group full">
                        <label>Nombre del evento</label>
                        <input type="text"
                               name="nombreEvento"
                               class="form-control"
                               value="<%= attr(eventoSeleccionado.getNombreEvento()) %>"
                               required>
                    </div>

                    <div class="form-group full">
                        <label>Descripción / Habrá</label>
                        <textarea name="descripcionEvento" class="form-control" rows="4" required><%= esc(eventoSeleccionado.getDescripcionEvento()) %></textarea>
                    </div>

                    <div class="form-group">
                        <label>Fecha</label>
                        <input type="date"
                               name="fechaEvento"
                               class="form-control"
                               value="<%= valorFechaInput(eventoSeleccionado.getFechaEvento()) %>"
                               required>
                    </div>

                    <div class="form-group">
                        <label>Hora inicio</label>
                        <input type="time"
                               name="horaInicio"
                               class="form-control"
                               value="<%= valorHoraInput(eventoSeleccionado.getHoraInicio()) %>"
                               required>
                    </div>

                    <div class="form-group">
                        <label>Hora fin</label>
                        <input type="time"
                               name="horaFin"
                               class="form-control"
                               value="<%= valorHoraInput(eventoSeleccionado.getHoraFin()) %>">
                    </div>

                    <div class="form-group">
                        <label>Lugar</label>
                        <input type="text"
                               name="lugar"
                               class="form-control"
                               value="<%= attr(eventoSeleccionado.getLugar()) %>"
                               required>
                    </div>

                    <div class="form-group">
                        <label>Responsable</label>
                        <input type="text"
                               name="responsable"
                               class="form-control"
                               value="<%= attr(eventoSeleccionado.getResponsable()) %>"
                               required>
                    </div>

                    <div class="form-group full">
                        <label>URL del formulario</label>
                        <input type="url"
                               name="urlFormulario"
                               class="form-control"
                               value="<%= attr(eventoSeleccionado.getUrlFormulario()) %>">
                    </div>

                    <div class="form-group full">
                        <label>URL de hoja de respuestas</label>
                        <input type="url"
                               name="urlHojaRespuestas"
                               class="form-control"
                               value="<%= attr(eventoSeleccionado.getUrlHojaRespuestas()) %>">
                    </div>

                    <div class="form-group">
                        <label>Google Form ID</label>
                        <input type="text"
                               name="googleFormId"
                               class="form-control"
                               value="<%= attr(eventoSeleccionado.getGoogleFormId()) %>">
                    </div>

                    <div class="form-group">
                        <label>Google Sheet ID</label>
                        <input type="text"
                               name="googleSheetId"
                               class="form-control"
                               value="<%= attr(eventoSeleccionado.getGoogleSheetId()) %>">
                    </div>

                    <div class="form-group">
                        <label>Facebook Post ID</label>
                        <input type="text"
                               name="facebookPostId"
                               class="form-control"
                               value="<%= attr(eventoSeleccionado.getFacebookPostId()) %>">
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="event-secondary-btn" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="event-primary-btn compact">Guardar cambios</button>
            </div>
        </form>
    </div>
</div>
<% } %>

<div class="modal fade" id="modalQR" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content custom-modal">
            <div class="modal-header">
                <div>
                    <h5 class="modal-title">QR del formulario</h5>
                    <p class="modal-note">Este QR apunta al enlace del formulario del evento.</p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="qr-box">
                    <div id="qrContainer"></div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="event-secondary-btn" data-bs-dismiss="modal">Cerrar</button>
                <button type="button" class="event-primary-btn compact" id="btnDescargarQR">
                    Descargar QR
                </button>
            </div>
        </div>
    </div>
</div>

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
    private String esc(String valor) {
        if (valor == null) {
            return "";
        }

        return valor
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String attr(String valor) {
        return esc(valor).replace("\n", "&#10;").replace("\r", "");
    }

    private boolean tieneTexto(String valor) {
        return valor != null && !valor.isBlank();
    }

    private String valorVacio(String valor) {
        if (valor == null || valor.isBlank()) {
            return "Sin información registrada.";
        }

        return valor;
    }

    private String formatoFecha(Date fecha) {
        if (fecha == null) {
            return "--";
        }

        return new SimpleDateFormat("dd/MM/yyyy").format(fecha);
    }

    private String formatoHora(Time hora) {
        if (hora == null) {
            return "--";
        }

        return new SimpleDateFormat("HH:mm").format(hora);
    }

    private String valorFechaInput(Date fecha) {
        if (fecha == null) {
            return "";
        }

        return fecha.toString();
    }

    private String valorHoraInput(Time hora) {
        if (hora == null) {
            return "";
        }

        return new SimpleDateFormat("HH:mm").format(hora);
    }

    private String obtenerClaseEstado(String estado) {
        if (estado == null) {
            return "draft";
        }

        switch (estado) {
            case "Publicado":
                return "published";
            case "Finalizado":
                return "finished";
            case "Cancelado":
                return "cancelled";
            case "Borrador":
            default:
                return "draft";
        }
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
<script src="<%= request.getContextPath() %>/js/eventos.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>