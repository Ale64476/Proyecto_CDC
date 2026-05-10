package com.cdc.util;

import java.sql.Date;
import java.time.LocalDate;
import java.util.Set;
import java.util.regex.Pattern;

public final class AlumnoValidator {

    private static final Pattern CURP_BASICA = Pattern.compile("^[A-Z0-9]{18}$");
    private static final Pattern TELEFONO_10_DIGITOS = Pattern.compile("^\\d{10}$");

    private static final Set<String> ESTADOS_VALIDOS = Set.of(
            "Activo",
            "Inactivo",
            "Baja"
    );

    private AlumnoValidator() {
    }

    public static String validarAlumno(
            String nombreCompleto,
            String fechaNacimiento,
            String curp,
            String celular,
            String domicilio,
            String estadoAlumno
    ) {
        nombreCompleto = limpiar(nombreCompleto);
        fechaNacimiento = limpiar(fechaNacimiento);
        curp = normalizarCurp(curp);
        celular = normalizarCelular(celular);
        domicilio = limpiar(domicilio);
        estadoAlumno = limpiar(estadoAlumno);

        if (nombreCompleto.isBlank()) {
            return "nombre_obligatorio";
        }

        if (nombreCompleto.length() < 3 || nombreCompleto.matches(".*\\d.*")) {
            return "nombre_invalido";
        }

        if (fechaNacimiento.isBlank()) {
            return "fecha_obligatoria";
        }

        try {
            LocalDate fecha = LocalDate.parse(fechaNacimiento);

            if (fecha.isAfter(LocalDate.now())) {
                return "fecha_futura";
            }
        } catch (Exception e) {
            return "fecha_invalida";
        }

        if (curp.isBlank()) {
            return "curp_obligatoria";
        }

        if (!CURP_BASICA.matcher(curp).matches()) {
            return "curp_invalida";
        }

        if (!TELEFONO_10_DIGITOS.matcher(celular).matches()) {
            return "celular_invalido";
        }

        if (domicilio.length() < 5) {
            return "domicilio_invalido";
        }

        if (!ESTADOS_VALIDOS.contains(estadoAlumno)) {
            return "estado_invalido";
        }

        return null;
    }

    public static Date convertirFecha(String fechaNacimiento) {
        return Date.valueOf(limpiar(fechaNacimiento));
    }

    public static String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }

    public static String normalizarCurp(String curp) {
        return limpiar(curp).toUpperCase();
    }

    public static String normalizarCelular(String celular) {
        return limpiar(celular).replaceAll("\\D", "");
    }
}