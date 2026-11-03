<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Programar Cita</title>
    <link rel="icon" type="image/png" href="${ctx}/Vista/Imagenes/logo2.0.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="appointment-page dashboard-shell" style="background-color: var(--vital-bg-page); overflow-y: auto !important;">

<main class="dashboard-main-v2 fade-in-up" style="animation-duration: 0.6s;">

    <div class="hero-card fade-in-up d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4" style="animation-delay: 0.1s;">
        <div>
            <p class="hero-eyebrow text-primary"><i class="bi bi-stars me-1"></i> Módulo Clínico</p>
            <h1 class="hero-title"><i class="bi bi-calendar-plus-fill me-2 text-primary"></i>Programar Nueva Cita</h1>
            <p class="hero-subtitle">Busca a tu paciente y asigna el tratamiento de forma rápida y segura.</p>
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
        <c:if test="${param.paciente_registrado == '1'}">
            <div class="alert alert-success shadow-sm border-0 rounded-4 alert-dismissible fade show"><i class="bi bi-check-circle-fill me-2"></i><strong>¡Éxito!</strong> Paciente registrado correctamente. Ya puede buscarlo.</div>
        </c:if>
        <c:if test="${param.paciente_error == 'datos_invalidos'}">
            <div class="alert alert-danger shadow-sm border-0 rounded-4"><i class="bi bi-exclamation-triangle-fill me-2"></i>No fue posible registrar el paciente. Revise nombres, documento, teléfono, correo y aceptación de datos.</div>
        </c:if>
        <c:if test="${param.paciente_error == 'registro'}">
            <div class="alert alert-danger shadow-sm border-0 rounded-4"><i class="bi bi-exclamation-triangle-fill me-2"></i>No fue posible guardar el paciente. Verifique si el documento o correo ya existen.</div>
        </c:if>
        <c:if test="${param.mensaje == 'cita_creada'}">
            <div class="alert alert-success shadow-sm border-0 rounded-4"><i class="bi bi-check-circle-fill me-2"></i><strong>Transacción Exitosa.</strong> Cita registrada y pago pendiente creado automáticamente.</div>
        </c:if>
        <c:if test="${param.mensaje == 'actualizado'}">
            <div class="alert alert-success shadow-sm border-0 rounded-4"><i class="bi bi-arrow-repeat me-2"></i><strong>Cita actualizada.</strong> La agenda clínica se ha refrescado.</div>
        </c:if>
        <c:if test="${param.mensaje == 'eliminado'}">
            <div class="alert alert-secondary shadow-sm border-0 rounded-4"><i class="bi bi-trash3-fill me-2"></i><strong>Cita eliminada.</strong> El registro fue borrado exitosamente.</div>
        </c:if>
        <c:if test="${param.error == 'paciente_no_existe'}">
            <div class="alert alert-danger shadow-sm border-0 rounded-4"><i class="bi bi-x-octagon-fill me-2"></i>Seleccione un paciente válido desde la lista de resultados.</div>
        </c:if>
        <c:if test="${param.error == 'datos_invalidos'}">
            <div class="alert alert-warning shadow-sm border-0 rounded-4"><i class="bi bi-exclamation-circle-fill me-2"></i>Faltan datos. Revise paciente, odontólogo, tratamiento, fecha, hora o estado.</div>
        </c:if>
    </div>

    <form id="registroCitaForm" action="${ctx}/AgendarCitaServlet" method="POST" class="needs-validation" novalidate>
        <input type="hidden" name="accion" value="${empty citaEditar ? 'insertar' : 'actualizar'}">
        <input type="hidden" name="id" value="${citaEditar.id_Cita}">
        <input type="hidden" id="txtDocumentoCita" name="txtDocumentoCita" value="${citaEditar != null ? citaEditar.usuario_id_Usuario : ''}">

        <section class="vital-card card mb-4 fade-in-up ${empty citaEditar ? '' : 'd-none'}" style="animation-delay: 0.3s;">
            <div class="card-header admin-card-header bg-white border-bottom p-4 d-flex flex-wrap gap-3 justify-content-between align-items-center rounded-top-4">
                <div>
                    <h2 class="h5 mb-1 fw-bold text-dark"><i class="bi bi-search text-primary me-2"></i>1. Identificación del Paciente</h2>
                    <small class="text-muted">Busque por nombre o documento y seleccione un resultado.</small>
                </div>
                <button type="button" class="btn btn-outline-primary fw-bold rounded-pill shadow-sm hover-effect" data-bs-toggle="modal" data-bs-target="#modalNuevoPaciente">
                    <i class="bi bi-person-plus-fill me-1"></i> Registrar Nuevo Paciente
                </button>
            </div>

            <div class="card-body p-4 p-md-5 bg-white rounded-bottom-4">
                <label for="buscadorPaciente" class="form-label fw-semibold text-secondary small">Buscar paciente</label>
                <div class="position-relative patient-search-wrap">
                    <div class="input-group input-group-lg shadow-sm rounded-4 overflow-hidden border border-light" style="border: 2px solid var(--vital-bg-page);">
                        <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-upc-scan"></i></span>
                        <input type="search" id="buscadorPaciente" class="form-control border-0 ps-0 fw-medium" placeholder="Escriba nombre o documento..." autocomplete="off">
                    </div>
                    <div id="resultadosPaciente" class="patient-results list-group shadow-lg position-absolute w-100 mt-2 d-none" style="z-index: 1050; border-radius: 1rem; overflow: hidden; border: 1px solid var(--vital-card-border); max-height: 250px; overflow-y: auto; background: white;"></div>
                </div>
                <div id="pacienteFeedback" class="form-text text-danger mt-2 fw-medium d-none"><i class="bi bi-exclamation-circle me-1"></i>Seleccione un paciente de la lista antes de guardar.</div>

                <div id="pacienteSeleccionado" class="glass-patient-card mt-4 p-4 rounded-4 shadow-sm d-none fade-in-up">
                    <div class="d-flex flex-wrap gap-2 justify-content-between align-items-center mb-4 pb-3 border-bottom border-success border-opacity-25">
                        <div class="d-flex align-items-center">
                            <div class="icon-circle-lg bg-white text-success shadow-sm me-3 d-flex align-items-center justify-content-center rounded-circle" style="width: 45px; height: 45px;">
                                <i class="bi bi-person-check-fill fs-4"></i>
                            </div>
                            <div>
                                <span class="badge bg-success bg-opacity-10 text-success rounded-pill mb-1">Paciente Confirmado</span>
                                <h3 id="pacienteNombreTitulo" class="h5 mb-0 fw-bold text-dark"></h3>
                            </div>
                        </div>
                        <button type="button" id="limpiarPaciente" class="btn btn-sm btn-white border shadow-sm rounded-pill px-3 text-danger fw-bold hover-effect bg-white">
                            <i class="bi bi-x-circle me-1"></i> Desvincular
                        </button>
                    </div>

                    <div class="row g-4">
                        <div class="col-md-3 col-sm-6">
                            <label class="form-label small text-muted fw-bold text-uppercase mb-1"><i class="bi bi-person me-1"></i>Nombre</label>
                            <input type="text" id="datoNombrePaciente" class="form-control form-control-sm bg-transparent border-0 fw-bold text-dark fs-6 px-0" readonly>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <label class="form-label small text-muted fw-bold text-uppercase mb-1"><i class="bi bi-card-heading me-1"></i>Documento</label>
                            <input type="text" id="datoDocumentoPaciente" class="form-control form-control-sm bg-transparent border-0 fw-bold text-dark fs-6 px-0" readonly>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <label class="form-label small text-muted fw-bold text-uppercase mb-1"><i class="bi bi-telephone me-1"></i>Teléfono</label>
                            <input type="text" id="datoTelefonoPaciente" class="form-control form-control-sm bg-transparent border-0 fw-bold text-dark fs-6 px-0" readonly>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <label class="form-label small text-muted fw-bold text-uppercase mb-1"><i class="bi bi-envelope-at me-1"></i>Correo</label>
                            <input type="text" id="datoCorreoPaciente" class="form-control form-control-sm bg-transparent border-0 fw-bold text-dark fs-6 px-0" readonly>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="vital-card card mb-4 fade-in-up" style="animation-delay: 0.4s;">
            <div class="card-header admin-card-header bg-white border-bottom p-4 rounded-top-4">
                <h2 class="h5 mb-1 fw-bold text-dark"><i class="bi bi-clipboard2-pulse text-primary me-2"></i>2. Detalles Clínicos y Fecha</h2>
                <small class="text-muted">Configure el especialista, categoría, tratamiento y momento de atención.</small>
            </div>
            <div class="card-body p-4 p-md-5">
                <div class="row g-4">

                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-secondary small">Profesional Odontólogo</label>
                        <div class="input-group shadow-sm rounded-4 overflow-hidden border border-light">
                            <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-person-badge fs-5"></i></span>
                            <select name="txtIdOdontologo" class="form-select border-0 bg-white" required>
                                <option value="" disabled selected>Seleccione un especialista...</option>
                                <c:forEach var="odontologo" items="${odontologos}">
                                    <option value="${odontologo.id_Usuario}" ${citaEditar.usuario_id_Usuario == odontologo.id_Usuario ? 'selected' : ''}>Dr/a. ${odontologo.nombreus} ${odontologo.apellido}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Seleccione un odontólogo.</div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-secondary small">Categoría de Tratamiento</label>
                        <div class="input-group shadow-sm rounded-4 overflow-hidden border border-light">
                            <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-tags fs-5"></i></span>
                            <select id="selectCategoria" class="form-select border-0 bg-white">
                                <option value="" disabled selected>Seleccione una categoría...</option>
                                <c:forEach var="cat" items="${categoriasTratamiento}">
                                    <option value="${cat.id_Categoria}">${cat.nombre_categoria}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-secondary small">Tratamiento Específico</label>
                        <div class="input-group shadow-sm rounded-4 overflow-hidden border border-light">
                            <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-bandaid fs-5"></i></span>
                            <select id="txtIdTratamiento" name="txtIdTratamiento" class="form-select border-0 bg-white" required>
                                <option value="" disabled selected>Seleccione primero una categoría...</option>
                                <c:forEach var="tratamiento" items="${tratamientos}">
                                    <option value="${tratamiento.id_Tipotratam}" 
                                            data-categoria="${tratamiento.categoria_Tratamiento_id_Categoria}" 
                                            ${citaEditar.tipo_Tratamiento_id_Tipotratam == tratamiento.id_Tipotratam ? 'selected' : ''}>
                                        ${tratamiento.descripcion_tipotratam}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Seleccione un tratamiento.</div>
                        </div>
                    </div>

                    <div class="col-12"><hr class="my-3 text-muted opacity-10"></div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-secondary small">Fecha de la Cita</label>
                        <div class="input-group shadow-sm rounded-4 overflow-hidden border border-light">
                            <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-calendar-event fs-5"></i></span>
                            <input type="date" name="txtFechaCita" class="form-control border-0 bg-white fw-bold text-dark" value="${fechaEditar}" required>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-secondary small">Hora</label>
                        <div class="input-group shadow-sm rounded-4 overflow-hidden border border-light">
                            <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-clock fs-5"></i></span>
                            <input type="time" name="txtHoraCita" class="form-control border-0 bg-white fw-bold text-dark" value="${horaEditar}" required>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-secondary small">Estado Inicial</label>
                        <div class="input-group shadow-sm rounded-4 overflow-hidden border border-light">
                            <span class="input-group-text bg-white text-primary border-0"><i class="bi bi-flag fs-5"></i></span>
                            <select name="txtEstadoCita" class="form-select border-0 bg-white fw-bold text-dark" required>
                                <option value="" disabled selected>Seleccione...</option>
                                <c:forEach var="estado" items="${estadosCita}">
                                    <option value="${estado.idEstado_cita}" ${citaEditar.estado_cita_idEstado_cita == estado.idEstado_cita ? 'selected' : ''}>${estado.descripcion_estadoci}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="col-12 mt-4">
                        <label class="form-label fw-semibold text-secondary small"><i class="bi bi-journal-text me-1 text-primary"></i> Observaciones Médicas</label>
                        <textarea name="txtObservaciones" class="form-control bg-light border-0 shadow-sm rounded-4 p-3" rows="2" placeholder="Ej: Paciente asiste a control mensual...">${citaEditar.descripcion_cita}</textarea>
                    </div>

                </div>
            </div>
        </section>

        <div class="d-flex flex-column flex-sm-row gap-3 justify-content-end pb-5 fade-in-up" style="animation-delay: 0.5s;">
            <c:choose>
                <c:when test="${sessionScope.usuarioLogueado.rol_id_Rol == 1 or fn:containsIgnoreCase(sessionScope.usuarioLogueado.descripcionRol, 'odont')}">
                    <a href="${ctx}/OdontologoInicioServlet" class="btn btn-white border fw-bold rounded-pill px-5 py-3 shadow-sm hover-effect">Cancelar</a>
                </c:when>
                <c:otherwise>
                    <a href="${ctx}/AdminInicioServlet" class="btn btn-white border fw-bold rounded-pill px-5 py-3 shadow-sm hover-effect">Cancelar</a>
                </c:otherwise>
            </c:choose>

            <button type="submit" class="btn-nueva-cita fs-6 shadow-lg px-5 py-3">
                <i class="bi bi-save2-fill me-2"></i> ${empty citaEditar ? 'Confirmar y Agendar' : 'Actualizar Cambios'}
            </button>
        </div>
    </form>
</main>

<div class="modal fade" id="modalNuevoPaciente" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4" style="background: linear-gradient(180deg, #ffffff 0%, var(--vital-bg-page) 100%);">
            <div class="modal-header bg-primary bg-opacity-10 border-bottom-0 pb-3 pt-4 px-4 rounded-top-4">
                <h5 class="modal-title fw-bold text-primary">
                    <div class="icon-circle-lg bg-white shadow-sm d-inline-flex me-2 align-items-center justify-content-center" style="width: 40px; height: 40px; font-size: 1.2rem;">
                        <i class="bi bi-person-plus-fill text-primary"></i>
                    </div>
                    Registro Rápido de Paciente
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body px-4 px-md-5 pb-5 pt-3">
                <form action="${ctx}/RegistrarPacienteModalServlet" method="POST" class="needs-validation" novalidate id="formRegistroRapidoModal">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary small">Nombres</label>
                            <input type="text" name="txtNombresModal" class="form-control rounded-3 shadow-sm border-0 bg-white" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-secondary small">Apellidos</label>
                            <input type="text" name="txtApellidosModal" class="form-control rounded-3 shadow-sm border-0 bg-white" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Tipo Doc.</label>
                            <select name="txtTipoDocModal" class="form-select rounded-3 shadow-sm border-0 bg-white" required>
                                <option value="">Seleccione...</option>
                                <c:forEach var="tipo" items="${tiposDocumento}">
                                    <option value="${tipo.id_Tipodocumento}">${tipo.descripcion_tipodoc}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-semibold text-secondary small">Número de Documento</label>
                            <input type="text" name="txtDocumentoModal" id="txtDocumentoModal" class="form-control rounded-3 shadow-sm border-0 bg-white fw-bold" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Fecha Nac.</label>
                            <input type="date" name="txtFechaNacModal" class="form-control rounded-3 shadow-sm border-0 bg-white" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Teléfono</label>
                            <input type="text" name="txtTelefonoModal" class="form-control rounded-3 shadow-sm border-0 bg-white" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold text-secondary small">Correo Electrónico</label>
                            <input type="email" name="txtCorreoModal" class="form-control rounded-3 shadow-sm border-0 bg-white" required>
                        </div>

                        <div class="col-12 mt-4 text-end border-top border-light pt-3">
                            <button type="button" class="btn btn-white shadow-sm border rounded-pill px-4 py-2 me-2" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn-nueva-cita shadow-lg px-4 py-2"><i class="bi bi-lightning-charge-fill me-1"></i> Crear Paciente</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
    const ctx = '${ctx}';
    const input = document.getElementById('buscadorPaciente');
    const contenedorRes = document.getElementById('resultadosPaciente');
    const feedback = document.getElementById('pacienteFeedback');
    const tarjeta = document.getElementById('pacienteSeleccionado');
    const nombreTitulo = document.getElementById('pacienteNombreTitulo');
    const datoNombre = document.getElementById('datoNombrePaciente');
    const datoDocumento = document.getElementById('datoDocumentoPaciente');
    const datoTelefono = document.getElementById('datoTelefonoPaciente');
    const datoCorreo = document.getElementById('datoCorreoPaciente');
    const inputDocOculto = document.getElementById('txtDocumentoCita');
    const btnLimpiar = document.getElementById('limpiarPaciente');

    if (input) {
        let debounceTimer = null;

        input.addEventListener('input', function () {
            const termino = this.value.trim();
            clearTimeout(debounceTimer);
            feedback.classList.add('d-none');

            if (termino.length < 2) {
                ocultarResultados();
                return;
            }
            debounceTimer = setTimeout(() => buscarPacientes(termino), 300);
        });

        document.addEventListener('click', function (e) {
            if (!contenedorRes.contains(e.target) && e.target !== input) {
                ocultarResultados();
            }
        });

        function buscarPacientes(termino) {
            const url = ctx + '/AgendarCitaServlet?accion=buscarPacientes&q=' + encodeURIComponent(termino);
            fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                .then(resp => resp.json())
                .then(pacientes => renderizarResultados(pacientes))
                .catch(err => console.error('Error buscando pacientes:', err));
        }

        function renderizarResultados(pacientes) {
            contenedorRes.innerHTML = '';
            if (!pacientes || pacientes.length === 0) {
                contenedorRes.innerHTML = '<div class="list-group-item text-muted">No se encontraron pacientes.</div>';
                contenedorRes.classList.remove('d-none');
                return;
            }
            pacientes.forEach(p => {
                const item = document.createElement('button');
                item.type = 'button';
                item.className = 'list-group-item list-group-item-action py-2';
                item.innerHTML = '<div class="fw-bold">' + escaparHtml(p.nombre) + '</div>' +
                    '<small class="text-muted">Doc: ' + escaparHtml(p.documento) + ' · Tel: ' + escaparHtml(p.telefono || 'N/A') + '</small>';
                item.addEventListener('click', () => seleccionarPaciente(p));
                contenedorRes.appendChild(item);
            });
            contenedorRes.classList.remove('d-none');
        }

        function seleccionarPaciente(p) {
            nombreTitulo.textContent = p.nombre;
            datoNombre.value = p.nombre;
            datoDocumento.value = p.documento;
            datoTelefono.value = p.telefono || '';
            datoCorreo.value = p.correo || '';
            inputDocOculto.value = p.documento;

            tarjeta.classList.remove('d-none');
            feedback.classList.add('d-none');
            input.value = p.nombre;
            ocultarResultados();
        }

        function ocultarResultados() {
            contenedorRes.classList.add('d-none');
        }

        if (btnLimpiar) {
            btnLimpiar.addEventListener('click', function () {
                tarjeta.classList.add('d-none');
                inputDocOculto.value = '';
                input.value = '';
                input.focus();
            });
        }
    }

    const selectCategoria = document.getElementById('selectCategoria');
    const selectTratamiento = document.getElementById('txtIdTratamiento');

    if (selectCategoria && selectTratamiento) {
        const opcionesOriginales = Array.from(selectTratamiento.options);

        selectCategoria.addEventListener('change', function () {
            const categoriaId = this.value;
            selectTratamiento.innerHTML = '<option value="" disabled selected>Seleccione el tratamiento...</option>';

            opcionesOriginales.forEach(opt => {
                if (opt.getAttribute('data-categoria') === categoriaId) {
                    selectTratamiento.appendChild(opt.cloneNode(true));
                }
            });
        });
    }

    const inputDocModal = document.getElementById('txtDocumentoModal');
    const formRegistroRapido = document.getElementById('formRegistroRapidoModal');

    if (inputDocModal && formRegistroRapido) {
        inputDocModal.addEventListener('blur', async () => {
            const documento = inputDocModal.value.trim();
            if (/^[0-9]{7,10}$/.test(documento)) {
                try {
                    const url = ctx + '/AgendarCitaServlet?accion=buscarPaciente&documento=' + encodeURIComponent(documento);
                    const respuesta = await fetch(url, { headers: { Accept: 'application/json' } });
                    const datos = await respuesta.json();

                    if (datos.existe) {
                        inputDocModal.classList.add('is-invalid');
                        inputDocModal.classList.remove('is-valid');
                        inputDocModal.dataset.duplicado = "true";
                        
                        let feedback = inputDocModal.nextElementSibling;
                        if (!feedback || !feedback.classList.contains('invalid-feedback')) {
                            feedback = document.createElement('div');
                            feedback.className = 'invalid-feedback';
                            inputDocModal.parentNode.appendChild(feedback);
                        }
                        feedback.textContent = "Este documento ya está registrado en el sistema.";
                    } else {
                        inputDocModal.classList.remove('is-invalid');
                        inputDocModal.classList.add('is-valid');
                        inputDocModal.dataset.duplicado = "false";
                    }
                } catch (error) {
                    console.warn("No se pudo verificar el documento en tiempo real.", error);
                }
            }
        });

        formRegistroRapido.addEventListener('submit', (event) => {
            if (inputDocModal.dataset.duplicado === "true") {
                event.preventDefault();
                event.stopPropagation();
                
                inputDocModal.classList.add('is-invalid');
                Swal.fire({
                    title: 'Documento Duplicado',
                    text: 'El documento ' + inputDocModal.value + ' ya pertenece a un paciente registrado. Por favor, búsquelo en el formulario principal.',
                    icon: 'error',
                    confirmButtonText: 'Entendido',
                    customClass: {
                        popup: 'rounded-4 shadow-lg',
                        confirmButton: 'btn btn-danger rounded-pill px-4 fw-bold'
                    },
                    buttonsStyling: false
                });
            }
        });
    }

    function escaparHtml(texto) {
        const div = document.createElement('div');
        div.textContent = texto == null ? '' : texto;
        return div.innerHTML;
    }
});
</script>
</body>
</html>