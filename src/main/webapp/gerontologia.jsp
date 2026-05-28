<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.Period" %>
<%@ page import="com.cdc.model.GerontologiaPaciente" %>
<%@ page import="com.cdc.model.GerontologiaConsulta" %>

<%
    List<GerontologiaPaciente> pacientes =
            (List<GerontologiaPaciente>) request.getAttribute("pacientesGerontologia");

    GerontologiaPaciente pacienteSeleccionado =
            (GerontologiaPaciente) request.getAttribute("pacienteSeleccionado");

    List<GerontologiaConsulta> consultas =
            (List<GerontologiaConsulta>) request.getAttribute("consultasPaciente");

    String tipoMensaje = request.getParameter("tipoMensaje");
    String mensaje = request.getParameter("mensaje");

    String textoMensaje = null;

    if (mensaje != null) {
        switch (mensaje) {
            case "paciente_creado":
                textoMensaje = "Expediente de gerontología creado correctamente.";
                break;
            case "paciente_no_creado":
                textoMensaje = "No se pudo crear el expediente de gerontología.";
                break;
            case "paciente_alumno_invalido":
                textoMensaje = "Debes seleccionar un alumno válido.";
                break;
            case "paciente_alumno_no_encontrado":
                textoMensaje = "No se encontró el alumno seleccionado.";
                break;
            case "paciente_alumno_no_activo":
                textoMensaje = "Solo puedes crear expedientes para alumnos activos.";
                break;
            case "paciente_ya_existe":
                textoMensaje = "Este alumno ya tiene expediente de gerontología.";
                break;
            case "paciente_archivado":
                textoMensaje = "El expediente fue archivado correctamente.";
                break;
            case "paciente_reactivado":
                textoMensaje = "El expediente fue reactivado correctamente.";
                break;
            case "paciente_id_invalido":
                textoMensaje = "El expediente seleccionado no es válido.";
                break;
            case "paciente_no_encontrado":
                textoMensaje = "No se encontró el expediente seleccionado.";
                break;
            case "paciente_estado_invalido":
                textoMensaje = "El estado del expediente no es válido.";
                break;
            case "paciente_estado_sin_cambios":
                textoMensaje = "El expediente ya tenía ese estado.";
                break;
            case "paciente_estado_no_actualizado":
                textoMensaje = "No se pudo actualizar el estado del expediente.";
                break;
            case "consulta_creada":
                textoMensaje = "Consulta registrada correctamente.";
                break;
            case "consulta_no_creada":
                textoMensaje = "No se pudo registrar la consulta.";
                break;
            case "consulta_actualizada":
                textoMensaje = "Consulta actualizada correctamente.";
                break;
            case "consulta_no_actualizada":
                textoMensaje = "No se pudo actualizar la consulta.";
                break;
            case "consulta_motivo_obligatorio":
                textoMensaje = "El motivo de consulta es obligatorio.";
                break;
            case "consulta_id_invalido":
                textoMensaje = "La consulta seleccionada no es válida.";
                break;
            case "consulta_no_encontrada":
                textoMensaje = "No se encontró la consulta seleccionada.";
                break;
            case "paciente_archivado_no_consulta":
                textoMensaje = "No puedes agregar consultas a un expediente archivado.";
                break;
            case "paciente_archivado_no_editar_consulta":
                textoMensaje = "No puedes editar consultas de un expediente archivado.";
                break;

            case "paciente_nombre_obligatorio":
                textoMensaje = "El nombre completo del paciente es obligatorio.";
                break;

            case "paciente_curp_obligatoria":
                textoMensaje = "La CURP del paciente es obligatoria.";
                break;

            case "paciente_curp_invalida":
                textoMensaje = "La CURP debe tener 18 caracteres alfanuméricos.";
                break;

            case "paciente_curp_duplicada":
                textoMensaje = "Ya existe un expediente de gerontología con esa CURP.";
                break;

            case "paciente_celular_invalido":
                textoMensaje = "El teléfono debe contener exactamente 10 dígitos.";
                break;

            case "paciente_fecha_nacimiento_obligatoria":
                textoMensaje = "La fecha de nacimiento es obligatoria.";
                break;

            case "paciente_fecha_nacimiento_futura":
                textoMensaje = "La fecha de nacimiento no puede ser futura.";
                break;

            case "paciente_fecha_nacimiento_invalida":
                textoMensaje = "La fecha de nacimiento no tiene un formato válido.";
                break;

            case "consulta_pdf_id_invalido":
                textoMensaje = "No se pudo generar el PDF porque la consulta no es válida.";
                break;

            case "consulta_pdf_no_encontrada":
                textoMensaje = "No se encontró la consulta solicitada para generar el PDF.";
                break;

            case "consulta_pdf_error":
                textoMensaje = "Ocurrió un error al generar el PDF de la consulta.";
                break;

            case "historial_pdf_id_invalido":
                textoMensaje = "No se pudo generar el PDF porque el expediente no es válido.";
                break;

            case "historial_pdf_error":
                textoMensaje = "Ocurrió un error al generar el PDF del historial.";
                break;

            case "paciente_pdf_no_encontrado":
                textoMensaje = "No se encontró el paciente solicitado para generar el PDF.";
                break;

            case "error_sistema":
                textoMensaje = "Ocurrió un error interno. Revisa la consola de Tomcat.";
                break;
            default:
                textoMensaje = null;
        }
    }

    boolean hayPaciente = pacienteSeleccionado != null;
    boolean pacienteActivo = hayPaciente
            && "Activo".equalsIgnoreCase(pacienteSeleccionado.getEstadoPaciente());

    GerontologiaConsulta consultaInicial = null;

    if (consultas != null && !consultas.isEmpty()) {
        consultaInicial = consultas.get(0);
    }

    String nuevoEstadoPaciente = pacienteActivo ? "Archivado" : "Activo";
    String textoBotonEstado = pacienteActivo ? "Archivar expediente" : "Reactivar expediente";
    String iconoBotonEstado = pacienteActivo ? "bi-archive" : "bi-arrow-clockwise";
    String tituloConfirmacionEstado = pacienteActivo ? "Archivar expediente" : "Reactivar expediente";
    String mensajeConfirmacionEstado = pacienteActivo
            ? "¿Seguro que deseas archivar este expediente? Se conservarán todas sus consultas, pero no se podrán agregar nuevas mientras esté archivado."
            : "¿Seguro que deseas reactivar este expediente? Volverá a permitir nuevas consultas.";
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gerontología - CDC Plan Chac</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

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
                        class="gero-primary-btn"
                        data-bs-toggle="modal"
                        data-bs-target="#modalNuevoExpediente">
                    <i class="bi bi-plus-lg"></i>
                    Nuevo expediente
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
                        <span><%= esc(textoMensaje) %></span>
                    </div>
                    <button type="button" class="cdc-toast-close" onclick="document.getElementById('cdcToast').remove()">×</button>
                </div>
            <% } %>

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
                        <span id="contadorExpedientes" class="gero-count">
                            <%= pacientes != null ? pacientes.size() : 0 %>
                        </span>
                    </div>

                    <div id="listaExpedientes" class="gero-expedientes-list">
                        <%
                            if (pacientes != null && !pacientes.isEmpty()) {
                                for (GerontologiaPaciente paciente : pacientes) {
                                    boolean seleccionado = hayPaciente
                                            && pacienteSeleccionado.getIdPaciente() == paciente.getIdPaciente();

                                    String estadoClase = "Activo".equalsIgnoreCase(paciente.getEstadoPaciente())
                                            ? "active"
                                            : "archived";
                        %>
                                    <a href="<%= request.getContextPath() %>/gerontologia?id=<%= paciente.getIdPaciente() %>"
                                       class="gero-expediente-item <%= seleccionado ? "selected" : "" %>"
                                       data-nombre="<%= attr(paciente.getNombreCompleto() + " " + paciente.getCurp()) %>"
                                       data-estado="<%= attr(paciente.getEstadoPaciente()) %>">

                                        <div class="gero-patient-avatar">
                                            <%= obtenerIniciales(paciente.getNombreCompleto()) %>
                                        </div>

                                        <div class="gero-expediente-body">
                                            <h4><%= esc(paciente.getNombreCompleto()) %></h4>
                                            <p><%= paciente.getEdad() %> años</p>
                                            <p class="gero-expediente-curp">CURP: <%= esc(paciente.getCurp()) %></p>

                                            <div class="gero-expediente-meta">
                                                <p>Última actualización: <%= formatoFechaHoraCorta(paciente.getFechaActualizacion()) %></p>
                                                <span class="status-badge <%= estadoClase %>"><%= esc(paciente.getEstadoPaciente()) %></span>
                                            </div>
                                        </div>
                                    </a>
                        <%
                                }
                            } else {
                        %>
                            <div class="gero-empty-small">
                                No hay expedientes de gerontología registrados.
                            </div>
                        <%
                            }
                        %>
                    </div>

                    <div id="expedienteEmptyFilter" class="gero-empty-small oculto">
                        No se encontraron expedientes con los filtros seleccionados.
                    </div>
                </aside>

                <section class="gero-detail-column">
                    <article class="gero-patient-card">
                        <% if (hayPaciente) { %>
                            <div class="gero-patient-avatar" id="expedienteIniciales">
                                <%= obtenerIniciales(pacienteSeleccionado.getNombreCompleto()) %>
                            </div>

                            <div class="gero-patient-info">
                                <div class="gero-patient-title-row">
                                    <h2 id="expedienteNombre"><%= esc(pacienteSeleccionado.getNombreCompleto()) %></h2>
                                    <span id="expedienteEstado"
                                          class="status-badge <%= pacienteActivo ? "active" : "archived" %>">
                                        <%= esc(pacienteSeleccionado.getEstadoPaciente()) %>
                                    </span>
                                </div>

                                <div class="gero-patient-meta">
                                    <span>
                                        <i class="bi bi-person"></i>
                                        <strong><%= pacienteSeleccionado.getEdad() %> años</strong>
                                    </span>

                                    <span>
                                        <i class="bi bi-card-text"></i>
                                        CURP:
                                        <strong><%= esc(pacienteSeleccionado.getCurp()) %></strong>
                                    </span>

                                    <span>
                                        <i class="bi bi-telephone"></i>
                                        Teléfono:
                                        <strong><%= esc(pacienteSeleccionado.getCelular()) %></strong>
                                    </span>

                                    <span>
                                        <i class="bi bi-calendar-heart"></i>
                                        Nacimiento:
                                        <strong><%= pacienteSeleccionado.getFechaNacimiento() != null ? pacienteSeleccionado.getFechaNacimiento().toString() : "--" %></strong>
                                    </span>

                                    <span>
                                        <i class="bi bi-clock-history"></i>
                                        Última actualización:
                                        <strong><%= formatoFechaHora(pacienteSeleccionado.getFechaActualizacion()) %></strong>
                                    </span>
                                </div>
                            </div>

                            <div class="gero-patient-actions">
                                <button type="button"
                                        class="gero-primary-btn compact"
                                        id="btnNuevaConsulta"
                                        <%= pacienteActivo ? "" : "disabled" %>>
                                    <i class="bi bi-plus-lg"></i>
                                    Nueva consulta
                                </button>

                                <a href="<%= request.getContextPath() %>/descargar-historial-gerontologia-pdf?idPaciente=<%= pacienteSeleccionado.getIdPaciente() %>"
                                class="gero-secondary-btn gero-pdf-btn">
                                    <i class="bi bi-file-earmark-pdf"></i>
                                    Descargar historial PDF
                                </a>



                                <form method="post"
                                      action="<%= request.getContextPath() %>/cambiar-estado-paciente-gerontologia"
                                      class="js-confirm-submit"
                                      data-confirm-title="<%= attr(tituloConfirmacionEstado) %>"
                                      data-confirm-message="<%= attr(mensajeConfirmacionEstado) %>"
                                      data-confirm-confirm-text="<%= attr(textoBotonEstado) %>"
                                      data-confirm-danger="<%= pacienteActivo ? "true" : "false" %>"
                                      style="display:inline;">
                                    <input type="hidden" name="idPaciente" value="<%= pacienteSeleccionado.getIdPaciente() %>">
                                    <input type="hidden" name="nuevoEstado" value="<%= nuevoEstadoPaciente %>">

                                    <button type="submit" class="gero-outline-danger-btn">
                                        <i class="bi <%= iconoBotonEstado %>"></i>
                                        <span><%= textoBotonEstado %></span>
                                    </button>
                                </form>
                            </div>
                        <% } else { %>
                            <div class="gero-empty-state">
                                <div>
                                    <i class="bi bi-journal-medical"></i>
                                    <h3>Sin expediente seleccionado</h3>
                                    <p>Crea o selecciona un expediente para comenzar.</p>
                                </div>
                            </div>
                        <% } %>

                    </article>

                    <section class="gero-consultas-card">
                        <div class="gero-consultas-list-panel">
                            <div class="section-header">
                                <h3>Consultas</h3>
                            </div>

                            <div id="listaConsultas" class="gero-consultas-list">
                                <%
                                    if (consultas != null && !consultas.isEmpty()) {
                                        for (GerontologiaConsulta consulta : consultas) {
                                            boolean consultaSeleccionada = consultaInicial != null
                                                    && consultaInicial.getIdConsulta() == consulta.getIdConsulta();
                                %>
                                            <article class="gero-consulta-item <%= consultaSeleccionada ? "selected" : "" %>"
                                                     data-consulta-id="<%= consulta.getIdConsulta() %>"
                                                     data-fecha="<%= attr(formatoFechaHora(consulta.getFechaConsulta())) %>"
                                                     data-paciente="<%= attr(consulta.getNombrePacienteSnapshot()) %>"
                                                     data-edad="<%= consulta.getEdadPacienteSnapshot() %> años"
                                                     data-motivo="<%= attr(consulta.getMotivoConsulta()) %>"
                                                     data-antecedentes="<%= attr(consulta.getAntecedentes()) %>"
                                                     data-notas="<%= attr(consulta.getNotas()) %>">

                                                <div class="gero-consulta-icon">
                                                    <i class="bi bi-calendar2-week"></i>
                                                </div>

                                                <div>
                                                    <h4><%= formatoFechaHoraCorta(consulta.getFechaConsulta()) %></h4>
                                                    <p><%= esc(resumenConsulta(consulta.getMotivoConsulta())) %></p>
                                                </div>
                                            </article>
                                <%
                                        }
                                    } else {
                                %>
                                    <div class="gero-empty-small">
                                        No hay consultas registradas.
                                    </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>

                        <div class="gero-consulta-detail-panel">
                            <div class="gero-consulta-detail-header">
                                <h3 id="consultaPanelTitulo">
                                    <%= consultaInicial != null ? "Detalle de la consulta" : "Sin consultas registradas" %>
                                </h3>

                            <div class="gero-consulta-actions" id="consultaActions">
                                <% if (hayPaciente && consultaInicial != null && pacienteActivo) { %>
                                    <button type="button" class="table-icon-btn" id="btnEditarConsulta" title="Editar consulta">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                <% } %>

                                <% if (hayPaciente && consultaInicial != null) { %>
                                    <a href="<%= request.getContextPath() %>/descargar-consulta-gerontologia-pdf?idConsulta=<%= consultaInicial.getIdConsulta() %>"
                                    id="btnDescargarConsultaPdf"
                                    class="table-icon-btn gero-pdf-icon-btn"
                                    title="Descargar consulta PDF">
                                        <i class="bi bi-file-earmark-pdf"></i>
                                    </a>
                                <% } else { %>
                                    <a href="#"
                                    id="btnDescargarConsultaPdf"
                                    class="table-icon-btn gero-pdf-icon-btn disabled"
                                    title="Descargar consulta PDF"
                                    aria-disabled="true">
                                        <i class="bi bi-file-earmark-pdf"></i>
                                    </a>
                                <% } %>
                            </div>
                            </div>

                            <div id="consultaVista" class="gero-consulta-view <%= consultaInicial == null ? "oculto" : "" %>">
                                <div class="gero-detail-grid">
                                    <div class="gero-detail-item">
                                        <span>Fecha y hora</span>
                                        <strong id="consultaFecha"><%= consultaInicial != null ? formatoFechaHora(consultaInicial.getFechaConsulta()) : "--" %></strong>
                                    </div>

                                    <div class="gero-detail-item">
                                        <span>Paciente</span>
                                        <strong id="consultaPaciente"><%= consultaInicial != null ? esc(consultaInicial.getNombrePacienteSnapshot()) : "--" %></strong>
                                    </div>

                                    <div class="gero-detail-item">
                                        <span>Edad</span>
                                        <strong id="consultaEdad"><%= consultaInicial != null ? consultaInicial.getEdadPacienteSnapshot() + " años" : "--" %></strong>
                                    </div>
                                </div>

                                <div class="gero-clinical-block">
                                    <h4>Motivo de consulta</h4>
                                    <p id="consultaMotivo"><%= consultaInicial != null ? esc(consultaInicial.getMotivoConsulta()) : "--" %></p>
                                </div>

                                <div class="gero-clinical-block">
                                    <h4>Antecedentes</h4>
                                    <p id="consultaAntecedentes"><%= consultaInicial != null ? esc(valorVacio(consultaInicial.getAntecedentes())) : "--" %></p>
                                </div>

                                <div class="gero-clinical-block">
                                    <h4>Notas</h4>
                                    <p id="consultaNotas"><%= consultaInicial != null ? esc(valorVacio(consultaInicial.getNotas())) : "--" %></p>
                                </div>
                            </div>

                            <form id="consultaForm"
                                  method="post"
                                  action="<%= request.getContextPath() %>/crear-consulta-gerontologia"
                                  data-url-crear="<%= request.getContextPath() %>/crear-consulta-gerontologia"
                                  data-url-actualizar="<%= request.getContextPath() %>/actualizar-consulta-gerontologia"
                                  class="gero-consulta-form oculto">
                                <% if (hayPaciente) { %>
                                    <input type="hidden" name="idPaciente" value="<%= pacienteSeleccionado.getIdPaciente() %>">
                                <% } %>

                                <input type="hidden" name="idConsulta" id="idConsultaInput">

                                <div class="gero-form-note">
                                    <i class="bi bi-clipboard2-pulse"></i>
                                    <div>
                                        <strong id="consultaFormPaciente">
                                            <%= hayPaciente ? esc(pacienteSeleccionado.getNombreCompleto()) : "Paciente" %>
                                        </strong>
                                        <span id="consultaFormMeta">
                                            <%= hayPaciente ? pacienteSeleccionado.getEdad() + " años" : "--" %>
                                        </span>
                                    </div>
                                </div>

                                <div class="form-group full">
                                    <label for="consultaMotivoInput">Motivo de consulta</label>
                                    <textarea id="consultaMotivoInput" name="motivoConsulta" class="form-control" rows="3" required></textarea>
                                </div>

                                <div class="form-group full">
                                    <label for="consultaAntecedentesInput">Antecedentes</label>
                                    <textarea id="consultaAntecedentesInput" name="antecedentes" class="form-control" rows="3"></textarea>
                                </div>

                                <div class="form-group full">
                                    <label for="consultaNotasInput">Notas</label>
                                    <textarea id="consultaNotasInput" name="notas" class="form-control" rows="4"></textarea>
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

                            <div id="consultaEmptyState" class="gero-empty-state <%= consultaInicial == null ? "" : "oculto" %>">
                                <div>
                                    <i class="bi bi-journal-medical"></i>
                                    <h3>Sin consultas registradas</h3>
                                    <p>Usa el botón “Nueva consulta” para agregar el primer seguimiento del expediente.</p>
                                </div>
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
        <form method="post"
              action="<%= request.getContextPath() %>/crear-paciente-gerontologia"
              class="modal-content custom-modal"
              id="formNuevoPaciente">

            <div class="modal-header">
                <div>
                    <h5 class="modal-title">Nuevo expediente</h5>
                    <p class="modal-note">
                        Registra los datos básicos del paciente para crear su expediente de gerontología.
                    </p>
                </div>

                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <div class="gero-modal-grid">
                    <div class="form-group full">
                        <label for="pacienteNombreCompleto">Nombre completo</label>
                        <input type="text"
                               id="pacienteNombreCompleto"
                               name="nombreCompleto"
                               class="form-control"
                               maxlength="150"
                               required>
                    </div>

                    <div class="form-group full">
                        <label for="pacienteCurp">CURP</label>
                        <input type="text"
                               id="pacienteCurp"
                               name="curp"
                               class="form-control"
                               maxlength="18"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="pacienteCelular">Teléfono</label>
                        <input type="text"
                               id="pacienteCelular"
                               name="celular"
                               class="form-control"
                               maxlength="10"
                               inputmode="numeric"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="pacienteFechaNacimiento">Fecha de nacimiento</label>
                        <input type="date"
                               id="pacienteFechaNacimiento"
                               name="fechaNacimiento"
                               class="form-control"
                               required>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="gero-secondary-btn" data-bs-dismiss="modal">Cancelar</button>

                <button type="submit" class="gero-primary-btn compact">
                    Crear expediente
                </button>
            </div>
        </form>
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

    private String formatoFechaHora(Timestamp timestamp) {
        if (timestamp == null) {
            return "--";
        }

        return new SimpleDateFormat("dd/MM/yyyy HH:mm").format(timestamp);
    }

    private String formatoFechaHoraCorta(Timestamp timestamp) {
        if (timestamp == null) {
            return "--";
        }

        return new SimpleDateFormat("dd/MM/yyyy HH:mm").format(timestamp);
    }

    private int calcularEdad(Date fechaNacimiento) {
        if (fechaNacimiento == null) {
            return 0;
        }

        LocalDate nacimiento = fechaNacimiento.toLocalDate();
        return Period.between(nacimiento, LocalDate.now()).getYears();
    }

    private String valorVacio(String valor) {
        if (valor == null || valor.isBlank()) {
            return "Sin información registrada.";
        }

        return valor;
    }

    private String resumenConsulta(String motivo) {
        if (motivo == null || motivo.isBlank()) {
            return "Consulta";
        }

        if (motivo.length() <= 32) {
            return motivo;
        }

        return motivo.substring(0, 32) + "...";
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
<script src="<%= request.getContextPath() %>/js/gerontologia.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>