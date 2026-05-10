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