package com.cdc.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.CalendarioDAO;
import com.cdc.dao.DashboardDAO;
import com.cdc.model.ActividadProxima;
import com.cdc.model.Aviso;
import com.cdc.model.CalendarioActividad;
import com.cdc.model.DashboardResumen;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final CalendarioDAO calendarioDAO = new CalendarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    DashboardResumen resumen = dashboardDAO.obtenerResumen();
    List<ActividadProxima> proximasActividades = dashboardDAO.listarProximasActividades();
    List<Aviso> avisos = dashboardDAO.listarAvisos();
    List<CalendarioActividad> actividadesCalendario = calendarioDAO.listarCalendarioCompleto();

    request.setAttribute("resumenDashboard", resumen);
    request.setAttribute("proximasActividades", proximasActividades);
    request.setAttribute("avisosDashboard", avisos);
    request.setAttribute("actividadesCalendario", actividadesCalendario);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}