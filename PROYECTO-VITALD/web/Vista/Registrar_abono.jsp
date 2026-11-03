<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%
    String hoyStr = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
    request.setAttribute("hoyStr", hoyStr);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Gestión de Abonos</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${ctx}/Vista/Imagenes/logo2.0.png">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" integrity="sha384-XGjxtQfXaH2tnPFa9x+ruJTuLE3Aa6LhHSWRr1XeTyhezb4abCG4ccI5AkVDxqC+" crossorigin="anonymous">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.0/dist/sweetalert2.min.css" integrity="sha256-h2GcvOa4U/JPMk4f4FqZ69X3F5e3ksRzZ8s/5qM829c=" crossorigin="anonymous">
    
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="dashboard-shell" style="background-color: var(--vital-bg-page); overflow-y: auto !important;">

<main class="dashboard-main-v2 fade-in-up" style="animation-duration: 0.6s;">

    <div class="hero-card fade-in-up d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4" style="animation-delay: 0.1s;">
        <div>
            <p class="hero-eyebrow text-success"><i class="bi bi-bank me-1"></i> Módulo Financiero</p>
            <h1 class="hero-title"><i class="bi bi-piggy-bank-fill me-2 text-success"></i>Gestión de Abonos</h1>
            <p class="hero-subtitle">Registra pagos parciales y cuotas vinculadas a los tratamientos de los pacientes.</p>
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
        <div id="msgSuccess" data-msg="El abono ha sido ingresado correctamente en la cuenta del paciente." class="d-none"></div>
    </c:if>
    <c:if test="${param.mensaje == 'eliminado'}">
        <div id="msgDeleted" data-msg="El abono fue anulado y el saldo del paciente ha sido restaurado." class="d-none"></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div id="msgError" data-msg="Ocurrió un error al intentar procesar este abono. Verifique los datos." class="d-none"></div>
    </c:if>

    <div class="row g-4">
        <div class="col-xl-4 col-lg-5 fade-in-up" style="animation-delay: 0.2s;">
            <section class="vital-card card finance-card shadow-sm rounded-4 border-0 h-100">
                <div class="card-header bg-transparent border-0 pt-4 px-4 pb-0">
                    <div class="d-flex align-items-center mb-2">
                        <div class="icon-circle-lg bg-success bg-opacity-10 text-success me-3 shadow-sm">
                            <i class="bi bi-cash-coin"></i>
                        </div>
                        <h2 class="h5 mb-0 fw-bold text-dark">${empty abonoEditar ? 'Ingresar Cuota' : 'Editar Abono'}</h2>
                    </div>
                </div>
                
                <div class="card-body p-4">
                    <form action="${ctx}/RegistroAbonoServlet" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="${empty abonoEditar ? 'insertar' : 'actualizar'}">
                        <input type="hidden" name="id" value="${abonoEditar.id_Abono}">
                        
                        <div class="row g-4">
                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">1. Cuenta a Abonar (Pago)</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-file-earmark-medical-fill"></i></span>
                                    <select name="pago" class="form-select border-0 bg-white fw-medium text-dark" required>
                                        <option value="" disabled ${empty abonoEditar && empty param.idPago ? 'selected' : ''}>Seleccione la cuenta...</option>
                                        <c:forEach var="pago" items="${pagos}">
                                            <c:set var="isSelected" value="${(abonoEditar.pago_id_Pago == pago.id_Pago) or (param.idPago == pago.id_Pago)}" />
                                            <option value="${pago.id_Pago}" ${isSelected ? 'selected' : ''}>
                                                Pago #${pago.id_Pago} | Total: $<fmt:formatNumber value="${pago.monto}" pattern="#,##0" />
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">Debe seleccionar una cuenta válida.</div>
                                </div>
                                <div class="form-text mt-2 small text-muted"><i class="bi bi-info-circle me-1"></i>Asocie este abono al pago general del tratamiento.</div>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">2. Monto a Ingresar</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-success border-0 fs-5 fw-bold">$</span>
                                    <input type="number" name="monto" class="form-control border-0 bg-white fw-bold text-dark fs-5" 
                                           value="<c:if test='${not empty abonoEditar}'><fmt:formatNumber value='${abonoEditar.monto_abono}' pattern='0' groupingUsed='false' /></c:if>" 
                                           min="1" step="1"
                                           placeholder="Ej. 50000" required>
                                    <div class="invalid-feedback">Ingrese un monto válido mayor a cero (solo números).</div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">3. Fecha del Comprobante</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-calendar2-check"></i></span>
                                    <input type="date" name="fecha" class="form-control border-0 bg-white fw-medium text-dark" 
                                           value="${not empty abonoEditar.fecha_abono ? abonoEditar.fecha_abono : hoyStr}" required>
                                    <div class="invalid-feedback">Indique la fecha en la que se realizó este pago.</div>
                                </div>
                            </div>

                            <div class="col-12 mt-4 pt-3 border-top border-success border-opacity-10 d-flex flex-column gap-2">
                                <button class="btn-nueva-cita shadow-sm w-100 fs-6" style="background: var(--vital-mint-600); color: white;" type="submit">
                                    <i class="bi bi-journal-plus me-2"></i>${empty abonoEditar ? 'Registrar Abono' : 'Guardar Cambios'}
                                </button>
                                <c:if test="${not empty abonoEditar}">
                                    <a class="btn btn-white text-danger fw-bold rounded-pill w-100 border shadow-sm hover-effect" href="${ctx}/RegistroAbonoServlet">
                                        <i class="bi bi-x-circle me-1"></i> Cancelar
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
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h2 class="h5 mb-1 fw-bold text-dark"><i class="bi bi-list-columns-reverse text-primary me-2"></i>Historial de Ingresos</h2>
                            <small class="text-muted">Desglose de cuotas y pagos parciales por paciente.</small>
                        </div>
                        <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill shadow-sm fs-6 border border-success border-opacity-25">${not empty abonos ? abonos.size() : '0'} Cuotas</span>
                    </div>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive" style="max-height: 500px; overflow-y: auto;">
                        <table class="table table-vital table-hover table-borderless align-middle mb-0">
                            <thead class="sticky-top bg-light" style="z-index: 1;">
                                <tr>
                                    <th class="ps-4 py-3 rounded-start">Paciente y Tratamiento (Asociado)</th>
                                    <th class="py-3">Fecha de Ingreso</th>
                                    <th class="py-3 text-end">Monto Abonado</th>
                                    <th class="pe-4 py-3 text-center rounded-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="abono" items="${abonos}">
                                    <c:set var="pagoRelacionado" value="" />
                                    <c:forEach var="pago" items="${pagos}">
                                        <c:if test="${pago.id_Pago == abono.pago_id_Pago}">
                                            <c:set var="pagoRelacionado" value="${pago}" />
                                        </c:if>
                                    </c:forEach>

                                    <c:set var="citaRelacionada" value="" />
                                    <c:if test="${not empty pagoRelacionado}">
                                        <c:forEach var="cita" items="${citas}">
                                            <c:if test="${cita.id_Cita == pagoRelacionado.cita_id_Cita}">
                                                <c:set var="citaRelacionada" value="${cita}" />
                                            </c:if>
                                        </c:forEach>
                                    </c:if>

                                    <tr class="border-bottom border-light">
                                        <td class="ps-4 py-3">
                                            <div class="patient-cell">
                                                <div class="patient-cell-avatar">
                                                    ${empty citaRelacionada.nombrePaciente ? 'P' : fn:substring(citaRelacionada.nombrePaciente, 0, 1)}
                                                </div>
                                                <div>
                                                    <div class="fw-bold text-dark mb-0">
                                                        ${empty citaRelacionada.nombrePaciente ? 'Paciente Registrado' : citaRelacionada.nombrePaciente}
                                                    </div>
                                                    <div class="text-muted small d-flex align-items-center mt-1">
                                                        <span class="badge-payment me-2">Pago #${abono.pago_id_Pago}</span>
                                                        ${empty citaRelacionada.descripcionTratamiento ? 'Tratamiento Médico' : citaRelacionada.descripcionTratamiento}
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="py-3 fw-medium text-secondary">
                                            <i class="bi bi-calendar-event text-muted me-1"></i> ${abono.fecha_abono}
                                        </td>
                                        <td class="py-3 text-end fw-bold text-success fs-6">
                                            + $ <fmt:formatNumber value="${abono.monto_abono}" pattern="#,##0" />
                                        </td>
                                        <td class="pe-4 py-3 text-center">
                                            <div class="d-flex justify-content-center gap-1">
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle hover-effect" style="width: 35px; height: 35px; line-height: 22px;" title="Editar Abono" href="${ctx}/RegistroAbonoServlet?accion=editar&id=${abono.id_Abono}">
                                                    <i class="bi bi-pencil-square text-primary"></i>
                                                </a>
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle hover-effect delete-btn" style="width: 35px; height: 35px; line-height: 22px;" title="Eliminar Abono" href="${ctx}/RegistroAbonoServlet?accion=eliminar&id=${abono.id_Abono}">
                                                    <i class="bi bi-trash-fill text-danger"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty abonos}">
                                    <tr>
                                        <td colspan="4" class="text-center py-5">
                                            <div class="empty-state-icon shadow-sm mx-auto mb-3" style="width: 70px; height: 70px;">
                                                <i class="bi bi-cash-stack fs-2 text-success opacity-50"></i>
                                            </div>
                                            <h5 class="fw-bold text-dark mb-1">Sin Cuotas Registradas</h5>
                                            <p class="text-muted small">No hay abonos parciales asociados a ninguna cuenta.</p>
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

<!-- Nasimpa ti SonarQube: Nainayon ti integrity ken crossorigin para iti Bootstrap JS ken SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmxc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.0/dist/sweetalert2.all.min.js" integrity="sha256-wA/Uccu1vNnJg6xU1+zB9wYqQ1U3L3+lB5zK0hQ5b5E=" crossorigin="anonymous"></script>
<script src="${ctx}/Vista/Javascript/validaciones.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const msgSuccess = document.getElementById('msgSuccess');
        const msgDeleted = document.getElementById('msgDeleted');
        const msgError = document.getElementById('msgError');

        if (msgSuccess) {
            Swal.fire({
                title: '¡Abono Exitoso!',
                text: msgSuccess.getAttribute('data-msg'),
                icon: 'success',
                customClass: { popup: 'rounded-4 shadow-lg', confirmButton: 'btn btn-primary rounded-pill px-4 fw-bold' },
                buttonsStyling: false,
                confirmButtonText: 'Aceptar'
            });
        }

        if (msgDeleted) {
            Swal.fire({
                title: 'Abono Anulado',
                text: msgDeleted.getAttribute('data-msg'),
                icon: 'info',
                customClass: { popup: 'rounded-4 shadow-lg', confirmButton: 'btn btn-primary rounded-pill px-4 fw-bold' },
                buttonsStyling: false,
                confirmButtonText: 'Entendido'
            });
        }

        if (msgError) {
            Swal.fire({
                title: 'Error de Transacción',
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
                    title: '¿Anular este Abono?',
                    text: "Al anular el abono, el saldo deudor de la cuenta del paciente aumentará. Esta acción no se puede deshacer.",
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