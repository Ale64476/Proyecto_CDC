document.addEventListener("DOMContentLoaded", function () {
    configurarFiltrosEventos();
    configurarValidacionEventos();
    configurarMiniModalEventos();
    configurarConfirmacionesEventos();
    configurarCopiarPublicacion();
    configurarQRFormulario();
});

function configurarFiltrosEventos() {
    const buscar = document.getElementById("buscarEvento");
    const filtro = document.getElementById("filtroEstadoEvento");
    const items = Array.from(document.querySelectorAll(".event-list-item"));
    const contador = document.getElementById("contadorEventos");
    const empty = document.getElementById("eventEmptyFilter");

    if (!buscar || !filtro || items.length === 0) {
        return;
    }

    function aplicarFiltros() {
        const texto = buscar.value.toLowerCase().trim();
        const estado = filtro.value;
        let visibles = 0;

        items.forEach(function (item) {
            const nombre = item.dataset.nombre || "";
            const responsable = item.dataset.responsable || "";
            const estadoItem = item.dataset.estado || "";

            const coincideTexto = nombre.toLowerCase().includes(texto)
                || responsable.toLowerCase().includes(texto);

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
}

function configurarValidacionEventos() {
    const formularios = document.querySelectorAll(".js-event-form");

    formularios.forEach(function (formulario) {
        formulario.addEventListener("submit", function (event) {
            const resultado = validarFormularioEvento(formulario);

            if (!resultado.valido) {
                event.preventDefault();

                mostrarMiniModalEventos(
                    "Revisa la información",
                    resultado.mensaje,
                    resultado.campo
                );
            }
        });
    });
}

function validarFormularioEvento(formulario) {
    const nombre = obtenerValor(formulario, "nombreEvento");
    const descripcion = obtenerValor(formulario, "descripcionEvento");
    const fecha = obtenerValor(formulario, "fechaEvento");
    const horaInicio = obtenerValor(formulario, "horaInicio");
    const horaFin = obtenerValor(formulario, "horaFin");
    const lugar = obtenerValor(formulario, "lugar");
    const responsable = obtenerValor(formulario, "responsable");

    if (!nombre) {
        return {
            valido: false,
            campo: formulario.querySelector('[name="nombreEvento"]'),
            mensaje: "El nombre del evento es obligatorio."
        };
    }

    if (nombre.length < 3) {
        return {
            valido: false,
            campo: formulario.querySelector('[name="nombreEvento"]'),
            mensaje: "El nombre del evento debe tener al menos 3 caracteres."
        };
    }

    if (!descripcion) {
        return {
            valido: false,
            campo: formulario.querySelector('[name="descripcionEvento"]'),
            mensaje: "La descripción del evento es obligatoria."
        };
    }

    if (!fecha) {
        return {
            valido: false,
            campo: formulario.querySelector('[name="fechaEvento"]'),
            mensaje: "La fecha del evento es obligatoria."
        };
    }

    if (!horaInicio) {
        return {
            valido: false,
            campo: formulario.querySelector('[name="horaInicio"]'),
            mensaje: "La hora de inicio es obligatoria."
        };
    }

    if (horaFin && horaFin <= horaInicio) {
        return {
            valido: false,
            campo: formulario.querySelector('[name="horaFin"]'),
            mensaje: "La hora de fin debe ser posterior a la hora de inicio."
        };
    }

    if (!lugar || lugar.length < 3) {
        return {
            valido: false,
            campo: formulario.querySelector('[name="lugar"]'),
            mensaje: "El lugar del evento es obligatorio."
        };
    }

    if (!responsable || responsable.length < 3) {
        return {
            valido: false,
            campo: formulario.querySelector('[name="responsable"]'),
            mensaje: "El responsable del evento es obligatorio."
        };
    }

    return {
        valido: true,
        campo: null,
        mensaje: null
    };
}

function obtenerValor(formulario, nombreCampo) {
    const campo = formulario.querySelector('[name="' + nombreCampo + '"]');
    return campo ? campo.value.trim() : "";
}

function configurarCopiarPublicacion() {
    const boton = document.getElementById("btnCopiarPublicacion");
    const texto = document.getElementById("textoPublicacion");

    if (!boton || !texto) {
        return;
    }

    boton.addEventListener("click", function () {
        const contenido = texto.textContent.trim();

        if (!contenido) {
            mostrarMiniModalEventos(
                "Sin texto disponible",
                "No hay texto de publicación para copiar.",
                null
            );
            return;
        }

        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(contenido).then(function () {
                mostrarMiniModalEventos(
                    "Texto copiado",
                    "El texto de publicación fue copiado correctamente.",
                    null
                );
            }).catch(function () {
                copiarTextoFallback(contenido);
            });
        } else {
            copiarTextoFallback(contenido);
        }
    });
}

function copiarTextoFallback(texto) {
    const textarea = document.createElement("textarea");
    textarea.value = texto;
    textarea.style.position = "fixed";
    textarea.style.opacity = "0";

    document.body.appendChild(textarea);
    textarea.select();

    try {
        document.execCommand("copy");

        mostrarMiniModalEventos(
            "Texto copiado",
            "El texto de publicación fue copiado correctamente.",
            null
        );
    } catch (error) {
        mostrarMiniModalEventos(
            "No se pudo copiar",
            "Copia el texto manualmente desde el recuadro de publicación.",
            null
        );
    }

    document.body.removeChild(textarea);
}

function configurarQRFormulario() {
    const botonQR = document.getElementById("btnGenerarQR");
    const botonDescargar = document.getElementById("btnDescargarQR");
    const contenedor = document.getElementById("qrContainer");

    if (!botonQR || !contenedor) {
        return;
    }

    botonQR.addEventListener("click", function () {
        const url = botonQR.dataset.urlFormulario || "";

        if (!url.trim()) {
            mostrarMiniModalEventos(
                "Formulario pendiente",
                "Agrega la URL del formulario para generar el QR.",
                null
            );
            return;
        }

        if (typeof QRCode === "undefined") {
            mostrarMiniModalEventos(
                "No se pudo generar el QR",
                "La librería de QR no está disponible. Revisa la conexión o carga la librería localmente.",
                null
            );
            return;
        }

        contenedor.innerHTML = "";

        new QRCode(contenedor, {
            text: url,
            width: 220,
            height: 220,
            correctLevel: QRCode.CorrectLevel.H
        });

        const modalElement = document.getElementById("modalQR");

        if (modalElement && typeof bootstrap !== "undefined") {
            const modal = bootstrap.Modal.getOrCreateInstance(modalElement);
            modal.show();
        }
    });

    if (botonDescargar) {
        botonDescargar.addEventListener("click", descargarQR);
    }
}

function descargarQR() {
    const contenedor = document.getElementById("qrContainer");

    if (!contenedor) {
        return;
    }

    const canvas = contenedor.querySelector("canvas");
    const img = contenedor.querySelector("img");

    let dataUrl = null;

    if (canvas) {
        dataUrl = canvas.toDataURL("image/png");
    } else if (img) {
        dataUrl = img.src;
    }

    if (!dataUrl) {
        mostrarMiniModalEventos(
            "QR no disponible",
            "Primero genera el QR del formulario.",
            null
        );
        return;
    }

    const enlace = document.createElement("a");
    enlace.href = dataUrl;
    enlace.download = "qr_evento.png";
    enlace.click();
}

function configurarMiniModalEventos() {
    const modal = document.getElementById("cdcMiniModal");
    const cerrar = document.getElementById("cdcMiniClose");
    const ok = document.getElementById("cdcMiniOk");

    if (!modal || !cerrar || !ok) {
        return;
    }

    cerrar.addEventListener("click", cerrarMiniModalEventos);
    ok.addEventListener("click", cerrarMiniModalEventos);

    modal.addEventListener("click", function (event) {
        if (event.target === modal) {
            cerrarMiniModalEventos();
        }
    });
}

function mostrarMiniModalEventos(titulo, mensaje, campo) {
    const modal = document.getElementById("cdcMiniModal");
    const tituloModal = document.getElementById("cdcMiniTitle");
    const mensajeModal = document.getElementById("cdcMiniMessage");

    if (!modal || !tituloModal || !mensajeModal) {
        alert(mensaje);
        return;
    }

    activarModoInfoMiniModalEventos();

    tituloModal.textContent = titulo;
    mensajeModal.textContent = mensaje;

    modal.classList.remove("oculto");
    modal._campoRetorno = campo || null;
}

function cerrarMiniModalEventos() {
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

function configurarConfirmacionesEventos() {
    const formularios = document.querySelectorAll(".js-confirm-submit");

    formularios.forEach(function (formulario) {
        formulario.addEventListener("submit", function (event) {
            if (formulario.dataset.confirmado === "true") {
                return;
            }

            event.preventDefault();

            mostrarMiniModalConfirmacionEventos(
                formulario.dataset.confirmTitle || "Confirmar acción",
                formulario.dataset.confirmMessage || "¿Deseas continuar?",
                formulario.dataset.confirmConfirmText || "Confirmar",
                formulario.dataset.confirmDanger === "true",
                formulario
            );
        });
    });
}

function mostrarMiniModalConfirmacionEventos(titulo, mensaje, textoConfirmar, esPeligroso, formulario) {
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
        cerrarMiniModalEventos();
    };

    modal.classList.remove("oculto");
}

function activarModoInfoMiniModalEventos() {
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
document.addEventListener("DOMContentLoaded", function () {
    abrirModalDesdeAccesoRapidoEvento();
});

function abrirModalDesdeAccesoRapidoEvento() {
    const params = new URLSearchParams(window.location.search);

    if (params.get("accion") !== "nuevo") {
        return;
    }

    const botonNuevoEvento = buscarBotonPorTexto("Nuevo evento");

    if (botonNuevoEvento) {
        setTimeout(function () {
            botonNuevoEvento.click();
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