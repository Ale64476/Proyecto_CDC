package com.cdc.servlet;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.GerontologiaDAO;
import com.cdc.model.GerontologiaPaciente;
import com.cdc.util.MensajeRedirect;

@WebServlet("/crear-paciente-gerontologia")
public class CrearPacienteGerontologiaServlet extends HttpServlet {

    private final GerontologiaDAO gerontologiaDAO = new GerontologiaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            String nombreCompleto = limpiar(request.getParameter("nombreCompleto"));
            String curp = limpiar(request.getParameter("curp")).toUpperCase();
            String celular = limpiar(request.getParameter("celular"));
            String fechaNacimientoStr = limpiar(request.getParameter("fechaNacimiento"));

            if (nombreCompleto.isBlank()) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request, null, "error", "paciente_nombre_obligatorio"
                ));
                return;
            }

            if (curp.isBlank()) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request, null, "error", "paciente_curp_obligatoria"
                ));
                return;
            }

            if (!curp.matches("[A-Z0-9]{18}")) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request, null, "error", "paciente_curp_invalida"
                ));
                return;
            }

            if (!celular.matches("\\d{10}")) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request, null, "error", "paciente_celular_invalido"
                ));
                return;
            }

            if (fechaNacimientoStr.isBlank()) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request, null, "error", "paciente_fecha_nacimiento_obligatoria"
                ));
                return;
            }

            LocalDate fechaNacimiento = LocalDate.parse(fechaNacimientoStr);

            if (fechaNacimiento.isAfter(LocalDate.now())) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request, null, "error", "paciente_fecha_nacimiento_futura"
                ));
                return;
            }

            if (gerontologiaDAO.existePacientePorCurp(curp)) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request, null, "error", "paciente_curp_duplicada"
                ));
                return;
            }

            GerontologiaPaciente paciente = new GerontologiaPaciente();
            paciente.setNombreCompleto(nombreCompleto);
            paciente.setCurp(curp);
            paciente.setCelular(celular);
            paciente.setFechaNacimiento(Date.valueOf(fechaNacimiento));

            int idPacienteCreado = gerontologiaDAO.crearPacienteRetornandoId(paciente);

            if (idPacienteCreado > 0) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request, idPacienteCreado, "exito", "paciente_creado"
                ));
            } else {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request, null, "error", "paciente_no_creado"
                ));
            }

        } catch (DateTimeParseException e) {
            response.sendRedirect(MensajeRedirect.gerontologia(
                    request, null, "error", "paciente_fecha_nacimiento_invalida"
            ));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(MensajeRedirect.gerontologia(
                    request, null, "error", "error_sistema"
            ));
        }
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}