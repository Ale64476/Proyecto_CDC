document.addEventListener("DOMContentLoaded", () => {

    const buscarAlumnoDisponible = document.getElementById("buscarAlumnoDisponible");
    const listaAlumnosDisponibles = document.querySelectorAll(".alumno-disponible-item");
    const addScheduleRowBtn = document.getElementById("addScheduleRowBtn");
    const scheduleRows = document.getElementById("scheduleRows");
    const attendanceDate = document.getElementById("attendanceDate");

    if (addScheduleRowBtn && scheduleRows) {
        addScheduleRowBtn.addEventListener("click", () => {
            const row = document.createElement("div");
            row.className = "schedule-row";
            row.innerHTML = `
                <select class="form-select" name="diaSemana">
                    <option>Lunes</option>
                    <option>Martes</option>
                    <option>Miércoles</option>
                    <option>Jueves</option>
                    <option>Viernes</option>
                    <option>Sábado</option>
                </select>

                <input type="time" class="form-control" name="horaInicio" value="10:00">
                <input type="time" class="form-control" name="horaFin" value="12:00">

                <button type="button" class="table-icon-btn remove-schedule-btn" title="Quitar horario">
                    <i class="bi bi-trash"></i>
                </button>
            `;
            scheduleRows.appendChild(row);
        });

        scheduleRows.addEventListener("click", (event) => {
            const removeBtn = event.target.closest(".remove-schedule-btn");
            if (!removeBtn) return;

            const row = removeBtn.closest(".schedule-row");
            if (!row) return;

            const totalRows = scheduleRows.querySelectorAll(".schedule-row").length;
            if (totalRows > 1) {
                row.remove();
            }
        });
    }

    if (attendanceDate) {
        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, "0");
        const dd = String(today.getDate()).padStart(2, "0");
        attendanceDate.value = `${yyyy}-${mm}-${dd}`;
    }

    if (buscarAlumnoDisponible) {
        buscarAlumnoDisponible.addEventListener("input", () => {
            const texto = buscarAlumnoDisponible.value.toLowerCase().trim();

            listaAlumnosDisponibles.forEach(item => {
                const contenido = item.textContent.toLowerCase();
                item.style.display = contenido.includes(texto) ? "" : "none";
            });
        });
    }
});

document.addEventListener("DOMContentLoaded", function () {
    const formulariosActividad = document.querySelectorAll(
        'form[action*="guardar-actividad"], form[action*="actualizar-actividad"]'
    );

    formulariosActividad.forEach(function (formulario) {
        formulario.addEventListener("submit", function (event) {
            const resultado = validarFormularioActividad(formulario);

            if (!resultado.valido) {
                event.preventDefault();

                mostrarMiniModalActividad(
                    "Revisa la información",
                    resultado.mensaje,
                    resultado.campo,
                    formulario
                );
            }
        });
    });

    configurarMiniModalActividad();
});

function validarFormularioActividad(formulario) {
    const nombreActividad = obtenerValorActividad(formulario, "nombreActividad");
    const idInstructor = obtenerValorActividad(formulario, "idInstructor");
    const estadoActividad = obtenerValorActividad(formulario, "estadoActividad");

    if (nombreActividad.length < 3) {
        return {
            valido: false,
            campo: "nombreActividad",
            mensaje: "El nombre de la actividad debe tener al menos 3 caracteres."
        };
    }

    if (!idInstructor || Number(idInstructor) <= 0) {
        return {
            valido: false,
            campo: "idInstructor",
            mensaje: "Selecciona un instructor válido."
        };
    }

    if (!["Activa", "Inactiva"].includes(estadoActividad)) {
        return {
            valido: false,
            campo: "estadoActividad",
            mensaje: "Selecciona un estado válido para la actividad."
        };
    }

    const esFormularioNuevo = formulario.getAttribute("action").includes("guardar-actividad");

    if (esFormularioNuevo) {
        const resultadoHorarios = validarHorariosActividad(formulario);

        if (!resultadoHorarios.valido) {
            return resultadoHorarios;
        }
    }

    return {
        valido: true,
        campo: null,
        mensaje: null
    };
}

function validarHorariosActividad(formulario) {
    const filas = formulario.querySelectorAll(".schedule-row");

    if (filas.length === 0) {
        return {
            valido: false,
            campo: "diaSemana",
            mensaje: "Agrega al menos un horario para la actividad."
        };
    }

    for (const fila of filas) {
        const dia = obtenerValorDentroDeFila(fila, "diaSemana");
        const horaInicio = obtenerValorDentroDeFila(fila, "horaInicio");
        const horaFin = obtenerValorDentroDeFila(fila, "horaFin");

        if (!dia || !horaInicio || !horaFin) {
            return {
                valido: false,
                campo: !dia ? "diaSemana" : (!horaInicio ? "horaInicio" : "horaFin"),
                mensaje: "Cada horario debe tener día, hora de inicio y hora de fin."
            };
        }

        if (horaInicio >= horaFin) {
            return {
                valido: false,
                campo: "horaInicio",
                mensaje: "La hora de inicio debe ser menor que la hora de fin."
            };
        }
    }

    return {
        valido: true,
        campo: null,
        mensaje: null
    };
}

function obtenerValorActividad(formulario, nombreCampo) {
    const campo = formulario.querySelector('[name="' + nombreCampo + '"]');
    return campo ? campo.value.trim() : "";
}

function obtenerValorDentroDeFila(fila, nombreCampo) {
    const campo = fila.querySelector('[name="' + nombreCampo + '"]');
    return campo ? campo.value.trim() : "";
}

function mostrarMiniModalActividad(titulo, mensaje, campo, formulario) {
    const modal = document.getElementById("cdcMiniModal");
    const tituloModal = document.getElementById("cdcMiniTitle");
    const mensajeModal = document.getElementById("cdcMiniMessage");

    if (!modal || !tituloModal || !mensajeModal) {
        alert(mensaje);
        return;
    }

    tituloModal.textContent = titulo;
    mensajeModal.textContent = mensaje;

    modal.classList.remove("oculto");
    modal.dataset.campo = campo || "";

    if (formulario) {
        formulario.dataset.formularioActivo = "true";
    }
}

function configurarMiniModalActividad() {
    const modal = document.getElementById("cdcMiniModal");
    const botonCerrar = document.getElementById("cdcMiniClose");
    const botonOk = document.getElementById("cdcMiniOk");

    if (!modal || !botonCerrar || !botonOk) {
        return;
    }

    botonCerrar.addEventListener("click", cerrarMiniModalActividad);
    botonOk.addEventListener("click", cerrarMiniModalActividad);

    modal.addEventListener("click", function (event) {
        if (event.target === modal) {
            cerrarMiniModalActividad();
        }
    });
}

function cerrarMiniModalActividad() {
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

document.addEventListener("DOMContentLoaded", function () {
    const formularioAsistencia = document.querySelector('form[action*="registrar-asistencia"]');
    const fechaAsistencia = document.getElementById("attendanceDate");

    if (!formularioAsistencia || !fechaAsistencia) {
        return;
    }

    fechaAsistencia.addEventListener("change", consultarAsistenciaExistente);

    const modalAsistencia = formularioAsistencia.closest(".modal");

    if (modalAsistencia) {
        modalAsistencia.addEventListener("shown.bs.modal", consultarAsistenciaExistente);
    }

    consultarAsistenciaExistente();
});

async function consultarAsistenciaExistente() {
    const formularioAsistencia = document.querySelector('form[action*="registrar-asistencia"]');
    const fechaAsistencia = document.getElementById("attendanceDate");

    if (!formularioAsistencia || !fechaAsistencia) {
        return;
    }

    const idActividadInput = formularioAsistencia.querySelector('[name="idActividad"]');

    if (!idActividadInput || !idActividadInput.value || !fechaAsistencia.value) {
        return;
    }

    limpiarChecksAsistencia(formularioAsistencia);
    ocultarAvisoAsistenciaExistente();

    try {
        const url = "consultar-asistencia?idActividad="
            + encodeURIComponent(idActividadInput.value)
            + "&fechaAsistencia="
            + encodeURIComponent(fechaAsistencia.value);

        const respuesta = await fetch(url, {
            headers: {
                "Accept": "application/json"
            }
        });

        if (!respuesta.ok) {
            throw new Error("No se pudo consultar la asistencia.");
        }

        const datos = await respuesta.json();

        marcarPresentesAsistencia(formularioAsistencia, datos.idsPresentes || []);

        if (datos.existe) {
            mostrarAvisoAsistenciaExistente();
        }

    } catch (error) {
        console.error(error);
    }
}

function limpiarChecksAsistencia(formulario) {
    const checks = formulario.querySelectorAll('input[name="idsPresentes"]');

    checks.forEach(function (check) {
        check.checked = false;
    });
}

function marcarPresentesAsistencia(formulario, idsPresentes) {
    const ids = new Set(idsPresentes.map(function (id) {
        return String(id);
    }));

    const checks = formulario.querySelectorAll('input[name="idsPresentes"]');

    checks.forEach(function (check) {
        check.checked = ids.has(String(check.value));
    });
}

function mostrarAvisoAsistenciaExistente() {
    const aviso = document.getElementById("attendanceExistingNotice");

    if (aviso) {
        aviso.classList.remove("hidden");
    }
}

function ocultarAvisoAsistenciaExistente() {
    const aviso = document.getElementById("attendanceExistingNotice");

    if (aviso) {
        aviso.classList.add("hidden");
    }
}