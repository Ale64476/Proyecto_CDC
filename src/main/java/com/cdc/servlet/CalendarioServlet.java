package com.cdc.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.CalendarioDAO;
import com.cdc.model.CalendarioActividad;

@WebServlet("/calendario")
public class CalendarioServlet extends HttpServlet {

    private final CalendarioDAO calendarioDAO = new CalendarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<CalendarioActividad> actividadesCalendario = calendarioDAO.listarCalendarioCompleto();
        request.setAttribute("actividadesCalendario", actividadesCalendario);

        String[] dias = {"Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"};
        int indiceDia = java.time.LocalDate.now().getDayOfWeek().getValue() - 1;
        String diaActual = dias[indiceDia];

        request.setAttribute("diaActual", diaActual);

        request.getRequestDispatcher("/calendario.jsp").forward(request, response);
    }
}