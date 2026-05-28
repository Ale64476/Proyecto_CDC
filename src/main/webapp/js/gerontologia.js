document.addEventListener("DOMContentLoaded", function () {
    configurarFiltrosExpedientes();
    configurarConsultas();
    configurarFormularioConsulta();
    configurarMiniModalGerontologia();
    configurarConfirmacionesGerontologia();
    configurarBotonPdfConsulta();
});

function configurarFiltrosExpedientes() {
    const buscar = document.getElementById("buscarExpediente");
    const filtro = document.getElementById("filtroExpediente");
    const items = Array.from(document.querySelectorAll(".gero-expediente-item"));
    const contador = document.getElementById("contadorExpedientes");
    const empty = document.getElementById("expedienteEmptyFilter");

    if (!buscar || !filtro || items.length === 0) {
        return;
    }

    function aplicarFiltros() {
        const texto = buscar.value.toLowerCase().trim();
        const estado = filtro.value;
        let visibles = 0;

        items.forEach(function (item) {
            const nombre = item.dataset.nombre || "";
            const estadoItem = item.dataset.estado || "";

            const coincideTexto = nombre.includes(texto);
            const coincideEstado = estado === "Todos" || estadoItem === estado;
            const visible = coincideTexto && coincideEstado;

            item.style.display = visible ? "" : "none";

            if (visible) {
                visibles++;
            }
        });

        if (contador) {
            contador.textContent = visibles;
        }

        if (empty) {
            empty.classList.toggle("oculto", visibles > 0);
        }
    }

    buscar.addEventListener("input", aplicarFiltros);
    filtro.addEventListener("change", aplicarFiltros);

    aplicarFiltros();
}

function configurarConsultas() {
    const consultaItems = document.querySelectorAll(".gero-consulta-item");

    consultaItems.forEach(function (item) {
        item.addEventListener("click", function () {
            seleccionarConsulta(item);
        });

        item.addEventListener("dblclick", function () {
            seleccionarConsulta(item);
            iniciarEditarConsulta();
        });
    });
}

function seleccionarConsulta(item) {
    document.querySelectorAll(".gero-consulta-item").forEach(function (consulta) {
        consulta.classList.remove("selected");
    });

    actualizarBotonPdfConsulta(item);

    item.classList.add("selected");

    setText("consultaPanelTitulo", "Detalle de la consulta");
    setText("consultaFecha", item.dataset.fecha || "--");
    setText("consultaPaciente", item.dataset.paciente || "--");
    setText("consultaEdad", item.dataset.edad || "--");
    setText("consultaMotivo", item.dataset.motivo || "Sin información registrada.");
    setText("consultaAntecedentes", item.dataset.antecedentes || "Sin información registrada.");
    setText("consultaNotas", item.dataset.notas || "Sin información registrada.");

    const vista = document.getElementById("consultaVista");
    const empty = document.getElementById("consultaEmptyState");
    const form = document.getElementById("consultaForm");

    if (vista) vista.classList.remove("oculto");
    if (empty) empty.classList.add("oculto");
    if (form) form.classList.add("oculto");
}

function configurarFormularioConsulta() {
    const btnNuevaConsulta = document.getElementById("btnNuevaConsulta");
    const btnEditarConsulta = document.getElementById("btnEditarConsulta");
    const btnCancelarConsulta = document.getElementById("btnCancelarConsulta");
    const consultaForm = document.getElementById("consultaForm");

    if (btnNuevaConsulta) {
        btnNuevaConsulta.addEventListener("click", iniciarNuevaConsulta);
    }

    if (btnEditarConsulta) {
        btnEditarConsulta.addEventListener("click", iniciarEditarConsulta);
    }

    if (btnCancelarConsulta) {
        btnCancelarConsulta.addEventListener("click", cancelarFormularioConsulta);
    }

    if (consultaForm) {
        consultaForm.addEventListener("submit", function (event) {
            const motivo = document.getElementById("consultaMotivoInput");

            if (!motivo || !motivo.value.trim()) {
                event.preventDefault();

                mostrarMiniModalGerontologia(
                    "Revisa la información",
                    "El motivo de consulta es obligatorio.",
                    motivo
                );
            }
        });
    }
}

function iniciarNuevaConsulta() {
    const form = document.getElementById("consultaForm");

    if (!form) {
        return;
    }

    form.action = form.dataset.urlCrear;
    document.getElementById("idConsultaInput").value = "";
    document.getElementById("consultaMotivoInput").value = "";
    document.getElementById("consultaAntecedentesInput").value = "";
    document.getElementById("consultaNotasInput").value = "";

    mostrarFormularioConsulta("Nueva consulta");
}

function iniciarEditarConsulta() {
    const form = document.getElementById("consultaForm");
    const seleccionada = document.querySelector(".gero-consulta-item.selected");

    if (!form || !seleccionada) {
        return;
    }

    form.action = form.dataset.urlActualizar;

    document.getElementById("idConsultaInput").value = seleccionada.dataset.consultaId || "";
    document.getElementById("consultaMotivoInput").value = seleccionada.dataset.motivo || "";
    document.getElementById("consultaAntecedentesInput").value = seleccionada.dataset.antecedentes || "";
    document.getElementById("consultaNotasInput").value = seleccionada.dataset.notas || "";

    mostrarFormularioConsulta("Editar consulta");
}

function mostrarFormularioConsulta(titulo) {
    const vista = document.getElementById("consultaVista");
    const empty = document.getElementById("consultaEmptyState");
    const form = document.getElementById("consultaForm");

    setText("consultaPanelTitulo", titulo);

    if (vista) vista.classList.add("oculto");
    if (empty) empty.classList.add("oculto");
    if (form) form.classList.remove("oculto");

    const motivo = document.getElementById("consultaMotivoInput");

    if (motivo) {
        setTimeout(function () {
            motivo.focus();
        }, 80);
    }
}

function cancelarFormularioConsulta() {
    const form = document.getElementById("consultaForm");
    const vista = document.getElementById("consultaVista");
    const empty = document.getElementById("consultaEmptyState");
    const seleccionada = document.querySelector(".gero-consulta-item.selected");

    if (form) {
        form.classList.add("oculto");
    }

    if (seleccionada) {
        setText("consultaPanelTitulo", "Detalle de la consulta");

        if (vista) vista.classList.remove("oculto");
        if (empty) empty.classList.add("oculto");
    } else {
        setText("consultaPanelTitulo", "Sin consultas registradas");

        if (vista) vista.classList.add("oculto");
        if (empty) empty.classList.remove("oculto");
    }
}

function configurarMiniModalGerontologia() {
    const modal = document.getElementById("cdcMiniModal");
    const cerrar = document.getElementById("cdcMiniClose");
    const ok = document.getElementById("cdcMiniOk");

    if (!modal || !cerrar || !ok) {
        return;
    }

    cerrar.addEventListener("click", cerrarMiniModalGerontologia);
    ok.addEventListener("click", cerrarMiniModalGerontologia);

    modal.addEventListener("click", function (event) {
        if (event.target === modal) {
            cerrarMiniModalGerontologia();
        }
    });
}

function mostrarMiniModalGerontologia(titulo, mensaje, campo) {
    const modal = document.getElementById("cdcMiniModal");
    const tituloModal = document.getElementById("cdcMiniTitle");
    const mensajeModal = document.getElementById("cdcMiniMessage");

    if (!modal || !tituloModal || !mensajeModal) {
        alert(mensaje);
        return;
    }

    activarModoInfoMiniModalGerontologia();

    tituloModal.textContent = titulo;
    mensajeModal.textContent = mensaje;

    modal.classList.remove("oculto");

    modal._campoRetorno = campo || null;
}

function cerrarMiniModalGerontologia() {
    const modal = document.getElementById("cdcMiniModal");

    if (!modal) {
        return;
    }

    const campo = modal._campoRetorno;

    modal.classList.add("oculto");
    modal._campoRetorno = null;

    if (campo) {
        setTimeout(function () {
            campo.focus();
        }, 80);
    }
}

function configurarConfirmacionesGerontologia() {
    const formularios = document.querySelectorAll(".js-confirm-submit");

    formularios.forEach(function (formulario) {
        formulario.addEventListener("submit", function (event) {
            if (formulario.dataset.confirmado === "true") {
                return;
            }

            event.preventDefault();

            mostrarMiniModalConfirmacionGerontologia(
                formulario.dataset.confirmTitle || "Confirmar acción",
                formulario.dataset.confirmMessage || "¿Deseas continuar?",
                formulario.dataset.confirmConfirmText || "Confirmar",
                formulario.dataset.confirmDanger === "true",
                formulario
            );
        });
    });
}

function mostrarMiniModalConfirmacionGerontologia(titulo, mensaje, textoConfirmar, esPeligroso, formulario) {
    const modal = document.getElementById("cdcMiniModal");
    const tituloModal = document.getElementById("cdcMiniTitle");
    const mensajeModal = document.getElementById("cdcMiniMessage");
    const botonOk = document.getElementById("cdcMiniOk");
    const botonCancelar = document.getElementById("cdcMiniCancel");
    const botonConfirmar = document.getElementById("cdcMiniConfirm");

    if (!modal || !tituloModal || !mensajeModal || !botonOk || !botonCancelar || !botonConfirmar) {
        if (confirm(mensaje)) {
            formulario.submit();
        }
        return;
    }

    tituloModal.textContent = titulo;
    mensajeModal.textContent = mensaje;

    botonOk.classList.add("oculto");
    botonCancelar.classList.remove("oculto");
    botonConfirmar.classList.remove("oculto");

    botonConfirmar.textContent = textoConfirmar;
    botonConfirmar.classList.toggle("cdc-mini-btn-danger", esPeligroso);
    botonConfirmar.classList.toggle("cdc-mini-btn-primary", !esPeligroso);

    botonConfirmar.onclick = function () {
        formulario.dataset.confirmado = "true";
        formulario.submit();
    };

    botonCancelar.onclick = function () {
        cerrarMiniModalGerontologia();
    };

    modal.classList.remove("oculto");
}

function activarModoInfoMiniModalGerontologia() {
    const botonOk = document.getElementById("cdcMiniOk");
    const botonCancelar = document.getElementById("cdcMiniCancel");
    const botonConfirmar = document.getElementById("cdcMiniConfirm");

    if (botonOk) {
        botonOk.classList.remove("oculto");
    }

    if (botonCancelar) {
        botonCancelar.classList.add("oculto");
    }

    if (botonConfirmar) {
        botonConfirmar.classList.add("oculto");
        botonConfirmar.onclick = null;
    }
}

function setText(id, valor) {
    const elemento = document.getElementById(id);

    if (elemento) {
        elemento.textContent = valor;
    }
}
document.addEventListener("DOMContentLoaded", function () {
    abrirModalDesdeAccesoRapidoGerontologia();
});

function abrirModalDesdeAccesoRapidoGerontologia() {
    const params = new URLSearchParams(window.location.search);

    if (params.get("accion") !== "nuevo") {
        return;
    }

    const botonNuevoExpediente = buscarBotonPorTexto("Nuevo expediente");

    if (botonNuevoExpediente) {
        setTimeout(function () {
            botonNuevoExpediente.click();
        }, 150);
    }
}

function buscarBotonPorTexto(textoBuscado) {
    const elementos = document.querySelectorAll("button, a");

    for (const elemento of elementos) {
        if (elemento.textContent.trim().toLowerCase() === textoBuscado.toLowerCase()) {
            return elemento;
        }
    }

    return null;
}

document.addEventListener("DOMContentLoaded", function () {
    configurarFormularioPacienteGerontologia();
});

function configurarFormularioPacienteGerontologia() {
    const form = document.getElementById("formNuevoPaciente");

    if (!form) {
        return;
    }

    const nombre = document.getElementById("pacienteNombreCompleto");
    const curp = document.getElementById("pacienteCurp");
    const celular = document.getElementById("pacienteCelular");
    const fechaNacimiento = document.getElementById("pacienteFechaNacimiento");

    if (curp) {
        curp.addEventListener("input", function () {
            curp.value = curp.value.toUpperCase().replace(/[^A-Z0-9]/g, "").slice(0, 18);
        });
    }

    if (celular) {
        celular.addEventListener("input", function () {
            celular.value = celular.value.replace(/\D/g, "").slice(0, 10);
        });
    }

    form.addEventListener("submit", function (event) {
        if (!nombre || !nombre.value.trim()) {
            event.preventDefault();
            mostrarMiniModalGerontologia(
                "Revisa la información",
                "El nombre completo del paciente es obligatorio.",
                nombre
            );
            return;
        }

        if (!curp || !/^[A-Z0-9]{18}$/.test(curp.value.trim())) {
            event.preventDefault();
            mostrarMiniModalGerontologia(
                "Revisa la información",
                "La CURP debe tener 18 caracteres alfanuméricos.",
                curp
            );
            return;
        }

        if (!celular || !/^\d{10}$/.test(celular.value.trim())) {
            event.preventDefault();
            mostrarMiniModalGerontologia(
                "Revisa la información",
                "El teléfono debe contener exactamente 10 dígitos.",
                celular
            );
            return;
        }

        if (!fechaNacimiento || !fechaNacimiento.value) {
            event.preventDefault();
            mostrarMiniModalGerontologia(
                "Revisa la información",
                "La fecha de nacimiento es obligatoria.",
                fechaNacimiento
            );
            return;
        }

        const fechaSeleccionada = new Date(fechaNacimiento.value + "T00:00:00");
        const hoy = new Date();
        hoy.setHours(0, 0, 0, 0);

        if (fechaSeleccionada > hoy) {
            event.preventDefault();
            mostrarMiniModalGerontologia(
                "Revisa la información",
                "La fecha de nacimiento no puede ser futura.",
                fechaNacimiento
            );
        }
    });
}

function actualizarBotonPdfConsulta(item) {
    const botonPdf = document.getElementById("btnDescargarConsultaPdf");

    if (!botonPdf || !item) {
        return;
    }

    const idConsulta = item.dataset.consultaId;

    if (!idConsulta) {
        botonPdf.setAttribute("href", "#");
        botonPdf.classList.add("disabled");
        botonPdf.setAttribute("aria-disabled", "true");
        return;
    }

    const contexto = window.location.pathname.split("/")[1];
    const baseUrl = contexto ? `/${contexto}` : "";

    botonPdf.setAttribute(
        "href",
        `${baseUrl}/descargar-consulta-gerontologia-pdf?idConsulta=${encodeURIComponent(idConsulta)}`
    );

    botonPdf.classList.remove("disabled");
    botonPdf.removeAttribute("aria-disabled");
}

function configurarBotonPdfConsulta() {
    const botonPdf = document.getElementById("btnDescargarConsultaPdf");

    if (!botonPdf) {
        return;
    }

    const consultaSeleccionada = document.querySelector(".gero-consulta-item.selected");

    if (consultaSeleccionada) {
        actualizarBotonPdfConsulta(consultaSeleccionada);
    }

    botonPdf.addEventListener("click", function (event) {
        if (botonPdf.classList.contains("disabled")) {
            event.preventDefault();
        }
    });
}