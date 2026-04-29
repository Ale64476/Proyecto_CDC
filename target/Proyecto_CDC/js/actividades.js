document.addEventListener("DOMContentLoaded", () => {
    const activityItems = document.querySelectorAll(".activity-item");
    const addScheduleRowBtn = document.getElementById("addScheduleRowBtn");
    const scheduleRows = document.getElementById("scheduleRows");

    const activityData = {
        1: {
            name: "Manualidades",
            instructor: "Ana López",
            schedule: "Lun 10:00 - 12:00 / Mié 16:00 - 18:00",
            description: "Taller creativo para desarrollar habilidades manuales y expresión artística.",
            count: "14",
            status: "Activa"
        },
        2: {
            name: "Boxeo",
            instructor: "Carlos Hernández",
            schedule: "Mar 17:00 - 18:30 / Jue 17:00 - 18:30",
            description: "Actividad física orientada al acondicionamiento, disciplina y técnica básica.",
            count: "18",
            status: "Activa"
        },
        3: {
            name: "Computación",
            instructor: "Diego Ramírez",
            schedule: "Lun 16:00 - 18:00 / Vie 12:00 - 14:00",
            description: "Curso introductorio al uso de herramientas digitales y computación básica.",
            count: "12",
            status: "Activa"
        },
        4: {
            name: "Música",
            instructor: "Luis Morales",
            schedule: "Mié 15:00 - 16:30 / Vie 15:00 - 16:30",
            description: "Espacio para explorar ritmo, canto e iniciación musical.",
            count: "10",
            status: "Activa"
        }
    };

    const activityDetailName = document.getElementById("activityDetailName");
    const activityDetailInstructor = document.getElementById("activityDetailInstructor");
    const activityDetailSchedule = document.getElementById("activityDetailSchedule");
    const activityDetailDescription = document.getElementById("activityDetailDescription");
    const activityDetailCount = document.getElementById("activityDetailCount");
    const activityDetailStatus = document.getElementById("activityDetailStatus");

    function loadActivity(activityId) {
        const activity = activityData[activityId];
        if (!activity) return;

        activityDetailName.textContent = activity.name;
        activityDetailInstructor.textContent = activity.instructor;
        activityDetailSchedule.textContent = activity.schedule;
        activityDetailDescription.textContent = activity.description;
        activityDetailCount.textContent = activity.count;
        activityDetailStatus.textContent = activity.status;
    }

    activityItems.forEach(item => {
        item.addEventListener("click", () => {
            activityItems.forEach(el => el.classList.remove("selected"));
            item.classList.add("selected");

            const activityId = item.dataset.activityId;
            loadActivity(activityId);
        });
    });

    if (addScheduleRowBtn && scheduleRows) {
        addScheduleRowBtn.addEventListener("click", () => {
            const row = document.createElement("div");
            row.className = "schedule-row";
            row.innerHTML = `
                <select class="form-select">
                    <option>Lunes</option>
                    <option>Martes</option>
                    <option>Miércoles</option>
                    <option>Jueves</option>
                    <option>Viernes</option>
                    <option>Sábado</option>
                </select>

                <input type="time" class="form-control" value="10:00">
                <input type="time" class="form-control" value="12:00">

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

    const attendanceDate = document.getElementById("attendanceDate");
    if (attendanceDate) {
        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, "0");
        const dd = String(today.getDate()).padStart(2, "0");
        attendanceDate.value = `${yyyy}-${mm}-${dd}`;
    }
});