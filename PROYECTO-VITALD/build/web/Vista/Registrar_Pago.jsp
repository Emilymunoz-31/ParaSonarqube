<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Módulo Financiero</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${ctx}/Vista/Imagenes/logo2.0.png">
    
    <!-- Nasimpa ti SonarQube: Nainayon ti integrity ken crossorigin para iti Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    
    <!-- Nasimpa ti SonarQube: Nainayon ti integrity ken crossorigin para iti Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" integrity="sha384-XGjxtQfXaH2tnPFa9x+ruJTuLE3Aa6LhHSWRr1XeTyhezb4abCG4ccI5AkVDxqC+" crossorigin="anonymous">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="dashboard-shell" style="background-color: var(--vital-bg-page); overflow-y: auto !important;">

<main class="dashboard-main-v2 fade-in-up" style="animation-duration: 0.6s;">

    <div class="hero-card fade-in-up d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4" style="animation-delay: 0.1s;">
        <div>
            <p class="hero-eyebrow text-success"><i class="bi bi-bank me-1"></i> Módulo Financiero</p>
            <h1 class="hero-title"><i class="bi bi-wallet2 me-2 text-success"></i>Gestión de Pagos</h1>
            <p class="hero-subtitle">Registra, actualiza y controla los pagos asociados a las citas clínicas.</p>
        </div>

        <c:choose>
            <c:when test="${sessionScope.usuarioLogueado.rol_id_Rol == 1 or fn:containsIgnoreCase(sessionScope.usuarioLogueado.descripcionRol, 'odont')}">
                <a href="${ctx}/OdontologoInicioServlet" class="btn btn-outline-secondary rounded-pill px-4 mt-3 mt-md-0 shadow-sm transition-all hover-effect">
                    <i class="bi bi-arrow-left me-2"></i> Volver al panel
                </a>
            </c:when>
            <c:otherwise>
                <a href="${ctx}/AdminInicioServlet" class="btn btn-outline-secondary rounded-pill px-4 mt-3 mt-md-0 shadow-sm transition-all hover-effect">
                    <i class="bi bi-arrow-left me-2"></i> Volver al panel
                </a>
            </c:otherwise>
        </c:choose>
    </div>

    <c:if test="${param.mensaje == 'guardado'}">
        <div id="msgSuccess" data-msg="El pago se ha registrado correctamente en el sistema." class="d-none"></div>
    </c:if>
    <c:if test="${param.mensaje == 'eliminado'}">
        <div id="msgDeleted" data-msg="El registro de pago ha sido anulado." class="d-none"></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div id="msgError" data-msg="No fue posible procesar la transacción financiera." class="d-none"></div>
    </c:if>

    <div class="row g-4">
        <div class="col-xl-4 col-lg-5 fade-in-up" style="animation-delay: 0.2s;">
            <section class="vital-card card finance-card shadow-sm rounded-4 border-0 h-100">
                <div class="card-header bg-transparent border-0 pt-4 px-4 pb-0">
                    <div class="d-flex align-items-center mb-2">
                        <div class="icon-circle-lg bg-success bg-opacity-10 text-success me-3 shadow-sm">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                        <h2 class="h5 mb-0 fw-bold text-dark">${empty pagoEditar ? 'Registrar / Actualizar Cobro' : 'Editar Factura'}</h2>
                    </div>
                </div>
                
                <div class="card-body p-4">
                    <form action="${ctx}/RegistroPagoServlet" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="${empty pagoEditar ? 'insertar' : 'actualizar'}">
                        <input type="hidden" name="id" value="${pagoEditar.id_Pago}">
                        
                        <div class="row g-4">
                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">1. Cita y Paciente Asociado</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-calendar-check-fill"></i></span>
                                    
                                    <select id="selectCitaPago" name="cita" class="form-select border-0 bg-white fw-medium text-dark" required>
                                        <option value="" data-costo="0" disabled selected>Seleccione la cita a cobrar...</option>
                                        
                                        <optgroup label="Citas Pendientes de Facturación">
                                            <c:forEach var="cita" items="${citas}">
                                                <c:set var="yaTienePago" value="false" />
                                                <c:forEach var="p" items="${pagos}">
                                                    <c:if test="${p.cita_id_Cita == cita.id_Cita}">
                                                        <c:set var="yaTienePago" value="true" />
                                                    </c:if>
                                                </c:forEach>

                                                <c:if test="${!yaTienePago}">
                                                    <option value="${cita.id_Cita}" data-costo="${cita.costoTratamiento}">
                                                        ${empty cita.nombrePaciente ? 'Paciente' : cita.nombrePaciente} - 
                                                        ${empty cita.descripcionTratamiento ? 'Tratamiento' : cita.descripcionTratamiento} 
                                                        (${cita.fecha_hora})
                                                    </option>
                                                </c:if>
                                            </c:forEach>
                                        </optgroup>

                                        <optgroup label="Citas Ya Facturadas (Bloqueadas para evitar duplicados)">
                                            <c:forEach var="cita" items="${citas}">
                                                <c:set var="pagoRegistrado" value="" />
                                                <c:forEach var="p" items="${pagos}">
                                                    <c:if test="${p.cita_id_Cita == cita.id_Cita}">
                                                        <c:set var="pagoRegistrado" value="${p}" />
                                                    </c:if>
                                                </c:forEach>

                                                <c:if test="${not empty pagoRegistrado}">
                                                    <c:set var="esLaQueSeEdita" value="${not empty pagoEditar && pagoEditar.cita_id_Cita == cita.id_Cita}" />
                                                    <option value="${cita.id_Cita}" 
                                                            data-costo="${cita.costoTratamiento}"
                                                            ${esLaQueSeEdita ? 'selected' : 'disabled'}
                                                            class="${esLaQueSeEdita ? 'fw-bold text-primary' : 'text-muted'}">
                                                        ${empty cita.nombrePaciente ? 'Paciente' : cita.nombrePaciente} - 
                                                        ${empty cita.descripcionTratamiento ? 'Tratamiento' : cita.descripcionTratamiento} 
                                                        (${cita.fecha_hora}) [${pagoRegistrado.descripcionEstadoPago}: $${pagoRegistrado.monto}]
                                                    </option>
                                                </c:if>
                                            </c:forEach>
                                        </optgroup>
                                    </select>
                                    <div class="invalid-feedback">Debe asociar este cobro a una cita existente.</div>
                                </div>
                                <div class="form-text mt-2 small text-muted"><i class="bi bi-shield-check text-success me-1"></i>Las citas con cobro registrado se bloquean para evitar pagos duplicados.</div>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">2. Monto de la Transacción</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-success border-0 fs-5 fw-bold">$</span>
                                    
                                    <input type="number" id="inputMontoPago" name="monto" class="form-control border-0 bg-white fw-bold text-dark fs-5" 
                                           value="<c:if test='${not empty pagoEditar}'><fmt:formatNumber value='${pagoEditar.monto}' pattern='0' groupingUsed='false' /></c:if>" 
                                           min="1" step="1"
                                           placeholder="Ej. 150000" required>
                                           
                                    <div class="invalid-feedback">Ingrese un monto válido mayor a cero (sin puntos ni comas).</div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">3. Método de Pago</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-credit-card-2-front-fill"></i></span>
                                    <select name="medioPago" class="form-select border-0 bg-white fw-medium" required>
                                        <option value="" disabled selected>Seleccione la forma de pago...</option>
                                        <c:forEach var="medio" items="${mediosPago}">
                                            <option value="${medio.id_Mediopago}" ${pagoEditar.medio_pago_id_Mediopago == medio.id_Mediopago ? 'selected' : ''}>${medio.descripcion_mediopa}</option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">Seleccione cómo pagó el paciente.</div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">4. Estado de la Factura</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-bookmark-check-fill"></i></span>
                                    <select name="estadoPago" class="form-select border-0 bg-white fw-bold" required>
                                        <option value="" disabled selected>Seleccione el estado...</option>
                                        <c:forEach var="estado" items="${estadosPago}">
                                            <option value="${estado.id_Estadopago}" ${pagoEditar.estado_pago_id_Estadopago == estado.id_Estadopago ? 'selected' : ''}>${estado.descripcion_estadop}</option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">Defina el estado de esta transacción.</div>
                                </div>
                            </div>

                            <div class="col-12 mt-4 pt-3 border-top border-success border-opacity-10 d-flex flex-column gap-2">
                                <button class="btn-nueva-cita shadow-sm w-100 fs-6" style="background: var(--vital-mint-600); color: white;" type="submit">
                                    <i class="bi bi-check-circle-fill me-2"></i>${empty pagoEditar ? 'Procesar / Actualizar Pago' : 'Actualizar Pago'}
                                </button>
                                <c:if test="${not empty pagoEditar}">
                                    <a class="btn btn-white text-danger fw-bold rounded-pill w-100 border shadow-sm hover-effect" href="${ctx}/RegistroPagoServlet">
                                        <i class="bi bi-x-circle me-1"></i> Cancelar Edición
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </form>
                </div>
            </section>
        </div>

        <div class="col-xl-8 col-lg-7 fade-in-up" style="animation-delay: 0.4s;">
            <section class="vital-card card border-0 shadow-sm rounded-4 overflow-hidden h-100">
                <div class="card-header admin-card-header bg-white border-bottom p-4">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                        <div>
                            <h2 class="h5 mb-1 fw-bold text-dark"><i class="bi bi-receipt text-primary me-2"></i>Historial Financiero</h2>
                            <small class="text-muted">Lista detallada filtrada por estado de cobro.</small>
                        </div>
                        <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill shadow-sm fs-6 border border-success border-opacity-25">${pagos.size()} Transacciones</span>
                    </div>

                    <div class="d-flex gap-2 mt-3 flex-wrap" id="filtrosEstadoPago">
                        <button type="button" class="btn btn-sm btn-outline-dark rounded-pill px-3 filter-btn active" data-filter="all">Todos</button>
                        <button type="button" class="btn btn-sm btn-outline-success rounded-pill px-3 filter-btn" data-filter="pagado">Pagados</button>
                        <button type="button" class="btn btn-sm btn-outline-warning rounded-pill px-3 filter-btn" data-filter="parcial">Pago Parcial</button>
                        <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-3 filter-btn" data-filter="pendiente">Pendientes</button>
                    </div>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive" style="max-height: 600px; overflow-y: auto;">
                        <table class="table table-vital table-hover table-borderless align-middle mb-0" id="tablaPagos">
                            <thead class="sticky-top bg-light" style="z-index: 1;">
                                <tr>
                                    <th class="ps-4 py-3 rounded-start">Paciente y Tratamiento</th>
                                    <th class="py-3">Monto Total</th>
                                    <th class="py-3 text-center">Método</th>
                                    <th class="py-3 text-center">Estado</th>
                                    <th class="pe-4 py-3 text-end rounded-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pago" items="${pagos}">
                                    <c:set var="citaRelacionada" value="" />
                                    <c:forEach var="cita" items="${citas}">
                                        <c:if test="${cita.id_Cita == pago.cita_id_Cita}">
                                            <c:set var="citaRelacionada" value="${cita}" />
                                        </c:if>
                                    </c:forEach>

                                    <c:set var="estadoLower" value="${fn:toLowerCase(pago.descripcionEstadoPago)}" />
                                    
                                    <c:set var="badgeClass" value="bg-secondary text-secondary" />
                                    <c:if test="${fn:contains(estadoLower, 'pagado')}">
                                        <c:set var="badgeClass" value="bg-success bg-opacity-10 text-success border border-success border-opacity-25" />
                                    </c:if>
                                    <c:if test="${fn:contains(estadoLower, 'parcial')}">
                                        <c:set var="badgeClass" value="bg-warning bg-opacity-10 text-dark border border-warning border-opacity-50" />
                                    </c:if>
                                    <c:if test="${fn:contains(estadoLower, 'pendiente')}">
                                        <c:set var="badgeClass" value="bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25" />
                                    </c:if>

                                    <tr class="border-bottom border-light fila-pago" data-estado="${estadoLower}">
                                        <td class="ps-4 py-3">
                                            <div class="patient-cell">
                                                <div class="patient-cell-avatar">
                                                    ${empty citaRelacionada.nombrePaciente ? 'P' : fn:substring(citaRelacionada.nombrePaciente, 0, 1)}
                                                </div>
                                                <div>
                                                    <div class="fw-bold text-dark mb-0">${empty citaRelacionada.nombrePaciente ? 'Paciente Registrado' : citaRelacionada.nombrePaciente}</div>
                                                    <div class="text-muted small">
                                                        <i class="bi bi-bandaid text-primary opacity-50 me-1"></i>${empty citaRelacionada.descripcionTratamiento ? 'Cita #' += pago.cita_id_Cita : citaRelacionada.descripcionTratamiento}
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="py-3 fw-bold text-dark fs-6">
                                            $ <fmt:formatNumber value="${pago.monto}" pattern="#,##0" />
                                        </td>
                                        <td class="py-3 text-center text-secondary fw-medium">
                                            ${empty pago.descripcionMedioPago ? 'No definido' : pago.descripcionMedioPago}
                                        </td>
                                        <td class="py-3 text-center">
                                            <span class="badge rounded-pill px-3 py-2 fw-semibold ${badgeClass}">
                                                ${empty pago.descripcionEstadoPago ? 'Pendiente' : pago.descripcionEstadoPago}
                                            </span>
                                        </td>
                                        <td class="pe-4 py-3 text-end">
                                            <div class="d-flex justify-content-end gap-1">
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle hover-effect" style="width: 35px; height: 35px; line-height: 22px;" title="Editar Transacción" href="${ctx}/RegistroPagoServlet?accion=editar&id=${pago.id_Pago}">
                                                    <i class="bi bi-pencil-square text-primary"></i>
                                                </a>
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle hover-effect delete-btn" style="width: 35px; height: 35px; line-height: 22px;" title="Anular Pago" href="${ctx}/RegistroPagoServlet?accion=eliminar&id=${pago.id_Pago}">
                                                    <i class="bi bi-trash-fill text-danger"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty pagos}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5">
                                            <div class="empty-state-icon shadow-sm mx-auto mb-3" style="width: 70px; height: 70px;">
                                                <i class="bi bi-piggy-bank text-success opacity-50 fs-2"></i>
                                            </div>
                                            <h5 class="fw-bold text-dark mb-1">Caja Vacía</h5>
                                            <p class="text-muted small">Aún no hay transacciones o cobros registrados en el sistema.</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </div>
</main>

<!-- Nasimpa ti SonarQube: Nainayon ti integrity ken crossorigin para iti Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmxc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${ctx}/Vista/Javascript/validaciones.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const selectCita = document.getElementById('selectCitaPago');
        const inputMonto = document.getElementById('inputMontoPago');

        if (selectCita && inputMonto) {
            selectCita.addEventListener('change', function() {
                const opcionElegida = this.options[this.selectedIndex];
                const costoTratamiento = opcionElegida.getAttribute('data-costo');
                
                if (costoTratamiento && parseFloat(costoTratamiento) > 0) {
                    inputMonto.value = Math.trunc(parseFloat(costoTratamiento));
                } else {
                    inputMonto.value = '';
                }
            });
        }

        const filterBtns = document.querySelectorAll('.filter-btn');
        const rows = document.querySelectorAll('.fila-pago');

        filterBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                filterBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');

                const filter = this.getAttribute('data-filter');

                rows.forEach(row => {
                    const estado = row.getAttribute('data-estado');
                    if (filter === 'all' || (estado && estado.includes(filter))) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        });

        const msgSuccess = document.getElementById('msgSuccess');
        const msgDeleted = document.getElementById('msgDeleted');
        const msgError = document.getElementById('msgError');

        if (msgSuccess) {
            Swal.fire({
                title: '¡Operación Exitosa!',
                text: msgSuccess.getAttribute('data-msg'),
                icon: 'success',
                customClass: { popup: 'rounded-4 shadow-lg', confirmButton: 'btn btn-primary rounded-pill px-4 fw-bold' },
                buttonsStyling: false,
                confirmButtonText: 'Continuar'
            });
        }

        if (msgDeleted) {
            Swal.fire({
                title: 'Transacción Anulada',
                text: msgDeleted.getAttribute('data-msg'),
                icon: 'info',
                customClass: { popup: 'rounded-4 shadow-lg', confirmButton: 'btn btn-primary rounded-pill px-4 fw-bold' },
                buttonsStyling: false,
                confirmButtonText: 'Entendido'
            });
        }

        if (msgError) {
            Swal.fire({
                title: 'Fallo en la Operación',
                text: msgError.getAttribute('data-msg'),
                icon: 'error',
                customClass: { popup: 'rounded-4 shadow-lg', confirmButton: 'btn btn-danger rounded-pill px-4 fw-bold' },
                buttonsStyling: false,
                confirmButtonText: 'Revisar'
            });
        }

        document.querySelectorAll('.delete-btn').forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                const url = this.getAttribute('href');
                Swal.fire({
                    title: '¿Anular este pago?',
                    text: "El registro financiero será eliminado de la base de datos.",
                    icon: 'warning',
                    showCancelButton: true,
                    customClass: {
                        popup: 'rounded-4 shadow-lg',
                        confirmButton: 'btn btn-danger rounded-pill px-4 fw-bold me-2',
                        cancelButton: 'btn btn-light border rounded-pill px-4 fw-bold'
                    },
                    buttonsStyling: false,
                    confirmButtonText: 'Sí, anular',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = url;
                    }
                });
            });
        });
    });
</script>
</body>
</html>