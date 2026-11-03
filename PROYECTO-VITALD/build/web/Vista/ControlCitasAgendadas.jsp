<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%
    String ahoraStr = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date());
    request.setAttribute("ahoraStr", ahoraStr);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Control de Citas</title>
    <link rel="icon" type="image/png" href="${ctx}/Vista/Imagenes/logo2.0.png">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
          integrity="sha384-XGjxtQfXaH2tnPFa9x+ruJTuLE3Aa6LhHSWRr1XeTyhezb4abCG4ccI5AkVDxqC+"
          crossorigin="anonymous">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="dashboard-shell" style="background-color: var(--vital-bg-page); overflow-y: auto !important;">

<main class="dashboard-main-v2 fade-in-up py-4 px-3 px-md-5" style="animation-duration: 0.6s;">

    <div class="hero-card fade-in-up d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4" style="animation-delay: 0.1s;">
        <div>
            <p class="hero-eyebrow text-primary"><i class="bi bi-calendar2-check-fill me-1"></i> Módulo Clínico</p>
            <h1 class="hero-title"><i class="bi bi-card-list me-2 text-primary"></i>Control de Citas Agendadas</h1>
            <p class="hero-subtitle">Visualiza, edita o elimina las citas programadas en el sistema.</p>
        </div>
        <div class="d-flex flex-column flex-sm-row gap-2 mt-3 mt-md-0">
            <a href="${ctx}/AgendarCitaServlet" class="btn btn-primary rounded-pill px-4 shadow-sm fw-semibold hover-effect">
                <i class="bi bi-plus-circle-fill me-2"></i> Agregar Nueva Cita
            </a>

            <c:choose>
                <c:when test="${sessionScope.usuarioLogueado.rol_id_Rol == 1 or fn:containsIgnoreCase(sessionScope.usuarioLogueado.descripcionRol, 'odont')}">
                    <a href="${ctx}/OdontologoInicioServlet" class="btn btn-outline-secondary rounded-pill px-4 shadow-sm transition-all hover-effect">
                        <i class="bi bi-arrow-left me-2"></i> Volver al panel
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${ctx}/AdminInicioServlet" class="btn btn-outline-secondary rounded-pill px-4 shadow-sm transition-all hover-effect">
                        <i class="bi bi-arrow-left me-2"></i> Volver al panel
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <c:if test="${param.mensaje == 'eliminado'}">
        <div class="alert alert-success border-0 shadow-sm rounded-4 mb-4 fade-in-up">
            <i class="bi bi-check-circle-fill me-2"></i><strong>¡Éxito!</strong> La cita ha sido cancelada y eliminada correctamente.
        </div>
    </c:if>
    <c:if test="${param.mensaje == 'estado_actualizado'}">
        <div class="alert alert-info border-0 shadow-sm rounded-4 mb-4 fade-in-up">
            <i class="bi bi-arrow-repeat me-2"></i><strong>Actualizado:</strong> El estado de la cita ha sido modificado.
        </div>
    </c:if>
    <c:if test="${param.error == 'eliminar'}">
        <div class="alert alert-danger border-0 shadow-sm rounded-4 mb-4 fade-in-up">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>Ocurrió un error al intentar eliminar la cita.
        </div>
    </c:if>

    <div class="vital-card card border-0 shadow-sm rounded-4 overflow-hidden fade-in-up" style="animation-delay: 0.2s;">
        <div class="card-header admin-card-header bg-white border-bottom p-4 d-flex justify-content-between align-items-center">
            <h2 class="h5 mb-0 fw-bold text-dark"><i class="bi bi-list-task text-primary me-2"></i>Directorio General de Citas</h2>
            <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill shadow-sm fs-6 border border-primary border-opacity-25">
                ${fn:length(citas)} Agendadas
            </span>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive" style="max-height: 600px; overflow-y: auto;">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light sticky-top">
                        <tr>
                            <th class="ps-4 py-3 text-uppercase text-secondary small fw-bold">Fecha y Hora</th>
                            <th class="py-3 text-uppercase text-secondary small fw-bold">Paciente</th>
                            <th class="py-3 text-uppercase text-secondary small fw-bold">Odontólogo</th>
                            <th class="py-3 text-uppercase text-secondary small fw-bold">Tratamiento</th>
                            <th class="py-3 text-uppercase text-secondary small fw-bold text-center">Estado</th>
                            <th class="pe-4 py-3 text-uppercase text-secondary small fw-bold text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cita" items="${citas}">
                            <c:set var="yaPaso" value="${cita.fecha_hora < ahoraStr}" />
                            <c:set var="descEstado" value="${fn:toLowerCase(cita.descripcionEstadoCita)}" />
                            <c:set var="esProgramada" value="${fn:contains(descEstado, 'programada') && !fn:contains(descEstado, 'reprogramada')}" />
                            <c:set var="esReprogramada" value="${fn:contains(descEstado, 'reprogramada')}" />
                            <c:set var="esCancelada" value="${fn:contains(descEstado, 'cancelada')}" />
                            <c:set var="esAtendida" value="${fn:contains(descEstado, 'atendida') || fn:contains(descEstado, 'tomada')}" />

                            <c:choose>
                                <c:when test="${yaPaso && esProgramada}">
                                    <c:set var="colorEstado" value="bg-success text-white border-success" />
                                </c:when>
                                <c:when test="${esProgramada}">
                                    <c:set var="colorEstado" value="bg-primary text-white border-primary" />
                                </c:when>
                                <c:when test="${esReprogramada}">
                                    <c:set var="colorEstado" value="bg-warning text-dark border-warning" />
                                </c:when>
                                <c:when test="${esCancelada}">
                                    <c:set var="colorEstado" value="bg-danger text-white border-danger" />
                                </c:when>
                                <c:when test="${esAtendida}">
                                    <c:set var="colorEstado" value="bg-success text-white border-success" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="colorEstado" value="bg-secondary text-white border-secondary" />
                                </c:otherwise>
                            </c:choose>

                            <tr class="border-bottom ${yaPaso ? 'cita-vencida' : ''}">
                                <td class="ps-4 py-3">
                                    <div class="fw-bold ${yaPaso ? 'text-secondary' : 'text-dark'}">
                                        <i class="bi bi-clock me-2 ${yaPaso ? 'text-danger' : 'text-primary'}"></i>${cita.fecha_hora}
                                    </div>
                                </td>
                                <td class="py-3 fw-semibold text-dark">
                                    <i class="bi bi-person me-1 text-primary"></i> ${empty cita.nombrePaciente ? 'Paciente' : cita.nombrePaciente}
                                </td>
                                <td class="py-3">
                                    Dr/a. ${empty cita.nombreOdontologo ? 'Asignado' : cita.nombreOdontologo}
                                </td>
                                <td class="py-3">
                                    ${empty cita.descripcionTratamiento ? 'General' : cita.descripcionTratamiento}
                                </td>
                                <td class="py-3 text-center">
                                    <form action="${ctx}/ControlCitasAgendadasServlet" method="POST" class="m-0 p-0">
                                        <input type="hidden" name="accion" value="cambiarEstado">
                                        <input type="hidden" name="idCita" value="${cita.id_Cita}">

                                        <select name="nuevoEstado" class="form-select select-estado px-3 py-1 rounded-pill fw-semibold border ${colorEstado}" onchange="this.form.submit()">
                                            <c:choose>
                                                <c:when test="${not empty estadosCita}">
                                                    <c:forEach var="estadoCatalogo" items="${estadosCita}">
                                                        <c:set var="descCatLower" value="${fn:toLowerCase(estadoCatalogo.descripcion_estadoci)}" />
                                                        <c:set var="isSelected" value="${cita.estado_cita_idEstado_cita == estadoCatalogo.idEstado_cita || fn:contains(descEstado, descCatLower)}" />
                                                        <option value="${estadoCatalogo.idEstado_cita}" ${isSelected ? 'selected' : ''}>
                                                            ${estadoCatalogo.descripcion_estadoci}
                                                        </option>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="1" ${esProgramada ? 'selected' : ''}>Programada</option>
                                                    <option value="2" ${esReprogramada ? 'selected' : ''}>Reprogramada</option>
                                                    <option value="3" ${esCancelada ? 'selected' : ''}>Cancelada</option>
                                                    <option value="4" ${esAtendida ? 'selected' : ''}>Atendida / Tomada</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </select>
                                    </form>
                                    <c:if test="${yaPaso && esProgramada}">
                                        <small class="text-danger d-block mt-1" style="font-size: 0.7rem;"><i class="bi bi-check2-all"></i> Autocompletada</small>
                                    </c:if>
                                </td>
                                <td class="pe-4 py-3 text-end">
                                    <div class="d-flex justify-content-end gap-2">
                                        <a href="${ctx}/AgendarCitaServlet?accion=editar&id=${cita.id_Cita}" class="btn btn-sm btn-light border shadow-sm rounded-circle hover-effect" style="width: 35px; height: 35px;" title="Editar Cita">
                                            <i class="bi bi-pencil text-primary"></i>
                                        </a>
                                        <a href="${ctx}/ControlCitasAgendadasServlet?accion=eliminar&id=${cita.id_Cita}" class="btn btn-sm btn-light border shadow-sm rounded-circle hover-effect" style="width: 35px; height: 35px;" title="Eliminar Cita" onclick="return confirm('¿Está seguro de que desea eliminar permanentemente esta cita?');">
                                            <i class="bi bi-trash text-danger"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty citas}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <div class="empty-state-icon shadow-sm mx-auto mb-3 text-primary opacity-50" style="width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; border-radius: 50%; background: #f0f4f8;">
                                        <i class="bi bi-calendar-x fs-3"></i>
                                    </div>
                                    <h5 class="fw-bold text-dark mb-1">No hay citas agendadas</h5>
                                    <p class="small">Utilice el botón "Agregar Nueva Cita" para comenzar.</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>
