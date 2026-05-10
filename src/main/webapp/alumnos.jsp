<%@ page import="java.util.List" %>
<%@ page import="com.cdc.model.Alumno" %>
<%@ page import="com.cdc.model.ActividadAlumnoDetalle" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Alumno> listaAlumnos = (List<Alumno>) request.getAttribute("listaAlumnos");
    Alumno alumnoSeleccionado = (Alumno) request.getAttribute("alumnoSeleccionado");
    List<ActividadAlumnoDetalle> actividadesAlumno =
            (List<ActividadAlumnoDetalle>) request.getAttribute("actividadesAlumno");

    int totalActividadesInscritas = 0;
    int totalAsistenciasMes = 0;

    if (actividadesAlumno != null) {
        totalActividadesInscritas = actividadesAlumno.size();

        for (ActividadAlumnoDetalle actividad : actividadesAlumno) {
            totalAsistenciasMes += actividad.getAsistenciasDelMes();
        }
    }
%>


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
            <a href="<%= request.getContextPath() %>/dashboard" class="nav-item">
                <i class="bi bi-grid-1x2-fill"></i>
                <span class="nav-label">Dashboard</span>
            </a>

            <a href="<%= request.getContextPath() %>/actividades" class="nav-item">
                <i class="bi bi-calendar3"></i>
                <span class="nav-label">Actividades</span>
            </a>

            <a href="<%= request.getContextPath() %>/alumnos" class="nav-item active">
                <i class="bi bi-people-fill"></i>
                <span class="nav-label">Alumnos</span>
            </a>

            <a href="<%= request.getContextPath() %>/reportes" class="nav-item">
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

            <%
                String tipoMensaje = request.getParameter("tipoMensaje");
                String mensaje = request.getParameter("mensaje");

                String textoMensaje = null;

                if (mensaje != null) {
                    switch (mensaje) {
                        case "alumno_guardado":
                            textoMensaje = "Alumno guardado correctamente.";
                            break;
                        case "alumno_actualizado":
                            textoMensaje = "Alumno actualizado correctamente.";
                            break;
                        case "alumno_no_guardado":
                            textoMensaje = "No se pudo guardar el alumno.";
                            break;
                        case "alumno_no_actualizado":
                            textoMensaje = "No se pudo actualizar el alumno.";
                            break;
                        case "nombre_obligatorio":
                            textoMensaje = "El nombre completo es obligatorio.";
                            break;
                        case "nombre_invalido":
                            textoMensaje = "El nombre no debe contener números y debe tener al menos 3 caracteres.";
                            break;
                        case "fecha_obligatoria":
                            textoMensaje = "La fecha de nacimiento es obligatoria.";
                            break;
                        case "fecha_invalida":
                            textoMensaje = "La fecha de nacimiento no tiene un formato válido.";
                            break;
                        case "fecha_futura":
                            textoMensaje = "La fecha de nacimiento no puede ser futura.";
                            break;
                        case "curp_obligatoria":
                            textoMensaje = "La CURP es obligatoria.";
                            break;
                        case "curp_invalida":
                            textoMensaje = "La CURP debe tener 18 caracteres alfanuméricos.";
                            break;
                        case "celular_invalido":
                            textoMensaje = "El celular debe tener 10 dígitos.";
                            break;
                        case "domicilio_invalido":
                            textoMensaje = "El domicilio debe tener al menos 5 caracteres.";
                            break;
                        case "estado_invalido":
                            textoMensaje = "El estado del alumno no es válido.";
                            break;
                        case "id_alumno_invalido":
                            textoMensaje = "El identificador del alumno no es válido.";
                            break;
                        case "error_sistema":
                            textoMensaje = "Ocurrió un error interno. Revisa la consola de Tomcat.";
                            break;

                        case "alumno_reactivado":
                            textoMensaje = "Alumno reactivado correctamente. Ya puede inscribirse y aparecer en asistencia.";
                            break;
                        case "alumno_inactivado":
                            textoMensaje = "Alumno marcado como inactivo correctamente. Conserva su historial, pero no aparecerá en asistencia.";
                            break;
                        case "alumno_dado_baja":
                            textoMensaje = "Alumno dado de baja correctamente. Su historial se conservará.";
                            break;
                        case "estado_alumno_id_invalido":
                            textoMensaje = "El identificador del alumno no es válido.";
                            break;
                        case "estado_alumno_invalido":
                            textoMensaje = "El nuevo estado del alumno no es válido.";
                            break;
                        case "estado_alumno_no_encontrado":
                            textoMensaje = "No se encontró el alumno seleccionado.";
                            break;
                        case "estado_alumno_sin_cambios":
                            textoMensaje = "El alumno ya tenía ese estado.";
                            break;
                        case "estado_alumno_no_actualizado":
                            textoMensaje = "No se pudo actualizar el estado del alumno.";
                            break;
                        
                        default:
                            textoMensaje = null;
                    }
                }

                if (textoMensaje != null) {
                    String claseAlerta = "exito".equalsIgnoreCase(tipoMensaje) ? "alert-success" : "alert-danger";
            %>
                <div class="cdc-toast <%= "exito".equalsIgnoreCase(tipoMensaje) ? "cdc-toast-success" : "cdc-toast-error" %>">
                    <div class="cdc-toast-icon">
                        <%= "exito".equalsIgnoreCase(tipoMensaje) ? "✓" : "!" %>
                    </div>

                    <div class="cdc-toast-content">
                        <strong>
                            <%= "exito".equalsIgnoreCase(tipoMensaje) ? "Operación exitosa" : "Revisa la información" %>
                        </strong>
                        <span><%= textoMensaje %></span>
                    </div>

                    <button type="button" class="cdc-toast-close" onclick="this.parentElement.style.display='none'">
                        ×
                    </button>
                </div>
            <%
                }
            %>

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
                        <%
                            if (listaAlumnos != null && !listaAlumnos.isEmpty()) {
                                boolean primero = true;
                                for (Alumno alumno : listaAlumnos) {
                                    String iniciales = "";
                                    String[] partes = alumno.getNombreCompleto().trim().split("\\s+");
                                    if (partes.length >= 2) {
                                        iniciales = partes[0].substring(0, 1).toUpperCase() + partes[1].substring(0, 1).toUpperCase();
                                    } else if (partes.length == 1) {
                                        iniciales = partes[0].substring(0, 1).toUpperCase();
                                    }

                                    String estado = alumno.getEstadoAlumno();
                                    String claseEstado = estado.equalsIgnoreCase("Inactivo") || estado.equalsIgnoreCase("Baja")
                                            ? "inactive"
                                            : "active";
                        %>
                            <article class="student-list-item <%= (alumnoSeleccionado != null && alumnoSeleccionado.getIdAlumno() == alumno.getIdAlumno()) ? "selected" : "" %>"
                                data-student-id="<%= alumno.getIdAlumno() %>"
                                onclick="window.location.href='<%= request.getContextPath() %>/alumnos?id=<%= alumno.getIdAlumno() %>'">
                                <div class="student-list-avatar"><%= iniciales %></div>

                                <div class="student-list-body">
                                    <div class="student-list-top">
                                        <h4><%= alumno.getNombreCompleto() %></h4>
                                        <span class="status-badge <%= claseEstado %>"><%= estado %></span>
                                    </div>
                                    <p class="student-list-phone"><%= alumno.getCelular() %></p>
                                    <p class="student-list-meta">
                                        ID: <%= alumno.getIdAlumno() %>
                                    </p>
                                </div>
                            </article>
                        <%
                                    primero = false;
                                }
                            } else {
                        %>
                            <p>No hay alumnos registrados.</p>
                        <%
                            }
                        %>
                    </div>
                </section>

                <!-- Derecha -->
                <section class="student-detail-column">
                    <!-- Ficha -->
                    <section class="student-detail-card">
                        <div class="student-detail-main">
                            <div class="student-detail-avatar" id="studentDetailAvatar">
                                <%
                                    if (alumnoSeleccionado != null) {
                                        String[] partes = alumnoSeleccionado.getNombreCompleto().trim().split("\\s+");
                                        if (partes.length >= 2) {
                                            out.print(partes[0].substring(0, 1).toUpperCase() + partes[1].substring(0, 1).toUpperCase());
                                        } else if (partes.length == 1) {
                                            out.print(partes[0].substring(0, 1).toUpperCase());
                                        }
                                    } else {
                                        out.print("--");
                                    }
                                %>
                            </div>

                            <div class="student-detail-info">
                                <div class="student-detail-title-row">
                                    <h2 id="studentDetailName"><%= alumnoSeleccionado != null ? alumnoSeleccionado.getNombreCompleto() : "Sin alumno" %></h2>
                                    <span class="status-badge <%= (alumnoSeleccionado != null && (alumnoSeleccionado.getEstadoAlumno().equalsIgnoreCase("Inactivo") || alumnoSeleccionado.getEstadoAlumno().equalsIgnoreCase("Baja"))) ? "inactive" : "active" %>" id="studentDetailStatus">
                                        <%= alumnoSeleccionado != null ? alumnoSeleccionado.getEstadoAlumno() : "N/D" %>
                                    </span>
                                </div>

                                <div class="student-detail-grid">
                                    <div class="detail-item">
                                        <span class="detail-label">Fecha de nacimiento</span>
                                        <span class="detail-value" id="studentDetailBirthDate">
                                            <%= alumnoSeleccionado != null ? alumnoSeleccionado.getFechaNacimiento() : "" %>
                                        </span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Celular</span>
                                        <span class="detail-value" id="studentDetailPhone">
                                            <%= alumnoSeleccionado != null ? alumnoSeleccionado.getCelular() : "" %>
                                        </span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">CURP</span>
                                        <span class="detail-value" id="studentDetailCurp">
                                            <%= alumnoSeleccionado != null ? alumnoSeleccionado.getCurp() : "" %>
                                        </span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Actividades inscritas</span>
                                        <span class="detail-value" id="studentActivitiesCount"><%= totalActividadesInscritas %></span>
                                    </div>

                                    <div class="detail-item full">
                                        <span class="detail-label">Domicilio</span>
                                        <span class="detail-value" id="studentDetailAddress">
                                            <%= alumnoSeleccionado != null ? alumnoSeleccionado.getDomicilio() : "" %>
                                        </span>
                                    </div>

                                    <div class="detail-item">
                                        <span class="detail-label">Asistencias del mes</span>
                                        <span class="metric-value" id="studentAttendanceCount"><%= totalAsistenciasMes %></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%
                            boolean alumnoActivo = alumnoSeleccionado != null
                                    && "Activo".equalsIgnoreCase(alumnoSeleccionado.getEstadoAlumno());

                            String mensajeConfirmacionAlumno = alumnoActivo
                                    ? "¿Seguro que deseas dar de baja a este alumno? Seguirá existiendo en el historial del sistema."
                                    : "¿Seguro que deseas reactivar a este alumno? Volverá a aparecer como disponible en el sistema.";

                            String nuevoEstadoAlumno = alumnoActivo ? "Baja" : "Activo";
                            String claseBotonAlumno = alumnoActivo ? "danger" : "secondary";
                            String iconoBotonAlumno = alumnoActivo ? "bi-person-dash-fill" : "bi-arrow-clockwise";
                            String textoBotonAlumno = alumnoActivo ? "Dar de baja" : "Reactivar";
                        %>

                        <div class="student-actions">
                            <button class="action-btn secondary" type="button" data-bs-toggle="modal" data-bs-target="#modalEditarAlumno">
                                <i class="bi bi-pencil-square"></i>
                                <span>Editar</span>
                            </button>

                            <form method="post"
                                action="<%= request.getContextPath() %>/cambiar-estado-alumno"
                                onsubmit="return confirm('<%= mensajeConfirmacionAlumno %>');"
                                style="display: inline;">
                                <input type="hidden" name="idAlumno"
                                    value="<%= alumnoSeleccionado != null ? alumnoSeleccionado.getIdAlumno() : 0 %>">

                                <input type="hidden" name="nuevoEstado"
                                    value="<%= nuevoEstadoAlumno %>">

                                <button type="submit" class="action-btn <%= claseBotonAlumno %>">
                                    <i class="bi <%= iconoBotonAlumno %>"></i>
                                    <span><%= textoBotonAlumno %></span>
                                </button>
                            </form>
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
                                <%
                                    if (actividadesAlumno != null && !actividadesAlumno.isEmpty()) {
                                        for (ActividadAlumnoDetalle actividad : actividadesAlumno) {
                                            String claseEstadoActividad = actividad.getEstadoActividad().equalsIgnoreCase("Inactiva")
                                                    ? "inactive"
                                                    : "active";
                                %>
                                <tr>
                                    <td><%= actividad.getNombreActividad() %></td>
                                    <td><%= actividad.getNombreInstructor() %></td>
                                    <td><%= actividad.getHorarios() %></td>
                                    <td><%= actividad.getAsistenciasDelMes() %></td>
                                    <td>
                                        <span class="status-badge <%= claseEstadoActividad %>">
                                            <%= actividad.getEstadoActividad() %>
                                        </span>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="5">Este alumno no tiene actividades inscritas.</td>
                                </tr>
                                <%
                                    }
                                %>
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
            <form method="post" action="<%= request.getContextPath() %>/guardar-alumno">
                <div class="modal-header">
                    <h5 class="modal-title">Nuevo alumno</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <div class="student-form-grid">
                        <div class="form-group">
                            <label for="studentName">Nombre completo</label>
                            <input type="text" id="studentName" name="nombreCompleto" class="form-control" placeholder="Ej. Carla Gómez" required>
                        </div>

                        <div class="form-group">
                            <label for="studentBirthDate">Fecha de nacimiento</label>
                            <input type="date" id="studentBirthDate" name="fechaNacimiento" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="studentCurp">CURP</label>
                            <input type="text" id="studentCurp" name="curp" class="form-control" placeholder="Ej. GOGC090512MQRMLRA3" required maxlength="18">
                        </div>

                        <div class="form-group">
                            <label for="studentPhone">Celular</label>
                            <input type="text" id="studentPhone" name="celular" class="form-control" placeholder="Ej. 999 123 4567" required>
                        </div>

                        <div class="form-group full">
                            <label for="studentAddress">Domicilio</label>
                                <textarea id="studentAddress" name="domicilio" class="form-control" rows="3" placeholder="Ej. Calle 24 #123, Col. Centro, Chetumal, Quintana Roo, C.P. 77000" required></textarea>
                            </div>

                        <input type="hidden" name="estadoAlumno" value="Activo">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn activity-primary-btn modal-save-btn">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Editar alumno -->
<div class="modal fade" id="modalEditarAlumno" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content custom-modal">
            <form method="post" action="<%= request.getContextPath() %>/actualizar-alumno">
                <div class="modal-header">
                    <h5 class="modal-title">Editar alumno</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <input type="hidden" name="idAlumno" value="<%= alumnoSeleccionado != null ? alumnoSeleccionado.getIdAlumno() : 0 %>">

                    <div class="student-form-grid">
                        <div class="form-group">
                            <label for="editStudentName">Nombre completo</label>
                            <input type="text"
                                   id="editStudentName"
                                   name="nombreCompleto"
                                   class="form-control"
                                   value="<%= alumnoSeleccionado != null ? alumnoSeleccionado.getNombreCompleto() : "" %>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="editStudentBirthDate">Fecha de nacimiento</label>
                            <input type="date"
                                   id="editStudentBirthDate"
                                   name="fechaNacimiento"
                                   class="form-control"
                                   value="<%= alumnoSeleccionado != null && alumnoSeleccionado.getFechaNacimiento() != null ? alumnoSeleccionado.getFechaNacimiento().toString() : "" %>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="editStudentCurp">CURP</label>
                            <input type="text"
                                   id="editStudentCurp"
                                   name="curp"
                                   class="form-control"
                                   value="<%= alumnoSeleccionado != null ? alumnoSeleccionado.getCurp() : "" %>"
                                   maxlength="18"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="editStudentPhone">Celular</label>
                            <input type="text"
                                   id="editStudentPhone"
                                   name="celular"
                                   class="form-control"
                                   value="<%= alumnoSeleccionado != null ? alumnoSeleccionado.getCelular() : "" %>"
                                   required>
                        </div>

                        <div class="form-group full">
                            <label for="editStudentAddress">Domicilio</label>
                            <textarea id="editStudentAddress"
                                      name="domicilio"
                                      class="form-control"
                                      rows="3"
                                      required><%= alumnoSeleccionado != null ? alumnoSeleccionado.getDomicilio() : "" %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="editStudentStatus">Estado</label>
                            <select id="editStudentStatus" name="estadoAlumno" class="form-select" required>
                                <option value="Activo" <%= alumnoSeleccionado != null && "Activo".equalsIgnoreCase(alumnoSeleccionado.getEstadoAlumno()) ? "selected" : "" %>>Activo</option>
                                <option value="Inactivo" <%= alumnoSeleccionado != null && "Inactivo".equalsIgnoreCase(alumnoSeleccionado.getEstadoAlumno()) ? "selected" : "" %>>Inactivo</option>
                                <option value="Baja" <%= alumnoSeleccionado != null && "Baja".equalsIgnoreCase(alumnoSeleccionado.getEstadoAlumno()) ? "selected" : "" %>>Baja</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn activity-primary-btn modal-save-btn">Guardar cambios</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="cdcMiniModal" class="cdc-mini-modal oculto">
    <div class="cdc-mini-card">
        <button type="button" class="cdc-mini-close" id="cdcMiniClose">×</button>

        <div class="cdc-mini-icon" id="cdcMiniIcon">
            !
        </div>

        <div class="cdc-mini-content">
            <h3 id="cdcMiniTitle">Revisa la información</h3>
            <p id="cdcMiniMessage">Hay un dato inválido.</p>
        </div>

        <button type="button" class="cdc-mini-btn" id="cdcMiniOk">
            Entendido
        </button>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= request.getContextPath() %>/js/dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
<script src="<%= request.getContextPath() %>/js/alumnos.js?v=<%= System.currentTimeMillis() %>"></script>
</body>

</html>