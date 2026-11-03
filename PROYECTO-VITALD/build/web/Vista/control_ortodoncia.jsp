<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Control y Evolución de Ortodoncia</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${ctx}/Vista/Imagenes/logo2.0.png">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="dashboard-shell" style="background-color: var(--vital-bg-page); overflow-y: auto !important;">

<main class="dashboard-main-v2 fade-in-up" style="animation-duration: 0.6s;">

    <div class="hero-card fade-in-up d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4 no-print" style="animation-delay: 0.1s;">
        <div>
            <p class="hero-eyebrow text-primary"><i class="bi bi-activity me-1"></i> Módulo Clínico Especializado</p>
            <h1 class="hero-title"><i class="bi bi-clipboard2-pulse-fill me-2 text-primary"></i>Controles de Ortodoncia</h1>
            <p class="hero-subtitle">Historial cronológico, avance por etapas y registro de ajustes del paciente.</p>
        </div>
        <div class="d-flex gap-2 mt-3 mt-md-0">
            <a href="${ctx}/AgendarCitaServlet" class="btn btn-primary rounded-pill px-4 shadow-sm fw-semibold hover-effect">
                <i class="bi bi-calendar-plus me-1"></i> Agendar Control
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

    <!-- BUSCADOR -->
    <div class="row justify-content-center mb-5 fade-in-up no-print" style="animation-delay: 0.2s;">
        <div class="col-lg-6 col-md-8">
            <div class="vital-card card search-card shadow-lg border-0 rounded-4 p-4 p-md-5 text-center">
                <div class="icon-circle-lg bg-primary bg-opacity-10 text-primary mx-auto mb-3 shadow-sm">
                    <i class="bi bi-search"></i>
                </div>
                <h3 class="h5 fw-bold text-dark mb-3">Buscar Historial de Ortodoncia</h3>

                <form action="${ctx}/ControlOrtodonciaServlet" method="POST" class="needs-validation" id="formBusqueda" novalidate>
                    <div class="input-group input-group-lg shadow-sm rounded-pill overflow-hidden border border-white mb-2">
                        <span class="input-group-text bg-white text-primary border-0 ps-4"><i class="bi bi-person-vcard fs-5"></i></span>
                        <input type="text" 
                               inputmode="numeric" 
                               pattern="[0-9]{6,12}" 
                               maxlength="12" 
                               class="form-control border-0 bg-white fw-bold text-dark fs-5" 
                               id="txtDocumentoBusqueda" 
                               name="txtDocumentoBusqueda" 
                               placeholder="Ej. 1023456789" 
                               value="${documentoBuscado}" 
                               required 
                               autocomplete="off" 
                               autofocus>
                        <button class="btn btn-primary px-4 fw-bold" type="submit" id="btnBuscar">
                            <span class="btn-label"><i class="bi bi-search me-2 d-none d-sm-inline"></i>Buscar</span>
                            <span class="spinner-border spinner-border-sm text-white" role="status" aria-hidden="true"></span>
                        </button>
                    </div>
                    <small class="text-muted"><i class="bi bi-info-circle me-1"></i>Ingrese solo números de documento sin puntos ni letras.</small>
                </form>
            </div>
        </div>
    </div>

    <c:if test="${not empty documentoBuscado}">
        <div class="row justify-content-center fade-in-up" style="animation-delay: 0.4s;">
            <div class="col-xl-10 col-lg-12">

                <c:choose>
                    <c:when test="${not empty listaControles}">

                        <c:set var="totalConfirmadas" value="${0}"/>
                        <c:set var="totalPendientes" value="${0}"/>
                        <c:set var="totalCanceladas" value="${0}"/>
                        <c:set var="totalControles" value="${listaControles.size()}"/>
                        
                        <c:forEach var="ctrl" items="${listaControles}">
                            <c:choose>
                                <c:when test="${fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'confirmada') || fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'atendida') || fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'tomada')}">
                                    <c:set var="totalConfirmadas" value="${totalConfirmadas + 1}"/>
                                </c:when>
                                <c:when test="${fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'pendiente') || fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'programada') || fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'reprogramada')}">
                                    <c:set var="totalPendientes" value="${totalPendientes + 1}"/>
                                </c:when>
                                <c:when test="${fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'cancelada')}">
                                    <c:set var="totalCanceladas" value="${totalCanceladas + 1}"/>
                                </c:when>
                            </c:choose>
                        </c:forEach>

                        <c:set var="pacientePrincipal" value="${listaControles[0]}"/>

                        <c:set var="etapaTexto" value="Etapa 1: Alineación y Nivelación"/>
                        <c:set var="etapaClase" value="stage-1"/>
                        <c:set var="progresoPorcentaje" value="25"/>

                        <c:if test="${totalConfirmadas >= 3 && totalConfirmadas < 8}">
                            <c:set var="etapaTexto" value="Etapa 2: Cierre de Espacios y Engranaje"/>
                            <c:set var="etapaClase" value="stage-2"/>
                            <c:set var="progresoPorcentaje" value="50"/>
                        </c:if>
                        <c:if test="${totalConfirmadas >= 8 && totalConfirmadas < 14}">
                            <c:set var="etapaTexto" value="Etapa 3: Detalle y Finalización"/>
                            <c:set var="etapaClase" value="stage-3"/>
                            <c:set var="progresoPorcentaje" value="75"/>
                        </c:if>
                        <c:if test="${totalConfirmadas >= 14}">
                            <c:set var="etapaTexto" value="Etapa 4: Retención y Mantenimiento"/>
                            <c:set var="etapaClase" value="stage-4"/>
                            <c:set var="progresoPorcentaje" value="100"/>
                        </c:if>

                        <div class="patient-summary-card mb-4 d-flex flex-column justify-content-between gap-3">
                            <div class="d-flex flex-column flex-sm-row align-items-start align-items-sm-center justify-content-between gap-3">
                                <div class="d-flex align-items-center gap-3 position-relative">
                                    <div class="patient-summary-avatar">
                                        ${empty pacientePrincipal.nombrePaciente ? 'P' : fn:substring(fn:toUpperCase(pacientePrincipal.nombrePaciente), 0, 1)}
                                    </div>
                                    <div>
                                        <div class="patient-summary-name">${empty pacientePrincipal.nombrePaciente ? 'Paciente Registrado' : pacientePrincipal.nombrePaciente}</div>
                                        <div class="patient-summary-meta">
                                            Doc: <strong>${documentoBuscado}</strong> &nbsp;&middot;&nbsp; 
                                            Última Cita: <strong>${pacientePrincipal.fecha_hora}</strong>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex gap-2 position-relative no-print">
                                    <span class="stage-badge ${etapaClase} shadow-sm">
                                        <i class="bi bi-flag-fill"></i> ${etapaTexto}
                                    </span>
                                    <button type="button" class="btn btn-sm btn-light rounded-pill px-3 fw-bold" onclick="window.print()">
                                        <i class="bi bi-printer me-1"></i> Imprimir
                                    </button>
                                </div>
                            </div>

                            <div class="mt-2 pt-2 border-top border-light border-opacity-10 position-relative">
                                <div class="d-flex justify-content-between small text-white-50 mb-1">
                                    <span>Progreso Global Estimado (${progresoPorcentaje}%)</span>
                                    <span>${totalConfirmadas} Sesiones Atendidas</span>
                                </div>
                                <div class="progress rounded-pill bg-dark bg-opacity-25" style="height: 9px;">
                                    <div class="progress-bar bg-success progress-bar-striped progress-bar-animated" role="progressbar" style="width: ${progresoPorcentaje}%;"></div>
                                </div>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-6 col-lg-3">
                                <div class="stat-card">
                                    <div class="stat-icon bg-primary bg-opacity-10 text-primary"><i class="bi bi-calendar2-range"></i></div>
                                    <div>
                                        <div class="stat-value" data-count="${totalControles}">0</div>
                                        <div class="stat-label">Total Citas</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="stat-card">
                                    <div class="stat-icon bg-success bg-opacity-10 text-success"><i class="bi bi-check-circle-fill"></i></div>
                                    <div>
                                        <div class="stat-value" data-count="${totalConfirmadas}">0</div>
                                        <div class="stat-label">Realizadas</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="stat-card">
                                    <div class="stat-icon bg-warning bg-opacity-10 text-warning"><i class="bi bi-clock-history"></i></div>
                                    <div>
                                        <div class="stat-value" data-count="${totalPendientes}">0</div>
                                        <div class="stat-label">Pendientes</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="stat-card">
                                    <div class="stat-icon bg-danger bg-opacity-10 text-danger"><i class="bi bi-x-circle-fill"></i></div>
                                    <div>
                                        <div class="stat-value" data-count="${totalCanceladas}">0</div>
                                        <div class="stat-label">Canceladas</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="vital-card card border-0 shadow-sm rounded-4 overflow-hidden mb-5">
                            <div class="card-header admin-card-header bg-white border-bottom p-4">
                                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                                    <div class="d-flex align-items-center">
                                        <div class="icon-circle-md bg-primary bg-opacity-10 text-primary me-3 shadow-sm d-flex align-items-center justify-content-center" style="width: 45px; height: 45px; border-radius: 50%;">
                                            <i class="bi bi-sort-numeric-down fs-5"></i>
                                        </div>
                                        <div>
                                            <h2 class="h5 mb-0 fw-bold text-dark">Historial Secuencial de Ortodoncia</h2>
                                            <small class="text-muted">Evolución ordenada por fecha y procedimiento clínico.</small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="toolbar-vital pt-3 no-print">
                                <div class="filter-chips" id="filterChips">
                                    <button type="button" class="filter-chip active" data-filter="all">
                                        <span class="dot" style="background:var(--vital-navy);"></span> Todos (${totalControles})
                                    </button>
                                    <button type="button" class="filter-chip" data-filter="confirmada">
                                        <span class="dot" style="background:#198754;"></span> Realizadas (${totalConfirmadas})
                                    </button>
                                    <button type="button" class="filter-chip" data-filter="pendiente">
                                        <span class="dot" style="background:#ffc107;"></span> Pendientes (${totalPendientes})
                                    </button>
                                    <button type="button" class="filter-chip" data-filter="cancelada">
                                        <span class="dot" style="background:#dc3545;"></span> Canceladas (${totalCanceladas})
                                    </button>
                                </div>
                                <div class="view-switch" id="viewSwitch">
                                    <button type="button" class="active" data-view="tabla"><i class="bi bi-table me-1"></i>Tabla</button>
                                    <button type="button" data-view="timeline"><i class="bi bi-clock-history me-1"></i>Evolución Temporal</button>
                                </div>
                            </div>

                            <div class="card-body p-0" id="vistaTabla">
                                <div class="table-responsive">
                                    <table class="table table-vital table-hover align-middle mb-0">
                                        <thead class="bg-light">
                                            <tr>
                                                <th class="ps-4 py-3 text-center">Sesión</th>
                                                <th class="py-3">Fecha y Hora</th>
                                                <th class="py-3">Tratamiento / Procedimiento</th>
                                                <th class="py-3">Especialista</th>
                                                <th class="py-3 text-center">Estado</th>
                                                <th class="pe-4 py-3">Detalle Clínico / Ajuste</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="ctrl" items="${listaControles}" varStatus="loop">
                                                <c:set var="statusRow" value="pendiente"/>
                                                <c:if test="${fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'confirmada') || fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'atendida') || fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'tomada')}">
                                                    <c:set var="statusRow" value="confirmada"/>
                                                </c:if>
                                                <c:if test="${fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'cancelada')}">
                                                    <c:set var="statusRow" value="cancelada"/>
                                                </c:if>

                                                <tr class="border-bottom" data-status="${statusRow}">
                                                    <td class="ps-4 py-3 text-center">
                                                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 rounded-pill px-3 py-2 fw-bold">
                                                            Control #${totalControles - loop.index}
                                                        </span>
                                                    </td>
                                                    <td class="py-3 fw-bold text-dark">
                                                        <i class="bi bi-calendar-check text-primary me-1"></i> ${ctrl.fecha_hora}
                                                    </td>
                                                    <td class="py-3">
                                                        <span class="fw-semibold text-dark">${empty ctrl.descripcionTratamiento ? 'Control de Ortodoncia' : ctrl.descripcionTratamiento}</span>
                                                    </td>
                                                    <td class="py-3 text-secondary">
                                                        Dr/a. ${empty ctrl.nombreOdontologo ? 'Especialista' : ctrl.nombreOdontologo}
                                                    </td>
                                                    <td class="py-3 text-center">
                                                        <span class="badge rounded-pill px-3 py-2 ${statusRow eq 'confirmada' ? 'bg-success' : (statusRow eq 'cancelada' ? 'bg-danger' : 'bg-warning text-dark')}">
                                                            ${empty ctrl.descripcionEstadoCita ? 'Programada' : ctrl.descripcionEstadoCita}
                                                        </span>
                                                    </td>
                                                    <td class="pe-4 py-3 text-muted small">
                                                        <c:out value="${ctrl.descripcion_cita}" default="Sin observaciones clínicas registradas para este control."/>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="card-body p-0 d-none" id="vistaTimeline">
                                <div class="timeline">
                                    <c:forEach var="ctrl" items="${listaControles}" varStatus="loop">
                                        <c:set var="statusItem" value="pendiente"/>
                                        <c:if test="${fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'confirmada') || fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'atendida') || fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'tomada')}">
                                            <c:set var="statusItem" value="confirmada"/>
                                        </c:if>
                                        <c:if test="${fn:containsIgnoreCase(ctrl.descripcionEstadoCita, 'cancelada')}">
                                            <c:set var="statusItem" value="cancelada"/>
                                        </c:if>

                                        <div class="timeline-item" data-status="${statusItem}">
                                            <span class="timeline-dot" style="background-color: ${statusItem eq 'confirmada' ? '#198754' : (statusItem eq 'cancelada' ? '#dc3545' : '#ffc107')};"></span>
                                            <div class="timeline-card">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <span class="badge bg-primary text-white rounded-pill px-3">Control #${totalControles - loop.index}</span>
                                                    <span class="small text-muted"><i class="bi bi-clock me-1"></i>${ctrl.fecha_hora}</span>
                                                </div>
                                                <h6 class="fw-bold text-dark mb-1">${empty ctrl.descripcionTratamiento ? 'Control de Ortodoncia' : ctrl.descripcionTratamiento}</h6>
                                                <p class="text-secondary small mb-2">Atendido por: <strong>Dr/a. ${empty ctrl.nombreOdontologo ? 'Especialista' : ctrl.nombreOdontologo}</strong></p>
                                                <div class="bg-white p-2 rounded-3 border small text-muted">
                                                    <i class="bi bi-chat-left-text me-1 text-primary"></i>
                                                    <c:out value="${ctrl.descripcion_cita}" default="Sin notas clínicas en esta fecha."/>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="vital-card card border-0 shadow-sm rounded-4 overflow-hidden mb-5">
                            <div class="card-body p-5 text-center">
                                <div class="empty-state-icon shadow-sm mx-auto mb-4" style="width: 80px; height: 80px; background-color: #fff3f3; color: #dc3545; border-radius: 50%; display:flex; align-items:center; justify-content:center;">
                                    <i class="bi bi-search fs-1"></i>
                                </div>
                                <h3 class="fw-bold text-dark mb-2">Sin Historial de Ortodoncia</h3>
                                <p class="text-muted fs-5 mb-4">No se encontraron citas o controles agendados para el paciente con documento <strong class="text-danger">${documentoBuscado}</strong>.</p>
                                <a href="${ctx}/AgendarCitaServlet" class="btn btn-primary rounded-pill px-4 shadow-sm hover-effect">
                                    <i class="bi bi-calendar-plus me-2"></i> Agendar su Primer Control
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </c:if>

</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        'use strict';

        var inputDoc = document.getElementById('txtDocumentoBusqueda');
        if (inputDoc) {
            inputDoc.addEventListener('input', function () {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        }

        var formBusqueda = document.getElementById('formBusqueda');
        var btnBuscar = document.getElementById('btnBuscar');
        if (formBusqueda && btnBuscar) {
            formBusqueda.addEventListener('submit', function () {
                if (inputDoc && inputDoc.value.trim().length >= 6) {
                    btnBuscar.classList.add('is-loading');
                }
            });
        }

        document.querySelectorAll('.stat-value[data-count]').forEach(function (el) {
            var target = parseInt(el.getAttribute('data-count'), 10) || 0;
            var current = 0;
            var duration = 500;
            var start = null;
            function step(ts) {
                if (!start) start = ts;
                var progress = Math.min((ts - start) / duration, 1);
                current = Math.floor(progress * target);
                el.textContent = current;
                if (progress < 1) requestAnimationFrame(step);
                else el.textContent = target;
            }
            requestAnimationFrame(step);
        });

        var chips = document.querySelectorAll('.filter-chip');
        chips.forEach(function (chip) {
            chip.addEventListener('click', function () {
                chips.forEach(function (c) { c.classList.remove('active'); });
                chip.classList.add('active');
                var filter = chip.getAttribute('data-filter');

                document.querySelectorAll('#vistaTabla tbody tr, #vistaTimeline .timeline-item').forEach(function (row) {
                    var status = row.getAttribute('data-status');
                    var show = (filter === 'all' || status === filter);
                    row.classList.toggle('row-hidden', !show);
                });
            });
        });

        var viewButtons = document.querySelectorAll('#viewSwitch button');
        var vistaTabla = document.getElementById('vistaTabla');
        var vistaTimeline = document.getElementById('vistaTimeline');
        viewButtons.forEach(function (btn) {
            btn.addEventListener('click', function () {
                viewButtons.forEach(function (b) { b.classList.remove('active'); });
                btn.classList.add('active');
                if (btn.getAttribute('data-view') === 'timeline') {
                    vistaTabla.classList.add('d-none');
                    vistaTimeline.classList.remove('d-none');
                } else {
                    vistaTimeline.classList.add('d-none');
                    vistaTabla.classList.remove('d-none');
                }
            });
        });
    })();
</script>
</body>
</html>