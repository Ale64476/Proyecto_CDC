package com.cdc.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.EventoDAO;
import com.cdc.model.Evento;
import com.cdc.model.GoogleFormResponse;
import com.cdc.service.GoogleFormService;


@WebServlet("/eventos")
public class EventoServlet extends HttpServlet {

    private final EventoDAO eventoDAO = new EventoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Evento> eventos = eventoDAO.listarEventos();

        Evento eventoSeleccionado = null;

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isBlank()) {
            try {
                int idEvento = Integer.parseInt(idParam);
                eventoSeleccionado = eventoDAO.buscarPorId(idEvento);
            } catch (NumberFormatException e) {
                eventoSeleccionado = null;
            }
        }

        if (eventoSeleccionado == null && eventos != null && !eventos.isEmpty()) {
            eventoSeleccionado = eventos.get(0);
        }

        request.setAttribute("listaEventos", eventos);
        request.setAttribute("eventoSeleccionado", eventoSeleccionado);

        request.getRequestDispatcher("/eventos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("generarFormularioGoogle".equals(accion)) {
            generarFormularioGoogle(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/eventos");
    }

    private void generarFormularioGoogle(HttpServletRequest request, HttpServletResponse response)
        throws IOException {

        try {
            String idParam = request.getParameter("idEvento");

            if (idParam == null || idParam.isBlank()) {
                response.sendRedirect(request.getContextPath()
                        + "/eventos?tipoMensaje=error&mensaje=evento_no_valido");
                return;
            }

            int idEvento = Integer.parseInt(idParam);

            Evento evento = eventoDAO.buscarPorId(idEvento);

            if (evento == null) {
                response.sendRedirect(request.getContextPath()
                        + "/eventos?tipoMensaje=error&mensaje=evento_no_encontrado");
                return;
            }

            if (evento.getUrlFormulario() != null && !evento.getUrlFormulario().trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()
                        + "/eventos?id=" + idEvento
                        + "&tipoMensaje=error"
                        + "&mensaje=evento_ya_tiene_formulario");
                return;
            }

            GoogleFormService googleFormService = new GoogleFormService();

            GoogleFormResponse respuestaGoogle = googleFormService.generarFormularioEvento(
                    evento.getNombreEvento(),
                    evento.getDescripcionEvento(),
                    String.valueOf(evento.getFechaEvento()),
                    String.valueOf(evento.getHoraInicio()),
                    evento.getHoraFin() != null ? String.valueOf(evento.getHoraFin()) : "",
                    evento.getLugar(),
                    evento.getResponsable()
            );

            if (!respuestaGoogle.isOk()) {
                response.sendRedirect(request.getContextPath()
                        + "/eventos?id=" + idEvento
                        + "&tipoMensaje=error"
                        + "&mensaje=formulario_google_error");
                return;
            }

            boolean actualizado = eventoDAO.actualizarDatosGoogleFormulario(idEvento, respuestaGoogle);

            if (actualizado) {
                response.sendRedirect(request.getContextPath()
                        + "/eventos?id=" + idEvento
                        + "&tipoMensaje=exito"
                        + "&mensaje=formulario_generado");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/eventos?id=" + idEvento
                        + "&tipoMensaje=error"
                        + "&mensaje=formulario_guardado_error");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/eventos?tipoMensaje=error&mensaje=evento_no_valido");

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/eventos?tipoMensaje=error&mensaje=formulario_google_error");
        }
    }
}