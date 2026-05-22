package com.cdc.servlet;

import java.io.IOException;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.GerontologiaDAO;
import com.cdc.model.GerontologiaPaciente;
import com.cdc.util.MensajeRedirect;

@WebServlet("/cambiar-estado-paciente-gerontologia")
public class CambiarEstadoPacienteGerontologiaServlet extends HttpServlet {

    private static final Set<String> ESTADOS_VALIDOS = Set.of(
            "Activo",
            "Archivado"
    );

    private final GerontologiaDAO gerontologiaDAO = new GerontologiaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer idPaciente = null;

        try {
            String idPacienteStr = request.getParameter("idPaciente");
            String nuevoEstado = request.getParameter("nuevoEstado");

            if (idPacienteStr == null || idPacienteStr.isBlank()) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        null,
                        "error",
                        "paciente_id_invalido"
                ));
                return;
            }

            idPaciente = Integer.parseInt(idPacienteStr);

            if (idPaciente <= 0) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        null,
                        "error",
                        "paciente_id_invalido"
                ));
                return;
            }

            if (nuevoEstado == null || !ESTADOS_VALIDOS.contains(nuevoEstado)) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPaciente,
                        "error",
                        "paciente_estado_invalido"
                ));
                return;
            }

            GerontologiaPaciente paciente = gerontologiaDAO.buscarPacientePorId(idPaciente);

            if (paciente == null) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        null,
                        "error",
                        "paciente_no_encontrado"
                ));
                return;
            }

            if (nuevoEstado.equalsIgnoreCase(paciente.getEstadoPaciente())) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPaciente,
                        "error",
                        "paciente_estado_sin_cambios"
                ));
                return;
            }

            boolean actualizado = gerontologiaDAO.cambiarEstadoPaciente(idPaciente, nuevoEstado);

            if (actualizado) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPaciente,
                        "exito",
                        "Activo".equalsIgnoreCase(nuevoEstado)
                                ? "paciente_reactivado"
                                : "paciente_archivado"
                ));
            } else {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPaciente,
                        "error",
                        "paciente_estado_no_actualizado"
                ));
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.gerontologia(
                    request,
                    idPaciente,
                    "error",
                    "paciente_id_invalido"
            ));

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.gerontologia(
                    request,
                    idPaciente,
                    "error",
                    "error_sistema"
            ));
        }
    }
}