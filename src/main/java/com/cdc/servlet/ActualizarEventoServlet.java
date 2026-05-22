package com.cdc.servlet;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.EventoDAO;
import com.cdc.model.Evento;
import com.cdc.util.MensajeRedirect;

@WebServlet("/actualizar-evento")
public class ActualizarEventoServlet extends HttpServlet {

    private final EventoDAO eventoDAO = new EventoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer idEvento = null;

        try {
            String idEventoStr = request.getParameter("idEvento");

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

            Evento eventoExistente = eventoDAO.buscarPorId(idEvento);

            if (eventoExistente == null) {
                response.sendRedirect(MensajeRedirect.eventos(
                        request,
                        null,
                        "error",
                        "evento_no_encontrado"
                ));
                return;
            }

            Evento evento = construirEventoDesdeRequest(request);
            evento.setIdEvento(idEvento);

            String error = validarEvento(evento);

            if (error != null) {
                response.sendRedirect(MensajeRedirect.eventos(
                        request,
                        idEvento,
                        "error",
                        error
                ));
                return;
            }

            evento.setTextoPublicacion(generarTextoPublicacion(evento));

            boolean actualizado = eventoDAO.actualizarEvento(evento);

            if (actualizado) {
                response.sendRedirect(MensajeRedirect.eventos(
                        request,
                        idEvento,
                        "exito",
                        "evento_actualizado"
                ));
            } else {
                response.sendRedirect(MensajeRedirect.eventos(
                        request,
                        idEvento,
                        "error",
                        "evento_no_actualizado"
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

    private Evento construirEventoDesdeRequest(HttpServletRequest request) {
        Evento evento = new Evento();

        evento.setNombreEvento(limpiar(request.getParameter("nombreEvento")));
        evento.setDescripcionEvento(limpiar(request.getParameter("descripcionEvento")));
        evento.setFechaEvento(parseDate(request.getParameter("fechaEvento")));
        evento.setHoraInicio(parseTime(request.getParameter("horaInicio")));
        evento.setHoraFin(parseTime(request.getParameter("horaFin")));
        evento.setLugar(limpiar(request.getParameter("lugar")));
        evento.setResponsable(limpiar(request.getParameter("responsable")));

        evento.setUrlFormulario(limpiar(request.getParameter("urlFormulario")));
        evento.setGoogleFormId(limpiar(request.getParameter("googleFormId")));
        evento.setUrlHojaRespuestas(limpiar(request.getParameter("urlHojaRespuestas")));
        evento.setGoogleSheetId(limpiar(request.getParameter("googleSheetId")));
        evento.setFacebookPostId(limpiar(request.getParameter("facebookPostId")));

        return evento;
    }

    private String validarEvento(Evento evento) {
        if (evento.getNombreEvento() == null || evento.getNombreEvento().isBlank()) {
            return "evento_nombre_obligatorio";
        }

        if (evento.getNombreEvento().length() < 3) {
            return "evento_nombre_invalido";
        }

        if (evento.getDescripcionEvento() == null || evento.getDescripcionEvento().isBlank()) {
            return "evento_descripcion_obligatoria";
        }

        if (evento.getFechaEvento() == null) {
            return "evento_fecha_obligatoria";
        }

        if (evento.getHoraInicio() == null) {
            return "evento_hora_inicio_obligatoria";
        }

        if (evento.getHoraFin() != null && !evento.getHoraFin().after(evento.getHoraInicio())) {
            return "evento_hora_fin_invalida";
        }

        if (evento.getLugar() == null || evento.getLugar().length() < 3) {
            return "evento_lugar_obligatorio";
        }

        if (evento.getResponsable() == null || evento.getResponsable().length() < 3) {
            return "evento_responsable_obligatorio";
        }

        return null;
    }

    private String generarTextoPublicacion(Evento evento) {
        String enlaceFormulario = evento.getUrlFormulario();

        if (enlaceFormulario == null || enlaceFormulario.isBlank()) {
            enlaceFormulario = "Enlace de formulario pendiente.";
        }

        return """
                Te invitamos a participar en el evento %s, que se realizará en el Centro Comunitario Plan Chac.

                Fecha: %s
                Hora: %s

                Habrá:
                %s

                Esperamos contar con tu presencia.

                Por favor registra tu asistencia en:
                %s
                """.formatted(
                evento.getNombreEvento(),
                evento.getFechaEvento(),
                evento.getHoraInicio(),
                evento.getDescripcionEvento(),
                enlaceFormulario
        );
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }

    private Date parseDate(String valor) {
        if (valor == null || valor.isBlank()) {
            return null;
        }

        return Date.valueOf(valor);
    }

    private Time parseTime(String valor) {
        if (valor == null || valor.isBlank()) {
            return null;
        }

        if (valor.length() == 5) {
            valor = valor + ":00";
        }

        return Time.valueOf(valor);
    }
}