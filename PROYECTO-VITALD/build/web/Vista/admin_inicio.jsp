<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page import="Modelo.Usuario"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioLogueado == null) {
        response.sendRedirect(request.getContextPath() + "/Inicio_sesion");
        return;
    }
    String hoyStr = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
    request.setAttribute("hoyStr", hoyStr);

    if (request.getAttribute("totalPacientes") == null) {
        try {
            Controlador.UsuarioDAO uDao = new Controlador.UsuarioDAO();
            java.util.List<Modelo.Usuario> pacientes = uDao.buscarPacientes("");
            request.setAttribute("totalPacientes", pacientes != null ? pacientes.size() : 0);
        } catch (Exception e) {
            request.setAttribute("totalPacientes", 0);
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/Vista/Imagenes/logo2.0.png">    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/Css/Cssvital.css">
</head>
<body class="dashboard-page admin-module-page">

    <c:set var="rolUsuario" value="${empty usuarioLogueado.descripcionRol ? 'Usuario' : usuarioLogueado.descripcionRol}" />
    <c:set var="esAdmin" value="${fn:toLowerCase(rolUsuario) == 'administrador' || fn:toLowerCase(rolUsuario) == 'administrador.'}" />

    <c:set var="citasHoy" value="0" />
    <c:set var="totalProgramadas" value="0" />
    <c:set var="totalReprogramadas" value="0" />
    <c:set var="totalCanceladas" value="0" />
    <c:set var="totalAtendidas" value="0" />
    <c:set var="totalOtras" value="0" />

    <c:forEach var="citaConteo" items="${citas}">
        <c:if test="${fn:startsWith(citaConteo.fecha_hora, hoyStr)}">
            <c:set var="citasHoy" value="${citasHoy + 1}" />
        </c:if>
        
        <c:set var="estadoConteoTexto" value="${empty citaConteo.descripcionEstadoCita ? '' : citaConteo.descripcionEstadoCita}" />
        <c:set var="estadoConteoLower" value="${fn:toLowerCase(estadoConteoTexto)}" />
        
        <c:choose>
            <c:when test="${fn:contains(estadoConteoLower, 'programada') && !fn:contains(estadoConteoLower, 'reprogramada')}">
                <c:set var="totalProgramadas" value="${totalProgramadas + 1}" />
            </c:when>
            <c:when test="${fn:contains(estadoConteoLower, 'reprogramada')}">
                <c:set var="totalReprogramadas" value="${totalReprogramadas + 1}" />
            </c:when>
            <c:when test="${fn:contains(estadoConteoLower, 'cancelada')}">
                <c:set var="totalCanceladas" value="${totalCanceladas + 1}" />
            </c:when>
            <c:when test="${fn:contains(estadoConteoLower, 'atendida') || fn:contains(estadoConteoLower, 'tomada')}">
                <c:set var="totalAtendidas" value="${totalAtendidas + 1}" />
            </c:when>
            <c:otherwise>
                <c:set var="totalOtras" value="${totalOtras + 1}" />
            </c:otherwise>
        </c:choose>
    </c:forEach>
    
    <c:set var="totalPacientesMostrar" value="${empty totalPacientes ? 0 : totalPacientes}" />

    <div class="d-flex dashboard-shell">

        <%-- SIDEBAR DESKTOP --%>
        <aside class="dashboard-sidebar-v2 desktop-only d-none d-md-flex">
            <div class="sidebar-brand-row">
                <span class="sidebar-brand-icon">
                    <img src="${pageContext.request.contextPath}/Vista/Imagenes/logo2.0.png" alt="Logo VitalDentist">
                </span>
                <span class="sidebar-brand-text fs-5">VitalDentist</span>
            </div>

            <p class="sidebar-eyebrow mb-2">Panel ${rolUsuario}</p>

            <nav class="sidebar-nav">
                <a class="sidebar-nav-link active" href="${pageContext.request.contextPath}/AdminInicioServlet">
                    <i class="bi bi-grid-1x2-fill"></i> Inicio
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/AgendarCitaServlet">
                    <i class="bi bi-calendar-event"></i> Agendar Cita
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/ControlCitasAgendadasServlet">
                    <i class="bi bi-card-list"></i> Control de Citas
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroUsuarioServlet">
                    <i class="bi bi-people-fill"></i> Personal
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroTipoTratamientoServlet">
                    <i class="bi bi-clipboard2-pulse"></i> Tratamientos
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroPagoServlet">
                    <i class="bi bi-wallet2"></i> Pagos
                </a>

                <c:if test="${esAdmin}">
                    <p class="sidebar-subgroup-label">Administración</p>
                    <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroRolServlet">
                        <i class="bi bi-shield-lock"></i> Roles
                    </a>
                    <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroTipoDocumentoServlet">
                        <i class="bi bi-card-text"></i> Tipos documento
                    </a>
                    <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroCategoriaTratamientoServlet">
                        <i class="bi bi-tags"></i> Categorías
                    </a>
                    <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroEstadoCitaServlet">
                        <i class="bi bi-info-circle"></i> Estados de cita
                    </a>
                    <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroAbonoServlet">
                        <i class="bi bi-receipt"></i> Abonos
                    </a>
                </c:if>
            </nav>

            <div class="sidebar-footer">
                <a class="sidebar-user hover-effect" href="#" data-bs-toggle="modal" data-bs-target="#modalMiPerfil">
                    <span class="sidebar-user-avatar">${fn:substring(fn:toUpperCase(usuarioLogueado.nombreus), 0, 1)}</span>
                    <span>
                        <span class="d-block sidebar-user-name">${usuarioLogueado.nombreus}</span>
                        <span class="d-block sidebar-user-role">${rolUsuario}</span>
                    </span>
                </a>
                <a class="sidebar-nav-link mt-2 text-danger" style="color:#ff8a8a;" href="${pageContext.request.contextPath}/Inicio_sesion?accion=cerrar">
                    <i class="bi bi-box-arrow-right"></i> Cerrar sesión
                </a>
            </div>
        </aside>

        <nav class="offcanvas offcanvas-start dashboard-sidebar-v2 d-md-none" tabindex="-1" id="sidebarMenu" aria-labelledby="sidebarMenuLabel" data-bs-scroll="true">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="sidebar-brand-row mb-0">
                    <span class="sidebar-brand-icon">
                        <img src="${pageContext.request.contextPath}/Vista/Imagenes/logo2.0.png" alt="Logo VitalDentist">
                    </span>
                    <span class="sidebar-brand-text">VitalDentist</span>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" data-bs-target="#sidebarMenu" aria-label="Cerrar"></button>
            </div>

            <p class="sidebar-eyebrow mb-2">Panel ${rolUsuario}</p>

            <nav class="sidebar-nav">
                <a class="sidebar-nav-link active" href="${pageContext.request.contextPath}/AdminInicioServlet">
                    <i class="bi bi-grid-1x2-fill"></i> Inicio
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/AgendarCitaServlet">
                    <i class="bi bi-calendar-event"></i> Agendar Cita
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/ControlCitasAgendadasServlet">
                    <i class="bi bi-card-list"></i> Control de Citas
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroUsuarioServlet">
                    <i class="bi bi-people-fill"></i> Pacientes
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroTipoTratamientoServlet">
                    <i class="bi bi-clipboard2-pulse"></i> Tratamientos
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroPagoServlet">
                    <i class="bi bi-wallet2"></i> Pagos
                </a>

                <c:if test="${esAdmin}">
                    <p class="sidebar-subgroup-label">Administración</p>
                    <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroRolServlet">
                        <i class="bi bi-shield-lock"></i> Roles
                    </a>
                    <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroTipoDocumentoServlet">
                        <i class="bi bi-card-text"></i> Tipos documento
                    </a>
                    <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroCategoriaTratamientoServlet">
                        <i class="bi bi-tags"></i> Categorías
                    </a>
                    <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroEstadoCitaServlet">
                        <i class="bi bi-info-circle"></i> Estados de cita
                    </a>
                    <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroAbonoServlet">
                        <i class="bi bi-receipt"></i> Abonos
                    </a>
                </c:if>
            </nav>

            <div class="sidebar-footer">
                <a class="sidebar-user hover-effect" href="#" data-bs-toggle="modal" data-bs-target="#modalMiPerfil">
                    <span class="sidebar-user-avatar">${fn:substring(fn:toUpperCase(usuarioLogueado.nombreus), 0, 1)}</span>
                    <span>
                        <span class="d-block sidebar-user-name">${usuarioLogueado.nombreus}</span>
                        <span class="d-block sidebar-user-role">${rolUsuario}</span>
                    </span>
                </a>
                <a class="sidebar-nav-link mt-2" style="color:#ff8a8a;" href="${pageContext.request.contextPath}/Inicio_sesion?accion=cerrar">
                    <i class="bi bi-box-arrow-right"></i> Cerrar sesión
                </a>
            </div>
        </nav>

        <main class="dashboard-main-v2">

            <div class="mobile-topbar d-md-none">
                <button class="btn btn-sm btn-light shadow-sm" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu">
                    <i class="bi bi-list fs-4"></i>
                </button>
                <span class="fw-bold">VitalDentist</span>
            </div>

            <%-- HERO --%>
            <div class="hero-card d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <p class="hero-eyebrow mb-1">Dashboard clínico</p>
                    <h1 class="hero-title mb-1">¡Buen día, ${usuarioLogueado.nombreus}! 👋</h1>
                    <p class="hero-subtitle">Aquí tienes un resumen de la actividad clínica de hoy.</p>
                </div>

                <div class="d-flex align-items-stretch gap-2 flex-wrap">
                    <div class="hero-metric-pill">
                        <div class="hero-metric-value">${citasHoy}</div>
                        <div class="hero-metric-label">Citas hoy</div>
                    </div>
                    <div class="hero-metric-pill">
                        <div class="hero-metric-value">${totalPacientesMostrar}</div>
                        <div class="hero-metric-label">Pacientes</div>
                    </div>
                    <a class="btn btn-nueva-cita d-flex align-items-center fw-semibold" href="${pageContext.request.contextPath}/AgendarCitaServlet">
                        <i class="bi bi-plus-lg me-1"></i> Nueva cita
                    </a>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-lg-8">
                    <div class="panel-card">
                        <p class="panel-title"><i class="bi bi-calendar-week text-success"></i> Próximas citas vigentes</p>

                        <c:choose>
                            <c:when test="${not empty citas}">
                                <c:set var="citasMostradas" value="0" />
                                <c:forEach var="cita" items="${citas}">
                                    <c:set var="descEstado" value="${fn:toLowerCase(cita.descripcionEstadoCita)}" />
                                    <c:set var="esCancelada" value="${fn:contains(descEstado, 'cancelada')}" />
                                    <c:set var="esAtendida" value="${fn:contains(descEstado, 'atendida') || fn:contains(descEstado, 'tomada')}" />
                                    
                                    <c:if test="${cita.fecha_hora >= hoyStr && !fn:startsWith(cita.fecha_hora, '0001') && !esCancelada && !esAtendida}">
                                        <c:if test="${citasMostradas < 3}">
                                            <c:set var="nombrePacienteTexto" value="${empty cita.nombrePaciente ? 'Paciente' : cita.nombrePaciente}" />
                                            <c:set var="esReprogramada" value="${fn:contains(descEstado, 'reprogramada')}" />
                                            <c:set var="colorPunto" value="${esReprogramada ? 'text-warning' : 'text-primary'}" />
                                            
                                            <div class="appointment-row">
                                                <div class="appointment-left">
                                                    <span class="appointment-avatar">${fn:substring(fn:toUpperCase(nombrePacienteTexto), 0, 1)}</span>
                                                    <div class="min-w-0">
                                                        <div class="appointment-name">${nombrePacienteTexto}</div>
                                                        <div class="appointment-sub">
                                                            <i class="bi bi-circle-fill ${colorPunto} me-1" style="font-size: 0.5rem;"></i>
                                                            ${empty cita.descripcionTratamiento ? 'Tratamiento por asignar' : cita.descripcionTratamiento}
                                                        </div>
                                                    </div>
                                                </div>
                                                <span class="appointment-time ${colorPunto} fw-bold">${cita.fecha_hora}</span>
                                            </div>
                                            <c:set var="citasMostradas" value="${citasMostradas + 1}" />
                                        </c:if>
                                    </c:if>
                                </c:forEach>
                                
                                <c:if test="${citasMostradas == 0}">
                                    <p class="text-muted mb-0">No hay próximas citas vigentes programadas.</p>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted mb-0">No hay citas próximas registradas.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="panel-card">
                        <p class="panel-title"><i class="bi bi-pie-chart-fill text-success"></i> Estados de citas</p>

                        <c:if test="${not empty citas}">
                            <div class="distribution-bar">
                                <c:if test="${totalProgramadas > 0}"><div class="distribution-segment" data-status="programada" style="flex-grow:${totalProgramadas};" title="Programadas: ${totalProgramadas}"></div></c:if>
                                <c:if test="${totalReprogramadas > 0}"><div class="distribution-segment" data-status="reprogramada" style="flex-grow:${totalReprogramadas};" title="Reprogramadas: ${totalReprogramadas}"></div></c:if>
                                <c:if test="${totalCanceladas > 0}"><div class="distribution-segment" data-status="cancelada" style="flex-grow:${totalCanceladas};" title="Canceladas: ${totalCanceladas}"></div></c:if>
                                <c:if test="${totalAtendidas > 0}"><div class="distribution-segment" data-status="atendida" style="flex-grow:${totalAtendidas};" title="Atendidas: ${totalAtendidas}"></div></c:if>
                            </div>
                        </c:if>

                        <div class="legend-chip">
                            <div class="d-flex align-items-center">
                                <i class="legend-dot" data-status="programada"></i>
                                <span>Programadas</span>
                            </div>
                            <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-3 py-1 fw-bold fs-6">${totalProgramadas}</span>
                        </div>

                        <div class="legend-chip">
                            <div class="d-flex align-items-center">
                                <i class="legend-dot" data-status="reprogramada"></i>
                                <span>Reprogramadas</span>
                            </div>
                            <span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-3 py-1 fw-bold fs-6" style="color: #b45309 !important;">${totalReprogramadas}</span>
                        </div>

                        <div class="legend-chip">
                            <div class="d-flex align-items-center">
                                <i class="legend-dot" data-status="cancelada"></i>
                                <span>Canceladas</span>
                            </div>
                            <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3 py-1 fw-bold fs-6">${totalCanceladas}</span>
                        </div>

                        <div class="legend-chip">
                            <div class="d-flex align-items-center">
                                <i class="legend-dot" data-status="atendida"></i>
                                <span>Atendidas</span>
                            </div>
                            <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-1 fw-bold fs-6">${totalAtendidas}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-2">
                <div class="col-sm-6 col-lg-4">
                    <a href="${pageContext.request.contextPath}/ControlOrtodonciaServlet" class="feature-card">
                        <div class="feature-icon"><i class="bi bi-clipboard2-pulse"></i></div>
                        <div class="feature-title">Ortodoncia</div>
                        <p class="feature-sub">Historial por paciente</p>
                    </a>
                </div>
                <div class="col-sm-6 col-lg-4">
                    <a href="${pageContext.request.contextPath}/RegistroUsuarioServlet" class="feature-card">
                        <div class="feature-icon"><i class="bi bi-people-fill"></i></div>
                        <div class="feature-title">Pacientes</div>
                        <p class="feature-sub">Datos y accesos</p>
                    </a>
                </div>
                <div class="col-sm-6 col-lg-4">
                    <a href="${pageContext.request.contextPath}/RegistroTipoTratamientoServlet" class="feature-card">
                        <div class="feature-icon"><i class="bi bi-hospital"></i></div>
                        <div class="feature-title">Tratamientos</div>
                        <p class="feature-sub">Catálogo y costos</p>
                    </a>
                </div>
            </div>

            <a href="#cronogramaCitas" class="scroll-hint" title="Ver cronograma completo">
                <i class="bi bi-chevron-down"></i>
            </a>

            <section class="card admin-card mb-4 overflow-hidden border" id="cronogramaCitas">
                <div class="card-header admin-card-header d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <div>
                        <h2 class="h5 mb-0 fw-bold text-primary"><i class="bi bi-table me-2"></i> Cronograma de Citas</h2>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <a href="${pageContext.request.contextPath}/ControlCitasAgendadasServlet" class="btn btn-sm btn-outline-primary rounded-pill fw-bold shadow-sm d-none d-sm-inline-block">
                            <i class="bi bi-gear-fill me-1"></i> Administrar Citas
                        </a>
                        <div class="input-group table-search-wrap" style="max-width: 240px;">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="search" id="buscadorCitas" class="form-control" placeholder="Buscar paciente..." aria-label="Buscar">
                        </div>
                        <span class="badge bg-primary px-3 py-2 rounded-pill shadow-sm">${fn:length(citas)} registradas</span>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-vital table-hover align-middle mb-0" id="tablaCitas">
                            <thead class="table-light">
                                <tr>
                                    <th class="py-3 ps-4">Fecha y hora</th>
                                    <th class="py-3">Paciente</th>
                                    <th class="py-3">Tratamiento</th>
                                    <th class="py-3 pe-4">Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cita" items="${citas}">
                                    <c:set var="nombrePacienteTexto" value="${empty cita.nombrePaciente ? 'Paciente' : cita.nombrePaciente}" />
                                    <c:set var="estadoTexto" value="${empty cita.descripcionEstadoCita ? 'Sin Estado' : cita.descripcionEstadoCita}" />
                                    <c:set var="estadoLower" value="${fn:toLowerCase(estadoTexto)}" />
                                    
                                    <c:choose>
                                        <c:when test="${fn:contains(estadoLower, 'programada') && !fn:contains(estadoLower, 'reprogramada')}"><c:set var="badgeClass" value="bg-primary bg-opacity-10 text-primary border-primary" /></c:when>
                                        <c:when test="${fn:contains(estadoLower, 'reprogramada')}"><c:set var="badgeClass" value="bg-warning bg-opacity-10 text-dark border-warning" /></c:when>
                                        <c:when test="${fn:contains(estadoLower, 'cancelada')}"><c:set var="badgeClass" value="bg-danger bg-opacity-10 text-danger border-danger" /></c:when>
                                        <c:when test="${fn:contains(estadoLower, 'atendida') || fn:contains(estadoLower, 'tomada')}"><c:set var="badgeClass" value="bg-success bg-opacity-10 text-success border-success" /></c:when>
                                        <c:otherwise><c:set var="badgeClass" value="bg-secondary bg-opacity-10 text-secondary border-secondary" /></c:otherwise>
                                    </c:choose>
                                    
                                    <tr>
                                        <td class="ps-4 fw-semibold">${cita.fecha_hora}</td>
                                        <td class="d-flex align-items-center">
                                            <span class="patient-avatar me-2">${fn:substring(fn:toUpperCase(nombrePacienteTexto), 0, 1)}</span>
                                            <span>${nombrePacienteTexto}</span>
                                        </td>
                                        <td><span class="badge bg-secondary bg-opacity-10 text-dark">${empty cita.descripcionTratamiento ? 'Asignado' : cita.descripcionTratamiento}</span></td>
                                        <td class="pe-4"><span class="badge border ${badgeClass} px-3 py-2 rounded-pill">${estadoTexto}</span></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty citas}">
                                    <tr>
                                        <td colspan="4" class="text-center text-muted py-5">
                                            <span class="empty-state-icon mb-3"><i class="bi bi-calendar-x fs-1"></i></span>
                                            <h5 class="fw-semibold text-dark">No hay citas registradas</h5>
                                            <a href="${pageContext.request.contextPath}/AgendarCitaServlet" class="btn btn-outline-primary mt-2 rounded-pill">Agendar Primera Cita</a>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </main>
    </div>

    <div class="modal fade" id="modalMiPerfil" tabindex="-1" aria-labelledby="modalMiPerfilLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1.5rem; overflow: hidden;">
                <div class="modal-header bg-primary bg-opacity-10 border-bottom-0 pb-3 pt-4 px-4">
                    <h5 class="modal-title fw-bold text-primary">
                        <i class="bi bi-person-lines-fill me-2"></i> Configuración de Mi Perfil
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body px-4 px-md-5 pb-5 pt-3 bg-white">
                    <div class="text-center mb-4">
                        <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-inline-flex align-items-center justify-content-center mb-2 shadow-sm" style="width: 70px; height: 70px; font-size: 2rem; font-weight: bold;">
                            ${fn:substring(fn:toUpperCase(usuarioLogueado.nombreus), 0, 1)}
                        </div>
                        <h4 class="fw-bold text-dark mb-1">${usuarioLogueado.nombreus} ${usuarioLogueado.apellido}</h4>
                        <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill mt-1 border border-primary border-opacity-25">
                            <i class="bi bi-shield-check me-1"></i> ${rolUsuario}
                        </span>
                    </div>

                    <form action="${pageContext.request.contextPath}/RegistroUsuarioServlet" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="actualizarMiPerfil">
                        <input type="hidden" name="id" value="${usuarioLogueado.id_Usuario}">
                        <input type="hidden" name="txtRol" value="${usuarioLogueado.rol_id_Rol}">
                        <input type="hidden" name="txtTipoDoc" value="${usuarioLogueado.tipo_documento_id_Tipodocumento}">
                        <input type="hidden" name="txtDocumento" value="${usuarioLogueado.documento}">
                        
                        <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3 mt-4"><i class="bi bi-card-text me-2"></i>Datos Personales</h6>
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Nombres</label>
                                <input type="text" name="txtNombres" class="form-control bg-light border-0 shadow-sm" value="${usuarioLogueado.nombreus}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Apellidos</label>
                                <input type="text" name="txtApellidos" class="form-control bg-light border-0 shadow-sm" value="${usuarioLogueado.apellido}" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">
                                    Tipo de Documento <i class="bi bi-lock-fill text-danger opacity-75 ms-1" title="Campo bloqueado por seguridad"></i>
                                </label>
                                <input type="text" class="form-control bg-secondary bg-opacity-10 border-0 text-muted" value="Registrado en sistema" disabled>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">
                                    Número de Documento <i class="bi bi-lock-fill text-danger opacity-75 ms-1" title="Campo bloqueado por seguridad"></i>
                                </label>
                                <input type="text" class="form-control bg-secondary bg-opacity-10 border-0 text-muted fw-bold" value="${usuarioLogueado.documento}" disabled>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label small fw-semibold text-secondary">Fecha de Nac.</label>
                                <input type="date" name="txtFechaNac" class="form-control bg-light border-0 shadow-sm" value="${usuarioLogueado.fecha_nacimiento}" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold text-secondary">Teléfono</label>
                                <input type="tel" name="txtTelefono" class="form-control bg-light border-0 shadow-sm" value="${usuarioLogueado.telefono}" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold text-secondary">Correo Electrónico</label>
                                <input type="email" name="txtCorreo" class="form-control bg-light border-0 shadow-sm" value="${usuarioLogueado.correo}" required>
                            </div>

                            <div class="col-12 mt-3">
                                <label class="form-label small fw-semibold text-secondary"><i class="bi bi-key me-1"></i>Cambiar Contraseña (Opcional)</label>
                                <div class="input-group shadow-sm rounded-3 overflow-hidden border-0">
                                    <input type="password" name="txtPassword" class="form-control bg-light border-0" placeholder="Dejar en blanco para conservar la actual...">
                                </div>
                                <div class="form-text small">Si no deseas cambiar tu clave, deja este campo vacío.</div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top border-light d-flex justify-content-end gap-2">
                            <button type="button" class="btn btn-white border shadow-sm rounded-pill px-4 fw-bold hover-effect" data-bs-dismiss="modal">Cerrar</button>
                            <button type="submit" class="btn btn-primary shadow-sm rounded-pill px-4 fw-bold hover-effect"><i class="bi bi-save2-fill me-1"></i> Guardar Cambios</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('buscadorCitas').addEventListener('input', function (e) {
            var termino = e.target.value.trim().toLowerCase();
            var filas = document.querySelectorAll('#tablaCitas tbody tr');
            filas.forEach(function (fila) {
                var texto = fila.textContent.toLowerCase();
                fila.style.display = texto.includes(termino) ? '' : 'none';
            });
        });
    </script>
</body>
</html>