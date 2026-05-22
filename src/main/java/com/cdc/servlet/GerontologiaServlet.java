package com.cdc.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.GerontologiaDAO;
import com.cdc.model.Alumno;
import com.cdc.model.GerontologiaConsulta;
import com.cdc.model.GerontologiaPaciente;

@WebServlet("/gerontologia")
public class GerontologiaServlet extends HttpServlet {

    private final GerontologiaDAO gerontologiaDAO = new GerontologiaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<GerontologiaPaciente> pacientes = gerontologiaDAO.listarPacientes();
        List<Alumno> alumnosDisponibles = gerontologiaDAO.listarAlumnosDisponiblesParaPaciente();

        GerontologiaPaciente pacienteSeleccionado = null;
        List<GerontologiaConsulta> consultasPaciente = null;

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isBlank()) {
            try {
                int idPaciente = Integer.parseInt(idParam);
                pacienteSeleccionado = gerontologiaDAO.buscarPacientePorId(idPaciente);
            } catch (NumberFormatException e) {
                pacienteSeleccionado = null;
            }
        }

        if (pacienteSeleccionado == null && pacientes != null && !pacientes.isEmpty()) {
            pacienteSeleccionado = pacientes.get(0);
        }

        if (pacienteSeleccionado != null) {
            consultasPaciente = gerontologiaDAO.listarConsultasPorPaciente(
                    pacienteSeleccionado.getIdPaciente()
            );
        }

        request.setAttribute("pacientesGerontologia", pacientes);
        request.setAttribute("pacienteSeleccionado", pacienteSeleccionado);
        request.setAttribute("consultasPaciente", consultasPaciente);
        request.setAttribute("alumnosDisponiblesGerontologia", alumnosDisponibles);

        request.getRequestDispatcher("/gerontologia.jsp").forward(request, response);
    }
}