<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Estados de Cita</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${ctx}/Vista/Imagenes/logo2.0.png">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="dashboard-shell" style="background-color: var(--vital-bg-page); overflow-y: auto !important;">

<main class="dashboard-main-v2 fade-in-up" style="animation-duration: 0.6s;">

    <div class="hero-card fade-in-up d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4" style="animation-delay: 0.1s;">
        <div>
            <p class="hero-eyebrow text-primary"><i class="bi bi-gear-fill me-1"></i> Módulo de Configuración</p>
            <h1 class="hero-title"><i class="bi bi-clock-history me-2 text-primary"></i>Estados de Cita</h1>
            <p class="hero-subtitle">Define las etapas y controles de asistencia para la agenda odontológica.</p>
        </div>
        <a href="${ctx}/AdminInicioServlet" class="btn btn-outline-secondary rounded-pill px-4 mt-3 mt-md-0 shadow-sm transition-all hover-effect">
            <i class="bi bi-arrow-left me-2"></i> Volver al panel
        </a>
    </div>

    <c:if test="${param.mensaje == 'guardado'}">
        <div id="msgSuccess" data-msg="El estado de cita ha sido guardado exitosamente." class="d-none"></div>
    </c:if>
    <c:if test="${param.mensaje == 'eliminado'}">
        <div id="msgDeleted" data-msg="El estado de cita fue removido del sistema." class="d-none"></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div id="msgError" data-msg="No se pudo completar la operación. Compruebe que este estado no esté siendo usado por ninguna cita registrada." class="d-none"></div>
    </c:if>

    <div class="row g-4">
        <div class="col-lg-4 fade-in-up" style="animation-delay: 0.2s;">
            <section class="vital-card card status-card shadow-sm rounded-4 border-0 h-100">
                <div class="card-header bg-transparent border-0 pt-4 px-4 pb-0">
                    <div class="d-flex align-items-center mb-2">
                        <div class="icon-circle-md bg-primary bg-opacity-10 text-primary me-3 shadow-sm">
                            <i class="bi bi-flag-fill"></i>
                        </div>
                        <h2 class="h5 mb-0 fw-bold text-dark">${empty estadoEditar ? 'Nuevo Estado' : 'Editar Estado'}</h2>
                    </div>
                </div>
                
                <div class="card-body p-4">
                    <form action="${ctx}/RegistroEstadoCitaServlet" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="${empty estadoEditar ? 'insertar' : 'actualizar'}">
                        <input type="hidden" name="id" value="${estadoEditar.idEstado_cita}">
                        
                        <div class="row g-4">
                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">Descripción del Estado</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-chat-right-text"></i></span>
                                    <input type="text" name="descripcion" class="form-control border-0 bg-white fw-bold text-dark" value="${estadoEditar.descripcion_estadoci}" placeholder="Ej: Agendada, Cancelada, Asistió..." required>
                                    <div class="invalid-feedback">Debe proporcionar un nombre para este estado.</div>
                                </div>
                                <div class="form-text mt-2 small text-muted"><i class="bi bi-info-circle me-1"></i>Estos estados se verán al programar o actualizar citas.</div>
                            </div>

                            <div class="col-12 mt-4 pt-3 border-top border-light d-flex flex-column gap-2">
                                <button class="btn-nueva-cita shadow-sm w-100 fs-6" type="submit">
                                    <i class="bi bi-save2-fill me-2"></i>${empty estadoEditar ? 'Guardar Estado' : 'Actualizar Estado'}
                                </button>
                                <c:if test="${not empty estadoEditar}">
                                    <a class="btn btn-light text-danger fw-bold rounded-pill w-100 border shadow-sm hover-effect" href="${ctx}/RegistroEstadoCitaServlet">
                                        <i class="bi bi-x-circle me-1"></i> Cancelar
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </form>
                </div>
            </section>
        </div>

        <div class="col-lg-8 fade-in-up" style="animation-delay: 0.4s;">
            <section class="vital-card card border-0 shadow-sm rounded-4 overflow-hidden h-100">
                <div class="card-header admin-card-header bg-white border-bottom p-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h2 class="h5 mb-1 fw-bold text-dark"><i class="bi bi-calendar2-check text-primary me-2"></i>Estados Configurados</h2>
                            <small class="text-muted">Lista de situaciones posibles para una cita médica.</small>
                        </div>
                        <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill shadow-sm fs-6 border border-primary border-opacity-25">${estadosCita.size() != null ? estadosCita.size() : '0'}</span>
                    </div>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive" style="max-height: 500px; overflow-y: auto;">
                        <table class="table table-vital table-hover table-borderless align-middle mb-0">
                            <thead class="sticky-top bg-light" style="z-index: 1;">
                                <tr>
                                    <th class="ps-4 py-3 rounded-start">Descripción del Estado</th>
                                    <th class="py-3 text-center">Identificador Visual</th>
                                    <th class="pe-4 py-3 text-end rounded-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="estado" items="${estadosCita}">
                                    <tr class="border-bottom border-light">
                                        <td class="ps-4 py-3">
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-record-circle text-muted fs-5 me-3"></i>
                                                <div class="fw-bold text-dark fs-6">${estado.descripcion_estadoci}</div>
                                            </div>
                                        </td>
                                        <td class="py-3 text-center">
                                            <span class="badge-status shadow-sm">
                                                <i class="bi bi-activity me-1"></i> Estado Clínico
                                            </span>
                                        </td>
                                        <td class="pe-4 py-3 text-end">
                                            <div class="d-flex justify-content-end gap-1">
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle hover-effect" style="width: 35px; height: 35px; line-height: 22px;" title="Editar Estado" href="${ctx}/RegistroEstadoCitaServlet?accion=editar&id=${estado.idEstado_cita}">
                                                    <i class="bi bi-pencil-square text-primary"></i>
                                                </a>
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle hover-effect delete-btn" style="width: 35px; height: 35px; line-height: 22px;" title="Eliminar Estado" href="${ctx}/RegistroEstadoCitaServlet?accion=eliminar&id=${estado.idEstado_cita}">
                                                    <i class="bi bi-trash-fill text-danger"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty estadosCita}">
                                    <tr>
                                        <td colspan="3" class="text-center py-5">
                                            <div class="empty-state-icon shadow-sm mx-auto mb-3" style="width: 70px; height: 70px;">
                                                <i class="bi bi-calendar-x fs-2 text-primary opacity-50"></i>
                                            </div>
                                            <h5 class="fw-bold text-dark mb-1">Sin Estados</h5>
                                            <p class="text-muted small">No hay estados de cita configurados en el sistema.</p>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${ctx}/Vista/Javascript/validaciones.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
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
                confirmButtonText: 'Aceptar'
            });
        }

        if (msgDeleted) {
            Swal.fire({
                title: 'Estado Eliminado',
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
                    title: '¿Eliminar Estado de Cita?',
                    text: "Atención: Si alguna cita ya tiene este estado asignado, la base de datos impedirá eliminarlo por seguridad.",
                    icon: 'warning',
                    showCancelButton: true,
                    customClass: {
                        popup: 'rounded-4 shadow-lg',
                        confirmButton: 'btn btn-danger rounded-pill px-4 fw-bold me-2',
                        cancelButton: 'btn btn-light border rounded-pill px-4 fw-bold'
                    },
                    buttonsStyling: false,
                    confirmButtonText: 'Sí, intentar eliminar',
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