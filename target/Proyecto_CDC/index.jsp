<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CDC Plan Chac</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
</head>

<body>

    <header class="topbar">
        <h1>Centro comunitario Plan Chac</h1>
    </header>

    <div class="layout">
        <aside class="sidebar">
            <nav>
                <ul>
                    <li><a href="index.jsp">Inicio</a></li>
                    <li><a href="actividades.jsp">Actividades</a></li>
                    <li><a href="alumnos.jsp">Alumnos</a></li>
                    <li><a href="reportes.jsp">Reportes</a></li>
                </ul>
            </nav>
        </aside>

        <section id="dashboard" class="dashboard">

            <section id="stats" class="stats">
                <div class="card">
                    <p>Alumnos registrados: 
                        150
                    </p>
                </div>
                <div class="card">
                    <p>Talleres activos: 
                        20
                    </p>
                </div>
                <div class="card">
                    <p>Actividades de hoy: 
                        3
                    </p>
                </div>
                <div class="card">
                    <p>Asistentes registrados hoy: 
                        48
                    </p>
                </div>
            </section>

            <section class="dashboard_bottom">
                <section id="calendar" class="calendar">
                    <p>Calendario de actividades</p>
                    <table>
                        <tr>
                            <th>Lunes</th>
                            <th>Martes</th>
                            <th>Miércoles</th>
                            <th>Jueves</th>
                            <th>Viernes</th>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                </section>

                <section id="future_activities" class="future_activities">
                    <ul>
                        <li><p>10:00 Taller de arte</p></li>
                        <li><p>13:00 Taller de música</p></li>
                        <li><p>16:00 Boxeo</p></li>
                    </ul>
                </section>

                <section id="fast_access" class="fast_access">
                    <p>+ Registrar alumno</p>
                    <p>+ Agregar actividad</p>
                    <p>+ Generar reporte</p>
                </section>

                <section id="advertisements" class="advertisements">
                    <p>Aviso: Cupo limitado para el taller de arte</p>
                    <p>Aviso: El taller de música no tiene inscripciones disponibles</p>
                </section>
            </section>
        </section>
    </div>

</body>
</html>