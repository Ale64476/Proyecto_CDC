package com.cdc.servlet;

import java.io.IOException;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.EventoDAO;
import com.cdc.model.Evento;
import com.cdc.util.MensajeRedirect;

@WebServlet("/cambiar-estado-evento")
public class CambiarEstadoEventoServlet extends HttpServlet {

    private static final Set<String> ESTADOS_VALIDOS = Set.of(
            "Borrador",
            "Publicado",
            "Finalizado",
            "Cancelado"
    );

    private final EventoDAO eventoDAO = new EventoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer idEvento = null;

        try {
            String idEventoStr = request.getParameter("idEvento");
            String nuevoEstado = request.getParameter("nuevoEstado");

            if (idEventoStr == null || idEventoStr.isBlank()) {
                response.sendRedirect(MensajeRedirect.eventos(
                        request,
                        null,
                        "error",
                        "evento_id_invalido"
                ));
                return;
            }

            idEvento = Integer.parseInt(idEventoStr);

            if (idEvento <= 0) {
                response.sendRedirect(MensajeRedirect.eventos(
                        request,
                        null,
                        "error",
                        "evento_id_invalido"
                ));
                return;
            }

            if (nuevoEstado == null || !ESTADOS_VALIDOS.contains(nuevoEstado)) {
                response.sendRedirect(MensajeRedirect.eventos(
                        request,
                        idEvento,
                        "error",
                        "evento_estado_invalido"
                ));
                return;
            }

            Evento evento = eventoDAO.buscarPorId(idEvento);

            if (evento == null) {
                response.sendRedirect(MensajeRedirect.eventos(
                        request,
                        null,
                        "error",
                        "evento_no_encontrado"
                ));
                return;
            }

            if (nuevoEstado.equalsIgnoreCase(evento.getEstadoEvento())) {
                response.sendRedirect(MensajeRedirect.eventos(
                        request,
                        idEvento,
                        "error",
                        "evento_estado_sin_cambios"
                ));
                return;
            }

            boolean actualizado = eventoDAO.cambiarEstadoEvento(idEvento, nuevoEstado);

            if (actualizado) {
                response.sendRedirect(MensajeRedirect.eventos(
                        request,
                        idEvento,
                        "exito",
                        mensajeExitoPorEstado(nuevoEstado)
                ));
            } else {
                response.sendRedirect(MensajeRedirect.eventos(
                        request,
                        idEvento,
                        "error",
                        "evento_estado_no_actualizado"
                ));
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.eventos(
                    request,
                    idEvento,
                    "error",
                    "evento_id_invalido"
            ));

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(MensajeRedirect.eventos(
                    request,
                    idEvento,
                    "error",
                    "error_sistema"
            ));
        }
    }

    private String mensajeExitoPorEstado(String estado) {
        switch (estado) {
            case "Borrador":
                return "evento_borrador";
            case "Publicado":
                return "evento_publicado";
            case "Finalizado":
                return "evento_finalizado";
            case "Cancelado":
                return "evento_cancelado";
            default:
                return "evento_estado_actualizado";
        }
    }
}