package com.cdc.servlet;

import java.io.IOException;
import java.text.Normalizer;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.GerontologiaDAO;
import com.cdc.model.GerontologiaConsulta;
import com.cdc.model.GerontologiaPaciente;
import com.cdc.util.GerontologiaPdfUtil;
import com.cdc.util.MensajeRedirect;

@WebServlet("/descargar-historial-gerontologia-pdf")
public class DescargarHistorialGerontologiaPdfServlet extends HttpServlet {

    private final GerontologiaDAO gerontologiaDAO = new GerontologiaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idPacienteParam = request.getParameter("idPaciente");

        if (idPacienteParam == null || idPacienteParam.isBlank()) {
            response.sendRedirect(MensajeRedirect.gerontologia(
                    request, null, "error", "historial_pdf_id_invalido"
            ));
            return;
        }

        try {
            int idPaciente = Integer.parseInt(idPacienteParam);

            GerontologiaPaciente paciente = gerontologiaDAO.buscarPacientePorId(idPaciente);

            if (paciente == null) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request, null, "error", "paciente_pdf_no_encontrado"
                ));
                return;
            }

            List<GerontologiaConsulta> consultas = gerontologiaDAO.listarConsultasPorPaciente(idPaciente);

            String nombreArchivo = "historial_gerontologia_"
                    + paciente.getIdPaciente()
                    + "_"
                    + limpiarNombreArchivo(paciente.getNombreCompleto())
                    + ".pdf";

            response.reset();
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + nombreArchivo + "\"");

            GerontologiaPdfUtil.generarPdfHistorial(
                    response.getOutputStream(),
                    paciente,
                    consultas
            );

            response.getOutputStream().flush();

        } catch (NumberFormatException e) {
            response.sendRedirect(MensajeRedirect.gerontologia(
                    request, null, "error", "historial_pdf_id_invalido"
            ));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(MensajeRedirect.gerontologia(
                    request, null, "error", "historial_pdf_error"
            ));
        }
    }

    private String limpiarNombreArchivo(String nombre) {
        if (nombre == null || nombre.isBlank()) {
            return "paciente";
        }

        String normalizado = Normalizer.normalize(nombre, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "");

        return normalizado
                .toLowerCase()
                .replaceAll("[^a-z0-9]+", "_")
                .replaceAll("_+", "_")
                .replaceAll("^_|_$", "");
    }
}