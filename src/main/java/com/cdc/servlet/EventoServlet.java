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
}