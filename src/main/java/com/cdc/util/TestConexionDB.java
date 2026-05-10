package com.cdc.util;

import java.sql.Connection;
import java.sql.SQLException;

public class TestConexionDB {

    public static void main(String[] args) {
        try (Connection connection = ConexionDB.getConnection()) {
            if (connection != null) {
                System.out.println("Conexión exitosa a la base de datos.");
            } else {
                System.out.println("No se pudo establecer la conexión.");
            }
        } catch (SQLException e) {
            System.out.println("Error al conectar con la base de datos:");
            e.printStackTrace();
        }
    }
}