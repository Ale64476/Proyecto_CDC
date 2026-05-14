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

});