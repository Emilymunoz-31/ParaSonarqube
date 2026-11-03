<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Categorías Clínicas</title>
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
            <h1 class="hero-title"><i class="bi bi-tags-fill me-2 text-primary"></i>Categorías de Tratamiento</h1>
            <p class="hero-subtitle">Organiza y agrupa los diferentes servicios clínicos que ofrece el consultorio.</p>
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
        <div id="msgSuccess" data-msg="La categoría ha sido guardada exitosamente en el catálogo." class="d-none"></div>
    </c:if>
    <c:if test="${param.mensaje == 'eliminado'}">
        <div id="msgDeleted" data-msg="La categoría fue eliminada correctamente." class="d-none"></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div id="msgError" data-msg="Error: No se pudo completar la operación. Verifique que no haya tratamientos asociados a esta categoría." class="d-none"></div>
    </c:if>

    <div class="row g-4">
        <div class="col-lg-4 fade-in-up" style="animation-delay: 0.2s;">
            <section class="vital-card card category-card shadow-sm rounded-4 border-0 h-100">
                <div class="card-header bg-transparent border-0 pt-4 px-4 pb-0">
                    <div class="d-flex align-items-center mb-2">
                        <div class="icon-circle-md bg-primary bg-opacity-10 text-primary me-3 shadow-sm">
                            <i class="bi bi-folder-plus"></i>
                        </div>
                        <h2 class="h5 mb-0 fw-bold text-dark">${empty categoriaEditar ? 'Nueva Categoría' : 'Editar Categoría'}</h2>
                    </div>
                </div>
                
                <div class="card-body p-4">
                    <form action="${ctx}/RegistroCategoriaTratamientoServlet" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="${empty categoriaEditar ? 'insertar' : 'actualizar'}">
                        <input type="hidden" name="id" value="${categoriaEditar.id_Categoria}">
                        
                        <div class="row g-4">
                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">Nombre de la Categoría</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-bookmark-fill"></i></span>
                                    <input type="text" name="descripcion" class="form-control border-0 bg-white fw-bold text-dark" value="${categoriaEditar.nombre_categoria}" placeholder="Ej: Ortodoncia, Cirugía..." required>
                                    <div class="invalid-feedback">Por favor ingrese el nombre de la categoría.</div>
                                </div>
                            </div>

                            <div class="col-12 mt-4 pt-3 border-top border-light d-flex flex-column gap-2">
                                <button class="btn-nueva-cita shadow-sm w-100 fs-6" type="submit">
                                    <i class="bi bi-save2-fill me-2"></i>${empty categoriaEditar ? 'Guardar Categoría' : 'Actualizar Categoría'}
                                </button>
                                <c:if test="${not empty categoriaEditar}">
                                    <a class="btn btn-light text-danger fw-bold rounded-pill w-100 border shadow-sm hover-effect" href="${ctx}/RegistroCategoriaTratamientoServlet">
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
                            <h2 class="h5 mb-1 fw-bold text-dark"><i class="bi bi-collection text-primary me-2"></i>Agrupaciones Creadas</h2>
                            <small class="text-muted">Directorio de categorías para organizar los tratamientos.</small>
                        </div>
                        <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill shadow-sm fs-6 border border-primary border-opacity-25">${categorias.size() != null ? categorias.size() : '0'}</span>
                    </div>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive" style="max-height: 500px; overflow-y: auto;">
                        <table class="table table-vital table-hover table-borderless align-middle mb-0">
                            <thead class="sticky-top bg-light" style="z-index: 1;">
                                <tr>
                                    <th class="ps-4 py-3 rounded-start">Nombre de la Categoría</th>
                                    <th class="py-3 text-center">Estado</th>
                                    <th class="pe-4 py-3 text-end rounded-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="categoria" items="${categorias}">
                                    <tr class="border-bottom border-light">
                                        <td class="ps-4 py-3">
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-folder2 text-muted fs-4 me-3"></i>
                                                <div class="fw-bold text-dark fs-6">${categoria.nombre_categoria}</div>
                                            </div>
                                        </td>
                                        <td class="py-3 text-center">
                                            <span class="badge-category shadow-sm"><i class="bi bi-check-circle-fill me-1"></i> Activa</span>
                                        </td>
                                        <td class="pe-4 py-3 text-end">
                                            <div class="d-flex justify-content-end gap-1">
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle hover-effect" style="width: 35px; height: 35px; line-height: 22px;" title="Editar Categoría" href="${ctx}/RegistroCategoriaTratamientoServlet?accion=editar&id=${categoria.id_Categoria}">
                                                    <i class="bi bi-pencil-square text-primary"></i>
                                                </a>
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle hover-effect delete-btn" style="width: 35px; height: 35px; line-height: 22px;" title="Eliminar Categoría" href="${ctx}/RegistroCategoriaTratamientoServlet?accion=eliminar&id=${categoria.id_Categoria}">
                                                    <i class="bi bi-trash-fill text-danger"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty categorias}">
                                    <tr>
                                        <td colspan="3" class="text-center py-5">
                                            <div class="empty-state-icon shadow-sm mx-auto mb-3" style="width: 70px; height: 70px;">
                                                <i class="bi bi-folder-x fs-2 text-primary opacity-50"></i>
                                            </div>
                                            <h5 class="fw-bold text-dark mb-1">Sin Categorías</h5>
                                            <p class="text-muted small">Aún no se han configurado categorías de tratamiento.</p>
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
                title: 'Categoría Eliminada',
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
                    title: '¿Eliminar Categoría?',
                    text: "Asegúrese de que no haya tratamientos que pertenezcan a esta categoría antes de borrarla.",
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