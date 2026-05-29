package com.cdc.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class GoogleConfig {

    private static final Properties PROPERTIES = cargarPropiedades();

    private GoogleConfig() {
    }

    private static Properties cargarPropiedades() {
        Properties properties = new Properties();

        try (InputStream input = GoogleConfig.class.getClassLoader()
                .getResourceAsStream("google.properties")) {

            if (input == null) {
                throw new RuntimeException("No se encontró el archivo google.properties en resources.");
            }

            properties.load(input);
            return properties;

        } catch (IOException e) {
            throw new RuntimeException("Error al leer google.properties.", e);
        }
    }

    public static String get(String clave) {
        String valor = PROPERTIES.getProperty(clave);

        if (valor == null || valor.trim().isEmpty()) {
            throw new RuntimeException("No se encontró la propiedad requerida: " + clave);
        }

        return valor.trim();
    }
}