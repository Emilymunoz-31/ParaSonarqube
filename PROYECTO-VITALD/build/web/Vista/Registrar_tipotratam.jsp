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
    <title>VitalDentist - Catálogo de Tratamientos</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${ctx}/Vista/Imagenes/logo2.0.png">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" integrity="sha384-XGjxtQfXaH2tnPFa9x+ruJTuLE3Aa6LhHSWRr1XeTyhezb4abCG4ccI5AkVDxqC+" crossorigin="anonymous">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.0/dist/sweetalert2.min.css" integrity="sha256-h2GcvOa4U/JPMk4f4FqZ69X3F5e3ksRzZ8s/5qM829c=" crossorigin="anonymous">
    
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="dashboard-shell" style="background-color: var(--vital-bg-page); overflow-y: auto !important;">

<main class="dashboard-main-v2 fade-in-up" style="animation-duration: 0.6s;">

    <div class="hero-card fade-in-up d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center" style="animation-delay: 0.1s;">
        <div>
            <p class="hero-eyebrow text-primary"><i class="bi bi-gear-fill me-1"></i> Configuración Clínica</p>
            <h1 class="hero-title"><i class="bi bi-clipboard2-pulse-fill me-2 text-primary"></i>Catálogo de Tratamientos</h1>
            <p class="hero-subtitle">Administra los servicios, procedimientos y costos de la clínica.</p>
        </div>

        <%-- RETORNO INTELIGENTE SEGÚN EL ROL DE SESIÓN --%>
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
        <div id="msgSuccess" data-msg="Registro guardado correctamente en el catálogo." class="d-none"></div>
    </c:if>
    <c:if test="${param.mensaje == 'eliminado'}">
        <div id="msgDeleted" data-msg="El tratamiento fue eliminado del sistema." class="d-none"></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div id="msgError" data-msg="No fue posible completar la operación. Verifique los datos." class="d-none"></div>
    </c:if>

    <div class="row g-4 mt-1">
        <div class="col-lg-4 fade-in-up" style="animation-delay: 0.2s;">
            <section class="vital-card card treatment-card shadow-sm rounded-4 border-0 h-100">
                <div class="card-header bg-transparent border-0 pt-4 px-4 pb-0">
                    <div class="d-flex align-items-center mb-2">
                        <div class="icon-circle-md bg-primary bg-opacity-10 text-primary me-3 shadow-sm">
                            <i class="bi bi-bandaid-fill"></i>
                        </div>
                        <h2 class="h5 mb-0 fw-bold text-dark">${empty tratamientoEditar ? 'Nuevo Servicio' : 'Editar Servicio'}</h2>
                    </div>
                </div>
                
                <div class="card-body p-4">
                    <form action="${ctx}/RegistroTipoTratamientoServlet" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="${empty tratamientoEditar ? 'insertar' : 'actualizar'}">
                        <input type="hidden" name="id" value="${tratamientoEditar.id_Tipotratam}">
                        
                        <div class="row g-4">
                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">Descripción del Tratamiento</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-fonts"></i></span>
                                    <input type="text" name="descripcion" class="form-control border-0 bg-white fw-medium" value="${tratamientoEditar.descripcion_tipotratam}" placeholder="Ej: Resina Fotocurable" required>
                                    <div class="invalid-feedback">Ingrese una descripción válida.</div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">Costo Base ($)</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-success border-0"><i class="bi bi-currency-dollar"></i></span>
                                    <input type="number" name="costo" class="form-control border-0 bg-white fw-bold text-dark" 
                                           value="<c:if test='${not empty tratamientoEditar}'><fmt:formatNumber value='${tratamientoEditar.costo}' pattern='0' groupingUsed='false' /></c:if>" 
                                           min="1" step="1" placeholder="Ej: 80000" required>
                                    <div class="invalid-feedback">Ingrese un costo válido mayor a cero (solo números).</div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold text-secondary small">Categoría Clínica</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                                    <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-tags-fill"></i></span>
                                    <select name="categoria" class="form-select border-0 bg-white fw-medium" required>
                                        <option value="" disabled ${empty tratamientoEditar ? 'selected' : ''}>Seleccione la categoría...</option>
                                        <c:forEach var="categoria" items="${categorias}">
                                            <option value="${categoria.id_Categoria}" ${tratamientoEditar.categoria_Tratamiento_id_Categoria == categoria.id_Categoria ? 'selected' : ''}>
                                                ${categoria.nombre_categoria}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">Seleccione una categoría.</div>
                                </div>
                            </div>

                            <div class="col-12 mt-4 pt-3 border-top border-light d-flex flex-column gap-2">
                                <button class="btn-nueva-cita shadow-sm w-100" type="submit">
                                    <i class="bi bi-save2-fill me-2"></i>${empty tratamientoEditar ? 'Guardar Tratamiento' : 'Actualizar Tratamiento'}
                                </button>
                                <c:if test="${not empty tratamientoEditar}">
                                    <a class="btn btn-light text-danger fw-bold rounded-pill w-100 border shadow-sm hover-effect" href="${ctx}/RegistroTipoTratamientoServlet">
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
                            <h2 class="h5 mb-1 fw-bold text-dark"><i class="bi bi-list-columns-reverse text-primary me-2"></i>Tratamientos Activos</h2>
                            <small class="text-muted">Listado general de precios y servicios.</small>
                        </div>
                        <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill shadow-sm fs-6 border border-primary border-opacity-25">${not empty tratamientos ? tratamientos.size() : '0'}</span>
                    </div>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive" style="max-height: 500px; overflow-y: auto;">
                        <table class="table table-vital table-hover table-borderless align-middle mb-0">
                            <thead class="sticky-top bg-light" style="z-index: 1;">
                                <tr>
                                    <th class="ps-4 py-3 rounded-start">Descripción del Servicio</th>
                                    <th class="py-3">Categoría</th>
                                    <th class="py-3 text-end">Costo Est.</th>
                                    <th class="pe-4 py-3 text-center rounded-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="tratamiento" items="${tratamientos}">
                                    <c:set var="nombreCat" value="General" />
                                    <c:forEach var="cat" items="${categorias}">
                                        <c:if test="${cat.id_Categoria == tratamiento.categoria_Tratamiento_id_Categoria}">
                                            <c:set var="nombreCat" value="${cat.nombre_categoria}" />
                                        </c:if>
                                    </c:forEach>

                                    <tr class="border-bottom border-light">
                                        <td class="ps-4 py-3 fw-bold text-dark">
                                            <i class="bi bi-journal-medical text-primary opacity-50 me-2"></i>${tratamiento.descripcion_tipotratam}
                                        </td>
                                        <td class="py-3">
                                            <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary-subtle px-3 py-1 rounded-pill">
                                                <i class="bi bi-tag-fill me-1 opacity-50"></i>${nombreCat}
                                            </span>
                                        </td>
                                        <td class="py-3 text-end fw-bold text-success fs-6">
                                            $ <fmt:formatNumber value="${tratamiento.costo}" pattern="#,##0" />
                                        </td>
                                        <td class="pe-4 py-3 text-center">
                                            <div class="d-flex justify-content-center gap-1">
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle hover-effect" style="width: 35px; height: 35px; line-height: 22px;" title="Editar" href="${ctx}/RegistroTipoTratamientoServlet?accion=editar&id=${tratamiento.id_Tipotratam}">
                                                    <i class="bi bi-pencil-square text-primary"></i>
                                                </a>
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle hover-effect delete-btn" style="width: 35px; height: 35px; line-height: 22px;" title="Eliminar" href="${ctx}/RegistroTipoTratamientoServlet?accion=eliminar&id=${tratamiento.id_Tipotratam}">
                                                    <i class="bi bi-trash-fill text-danger"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty tratamientos}">
                                    <tr>
                                        <td colspan="4" class="text-center py-5">
                                            <div class="empty-state-icon shadow-sm mx-auto mb-3" style="width: 70px; height: 70px;">
                                                <i class="bi bi-folder-x fs-2 text-primary opacity-50"></i>
                                            </div>
                                            <h5 class="fw-bold text-dark mb-1">Catálogo Vacío</h5>
                                            <p class="text-muted small">Aún no has registrado ningún tratamiento.</p>
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

}<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmxc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.0/dist/sweetalert2.all.min.js" integrity="sha256-wA/Uccu1vNnJg6xU1+zB9wYqQ1U3L3+lB5zK0hQ5b5E=" crossorigin="anonymous"></script>
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
                title: 'Eliminado',
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
                    title: '¿Eliminar Tratamiento?',
                    text: "Esta acción no se puede deshacer.",
                    icon: 'warning',
                    showCancelButton: true,
                    customClass: {
                        popup: 'rounded-4 shadow-lg',
                        confirmButton: 'btn btn-danger rounded-pill px-4 fw-bold me-2',
                        cancelButton: 'btn btn-light border rounded-pill px-4 fw-bold'
                    },
                    buttonsStyling: false,
                    confirmButtonText: 'Sí, eliminar',
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