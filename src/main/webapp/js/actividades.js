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