document.addEventListener("DOMContentLoaded", () => {
    const menuToggle = document.getElementById("menuToggle");
    const currentDate = document.getElementById("currentDate");
    const storageKey = "cdc_sidebar_collapsed";

    function applySidebarState(collapsed) {
        document.body.classList.toggle("sidebar-collapsed", collapsed);

        if (menuToggle) {
            menuToggle.setAttribute("aria-expanded", String(!collapsed));
        }
    }

    const savedState = localStorage.getItem(storageKey);
    if (savedState === "true") {
        applySidebarState(true);
    } else {
        applySidebarState(false);
    }

    if (menuToggle) {
        menuToggle.addEventListener("click", () => {
            const collapsed = !document.body.classList.contains("sidebar-collapsed");
            applySidebarState(collapsed);
            localStorage.setItem(storageKey, collapsed);
        });
    }

    if (currentDate) {
        const today = new Date();
        const formatted = today.toLocaleDateString("es-MX", {
            day: "2-digit",
            month: "long",
            year: "numeric"
        });

        currentDate.textContent = formatted;
    }
});