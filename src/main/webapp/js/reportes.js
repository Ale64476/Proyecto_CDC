document.addEventListener("DOMContentLoaded", () => {

    const reportType = document.getElementById("reportType");

    const studentStatusFilter = document.querySelector(".filter-student-status");
    const activityStatusFilter = document.querySelector(".filter-activity-status");
    const activitySelectFilter = document.querySelector(".filter-activity-select");
    const dateFromFilter = document.querySelector(".filter-date-from");
    const dateToFilter = document.querySelector(".filter-date-to");

    function ocultarTodos() {

        studentStatusFilter.classList.add("hidden-filter");
        activityStatusFilter.classList.add("hidden-filter");
        activitySelectFilter.classList.add("hidden-filter");
        dateFromFilter.classList.add("hidden-filter");
        dateToFilter.classList.add("hidden-filter");

    }

    function actualizarFiltros() {

        ocultarTodos();

        const tipo = reportType.value;

        if (tipo === "alumnos") {

            studentStatusFilter.classList.remove("hidden-filter");

        }

        else if (tipo === "actividades") {

            activityStatusFilter.classList.remove("hidden-filter");

        }

        else if (tipo === "alumnos_por_actividad") {

            studentStatusFilter.classList.remove("hidden-filter");
            activitySelectFilter.classList.remove("hidden-filter");

        }

        else if (tipo === "asistencia_por_actividad") {

            activitySelectFilter.classList.remove("hidden-filter");
            dateFromFilter.classList.remove("hidden-filter");
            dateToFilter.classList.remove("hidden-filter");

        }

    }

    reportType.addEventListener("change", actualizarFiltros);

    actualizarFiltros();


    const exportExcelBtn = document.getElementById("exportExcelBtn");

    const nombreesReporte = {
        "alumnos": "Reporte_Alumnos",
        "actividades": "Reporte_Talleres",
        "alumnos_por_actividad": "Reporte_Alumnos_por_Taller",
        "asistencia_por_actividad": "Reporte_Asistencia_por_Taller"
    };

if (exportExcelBtn) {
    exportExcelBtn.addEventListener("click", () => {
        const tablaActiva = document.querySelector(".preview-table.active-preview");

        if (!tablaActiva) {
            alert("Primero genera o selecciona un reporte para exportar.");
            return;
        }

        const tipoReporte = reportType.value;
        const nombreArchivo = nombreesReporte[tipoReporte] || "reporte";
        const fecha = new Date().toISOString().split("T")[0];

        const html = `
            <html>
                <head>
                    <meta charset="UTF-8">
                </head>
                <body>
                    ${tablaActiva.outerHTML}
                </body>
            </html>
        `;

        const blob = new Blob([html], {
            type: "application/vnd.ms-excel;charset=utf-8;"
        });

        const url = URL.createObjectURL(blob);
        const enlace = document.createElement("a");

        enlace.href = url;
        enlace.download = `${nombreArchivo}_${fecha}.xls`;
        enlace.click();

        URL.revokeObjectURL(url);
    });
}
}
);