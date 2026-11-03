<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Gestión de Personal y Usuarios</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${ctx}/Vista/Imagenes/logo2.0.png">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" integrity="sha384-XGjxtQfXaH2tnPFa9x+ruJTuLE3Aa6LhHSWRr1XeTyhezb4abCG4ccI5AkVDxqC+" crossorigin="anonymous">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.0/dist/sweetalert2.min.css" integrity="sha256-h2GcvOa4U/JPMk4f4FqZ69X3F5e3ksRzZ8s/5qM829c=" crossorigin="anonymous">
    
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="registration-page dashboard-shell" style="background-color: var(--vital-bg-page); overflow-y: auto !important;">

<main class="dashboard-main-v2 fade-in-up" style="animation-duration: 0.6s;">

    <div class="hero-card fade-in-up d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center" style="animation-delay: 0.1s;">
        <div>
            <p class="hero-eyebrow text-primary"><i class="bi bi-shield-lock-fill me-1"></i> Módulo Administrativo</p>
            <h1 class="hero-title"><i class="bi bi-person-badge-fill me-2 text-primary"></i>Gestión de Personal</h1>
            <p class="hero-subtitle">Alta y administración de médicos, auxiliares y directorio de pacientes.</p>
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

    <div class="fade-in-up" style="animation-delay: 0.2s;">
        <c:if test="${empty roles or empty tiposDocumento}">
            <div class="alert alert-warning border-0 shadow-sm rounded-4 d-flex align-items-center mb-4"><i class="bi bi-info-circle-fill fs-5 text-warning me-2"></i> No se pudieron cargar catálogos desde la BD.</div>
        </c:if>
        
        <c:if test="${param.error == 'duplicado'}">
            <div class="alert alert-danger border-0 shadow-sm rounded-4 mb-4">
                <i class="bi bi-exclamation-octagon-fill me-2"></i><strong>Acción denegada:</strong> El número de documento ingresado ya se encuentra registrado en el sistema.
            </div>
        </c:if>
        <c:if test="${param.mensaje == 'exito'}">
            <div class="alert alert-success border-0 shadow-sm rounded-4 mb-4">
                <i class="bi bi-check-circle-fill me-2"></i><strong>¡Correcto!</strong> El usuario ha sido registrado exitosamente.
            </div>
        </c:if>
        <c:if test="${param.mensaje == 'actualizado'}">
            <div class="alert alert-success border-0 shadow-sm rounded-4 mb-4">
                <i class="bi bi-check-circle-fill me-2"></i><strong>¡Modificación Exitosa!</strong> Los datos del usuario se han actualizado correctamente.
            </div>
        </c:if>
    </div>

    <section class="vital-card card staff-form-card shadow-sm rounded-4 mb-5 fade-in-up" style="animation-delay: 0.3s;">
        <div class="card-body p-4 p-md-5">
            <div class="d-flex align-items-center mb-2">
                <div class="bg-white text-primary shadow-sm rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 45px; height: 45px; font-size: 1.2rem;">
                    <i class="bi bi-person-lines-fill"></i>
                </div>
                <h2 class="h4 mb-0 fw-bold text-dark">${empty usuarioEditar ? 'Alta de Nuevo Empleado' : 'Edición de Usuario'}</h2>
            </div>
            
            <div class="alert alert-info bg-primary bg-opacity-10 border-0 text-primary rounded-3 small mb-4 mt-3">
                <i class="bi bi-info-square-fill me-2"></i> <strong>Nota Importante:</strong> Los pacientes no deben registrarse por aquí. Se registran automáticamente desde el módulo de <em>Agendar Cita</em>.
            </div>

            <form id="registroUsuarioForm" action="${ctx}/RegistroUsuarioServlet" method="POST" class="needs-validation" novalidate>
                <input type="hidden" name="accion" value="${empty usuarioEditar ? 'insertar' : 'actualizar'}">
                <input type="hidden" name="id" value="${usuarioEditar.id_Usuario}">
                
                <div class="row g-4">
                    <div class="col-md-6">
                        <label for="txtNombres" class="form-label fw-semibold text-secondary small">Nombres Completos</label>
                        <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                            <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-person"></i></span>
                            <input type="text" id="txtNombres" name="txtNombres" class="form-control border-0 bg-white" value="${valores.txtNombres}" placeholder="Ej: Juan Camilo" required>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label for="txtApellidos" class="form-label fw-semibold text-secondary small">Apellidos</label>
                        <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                            <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-people"></i></span>
                            <input type="text" id="txtApellidos" name="txtApellidos" class="form-control border-0 bg-white" value="${valores.txtApellidos}" placeholder="Ej: Pérez Rodríguez" required>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label for="txtTipoDoc" class="form-label fw-semibold text-secondary small">Tipo Documento</label>
                        <c:choose>
                            <c:when test="${not empty usuarioEditar}">
                                <select class="form-select shadow-sm rounded-4 border-white bg-light text-muted" disabled>
                                    <c:forEach var="tipo" items="${tiposDocumento}">
                                        <option value="${tipo.id_Tipodocumento}" ${valores.txtTipoDoc == tipo.id_Tipodocumento ? 'selected' : ''}>${tipo.descripcion_tipodoc}</option>
                                    </c:forEach>
                                </select>
                                <input type="hidden" name="txtTipoDoc" value="${valores.txtTipoDoc}">
                            </c:when>
                            <c:otherwise>
                                <select id="txtTipoDoc" name="txtTipoDoc" class="form-select shadow-sm rounded-4 border-white bg-white" required>
                                    <option value="">Seleccione...</option>
                                    <c:forEach var="tipo" items="${tiposDocumento}">
                                        <option value="${tipo.id_Tipodocumento}" ${valores.txtTipoDoc == tipo.id_Tipodocumento ? 'selected' : ''}>${tipo.descripcion_tipodoc}</option>
                                    </c:forEach>
                                </select>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="col-md-4">
                        <label for="txtDocumento" class="form-label fw-semibold text-secondary small">Número de Documento</label>
                        <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                            <span class="input-group-text ${not empty usuarioEditar ? 'bg-light' : 'bg-white'} text-primary border-0"><i class="bi bi-upc-scan"></i></span>
                            <input type="text" id="txtDocumento" name="txtDocumento" class="form-control border-0 ${not empty usuarioEditar ? 'bg-light text-muted' : 'bg-white'} fw-bold" value="${valores.txtDocumento}" placeholder="Ej: 1023379397" pattern="[0-9]{7,10}" minlength="7" maxlength="10" inputmode="numeric" required ${not empty usuarioEditar ? 'readonly' : ''}>
                            <div class="invalid-feedback">Debe tener de 7 a 10 dígitos.</div>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty usuarioEditar && usuarioEditar.rol_id_Rol == 3}">
                            <input type="hidden" name="txtRol" value="3">
                        </c:when>
                        <c:otherwise>
                            <div class="col-md-4">
                                <label for="txtRol" class="form-label fw-semibold text-secondary small">Cargo / Rol Asignado</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-primary border-opacity-25">
                                    <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-briefcase-fill"></i></span>
                                    <select id="txtRol" name="txtRol" class="form-select border-0 bg-white fw-bold text-dark" required>
                                        <option value="">Seleccione el cargo...</option>
                                        <c:forEach var="rol" items="${roles}">
                                            <c:if test="${rol.id_Rol != 3}">
                                                <option value="${rol.id_Rol}" ${valores.txtRol == rol.id_Rol ? 'selected' : ''}>${rol.descripcion_rol}</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="col-12"><hr class="my-2 text-muted opacity-10"></div>

                    <div class="col-md-4">
                        <label for="txtFechaNac" class="form-label fw-semibold text-secondary small">Fecha de Nacimiento</label>
                        <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                            <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-calendar-event"></i></span>
                            <input type="date" id="txtFechaNac" name="txtFechaNac" class="form-control border-0 bg-white" value="${valores.txtFechaNac}" required>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label for="txtTelefono" class="form-label fw-semibold text-secondary small">Teléfono / Celular</label>
                        <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                            <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-telephone"></i></span>
                            <input type="text" id="txtTelefono" name="txtTelefono" class="form-control border-0 bg-white" value="${valores.txtTelefono}" placeholder="3001234567" pattern="[0-9]{7,10}" minlength="7" maxlength="10" inputmode="numeric" required>
                            <div class="invalid-feedback">Debe tener de 7 a 10 dígitos.</div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label for="txtCorreo" class="form-label fw-semibold text-secondary small">Correo Corporativo/Personal</label>
                        <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-white">
                            <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-envelope-at"></i></span>
                            <input type="email" id="txtCorreo" name="txtCorreo" class="form-control border-0 bg-white" value="${valores.txtCorreo}" placeholder="usuario@clinica.com" required>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty usuarioEditar && usuarioEditar.rol_id_Rol == 3}">
                            <input type="hidden" name="txtPassword" value="${not empty valores.txtPassword ? valores.txtPassword : 'paciente123'}">
                        </c:when>
                        <c:otherwise>
                            <div class="col-md-6 mt-4">
                                <label for="txtPassword" class="form-label fw-bold text-dark small"><i class="bi bi-key-fill text-warning me-1"></i> Contraseña de Acceso al Sistema</label>
                                <div class="input-group has-validation shadow-sm rounded-4 overflow-hidden border border-warning border-opacity-50">
                                    <span class="input-group-text bg-white text-warning border-0"><i class="bi bi-lock-fill"></i></span>
                                    <input type="password" id="txtPassword" name="txtPassword" class="form-control border-0 bg-white fw-bold" value="${valores.txtPassword}" placeholder="••••••••" required>
                                    <button class="btn bg-white border-0 text-secondary px-3" type="button" id="btnTogglePassword" title="Mostrar/Ocultar Contraseña">
                                        <i class="bi bi-eye-fill" id="iconTogglePassword"></i>
                                    </button>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="col-md-6 mt-4 d-flex align-items-center">
                        <div class="form-check bg-white w-100 p-3 rounded-4 shadow-sm border border-light">
                            <input type="checkbox" id="tratamientoDatos" name="tratamientoDatos" class="form-check-input ms-1 shadow-sm mt-2" ${not empty usuarioEditar ? 'checked' : ''} required>
                            <label for="tratamientoDatos" class="form-check-label ms-2 small fw-medium text-dark cursor-pointer">
                                El usuario acepta las políticas de confidencialidad y tratamiento de datos del sistema clínico.
                            </label>
                        </div>
                    </div>

                    <div class="col-12 mt-4 d-flex flex-column flex-sm-row gap-3 justify-content-end pt-3 border-top border-light">
                        <c:if test="${not empty usuarioEditar}">
                            <a class="btn btn-white border fw-bold rounded-pill px-5 py-3 shadow-sm hover-effect" href="${ctx}/RegistroUsuarioServlet">Cancelar Edición</a>
                        </c:if>
                        <button type="submit" class="btn-nueva-cita fs-6 shadow-lg px-5 py-3">
                            <i class="bi bi-shield-check me-2"></i>${empty usuarioEditar ? 'Registrar Personal' : 'Guardar Cambios'}
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </section>

    <section class="vital-card card border-0 shadow-sm rounded-4 overflow-hidden mb-5 fade-in-up" style="animation-delay: 0.5s;">
        <div class="card-header admin-card-header bg-white border-bottom p-4">
            <h2 class="h5 mb-3 fw-bold text-dark"><i class="bi bi-journal-medical text-primary me-2"></i>Directorio de Usuarios</h2>
            
            <ul class="nav nav-pills nav-pills-vital" id="pills-tab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="pills-medicos-tab" data-bs-toggle="pill" data-bs-target="#pills-medicos" type="button" role="tab" aria-selected="true">
                        <i class="bi bi-heart-pulse-fill me-1"></i> Especialistas
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="pills-admin-tab" data-bs-toggle="pill" data-bs-target="#pills-admin" type="button" role="tab" aria-selected="false">
                        <i class="bi bi-laptop me-1"></i> Administrativos
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="pills-pacientes-tab" data-bs-toggle="pill" data-bs-target="#pills-pacientes" type="button" role="tab" aria-selected="false">
                        <i class="bi bi-people-fill me-1"></i> Pacientes
                    </button>
                </li>
            </ul>
        </div>
        
        <div class="card-body p-0">
            <div class="tab-content" id="pills-tabContent">
                
                <div class="tab-pane fade show active" id="pills-medicos" role="tabpanel">
                    <div class="table-responsive">
                        <table class="table table-vital table-hover table-borderless align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-4 py-3">Médico Especialista</th>
                                    <th class="py-3">Documento</th>
                                    <th class="py-3">Contacto</th>
                                    <th class="py-3 text-center">Rol</th>
                                    <th class="pe-4 py-3 text-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="usuario" items="${usuarios}">
                                    <c:if test="${fn:containsIgnoreCase(usuario.descripcionRol, 'odont') || fn:containsIgnoreCase(usuario.descripcionRol, 'medico') || fn:containsIgnoreCase(usuario.descripcionRol, 'especialista')}">
                                        <tr class="border-bottom border-light">
                                            <td class="ps-4 py-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="patient-avatar avatar-odont me-2">${fn:substring(usuario.nombreus, 0, 1)}</div>
                                                    <div class="fw-bold text-dark">Dr/a. ${usuario.nombreus} ${usuario.apellido}</div>
                                                </div>
                                            </td>
                                            <td class="py-3 fw-medium text-secondary">${usuario.documento}</td>
                                            <td class="py-3 text-secondary small">
                                                <div><i class="bi bi-telephone-fill text-muted me-1"></i> ${empty usuario.telefono ? 'N/A' : usuario.telefono}</div>
                                                <div><i class="bi bi-envelope-fill text-muted me-1"></i> ${empty usuario.correo ? 'N/A' : usuario.correo}</div>
                                            </td>
                                            <td class="py-3 text-center">
                                                <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-2 rounded-pill">${usuario.descripcionRol}</span>
                                            </td>
                                            <td class="pe-4 py-3 text-end">
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle me-1" href="${ctx}/RegistroUsuarioServlet?accion=editar&id=${usuario.id_Usuario}"><i class="bi bi-pencil-square text-primary"></i></a>
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle" href="${ctx}/RegistroUsuarioServlet?accion=eliminar&id=${usuario.id_Usuario}" onclick="return confirm('¿Remover este usuario?')"><i class="bi bi-trash-fill text-danger"></i></a>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="tab-pane fade" id="pills-admin" role="tabpanel">
                    <div class="table-responsive">
                        <table class="table table-vital table-hover table-borderless align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-4 py-3">Personal Administrativo</th>
                                    <th class="py-3">Documento</th>
                                    <th class="py-3">Contacto</th>
                                    <th class="py-3 text-center">Rol</th>
                                    <th class="pe-4 py-3 text-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="usuario" items="${usuarios}">
                                    <c:if test="${fn:containsIgnoreCase(usuario.descripcionRol, 'admin') || fn:containsIgnoreCase(usuario.descripcionRol, 'secretar') || fn:containsIgnoreCase(usuario.descripcionRol, 'recep')}">
                                        <tr class="border-bottom border-light">
                                            <td class="ps-4 py-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="patient-avatar avatar-admin me-2">${fn:substring(usuario.nombreus, 0, 1)}</div>
                                                    <div class="fw-bold text-dark">${usuario.nombreus} ${usuario.apellido}</div>
                                                </div>
                                            </td>
                                            <td class="py-3 fw-medium text-secondary">${usuario.documento}</td>
                                            <td class="py-3 text-secondary small">
                                                <div><i class="bi bi-telephone-fill text-muted me-1"></i> ${empty usuario.telefono ? 'N/A' : usuario.telefono}</div>
                                                <div><i class="bi bi-envelope-fill text-muted me-1"></i> ${empty usuario.correo ? 'N/A' : usuario.correo}</div>
                                            </td>
                                            <td class="py-3 text-center">
                                                <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-3 py-2 rounded-pill">${usuario.descripcionRol}</span>
                                            </td>
                                            <td class="pe-4 py-3 text-end">
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle me-1" href="${ctx}/RegistroUsuarioServlet?accion=editar&id=${usuario.id_Usuario}"><i class="bi bi-pencil-square text-primary"></i></a>
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle" href="${ctx}/RegistroUsuarioServlet?accion=eliminar&id=${usuario.id_Usuario}" onclick="return confirm('¿Remover este usuario?')"><i class="bi bi-trash-fill text-danger"></i></a>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="tab-pane fade" id="pills-pacientes" role="tabpanel">
                    <div class="table-responsive">
                        <table class="table table-vital table-hover table-borderless align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-4 py-3">Paciente Registrado</th>
                                    <th class="py-3">Documento</th>
                                    <th class="py-3">Contacto</th>
                                    <th class="py-3 text-center">Rol</th>
                                    <th class="pe-4 py-3 text-end">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="usuario" items="${usuarios}">
                                    <c:if test="${fn:containsIgnoreCase(usuario.descripcionRol, 'paciente')}">
                                        <tr class="border-bottom border-light">
                                            <td class="ps-4 py-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="patient-avatar avatar-paciente me-2">${fn:substring(usuario.nombreus, 0, 1)}</div>
                                                    <div class="fw-bold text-dark">${usuario.nombreus} ${usuario.apellido}</div>
                                                </div>
                                            </td>
                                            <td class="py-3 fw-medium text-secondary">${usuario.documento}</td>
                                            <td class="py-3 text-secondary small">
                                                <div><i class="bi bi-telephone-fill text-muted me-1"></i> ${empty usuario.telefono ? 'N/A' : usuario.telefono}</div>
                                                <div><i class="bi bi-envelope-fill text-muted me-1"></i> ${empty usuario.correo ? 'N/A' : usuario.correo}</div>
                                            </td>
                                            <td class="py-3 text-center">
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary-subtle px-3 py-2 rounded-pill">${usuario.descripcionRol}</span>
                                            </td>
                                            <td class="pe-4 py-3 text-end">
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle me-1" href="${ctx}/RegistroUsuarioServlet?accion=editar&id=${usuario.id_Usuario}"><i class="bi bi-pencil-square text-primary"></i></a>
                                                <a class="btn btn-sm bg-white border shadow-sm rounded-circle" href="${ctx}/RegistroUsuarioServlet?accion=eliminar&id=${usuario.id_Usuario}" onclick="return confirm('¿Remover este paciente?')"><i class="bi bi-trash-fill text-danger"></i></a>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </section>
</main>

<!-- Nasimpa ti SonarQube: Nainayon ti integrity ken crossorigin para iti Bootstrap JS ken SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmxc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.11.0/dist/sweetalert2.all.min.js" integrity="sha256-wA/Uccu1vNnJg6xU1+zB9wYqQ1U3L3+lB5zK0hQ5b5E=" crossorigin="anonymous"></script>
<script src="${ctx}/Vista/Javascript/validaciones.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const btnToggle = document.getElementById('btnTogglePassword');
    const inputPass = document.getElementById('txtPassword');
    const iconToggle = document.getElementById('iconTogglePassword');

    if (btnToggle && inputPass && iconToggle) {
        btnToggle.addEventListener('click', function() {
            const type = inputPass.getAttribute('type') === 'password' ? 'text' : 'password';
            inputPass.setAttribute('type', type);
            iconToggle.classList.toggle('bi-eye-fill');
            iconToggle.classList.toggle('bi-eye-slash-fill');
        });
    }

    const formRegistroUsuario = document.getElementById('registroUsuarioForm');
    if (formRegistroUsuario) {
        formRegistroUsuario.addEventListener('submit', function(event) {
            const accionInput = formRegistroUsuario.querySelector('input[name="accion"]');
            const accion = accionInput ? accionInput.value : 'insertar';

            if (accion === 'actualizar') {
                if (!formRegistroUsuario.checkValidity()) {
                    return; 
                }
                event.preventDefault(); 
                
                Swal.fire({
                    title: '¿Confirmar modificación?',
                    text: '¿Estás seguro de modificar estos datos?',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: 'Sí, guardar cambios',
                    cancelButtonText: 'Cancelar',
                    customClass: {
                        popup: 'rounded-4 shadow-lg',
                        confirmButton: 'btn btn-primary rounded-pill px-4 fw-bold me-2',
                        cancelButton: 'btn btn-light border rounded-pill px-4 fw-bold'
                    },
                    buttonsStyling: false
                }).then((result) => {
                    if (result.isConfirmed) {
                        formRegistroUsuario.submit();
                    }
                });
            }
        });
    }
});
</script>
</body>
</html>