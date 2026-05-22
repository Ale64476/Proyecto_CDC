document.addEventListener("DOMContentLoaded", function () {
    const formulariosAlumno = document.querySelectorAll(
        'form[action*="guardar-alumno"], form[action*="actualizar-alumno"]'
    );

    formulariosAlumno.forEach(function (formulario) {
        formulario.addEventListener("submit", function (event) {
            const resultado = validarFormularioAlumno(formulario);

            if (!resultado.valido) {
                event.preventDefault();

                mostrarMiniModal(
                    "Revisa la información",
                    resultado.mensaje,
                    resultado.campo,
                    formulario
                );
            }
        });
    });

    configurarMiniModal();
    configurarBuscadorAlumnos();
});

function validarFormularioAlumno(formulario) {
    const nombreCompleto = obtenerValor(formulario, "nombreCompleto");
    const fechaNacimiento = obtenerValor(formulario, "fechaNacimiento");
    const curp = obtenerValor(formulario, "curp").toUpperCase();
    const celular = obtenerValor(formulario, "celular").replace(/\D/g, "");
    const domicilio = obtenerValor(formulario, "domicilio");
    const estadoAlumno = obtenerValor(formulario, "estadoAlumno");

    colocarValor(formulario, "curp", curp);
    colocarValor(formulario, "celular", celular);

    if (nombreCompleto.length < 3) {
        return {
            valido: false,
            campo: "nombreCompleto",
            mensaje: "El nombre completo debe tener al menos 3 caracteres."
        };
    }

    if (/\d/.test(nombreCompleto)) {
        return {
            valido: false,
            campo: "nombreCompleto",
            mensaje: "El nombre completo no debe contener números."
        };
    }

    if (!fechaNacimiento) {
        return {
            valido: false,
            campo: "fechaNacimiento",
            mensaje: "La fecha de nacimiento es obligatoria."
        };
    }

    const fecha = new Date(fechaNacimiento + "T00:00:00");
    const hoy = new Date();
    hoy.setHours(0, 0, 0, 0);

    if (isNaN(fecha.getTime())) {
        return {
            valido: false,
            campo: "fechaNacimiento",
            mensaje: "La fecha de nacimiento no tiene un formato válido."
        };
    }

    if (fecha > hoy) {
        return {
            valido: false,
            campo: "fechaNacimiento",
            mensaje: "La fecha de nacimiento no puede ser futura."
        };
    }

    if (!/^[A-Z0-9]{18}$/.test(curp)) {
        return {
            valido: false,
            campo: "curp",
            mensaje: "La CURP debe tener exactamente 18 caracteres alfanuméricos."
        };
    }

    if (!/^\d{10}$/.test(celular)) {
        return {
            valido: false,
            campo: "celular",
            mensaje: "El celular debe tener exactamente 10 dígitos."
        };
    }

    if (domicilio.length < 5) {
        return {
            valido: false,
            campo: "domicilio",
            mensaje: "El domicilio debe tener al menos 5 caracteres."
        };
    }

    const estadosValidos = ["Activo", "Inactivo", "Baja"];

    if (!estadosValidos.includes(estadoAlumno)) {
        return {
            valido: false,
            campo: "estadoAlumno",
            mensaje: "Selecciona un estado válido para el alumno."
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

function colocarValor(formulario, nombreCampo, valor) {
    const campo = formulario.querySelector('[name="' + nombreCampo + '"]');

    if (campo) {
        campo.value = valor;
    }
}

function mostrarMiniModal(titulo, mensaje, campo, formulario) {
    const modal = document.getElementById("cdcMiniModal");
    const tituloModal = document.getElementById("cdcMiniTitle");
    const mensajeModal = document.getElementById("cdcMiniMessage");

    tituloModal.textContent = titulo;
    mensajeModal.textContent = mensaje;
    activarModoInfoMiniModal();

    modal.classList.remove("oculto");
    modal.dataset.campo = campo || "";
    modal.dataset.formularioActivo = "";

    if (formulario) {
        formulario.dataset.formularioActivo = "true";
    }
}

function configurarMiniModal() {
    const modal = document.getElementById("cdcMiniModal");
    const botonCerrar = document.getElementById("cdcMiniClose");
    const botonOk = document.getElementById("cdcMiniOk");

    if (!modal || !botonCerrar || !botonOk) {
        return;
    }

    botonCerrar.addEventListener("click", cerrarMiniModal);
    botonOk.addEventListener("click", cerrarMiniModal);

    modal.addEventListener("click", function (event) {
        if (event.target === modal) {
            cerrarMiniModal();
        }
    });
}

function cerrarMiniModal() {
    const modal = document.getElementById("cdcMiniModal");
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

document.addEventListener("DOMContentLoaded", function () {
    configurarConfirmacionesPeligrosas();
});

function configurarConfirmacionesPeligrosas() {
    const formulariosConfirmacion = document.querySelectorAll(".js-confirm-submit");

    formulariosConfirmacion.forEach(function (formulario) {
        formulario.addEventListener("submit", function (event) {
            if (formulario.dataset.confirmado === "true") {
                return;
            }

            event.preventDefault();

            mostrarMiniModalConfirmacion(
                formulario.dataset.confirmTitle || "Confirmar acción",
                formulario.dataset.confirmMessage || "¿Deseas continuar?",
                formulario.dataset.confirmConfirmText || "Confirmar",
                formulario.dataset.confirmDanger === "true",
                formulario
            );
        });
    });
}

function mostrarMiniModalConfirmacion(titulo, mensaje, textoConfirmar, esPeligroso, formulario) {
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
        cerrarMiniModal();
    };

    modal.classList.remove("oculto");
}

function activarModoInfoMiniModal() {
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
function configurarBuscadorAlumnos() {
    const buscador = document.getElementById("searchStudentListInput");
    const filtroEstado = document.getElementById("studentStatusFilter");
    
    const listaAlumnos = document.getElementById("studentList");

    if (!listaAlumnos) {
        return;
    }

    const tarjetasAlumno = Array.from(
        listaAlumnos.querySelectorAll(".student-list-item")
    );

    function aplicarFiltros() {
    const textoBusqueda = normalizarTexto(buscador ? buscador.value : "");
    const estadoSeleccionado = normalizarTexto(filtroEstado ? filtroEstado.value : "all");

    tarjetasAlumno.forEach(function (tarjeta) {
        const textoTarjeta = normalizarTexto(tarjeta.textContent);

        const coincideBusqueda =
            textoBusqueda === "" || textoTarjeta.includes(textoBusqueda);

        let coincideEstado = true;
        
        if (
            estadoSeleccionado === "activos"
        ) {
            coincideEstado =
                textoTarjeta.includes("activo")&& !textoTarjeta.includes("inactivo")&&!textoTarjeta.includes("baja");

        } else if (

            estadoSeleccionado === "inactivos"
        ) {
            coincideEstado =
                textoTarjeta.includes("inactivo")
        }
            else if (estadoSeleccionado === "baja") {
                coincideEstado = textoTarjeta.includes("baja");
            }

        tarjeta.style.display =
            coincideBusqueda && coincideEstado ? "" : "none";
    });

    ordenarAlumnos();
}

    function ordenarAlumnos() {
        if (!filtroOrden) {
            return;
        }

        const ordenSeleccionado = filtroOrden.value;

        if (ordenSeleccionado !== "name") {
            return;
        }

        const tarjetasOrdenadas = tarjetasAlumno.slice().sort(function (a, b) {
            const nombreA = normalizarTexto(obtenerNombreAlumno(a));
            const nombreB = normalizarTexto(obtenerNombreAlumno(b));

            return nombreA.localeCompare(nombreB);
        });

        tarjetasOrdenadas.forEach(function (tarjeta) {
            listaAlumnos.appendChild(tarjeta);
        });
    }

    if (buscador) {
        buscador.addEventListener("input", aplicarFiltros);
    }

    if (filtroEstado) {
        filtroEstado.addEventListener("change", aplicarFiltros);
    }

    if (filtroOrden) {
        filtroOrden.addEventListener("change", aplicarFiltros);
    }

    aplicarFiltros();
    function normalizarTexto(texto) {
    return String(texto || "")
        .toLowerCase()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .trim();
}

function obtenerNombreAlumno(tarjeta) {
    const nombre = tarjeta.querySelector("h4");

    if (nombre) {
        return nombre.textContent;
    }

    return tarjeta.textContent;
}
}
document.addEventListener("DOMContentLoaded", function () {
    abrirModalDesdeAccesoRapidoAlumno();
});

function abrirModalDesdeAccesoRapidoAlumno() {
    const params = new URLSearchParams(window.location.search);

    if (params.get("accion") !== "nuevo") {
        return;
    }

    const botonNuevoAlumno = buscarBotonPorTexto("Nuevo alumno");

    if (botonNuevoAlumno) {
        setTimeout(function () {
            botonNuevoAlumno.click();
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