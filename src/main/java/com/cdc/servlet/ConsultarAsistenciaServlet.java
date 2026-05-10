package com.cdc.servlet;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.ActividadDAO;

@WebServlet("/consultar-asistencia")
public class ConsultarAsistenciaServlet extends HttpServlet {

    private final ActividadDAO actividadDAO = new ActividadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            String idActividadStr = request.getParameter("idActividad");
            String fechaAsistenciaStr = request.getParameter("fechaAsistencia");

            if (idActividadStr == null || idActividadStr.isBlank()
                    || fechaAsistenciaStr == null || fechaAsistenciaStr.isBlank()) {

                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"datos_incompletos\"}");
                return;
            }

            int idActividad = Integer.parseInt(idActividadStr);
            LocalDate fechaLocal = LocalDate.parse(fechaAsistenciaStr);
            Date fechaAsistencia = Date.valueOf(fechaLocal);

            boolean existe = actividadDAO.existeAsistenciaRegistrada(idActividad, fechaAsistencia);
            List<Integer> idsPresentes = actividadDAO.listarIdsPresentesAsistencia(idActividad, fechaAsistencia);

            String json = "{"
                    + "\"existe\":" + existe + ","
                    + "\"idsPresentes\":" + convertirListaAJson(idsPresentes)
                    + "}";

            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"datos_invalidos\"}");
        }
    }

    private String convertirListaAJson(List<Integer> ids) {
        StringBuilder json = new StringBuilder();
        json.append("[");

        for (int i = 0; i < ids.size(); i++) {
            json.append(ids.get(i));

            if (i < ids.size() - 1) {
                json.append(",");
            }
        }

        json.append("]");
        return json.toString();
    }
}