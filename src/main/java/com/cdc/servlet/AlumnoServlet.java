package com.cdc.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cdc.dao.AlumnoDAO;
import com.cdc.model.ActividadAlumnoDetalle;
import com.cdc.model.Alumno;

@WebServlet("/alumnos")
public class AlumnoServlet extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Alumno> alumnos = alumnoDAO.listarTodos();
        request.setAttribute("listaAlumnos", alumnos);

        Alumno alumnoSeleccionado = null;
        List<ActividadAlumnoDetalle> actividadesAlumno = null;

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isBlank()) {
            try {
                int idAlumno = Integer.parseInt(idParam);
                alumnoSeleccionado = alumnoDAO.buscarPorId(idAlumno);

                if (alumnoSeleccionado != null) {
                    actividadesAlumno = alumnoDAO.listarActividadesPorAlumno(idAlumno);
                }
            } catch (NumberFormatException e) {
                alumnoSeleccionado = null;
            }
        }

        if (alumnoSeleccionado == null && !alumnos.isEmpty()) {
            alumnoSeleccionado = alumnos.get(0);
            actividadesAlumno = alumnoDAO.listarActividadesPorAlumno(alumnoSeleccionado.getIdAlumno());
        }

        request.setAttribute("alumnoSeleccionado", alumnoSeleccionado);
        request.setAttribute("actividadesAlumno", actividadesAlumno);

        request.getRequestDispatcher("/alumnos.jsp").forward(request, response);
    }
}