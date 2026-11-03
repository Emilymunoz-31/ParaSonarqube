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
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Portal Odontológico</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/Vista/Imagenes/logo2.0.png">    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/Css/Cssvital.css">
</head>
<body class="dashboard-page admin-module-page">

    <c:set var="rolUsuario" value="${empty usuarioLogueado.descripcionRol ? 'Odontólogo' : usuarioLogueado.descripcionRol}" />

    <c:set var="citasHoy" value="0" />
    <c:forEach var="c" items="${citas}">
        <c:if test="${fn:startsWith(c.fecha_hora, hoyStr)}">
            <c:set var="citasHoy" value="${citasHoy + 1}" />
        </c:if>
    </c:forEach>

    <div class="d-flex dashboard-shell">

        <aside class="dashboard-sidebar-v2 desktop-only d-none d-md-flex">
            <div class="sidebar-brand-row">
                <span class="sidebar-brand-icon">
                    <img src="${pageContext.request.contextPath}/Vista/Imagenes/logo2.0.png" alt="Logo VitalDentist">
                </span>
                <span class="sidebar-brand-text fs-5">VitalDentist</span>
            </div>

            <p class="sidebar-eyebrow mb-2">Portal Profesional</p>

            <nav class="sidebar-nav">
                <a class="sidebar-nav-link active" href="${pageContext.request.contextPath}/OdontologoInicioServlet">
                    <i class="bi bi-grid-1x2-fill"></i> Panel Médico
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/AgendarCitaServlet">
                    <i class="bi bi-calendar-plus-fill"></i> Agendar Cita
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/ControlCitasAgendadasServlet">
                    <i class="bi bi-calendar-check"></i> Control de Citas
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/ControlOrtodonciaServlet">
                    <i class="bi bi-clipboard2-pulse-fill"></i> Ortodoncia
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroTipoTratamientoServlet">
                    <i class="bi bi-bandaid-fill"></i> Tratamientos
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroCategoriaTratamientoServlet">
                    <i class="bi bi-tags-fill"></i> Categorías
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroPagoServlet">
                    <i class="bi bi-credit-card-2-front"></i> Pagos
                </a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroAbonoServlet">
                    <i class="bi bi-cash-coin"></i> Abonos
                </a>
            </nav>

            <div class="sidebar-footer">
                <a class="sidebar-user hover-effect" href="#" data-bs-toggle="modal" data-bs-target="#modalMiPerfil">
                    <span class="sidebar-user-avatar">${fn:substring(fn:toUpperCase(usuarioLogueado.nombreus), 0, 1)}</span>
                    <span>
                        <span class="d-block sidebar-user-name">Dr/a. ${usuarioLogueado.nombreus}</span>
                        <span class="d-block sidebar-user-role">${rolUsuario}</span>
                    </span>
                </a>
                <a class="sidebar-nav-link text-danger mt-2" style="color:#ff8a8a;" href="${pageContext.request.contextPath}/Inicio_sesion?accion=cerrar">
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
            <p class="sidebar-eyebrow mb-2">Portal Odontológico</p>
            <nav class="sidebar-nav">
                <a class="sidebar-nav-link active" href="${pageContext.request.contextPath}/OdontologoInicioServlet"><i class="bi bi-grid-1x2-fill"></i> Panel Médico</a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/AgendarCitaServlet"><i class="bi bi-calendar-plus-fill"></i> Agendar Cita</a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/ControlCitasAgendadasServlet"><i class="bi bi-calendar-check"></i> Control de Citas</a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/ControlOrtodonciaServlet"><i class="bi bi-clipboard2-pulse-fill"></i> Ortodoncia</a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroTipoTratamientoServlet"><i class="bi bi-bandaid-fill"></i> Tratamientos</a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroCategoriaTratamientoServlet"><i class="bi bi-tags-fill"></i> Categorías</a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroPagoServlet"><i class="bi bi-credit-card-2-front"></i> Pagos</a>
                <a class="sidebar-nav-link" href="${pageContext.request.contextPath}/RegistroAbonoServlet"><i class="bi bi-cash-coin"></i> Abonos</a>
            </nav>
            <div class="sidebar-footer">
                <a class="sidebar-user hover-effect" href="#" data-bs-toggle="modal" data-bs-target="#modalMiPerfil">
                    <span class="sidebar-user-avatar">${fn:substring(fn:toUpperCase(usuarioLogueado.nombreus), 0, 1)}</span>
                    <span>
                        <span class="d-block sidebar-user-name">Dr/a. ${usuarioLogueado.nombreus}</span>
                        <span class="d-block sidebar-user-role">${rolUsuario}</span>
                    </span>
                </a>
                <a class="sidebar-nav-link text-danger mt-2" style="color:#ff8a8a;" href="${pageContext.request.contextPath}/Inicio_sesion?accion=cerrar">
                    <i class="bi bi-box-arrow-right"></i> Cerrar sesión
                </a>
            </div>
        </nav>

        <main class="dashboard-main-v2 flex-grow-1 p-3 p-md-4">
            <div class="mobile-topbar d-md-none mb-3">
                <button class="btn btn-sm btn-light shadow-sm" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu">
                    <i class="bi bi-list fs-4"></i>
                </button>
                <span class="fw-bold fs-5 text-primary">VitalDentist Clínico</span>
            </div>

            <div class="clinic-hero mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div class="position-relative" style="z-index: 1;">
                    <span class="badge bg-success bg-opacity-25 text-white rounded-pill px-3 py-1 mb-2 border border-success border-opacity-50">
                        <i class="bi bi-shield-plus me-1"></i> Módulo Profesional
                    </span>
                    <h1 class="h2 fw-bold mb-1 text-white">Dr/a. ${usuarioLogueado.nombreus} ${usuarioLogueado.apellido}</h1>
                    <p class="text-white-50 mb-0">Gestión de agenda odontológica, historial de procedimientos y cartera.</p>
                </div>
                <div class="d-flex gap-2 flex-wrap position-relative" style="z-index: 1;">
                    <div class="bg-white bg-opacity-10 rounded-4 px-3 py-2 text-center border border-white border-opacity-10">
                        <div class="fs-4 fw-bold text-white">${citasHoy}</div>
                        <div class="small text-white-50 text-uppercase fw-semibold" style="font-size: 0.68rem;">Citas Hoy</div>
                    </div>
                    <div class="bg-white bg-opacity-10 rounded-4 px-3 py-2 text-center border border-white border-opacity-10">
                        <div class="fs-4 fw-bold text-white">${empty totalPacientes ? 0 : totalPacientes}</div>
                        <div class="small text-white-50 text-uppercase fw-semibold" style="font-size: 0.68rem;">Pacientes</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/AgendarCitaServlet" class="btn btn-nueva-cita d-flex align-items-center fw-bold shadow-sm px-4">
                        <i class="bi bi-calendar-plus-fill me-2"></i> Programar Cita
                    </a>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <a href="${pageContext.request.contextPath}/AgendarCitaServlet" class="portal-card">
                        <div>
                            <div class="portal-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-calendar-plus"></i>
                            </div>
                            <h2 class="h6 fw-bold text-dark mb-1">Agendar y Registro Rápido</h2>
                            <p class="text-muted small mb-0">Agenda citas y registra nuevos pacientes en un solo paso.</p>
                        </div>
                        <div class="mt-3 text-primary fw-semibold small d-flex align-items-center">
                            Ingresar <i class="bi bi-arrow-right ms-1"></i>
                        </div>
                    </a>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <a href="${pageContext.request.contextPath}/ControlCitasAgendadasServlet" class="portal-card">
                        <div>
                            <div class="portal-icon bg-info bg-opacity-10 text-info">
                                <i class="bi bi-calendar2-check"></i>
                            </div>
                            <h2 class="h6 fw-bold text-dark mb-1">Control de Citas</h2>
                            <p class="text-muted small mb-0">Actualiza estados: atendidas, reprogramadas o canceladas.</p>
                        </div>
                        <div class="mt-3 text-info fw-semibold small d-flex align-items-center">
                            Gestionar <i class="bi bi-arrow-right ms-1"></i>
                        </div>
                    </a>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <a href="${pageContext.request.contextPath}/ControlOrtodonciaServlet" class="portal-card">
                        <div>
                            <div class="portal-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-clipboard2-pulse"></i>
                            </div>
                            <h2 class="h6 fw-bold text-dark mb-1">Evolución Ortodoncia</h2>
                            <p class="text-muted small mb-0">Seguimiento por etapas clínicas y notas de ajuste.</p>
                        </div>
                        <div class="mt-3 text-success fw-semibold small d-flex align-items-center">
                            Ver historial <i class="bi bi-arrow-right ms-1"></i>
                        </div>
                    </a>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <a href="${pageContext.request.contextPath}/RegistroPagoServlet" class="portal-card">
                        <div>
                            <div class="portal-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-wallet2"></i>
                            </div>
                            <h2 class="h6 fw-bold text-dark mb-1">Pagos y Abonos</h2>
                            <p class="text-muted small mb-0">Facturación sin duplicados y control de saldos pendientes.</p>
                        </div>
                        <div class="mt-3 text-warning fw-semibold small d-flex align-items-center">
                            Abrir caja <i class="bi bi-arrow-right ms-1"></i>
                        </div>
                    </a>
                </div>

                <div class="col-sm-6 col-xl-6">
                    <a href="${pageContext.request.contextPath}/RegistroTipoTratamientoServlet" class="portal-card">
                        <div class="d-flex align-items-center gap-3">
                            <div class="portal-icon bg-danger bg-opacity-10 text-danger mb-0">
                                <i class="bi bi-bandaid"></i>
                            </div>
                            <div>
                                <h2 class="h6 fw-bold text-dark mb-0">Catálogo de Tratamientos</h2>
                                <small class="text-muted">Consulta procedimientos odontológicos y aranceles clínicos.</small>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-sm-6 col-xl-6">
                    <a href="${pageContext.request.contextPath}/RegistroCategoriaTratamientoServlet" class="portal-card">
                        <div class="d-flex align-items-center gap-3">
                            <div class="portal-icon bg-secondary bg-opacity-10 text-secondary mb-0">
                                <i class="bi bi-tags"></i>
                            </div>
                            <div>
                                <h2 class="h6 fw-bold text-dark mb-0">Categorías de Tratamientos</h2>
                                <small class="text-muted">Organización clínica (Ortodoncia, Endodoncia, Preventiva, etc.).</small>
                            </div>
                        </div>
                    </a>
                </div>
            </div>

            <section class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
                <div class="card-header bg-white border-bottom p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <div>
                        <h2 class="h5 mb-0 fw-bold text-dark">
                            <i class="bi bi-calendar3 text-primary me-2"></i>Cronograma General de Atención
                        </h2>
                        <small class="text-muted">Lista cronológica completa de pacientes y tratamientos programados.</small>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <div class="input-group input-group-sm" style="max-width: 240px;">
                            <span class="input-group-text bg-white border-end-0"><i class="bi bi-search"></i></span>
                            <input type="search" id="filtroCronograma" class="form-control border-start-0 ps-0" placeholder="Buscar paciente o fecha...">
                        </div>
                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 rounded-pill px-3 py-2">
                            ${fn:length(citas)} citas
                        </span>
                    </div>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive" style="max-height: 520px; overflow-y: auto;">
                        <table class="table table-hover align-middle mb-0" id="tablaCronograma">
                            <thead class="table-light sticky-top">
                                <tr>
                                    <th class="ps-4 py-3 text-uppercase text-secondary small fw-bold">Fecha y Hora</th>
                                    <th class="py-3 text-uppercase text-secondary small fw-bold">Paciente</th>
                                    <th class="py-3 text-uppercase text-secondary small fw-bold">Tratamiento Asignado</th>
                                    <th class="py-3 text-uppercase text-secondary small fw-bold text-center">Estado</th>
                                    <th class="pe-4 py-3 text-uppercase text-secondary small fw-bold text-end">Gestión</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${citas}">
                                    <c:set var="estLower" value="${fn:toLowerCase(c.descripcionEstadoCita)}" />
                                    <c:set var="badgeEstado" value="bg-secondary text-secondary" />
                                    <c:if test="${fn:contains(estLower, 'programada') && !fn:contains(estLower, 'reprogramada')}">
                                        <c:set var="badgeEstado" value="bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25" />
                                    </c:if>
                                    <c:if test="${fn:contains(estLower, 'reprogramada')}">
                                        <c:set var="badgeEstado" value="bg-warning bg-opacity-10 text-dark border border-warning border-opacity-50" />
                                    </c:if>
                                    <c:if test="${fn:contains(estLower, 'atendida') || fn:contains(estLower, 'tomada')}">
                                        <c:set var="badgeEstado" value="bg-success bg-opacity-10 text-success border border-success border-opacity-25" />
                                    </c:if>
                                    <c:if test="${fn:contains(estLower, 'cancelada')}">
                                        <c:set var="badgeEstado" value="bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25" />
                                    </c:if>

                                    <tr class="border-bottom border-light fila-agenda">
                                        <td class="ps-4 py-3">
                                            <div class="fw-bold text-dark">
                                                <i class="bi bi-clock me-1 text-primary"></i> ${c.fecha_hora}
                                            </div>
                                        </td>
                                        <td class="py-3">
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="patient-avatar-mini shadow-sm">
                                                    ${empty c.nombrePaciente ? 'P' : fn:substring(c.nombrePaciente, 0, 1)}
                                                </div>
                                                <div class="fw-semibold text-dark">${empty c.nombrePaciente ? 'Paciente Registrado' : c.nombrePaciente}</div>
                                            </div>
                                        </td>
                                        <td class="py-3">
                                            <span class="badge bg-light text-dark border px-3 py-1 rounded-pill">
                                                ${empty c.descripcionTratamiento ? 'Consulta general' : c.descripcionTratamiento}
                                            </span>
                                        </td>
                                        <td class="py-3 text-center">
                                            <span class="badge rounded-pill px-3 py-1 fw-semibold ${badgeEstado}">
                                                ${empty c.descripcionEstadoCita ? 'Programada' : c.descripcionEstadoCita}
                                            </span>
                                        </td>
                                        <td class="pe-4 py-3 text-end">
                                            <a href="${pageContext.request.contextPath}/ControlCitasAgendadasServlet" class="btn btn-sm btn-light border rounded-pill px-3 fw-semibold">
                                                <i class="bi bi-pencil-square text-primary me-1"></i> Editar Estado
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty citas}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">
                                            <i class="bi bi-calendar-x fs-1 opacity-50 d-block mb-2 text-primary"></i>
                                            <h6 class="fw-bold text-dark">No hay citas en la agenda</h6>
                                            <p class="small">Utiliza el botón "Programar Cita" para agendar una atención.</p>
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
                        <i class="bi bi-person-lines-fill me-2"></i> Mi Perfil Profesional
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body px-4 px-md-5 pb-5 pt-3 bg-white">
                    <div class="text-center mb-4">
                        <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-inline-flex align-items-center justify-content-center mb-2 shadow-sm" style="width: 70px; height: 70px; font-size: 2rem; font-weight: bold;">
                            ${fn:substring(fn:toUpperCase(usuarioLogueado.nombreus), 0, 1)}
                        </div>
                        <h4 class="fw-bold text-dark mb-1">Dr/a. ${usuarioLogueado.nombreus} ${usuarioLogueado.apellido}</h4>
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
                        
                        <h6 class="fw-bold text-secondary border-bottom pb-2 mb-3 mt-4"><i class="bi bi-card-text me-2"></i>Datos Profesionales</h6>
                        
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
        document.getElementById('filtroCronograma').addEventListener('input', function() {
            const termino = this.value.toLowerCase().trim();
            const filas = document.querySelectorAll('#tablaCronograma tbody tr.fila-agenda');
            filas.forEach(fila => {
                const texto = fila.innerText.toLowerCase();
                fila.style.display = texto.includes(termino) ? '' : 'none';
            });
        });
    </script>
</body>
</html>