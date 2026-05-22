package com.cdc.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.AlumnoDAO;
import com.cdc.dao.GerontologiaDAO;
import com.cdc.model.Alumno;
import com.cdc.util.MensajeRedirect;

@WebServlet("/crear-paciente-gerontologia")
public class CrearPacienteGerontologiaServlet extends HttpServlet {

    private final GerontologiaDAO gerontologiaDAO = new GerontologiaDAO();
    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            String idAlumnoStr = request.getParameter("idAlumno");

            if (idAlumnoStr == null || idAlumnoStr.isBlank()) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        null,
                        "error",
                        "paciente_alumno_invalido"
                ));
                return;
            }

            int idAlumno = Integer.parseInt(idAlumnoStr);

            if (idAlumno <= 0) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        null,
                        "error",
                        "paciente_alumno_invalido"
                ));
                return;
            }

            Alumno alumno = alumnoDAO.buscarPorId(idAlumno);

            if (alumno == null) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        null,
                        "error",
                        "paciente_alumno_no_encontrado"
                ));
                return;
            }

            if (!"Activo".equalsIgnoreCase(alumno.getEstadoAlumno())) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        null,
                        "error",
                        "paciente_alumno_no_activo"
                ));
                return;
            }

            if (gerontologiaDAO.existePacientePorAlumno(idAlumno)) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        null,
                        "error",
                        "paciente_ya_existe"
                ));
                return;
            }

            int idPacienteCreado = gerontologiaDAO.crearPacienteRetornandoId(idAlumno);

            if (idPacienteCreado > 0) {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        idPacienteCreado,
                        "exito",
                        "paciente_creado"
                ));
            } else {
                response.sendRedirect(MensajeRedirect.gerontologia(
                        request,
                        null,
                        "error",
                        "paciente_no_creado"
                ));
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.gerontologia(
                    request,
                    null,
                    "error",
                    "paciente_alumno_invalido"
            ));

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.gerontologia(
                    request,
                    null,
                    "error",
                    "error_sistema"
            ));
        }
    }
}