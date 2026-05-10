package com.cdc.dao;

import com.cdc.model.Alumno;

import java.util.List;

public class TestAlumnoDAO {

    public static void main(String[] args) {
        AlumnoDAO alumnoDAO = new AlumnoDAO();
        List<Alumno> alumnos = alumnoDAO.listarTodos();

        System.out.println("Total de alumnos encontrados: " + alumnos.size());

        for (Alumno alumno : alumnos) {
            System.out.println(
                    alumno.getIdAlumno() + " - " +
                    alumno.getNombreCompleto() + " - " +
                    alumno.getCelular() + " - " +
                    alumno.getEstadoAlumno()
            );
        }
    }
}