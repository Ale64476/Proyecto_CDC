package com.cdc.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.InstructorDAO;
import com.cdc.model.Instructor;
import com.cdc.util.MensajeRedirect;

@WebServlet("/guardar-instructor")
public class GuardarInstructorServlet extends HttpServlet {

    private final InstructorDAO instructorDAO = new InstructorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            String nombreCompleto = limpiar(request.getParameter("nombreCompleto"));
            String celular = normalizarCelular(request.getParameter("celular"));

            String error = validarInstructor(nombreCompleto, celular);

            if (error != null) {
                response.sendRedirect(MensajeRedirect.instructores(
                        request,
                        null,
                        "error",
                        error
                ));
                return;
            }

            Instructor instructor = new Instructor();
            instructor.setNombreCompleto(nombreCompleto);
            instructor.setCelular(celular);
            instructor.setEstadoInstructor("Activo");

            boolean guardado = instructorDAO.insertarInstructor(instructor);

            if (guardado) {
                response.sendRedirect(MensajeRedirect.instructores(
                        request,
                        null,
                        "exito",
                        "instructor_guardado"
                ));
            } else {
                response.sendRedirect(MensajeRedirect.instructores(
                        request,
                        null,
                        "error",
                        "instructor_no_guardado"
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.instructores(
                    request,
                    null,
                    "error",
                    "error_sistema"
            ));
        }
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }

    private String normalizarCelular(String valor) {
        return valor == null ? "" : valor.replaceAll("\\D", "");
    }

    private String validarInstructor(String nombreCompleto, String celular) {
        if (nombreCompleto == null || nombreCompleto.isBlank()) {
            return "instructor_nombre_obligatorio";
        }

        if (nombreCompleto.length() < 3) {
            return "instructor_nombre_invalido";
        }

        if (celular == null || celular.isBlank()) {
            return "instructor_celular_obligatorio";
        }

        if (!celular.matches("\\d{10}")) {
            return "instructor_celular_invalido";
        }

        return null;
    }
}