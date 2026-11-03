<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Gestión de Roles</title>
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
            <p class="hero-eyebrow text-primary"><i class="bi bi-shield-lock-fill me-1"></i> Módulo de Configuración</p>
            <h1 class="hero-title"><i class="bi bi-diagram-3-fill me-2 text-primary"></i>Gestión de Roles del Sistema</h1>
            <p class="hero-subtitle">Visualiza y controla el estatus (Activo / Inactivo) de los perfiles de acceso.</p>
        </div>
        <a href="${ctx}/AdminInicioServlet" class="btn btn-outline-secondary rounded-pill px-4 mt-3 mt-md-0 shadow-sm transition-all hover-effect">
            <i class="bi bi-arrow-left me-2"></i> Volver al panel
        </a>
    </div>

    <c:if test="${param.mensaje == 'actualizado'}">
        <div class="alert alert-success border-0 shadow-sm rounded-4 mb-4"><i class="bi bi-check-circle-fill me-2"></i><strong>¡Éxito!</strong> El estado del rol se ha actualizado correctamente.</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger border-0 shadow-sm rounded-4 mb-4"><i class="bi bi-exclamation-triangle-fill me-2"></i>No fue posible procesar la solicitud de estado del rol.</div>
    </c:if>

    <div class="row g-4 justify-content-center">
        <div class="col-xl-10 fade-in-up" style="animation-delay: 0.2s;">
            <section class="vital-card card border-0 shadow-sm rounded-4 overflow-hidden h-100">
                <div class="card-header admin-card-header bg-white border-bottom p-4 d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center">
                        <div class="role-icon-box me-3 shadow-sm">
                            <i class="bi bi-shield-shaded"></i>
                        </div>
                        <div>
                            <h2 class="h5 mb-1 fw-bold text-dark">Roles Estructurados Fijos</h2>
                            <small class="text-muted">Perfiles del sistema predefinidos por la arquitectura de la clínica.</small>
                        </div>
                    </div>
                    <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill shadow-sm fs-6 border border-primary border-opacity-25">
                        ${fn:length(roles)} Registrados
                    </span>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-vital table-hover table-borderless align-middle mb-0 table-roles">
                            <thead>
                                <tr>
                                    <th class="ps-4 py-3">ID</th>
                                    <th class="py-3">Descripción / Nombre del Rol</th>
                                    <th class="py-3 text-center">Estado Actual</th>
                                    <th class="pe-4 py-3 text-end">Cambiar Estatus (Activar / Inactivar)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="rol" items="${roles}">
                                    <tr class="border-bottom border-light">
                                        <td class="ps-4 py-3 fw-bold text-muted">#${rol.id_Rol}</td>
                                        <td class="py-3">
                                            <div class="d-flex align-items-center">
                                                <div class="fw-bold text-dark fs-6">${rol.descripcion_rol}</div>
                                            </div>
                                        </td>
                                        <td class="py-3 text-center">
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-1 rounded-pill fw-semibold">
                                                <i class="bi bi-check-circle-fill me-1"></i> Activo
                                            </span>
                                        </td>
                                        <td class="pe-4 py-3 text-end">
                                            <a href="${ctx}/RegistroRolServlet?accion=cambiarEstado&id=${rol.id_Rol}&estado=false" class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-semibold shadow-sm hover-effect">
                                                <i class="bi bi-toggle-off me-1"></i> Inactivar
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty roles}">
                                    <tr>
                                        <td colspan="4" class="text-center py-5">
                                            <div class="empty-state-icon shadow-sm mx-auto mb-3 text-primary opacity-50" style="width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; border-radius: 50%; background: #f0f4f8;">
                                                <i class="bi bi-shield-slash fs-3"></i>
                                            </div>
                                            <h5 class="fw-bold text-dark mb-1">No hay roles registrados</h5>
                                            <p class="text-muted small">Verifique la conexión con la base de datos.</p>
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
</body>
</html>