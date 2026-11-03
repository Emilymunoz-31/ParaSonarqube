<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="Modelo.Usuario"%>

<%
    response.setCharacterEncoding("UTF-8");
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");

    if (usuarioLogueado == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login.jsp");
        return;
    }

    String rolActual = usuarioLogueado.getDescripcionRol();
    String rolNormalizado = rolActual == null ? "" : rolActual.trim();
    boolean esAdministrador = rolNormalizado.equalsIgnoreCase("Administrador")
            || rolNormalizado.equalsIgnoreCase("Administrador.");

    if (rolNormalizado.isEmpty()) {
        rolNormalizado = "Rol " + usuarioLogueado.getRol_id_Rol();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Panel Principal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/Css/Cssvital.css">
</head>
<body class="dashboard-page">

    <nav class="navbar navbar-dark bg-primary shadow-sm sticky-top">
        <div class="container-fluid">
            <span class="navbar-brand fw-bold">🦷 VitalDentist</span>
            <div class="d-flex align-items-center text-white">
                <span class="me-3">Bienvenido: <strong class="badge bg-light text-primary"><%= rolNormalizado %></strong></span>
                <a href="${pageContext.request.contextPath}/Vista/Login.jsp" class="btn btn-outline-light btn-sm rounded-pill">Cerrar Sesión</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">

            <nav class="col-md-3 col-lg-2 dashboard-sidebar p-3 shadow-sm d-none d-md-block">
                <h6 class="text-muted small text-uppercase fw-bold mb-3 px-3">Navegación</h6>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link dashboard-nav-link active" href="#">Inicio</a>
                    </li>

                    <% if (esAdministrador) { %>
                        <li class="nav-item">
                            <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/RegistroUsuarioServlet">Registrar Usuario</a>
                        </li>
                    <% } %>

                    <li class="nav-item">
                        <a class="nav-link dashboard-nav-link" href="${pageContext.request.contextPath}/AgendarCitaServlet">Agendar cita</a>
                    </li>
                </ul>
            </nav>

            <main class="col-md-9 col-lg-10 p-4">
                <div class="container">
                    <div class="card shadow-sm border-0 p-4 bg-white mb-4">
                        <h2 class="text-primary fw-bold">Panel de Control</h2>
                        <p class="text-muted">Gestión de citas de la clínica VitalDentist.</p>
                        <hr>
                        <div class="alert alert-info border-0 shadow-sm">
                            Perfil activo: <strong><%= rolNormalizado %></strong>. Tienes acceso a las funciones asignadas a tu cargo.
                        </div>
                    </div>

                    <div class="row g-4">
                        <%-- Tarjeta visible para Administradores --%>
                        <% if (esAdministrador) { %>
                        <div class="col-md-4">
                            <div class="card card-menu shadow-sm border-0 h-100 js-card-link" data-href="${pageContext.request.contextPath}/RegistroUsuarioServlet" role="link" tabindex="0">
                                <div class="card-body text-center">
                                    <div class="display-6 text-primary mb-3">👤</div>
                                    <h5 class="fw-bold">Gestión de Usuarios</h5>
                                    <p class="text-muted small">Registrar nuevos odontólogos o administradores.</p>
                                    <span class="btn btn-sm btn-outline-primary">Entrar</span>
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <div class="col-md-4">
                            <div class="card card-menu shadow-sm border-0 h-100">
                                <div class="card-body text-center">
                                    <div class="display-6 text-success mb-3">🦷</div>
                                    <h5 class="fw-bold">Citas Médicas</h5>
                                    <p class="text-muted small">Programar, cancelar o editar citas de pacientes.</p>
                                    <span class="btn btn-sm btn-outline-success">Ver Agenda</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/Vista/Javascript/dashboard.js"></script>
</body>
</html>
