package com.cdc.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.GerontologiaDAO;
import com.cdc.model.GerontologiaConsulta;
import com.cdc.model.GerontologiaPaciente;
import com.cdc.util.MensajeRedirect;

@WebServlet("/actualizar-consulta-gerontologia")
public class ActualizarConsultaGerontologiaServlet extends HttpServlet {

    private final GerontologiaDAO gerontologiaDAO = new GerontologiaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer idPaciente = null;

        try {
            String idPacienteStr = request.getParameter("idPaciente");
            String idConsultaStr = request.getParameter("idConsulta");

            if (idPacienteStr == null || idPacienteStr.isBlank()
                    || idConsultaStr == null || idConsultaStr.isBlank()) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPaciente,
                        "error",
                        "consulta_id_invalido"
                ));
                return;
            }

            idPaciente = Integer.parseInt(idPacienteStr);
            int idConsulta = Integer.parseInt(idConsultaStr);

            if (idPaciente <= 0 || idConsulta <= 0) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPaciente,
                        "error",
                        "consulta_id_invalido"
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

            if (!"Activo".equalsIgnoreCase(paciente.getEstadoPaciente())) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPaciente,
                        "error",
                        "paciente_archivado_no_editar_consulta"
                ));
                return;
            }

            GerontologiaConsulta consultaExistente = gerontologiaDAO.buscarConsultaPorId(idConsulta);

            if (consultaExistente == null || consultaExistente.getIdPaciente() != idPaciente) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPaciente,
                        "error",
                        "consulta_no_encontrada"
                ));
                return;
            }

            String motivoConsulta = limpiar(request.getParameter("motivoConsulta"));
            String antecedentes = limpiar(request.getParameter("antecedentes"));
            String notas = limpiar(request.getParameter("notas"));

            if (motivoConsulta.isBlank()) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPaciente,
                        "error",
                        "consulta_motivo_obligatorio"
                ));
                return;
            }

            GerontologiaConsulta consulta = new GerontologiaConsulta();
            consulta.setIdConsulta(idConsulta);
            consulta.setIdPaciente(idPaciente);
            consulta.setMotivoConsulta(motivoConsulta);
            consulta.setAntecedentes(antecedentes);
            consulta.setNotas(notas);

            boolean actualizada = gerontologiaDAO.actualizarConsulta(consulta);

            if (actualizada) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPaciente,
                        "exito",
                        "consulta_actualizada"
                ));
            } else {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPaciente,
                        "error",
                        "consulta_no_actualizada"
                ));
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.gerontologia(
                    request,
                    idPaciente,
                    "error",
                    "consulta_id_invalido"
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

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}