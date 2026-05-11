const alumnosDisponiblesDemo = [
    { id: 101, nombre: "Andrea Ruiz", edad: 71 },
    { id: 102, nombre: "Carla Gómez", edad: 66 },
    { id: 103, nombre: "José Pérez", edad: 74 }
];

let expedientes = [
    {
        id: 1,
        alumnoId: 1,
        nombre: "María del Carmen López",
        edad: 68,
        estado: "Activo",
        ultimaActualizacion: "Hoy, 11:30",
        consultas: [
            {
                id: 101,
                fecha: "Hoy, 11:30",
                tipo: "Seguimiento",
                motivo: "Seguimiento de control de hipertensión arterial.",
                antecedentes: "Hipertensión diagnosticada hace 8 años.\nDiabetes tipo 2 controlada.",
                notas: "Paciente refiere sentirse estable.\nMantiene adherencia al tratamiento.\nSe recomienda continuar con dieta baja en sodio y actividad física ligera.",
                eliminada: false
            },
            {
                id: 102,
                fecha: "08/05/2026, 10:00",
                tipo: "Seguimiento",
                motivo: "Revisión general y seguimiento de tratamiento.",
                antecedentes: "Sin cambios relevantes desde la consulta anterior.",
                notas: "Se mantiene observación y seguimiento mensual.",
                eliminada: false
            },
            {
                id: 103,
                fecha: "24/04/2026, 09:30",
                tipo: "Consulta inicial",
                motivo: "Valoración inicial de gerontología.",
                antecedentes: "Paciente refiere antecedentes de hipertensión.",
                notas: "Se abre expediente para seguimiento.",
                eliminada: false
            }
        ]
    },
    {
        id: 2,
        alumnoId: 2,
        nombre: "José Antonio Ramírez",
        edad: 72,
        estado: "Activo",
        ultimaActualizacion: "Ayer, 16:45",
        consultas: [
            {
                id: 201,
                fecha: "Ayer, 16:45",
                tipo: "Seguimiento",
                motivo: "Seguimiento por molestias articulares.",
                antecedentes: "Dolor ocasional en rodilla derecha.",
                notas: "Se sugiere registrar evolución y actividad física moderada.",
                eliminada: false
            }
        ]
    },
    {
        id: 3,
        alumnoId: 3,
        nombre: "Elena Pérez Martínez",
        edad: 65,
        estado: "Activo",
        ultimaActualizacion: "15/05/2026",
        consultas: []
    },
    {
        id: 4,
        alumnoId: 4,
        nombre: "Roberto Flores Herrera",
        edad: 70,
        estado: "Archivado",
        ultimaActualizacion: "10/05/2026",
        consultas: [
            {
                id: 401,
                fecha: "10/05/2026, 12:00",
                tipo: "Seguimiento",
                motivo: "Consulta archivada de seguimiento.",
                antecedentes: "Expediente archivado.",
                notas: "Se conserva historial para consulta posterior.",
                eliminada: false
            }
        ]
    }
];

let expedienteSeleccionadoId = 1;
let consultaSeleccionadaId = 101;
let modoFormularioConsulta = null;
let consultaEditandoId = null;
let accionConfirmada = null;

document.addEventListener("DOMContentLoaded", function () {
    configurarEventosGerontologia();
    cargarAlumnosDisponibles();
    renderizarTodo();
});

function configurarEventosGerontologia() {
    const buscarExpediente = document.getElementById("buscarExpediente");
    const filtroExpediente = document.getElementById("filtroExpediente");
    const btnNuevaConsulta = document.getElementById("btnNuevaConsulta");
    const btnArchivarExpediente = document.getElementById("btnArchivarExpediente");
    const btnEditarConsulta = document.getElementById("btnEditarConsulta");
    const btnEliminarConsulta = document.getElementById("btnEliminarConsulta");
    const btnCancelarConsulta = document.getElementById("btnCancelarConsulta");
    const consultaForm = document.getElementById("consultaForm");
    const alumnoSelect = document.getElementById("alumnoExpedienteSelect");
    const btnCrearExpediente = document.getElementById("btnCrearExpediente");

    if (buscarExpediente) {
        buscarExpediente.addEventListener("input", renderizarListaExpedientes);
    }

    if (filtroExpediente) {
        filtroExpediente.addEventListener("change", renderizarListaExpedientes);
    }

    if (btnNuevaConsulta) {
        btnNuevaConsulta.addEventListener("click", iniciarNuevaConsulta);
    }

    if (btnArchivarExpediente) {
        btnArchivarExpediente.addEventListener("click", confirmarArchivoExpediente);
    }

    if (btnEditarConsulta) {
        btnEditarConsulta.addEventListener("click", iniciarEditarConsulta);
    }

    if (btnEliminarConsulta) {
        btnEliminarConsulta.addEventListener("click", confirmarEliminarConsulta);
    }

    if (btnCancelarConsulta) {
        btnCancelarConsulta.addEventListener("click", cancelarFormularioConsulta);
    }

    if (consultaForm) {
        consultaForm.addEventListener("submit", guardarConsulta);
    }

    if (alumnoSelect) {
        alumnoSelect.addEventListener("change", mostrarPreviewAlumno);
    }

    if (btnCrearExpediente) {
        btnCrearExpediente.addEventListener("click", crearExpedienteDemo);
    }

    configurarConfirmacionGerontologia();
}

function renderizarTodo() {
    renderizarListaExpedientes();
    renderizarDetalleExpediente();
}

function obtenerExpedienteSeleccionado() {
    return expedientes.find(expediente => expediente.id === expedienteSeleccionadoId) || expedientes[0] || null;
}

function obtenerConsultasActivas(expediente) {
    if (!expediente || !expediente.consultas) {
        return [];
    }

    return expediente.consultas.filter(consulta => !consulta.eliminada);
}

function obtenerConsultaSeleccionada() {
    const expediente = obtenerExpedienteSeleccionado();

    if (!expediente) {
        return null;
    }

    return obtenerConsultasActivas(expediente).find(consulta => consulta.id === consultaSeleccionadaId) || null;
}

function renderizarListaExpedientes() {
    const lista = document.getElementById("listaExpedientes");
    const contador = document.getElementById("contadorExpedientes");
    const buscar = document.getElementById("buscarExpediente");
    const filtro = document.getElementById("filtroExpediente");

    if (!lista) {
        return;
    }

    const texto = buscar ? buscar.value.toLowerCase().trim() : "";
    const estado = filtro ? filtro.value : "Activo";

    const expedientesFiltrados = expedientes.filter(expediente => {
        const coincideTexto = expediente.nombre.toLowerCase().includes(texto);
        const coincideEstado = estado === "Todos" || expediente.estado === estado;
        return coincideTexto && coincideEstado;
    });

    if (contador) {
        contador.textContent = expedientesFiltrados.length;
    }

    if (expedientesFiltrados.length === 0) {
        lista.innerHTML = `
            <div class="gero-empty-small">
                No hay expedientes con los filtros seleccionados.
            </div>
        `;
        return;
    }

    lista.innerHTML = expedientesFiltrados.map(expediente => {
        const seleccionado = expediente.id === expedienteSeleccionadoId;
        const estadoClase = expediente.estado === "Archivado" ? "archived" : "active";

        return `
            <article class="gero-expediente-item ${seleccionado ? "selected" : ""}" data-expediente-id="${expediente.id}">
                <div class="gero-patient-avatar">${obtenerIniciales(expediente.nombre)}</div>

                <div class="gero-expediente-body">
                    <h4>${expediente.nombre}</h4>
                    <p>${expediente.edad} años</p>

                    <div class="gero-expediente-meta">
                        <p>Última actualización: ${expediente.ultimaActualizacion}</p>
                        <span class="status-badge ${estadoClase}">${expediente.estado}</span>
                    </div>
                </div>
            </article>
        `;
    }).join("");

    lista.querySelectorAll(".gero-expediente-item").forEach(item => {
        item.addEventListener("click", function () {
            expedienteSeleccionadoId = Number(item.dataset.expedienteId);
            const expediente = obtenerExpedienteSeleccionado();
            const consultas = obtenerConsultasActivas(expediente);

            consultaSeleccionadaId = consultas.length > 0 ? consultas[0].id : null;
            cancelarFormularioConsulta();
            renderizarTodo();
        });
    });
}

function renderizarDetalleExpediente() {
    const expediente = obtenerExpedienteSeleccionado();

    if (!expediente) {
        return;
    }

    const estadoClase = expediente.estado === "Archivado" ? "archived" : "active";

    setText("expedienteIniciales", obtenerIniciales(expediente.nombre));
    setText("expedienteNombre", expediente.nombre);
    setText("expedienteEdad", `${expediente.edad} años`);
    setText("expedienteActualizacion", expediente.ultimaActualizacion);

    const estado = document.getElementById("expedienteEstado");
    if (estado) {
        estado.textContent = expediente.estado;
        estado.className = `status-badge ${estadoClase}`;
    }

    const btnNuevaConsulta = document.getElementById("btnNuevaConsulta");
    const btnArchivarExpediente = document.getElementById("btnArchivarExpediente");

    if (btnNuevaConsulta) {
        const archivado = expediente.estado === "Archivado";
        btnNuevaConsulta.disabled = archivado;
        btnNuevaConsulta.classList.toggle("disabled", archivado);
    }

    if (btnArchivarExpediente) {
        btnArchivarExpediente.innerHTML = expediente.estado === "Archivado"
            ? `<i class="bi bi-arrow-clockwise"></i><span>Reactivar expediente</span>`
            : `<i class="bi bi-archive"></i><span>Archivar expediente</span>`;
    }

    renderizarListaConsultas();
    renderizarDetalleConsulta();
}

function renderizarListaConsultas() {
    const lista = document.getElementById("listaConsultas");
    const expediente = obtenerExpedienteSeleccionado();

    if (!lista || !expediente) {
        return;
    }

    const consultas = obtenerConsultasActivas(expediente);

    if (consultas.length === 0) {
        lista.innerHTML = `
            <div class="gero-empty-small">
                No hay consultas registradas.
            </div>
        `;
        return;
    }

    if (!consultaSeleccionadaId) {
        consultaSeleccionadaId = consultas[0].id;
    }

    lista.innerHTML = consultas.map(consulta => {
        const seleccionado = consulta.id === consultaSeleccionadaId;

        return `
            <article class="gero-consulta-item ${seleccionado ? "selected" : ""}" data-consulta-id="${consulta.id}">
                <div class="gero-consulta-icon">
                    <i class="bi bi-calendar2-week"></i>
                </div>

                <div>
                    <h4>${consulta.fecha}</h4>
                    <p>${consulta.tipo}</p>
                </div>
            </article>
        `;
    }).join("");

    lista.querySelectorAll(".gero-consulta-item").forEach(item => {
        item.addEventListener("click", function () {
            consultaSeleccionadaId = Number(item.dataset.consultaId);
            cancelarFormularioConsulta();
            renderizarListaConsultas();
            renderizarDetalleConsulta();
        });

        item.addEventListener("dblclick", function () {
            consultaSeleccionadaId = Number(item.dataset.consultaId);
            iniciarEditarConsulta();
        });
    });
}

function renderizarDetalleConsulta() {
    const consulta = obtenerConsultaSeleccionada();
    const expediente = obtenerExpedienteSeleccionado();

    const vista = document.getElementById("consultaVista");
    const empty = document.getElementById("consultaEmptyState");
    const acciones = document.getElementById("consultaActions");

    if (!consulta || !expediente) {
        if (vista) vista.classList.add("oculto");
        if (acciones) acciones.classList.add("oculto");
        if (empty) empty.classList.remove("oculto");
        return;
    }

    if (vista) vista.classList.remove("oculto");
    if (acciones) acciones.classList.remove("oculto");
    if (empty) empty.classList.add("oculto");

    setText("consultaPanelTitulo", "Detalle de la consulta");
    setText("consultaFecha", consulta.fecha);
    setText("consultaPaciente", expediente.nombre);
    setText("consultaEdad", `${expediente.edad} años`);
    setText("consultaMotivo", consulta.motivo);
    setText("consultaAntecedentes", consulta.antecedentes || "Sin antecedentes registrados.");
    setText("consultaNotas", consulta.notas || "Sin notas registradas.");
}

function iniciarNuevaConsulta() {
    const expediente = obtenerExpedienteSeleccionado();

    if (!expediente || expediente.estado === "Archivado") {
        return;
    }

    modoFormularioConsulta = "nuevo";
    consultaEditandoId = null;

    mostrarFormularioConsulta();
    setText("consultaPanelTitulo", "Nueva consulta");

    document.getElementById("consultaMotivoInput").value = "";
    document.getElementById("consultaAntecedentesInput").value = "";
    document.getElementById("consultaNotasInput").value = "";

    setText("consultaFormPaciente", expediente.nombre);
    setText("consultaFormMeta", `${expediente.edad} años · ${obtenerFechaHoraActual()}`);
}

function iniciarEditarConsulta() {
    const expediente = obtenerExpedienteSeleccionado();
    const consulta = obtenerConsultaSeleccionada();

    if (!expediente || !consulta || expediente.estado === "Archivado") {
        return;
    }

    modoFormularioConsulta = "editar";
    consultaEditandoId = consulta.id;

    mostrarFormularioConsulta();
    setText("consultaPanelTitulo", "Editar consulta");

    document.getElementById("consultaMotivoInput").value = consulta.motivo;
    document.getElementById("consultaAntecedentesInput").value = consulta.antecedentes || "";
    document.getElementById("consultaNotasInput").value = consulta.notas || "";

    setText("consultaFormPaciente", expediente.nombre);
    setText("consultaFormMeta", `${expediente.edad} años · ${consulta.fecha}`);
}

function mostrarFormularioConsulta() {
    const vista = document.getElementById("consultaVista");
    const form = document.getElementById("consultaForm");
    const empty = document.getElementById("consultaEmptyState");
    const acciones = document.getElementById("consultaActions");

    if (vista) vista.classList.add("oculto");
    if (empty) empty.classList.add("oculto");
    if (acciones) acciones.classList.add("oculto");
    if (form) form.classList.remove("oculto");
}

function cancelarFormularioConsulta() {
    const form = document.getElementById("consultaForm");

    if (form) {
        form.classList.add("oculto");
    }

    modoFormularioConsulta = null;
    consultaEditandoId = null;

    renderizarDetalleConsulta();
}

function guardarConsulta(event) {
    event.preventDefault();

    const expediente = obtenerExpedienteSeleccionado();

    if (!expediente) {
        return;
    }

    const motivo = document.getElementById("consultaMotivoInput").value.trim();
    const antecedentes = document.getElementById("consultaAntecedentesInput").value.trim();
    const notas = document.getElementById("consultaNotasInput").value.trim();

    if (!motivo) {
        document.getElementById("consultaMotivoInput").focus();
        return;
    }

    if (modoFormularioConsulta === "nuevo") {
        const nuevaConsulta = {
            id: Date.now(),
            fecha: obtenerFechaHoraActual(),
            tipo: expediente.consultas.length === 0 ? "Consulta inicial" : "Seguimiento",
            motivo,
            antecedentes,
            notas,
            eliminada: false
        };

        expediente.consultas.unshift(nuevaConsulta);
        expediente.ultimaActualizacion = "Ahora";
        consultaSeleccionadaId = nuevaConsulta.id;
    }

    if (modoFormularioConsulta === "editar") {
        const consulta = expediente.consultas.find(item => item.id === consultaEditandoId);

        if (consulta) {
            consulta.motivo = motivo;
            consulta.antecedentes = antecedentes;
            consulta.notas = notas;
            expediente.ultimaActualizacion = "Ahora";
            consultaSeleccionadaId = consulta.id;
        }
    }

    modoFormularioConsulta = null;
    consultaEditandoId = null;

    renderizarTodo();
}

function confirmarEliminarConsulta() {
    const consulta = obtenerConsultaSeleccionada();

    if (!consulta) {
        return;
    }

    mostrarConfirmacionGerontologia(
        "Eliminar consulta",
        "La consulta dejará de verse activa en el expediente, pero el historial podrá conservarse cuando conectemos base de datos.",
        "Eliminar",
        function () {
            eliminarConsultaSeleccionada();
        }
    );
}

function eliminarConsultaSeleccionada() {
    const expediente = obtenerExpedienteSeleccionado();

    if (!expediente) {
        return;
    }

    const consulta = expediente.consultas.find(item => item.id === consultaSeleccionadaId);

    if (consulta) {
        consulta.eliminada = true;
        expediente.ultimaActualizacion = "Ahora";
    }

    const activas = obtenerConsultasActivas(expediente);
    consultaSeleccionadaId = activas.length > 0 ? activas[0].id : null;

    renderizarTodo();
}

function confirmarArchivoExpediente() {
    const expediente = obtenerExpedienteSeleccionado();

    if (!expediente) {
        return;
    }

    const archivado = expediente.estado === "Archivado";

    mostrarConfirmacionGerontologia(
        archivado ? "Reactivar expediente" : "Archivar expediente",
        archivado
            ? "El expediente volverá a estar activo y permitirá nuevas consultas."
            : "El expediente dejará de estar activo, pero conservará sus consultas e historial.",
        archivado ? "Reactivar" : "Archivar",
        function () {
            expediente.estado = archivado ? "Activo" : "Archivado";
            expediente.ultimaActualizacion = "Ahora";
            renderizarTodo();
        }
    );
}

function cargarAlumnosDisponibles() {
    const select = document.getElementById("alumnoExpedienteSelect");

    if (!select) {
        return;
    }

    alumnosDisponiblesDemo.forEach(alumno => {
        const option = document.createElement("option");
        option.value = alumno.id;
        option.textContent = `${alumno.nombre} · ${alumno.edad} años`;
        select.appendChild(option);
    });
}

function mostrarPreviewAlumno() {
    const select = document.getElementById("alumnoExpedienteSelect");
    const preview = document.getElementById("alumnoPreview");

    if (!select || !preview) {
        return;
    }

    const alumno = alumnosDisponiblesDemo.find(item => item.id === Number(select.value));

    if (!alumno) {
        preview.classList.add("oculto");
        return;
    }

    setText("previewIniciales", obtenerIniciales(alumno.nombre));
    setText("previewNombre", alumno.nombre);
    setText("previewEdad", `${alumno.edad} años`);

    preview.classList.remove("oculto");
}

function crearExpedienteDemo() {
    const select = document.getElementById("alumnoExpedienteSelect");

    if (!select || !select.value) {
        select.focus();
        return;
    }

    const alumno = alumnosDisponiblesDemo.find(item => item.id === Number(select.value));

    if (!alumno) {
        return;
    }

    const nuevoExpediente = {
        id: Date.now(),
        alumnoId: alumno.id,
        nombre: alumno.nombre,
        edad: alumno.edad,
        estado: "Activo",
        ultimaActualizacion: "Sin consultas",
        consultas: []
    };

    expedientes.unshift(nuevoExpediente);
    expedienteSeleccionadoId = nuevoExpediente.id;
    consultaSeleccionadaId = null;

    const indexAlumno = alumnosDisponiblesDemo.findIndex(item => item.id === alumno.id);
    if (indexAlumno >= 0) {
        alumnosDisponiblesDemo.splice(indexAlumno, 1);
    }

    const modalElement = document.getElementById("modalNuevoExpediente");
    const modal = bootstrap.Modal.getInstance(modalElement);

    if (modal) {
        modal.hide();
    }

    select.value = "";
    mostrarPreviewAlumno();

    renderizarTodo();
}

function configurarConfirmacionGerontologia() {
    const close = document.getElementById("geroConfirmClose");
    const cancel = document.getElementById("geroConfirmCancel");
    const accept = document.getElementById("geroConfirmAccept");

    if (close) {
        close.addEventListener("click", cerrarConfirmacionGerontologia);
    }

    if (cancel) {
        cancel.addEventListener("click", cerrarConfirmacionGerontologia);
    }

    if (accept) {
        accept.addEventListener("click", function () {
            if (typeof accionConfirmada === "function") {
                accionConfirmada();
            }

            cerrarConfirmacionGerontologia();
        });
    }
}

function mostrarConfirmacionGerontologia(titulo, mensaje, textoBoton, accion) {
    accionConfirmada = accion;

    setText("geroConfirmTitle", titulo);
    setText("geroConfirmMessage", mensaje);
    setText("geroConfirmAccept", textoBoton);

    const modal = document.getElementById("geroConfirmModal");

    if (modal) {
        modal.classList.remove("oculto");
    }
}

function cerrarConfirmacionGerontologia() {
    const modal = document.getElementById("geroConfirmModal");

    if (modal) {
        modal.classList.add("oculto");
    }

    accionConfirmada = null;
}

function obtenerIniciales(nombre) {
    if (!nombre) {
        return "--";
    }

    const partes = nombre.trim().split(/\s+/);

    if (partes.length >= 2) {
        return (partes[0][0] + partes[1][0]).toUpperCase();
    }

    return partes[0][0].toUpperCase();
}

function obtenerFechaHoraActual() {
    const ahora = new Date();
    const dia = String(ahora.getDate()).padStart(2, "0");
    const mes = String(ahora.getMonth() + 1).padStart(2, "0");
    const anio = ahora.getFullYear();
    const hora = String(ahora.getHours()).padStart(2, "0");
    const minuto = String(ahora.getMinutes()).padStart(2, "0");

    return `${dia}/${mes}/${anio}, ${hora}:${minuto}`;
}

function setText(id, valor) {
    const elemento = document.getElementById(id);

    if (elemento) {
        elemento.textContent = valor;
    }
}