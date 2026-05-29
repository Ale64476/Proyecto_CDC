document.addEventListener("DOMContentLoaded", () => {
    configurarFiltrosReportes();
    configurarExportacionExcel();
});

function configurarFiltrosReportes() {
    const reportType = document.getElementById("reportType");

    if (!reportType) {
        return;
    }

    function ocultarTodosLosFiltros() {
        document.querySelectorAll(".dynamic-filter, .filter-gerontologia-status, .filter-gerontologia-date-from, .filter-gerontologia-date-to")
            .forEach((filtro) => {
                filtro.classList.add("hidden-filter");
            });
    }

    function mostrarFiltro(selector) {
        document.querySelectorAll(selector).forEach((filtro) => {
            filtro.classList.remove("hidden-filter");
        });
    }

    function actualizarFiltros() {
        const tipo = reportType.value;

        ocultarTodosLosFiltros();

        if (tipo === "alumnos") {
            mostrarFiltro(".filter-student-status");
        }

        if (tipo === "actividades") {
            mostrarFiltro(".filter-activity-status");
        }

        if (tipo === "alumnos_por_actividad") {
            mostrarFiltro(".filter-student-status");
            mostrarFiltro(".filter-activity-select");
        }

        if (tipo === "asistencia_por_actividad") {
            mostrarFiltro(".filter-activity-select");
            mostrarFiltro(".filter-date-from");
            mostrarFiltro(".filter-date-to");
        }

        if (tipo === "gerontologia") {
            mostrarFiltro(".filter-gerontologia-status");
            mostrarFiltro(".filter-gerontologia-date-from");
            mostrarFiltro(".filter-gerontologia-date-to");
        }
    }

    reportType.addEventListener("change", actualizarFiltros);

    actualizarFiltros();
}

function configurarExportacionExcel() {
    const exportExcelBtn = document.getElementById("exportExcelBtn");
    const reportType = document.getElementById("reportType");

    if (!exportExcelBtn) {
        return;
    }

    const nombresReporte = {
        alumnos: "Reporte_Alumnos",
        actividades: "Reporte_Talleres",
        alumnos_por_actividad: "Reporte_Alumnos_por_Taller",
        asistencia_por_actividad: "Reporte_Asistencia_por_Taller",
        gerontologia: "Reporte_Pacientes_Gerontologia"
    };

    exportExcelBtn.addEventListener("click", () => {
        const tablaActiva = document.querySelector(".report-preview-table.active-preview, .preview-table.active-preview");

        if (!tablaActiva) {
            alert("Primero genera o selecciona un reporte para exportar.");
            return;
        }

        const tipoReporte = reportType ? reportType.value : "reporte";
        const nombreArchivo = nombresReporte[tipoReporte] || "Reporte";
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