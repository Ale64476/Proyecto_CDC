package com.cdc.servlet;

import java.io.IOException;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.InstructorDAO;
import com.cdc.model.Instructor;
import com.cdc.util.MensajeRedirect;

@WebServlet("/cambiar-estado-instructor")
public class CambiarEstadoInstructorServlet extends HttpServlet {

    private static final Set<String> ESTADOS_VALIDOS = Set.of("Activo", "Inactivo");

    private final InstructorDAO instructorDAO = new InstructorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer idInstructor = null;

        try {
            String idInstructorStr = request.getParameter("idInstructor");
            String nuevoEstado = request.getParameter("nuevoEstado");

            if (idInstructorStr == null || idInstructorStr.isBlank()) {
                response.sendRedirect(MensajeRedirect.instructores(
                        request,
                        null,
                        "error",
                        "estado_instructor_id_invalido"
                ));
                return;
            }

            idInstructor = Integer.parseInt(idInstructorStr);

            if (idInstructor <= 0) {
                response.sendRedirect(MensajeRedirect.instructores(
                        request,
                        null,
                        "error",
                        "estado_instructor_id_invalido"
                ));
                return;
            }

            if (nuevoEstado == null || !ESTADOS_VALIDOS.contains(nuevoEstado)) {
                response.sendRedirect(MensajeRedirect.instructores(
                        request,
                        idInstructor,
                        "error",
                        "estado_instructor_invalido"
                ));
                return;
            }

            Instructor instructor = instructorDAO.buscarPorId(idInstructor);

            if (instructor == null) {
                response.sendRedirect(MensajeRedirect.instructores(
                        request,
                        null,
                        "error",
                        "instructor_no_encontrado"
                ));
                return;
            }

            if (nuevoEstado.equalsIgnoreCase(instructor.getEstadoInstructor())) {
                response.sendRedirect(MensajeRedirect.instructores(
                        request,
                        idInstructor,
                        "error",
                        "estado_instructor_sin_cambios"
                ));
                return;
            }

            boolean actualizado = instructorDAO.cambiarEstadoInstructor(idInstructor, nuevoEstado);

            if (actualizado) {
                response.sendRedirect(MensajeRedirect.instructores(
                        request,
                        idInstructor,
                        "exito",
                        "Activo".equalsIgnoreCase(nuevoEstado)
                                ? "instructor_reactivado"
                                : "instructor_desactivado"
                ));
            } else {
                response.sendRedirect(MensajeRedirect.instructores(
                        request,
                        idInstructor,
                        "error",
                        "estado_instructor_no_actualizado"
                ));
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.instructores(
                    request,
                    idInstructor,
                    "error",
                    "estado_instructor_id_invalido"
            ));

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.instructores(
                    request,
                    idInstructor,
                    "error",
                    "error_sistema"
            ));
        }
    }
}