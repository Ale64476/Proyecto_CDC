document.addEventListener("DOMContentLoaded", function () {
    configurarFiltrosInstructores();
    configurarValidacionInstructores();
    configurarMiniModalInstructor();
    configurarConfirmacionesInstructor();
});

function configurarFiltrosInstructores() {
    const buscar = document.getElementById("buscarInstructor");
    const filtroEstado = document.getElementById("filtroEstadoInstructor");
    const items = Array.from(document.querySelectorAll(".instructor-list-item"));
    const contador = document.getElementById("contadorInstructores");
    const empty = document.getElementById("instructorEmptyFilter");

    if (!buscar || !filtroEstado || items.length === 0) {
        return;
    }

    function aplicarFiltros() {
        const texto = buscar.value.toLowerCase().trim();
        const estado = filtroEstado.value;
        let visibles = 0;

        items.forEach(function (item) {
            const nombre = item.dataset.nombre || "";
            const celular = item.dataset.celular || "";
            const estadoItem = item.dataset.estado || "";

            const coincideTexto = nombre.includes(texto) || celular.includes(texto);
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
    filtroEstado.addEventListener("change", aplicarFiltros);
}

function configurarValidacionInstructores() {
    const formularios = document.querySelectorAll(".js-instructor-form");

    formularios.forEach(function (formulario) {
        formulario.addEventListener("submit", function (event) {
            const resultado = validarFormularioInstructor(formulario);

            if (!resultado.valido) {
                event.preventDefault();

                mostrarMiniModalInstructor(
                    "Revisa la información",
                    resultado.mensaje,
                    resultado.campo,
                    formulario
                );
            }
        });
    });
}

function validarFormularioInstructor(formulario) {
    const nombre = obtenerValorInstructor(formulario, "nombreCompleto");
    const celular = obtenerValorInstructor(formulario, "celular").replace(/\D/g, "");

    const celularInput = formulario.querySelector('[name="celular"]');

    if (celularInput) {
        celularInput.value = celular;
    }

    if (!nombre) {
        return {
            valido: false,
            campo: "nombreCompleto",
            mensaje: "El nombre del instructor es obligatorio."
        };
    }

    if (nombre.length < 3) {
        return {
            valido: false,
            campo: "nombreCompleto",
            mensaje: "El nombre del instructor debe tener al menos 3 caracteres."
        };
    }

    if (!celular) {
        return {
            valido: false,
            campo: "celular",
            mensaje: "El teléfono del instructor es obligatorio."
        };
    }

    if (!/^\d{10}$/.test(celular)) {
        return {
            valido: false,
            campo: "celular",
            mensaje: "El teléfono debe tener exactamente 10 dígitos."
        };
    }

    return {
        valido: true,
        campo: null,
        mensaje: null
    };
}

function obtenerValorInstructor(formulario, nombreCampo) {
    const campo = formulario.querySelector('[name="' + nombreCampo + '"]');
    return campo ? campo.value.trim() : "";
}

function configurarMiniModalInstructor() {
    const modal = document.getElementById("cdcMiniModal");
    const cerrar = document.getElementById("cdcMiniClose");
    const ok = document.getElementById("cdcMiniOk");

    if (!modal || !cerrar || !ok) {
        return;
    }

    cerrar.addEventListener("click", cerrarMiniModalInstructor);
    ok.addEventListener("click", cerrarMiniModalInstructor);

    modal.addEventListener("click", function (event) {
        if (event.target === modal) {
            cerrarMiniModalInstructor();
        }
    });
}

function mostrarMiniModalInstructor(titulo, mensaje, campo, formulario) {
    const modal = document.getElementById("cdcMiniModal");
    const tituloModal = document.getElementById("cdcMiniTitle");
    const mensajeModal = document.getElementById("cdcMiniMessage");

    if (!modal || !tituloModal || !mensajeModal) {
        alert(mensaje);
        return;
    }

    activarModoInfoMiniModalInstructor();

    tituloModal.textContent = titulo;
    mensajeModal.textContent = mensaje;

    modal.classList.remove("oculto");
    modal.dataset.campo = campo || "";

    if (formulario) {
        formulario.dataset.formularioActivo = "true";
    }
}

function cerrarMiniModalInstructor() {
    const modal = document.getElementById("cdcMiniModal");

    if (!modal) {
        return;
    }

    const campo = modal.dataset.campo;

    modal.classList.add("oculto");

    if (campo) {
        const formularioActivo = document.querySelector('form[data-formulario-activo="true"]');

        if (formularioActivo) {
            const input = formularioActivo.querySelector('[name="' + campo + '"]');

            if (input) {
                setTimeout(function () {
                    input.focus();
                }, 80);
            }

            delete formularioActivo.dataset.formularioActivo;
        }
    }
}

function configurarConfirmacionesInstructor() {
    const formularios = document.querySelectorAll(".js-confirm-submit");

    formularios.forEach(function (formulario) {
        formulario.addEventListener("submit", function (event) {
            if (formulario.dataset.confirmado === "true") {
                return;
            }

            event.preventDefault();

            mostrarMiniModalConfirmacionInstructor(
                formulario.dataset.confirmTitle || "Confirmar acción",
                formulario.dataset.confirmMessage || "¿Deseas continuar?",
                formulario.dataset.confirmConfirmText || "Confirmar",
                formulario.dataset.confirmDanger === "true",
                formulario
            );
        });
    });
}

function mostrarMiniModalConfirmacionInstructor(titulo, mensaje, textoConfirmar, esPeligroso, formulario) {
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
        cerrarMiniModalInstructor();
    };

    modal.classList.remove("oculto");
}

function activarModoInfoMiniModalInstructor() {
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