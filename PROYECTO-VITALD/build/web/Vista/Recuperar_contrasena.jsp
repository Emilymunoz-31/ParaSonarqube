<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Recuperar Contraseña</title>
    <link rel="icon" type="image/png" href="${ctx}/Vista/Imagenes/logo2.0.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="recover-page d-flex align-items-center min-vh-100">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12 col-md-6 col-lg-4">

                <div class="brand-mark">
                    <span class="tooth-badge"><i class="bi bi-shield-check"></i></span>
                    <span>VitalDentist</span>
                </div>

                <div class="card recover-card shadow-lg border-0 rounded-4">
                    <div class="card-body p-4 p-md-5">

                        <div class="text-center mb-4">
                            <div class="icon-circle-recover">
                                <i class="bi bi-shield-lock-fill"></i>
                            </div>
                            <h2 class="fw-bold color-primario mb-2">Recuperar Contraseña</h2>
                            <p class="text-muted small mb-0">Ingresa tu correo registrado para enviarte el código de verificación.</p>
                        </div>

                        <c:if test="${not empty mensaje}">
                            <div class="alert alert-info alert-dismissible fade show small text-center" role="alert">
                                <i class="bi bi-info-circle-fill me-1"></i><strong>${mensaje}</strong>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show small text-center" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-1"></i><strong>${error}</strong>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form id="formRecuperar" action="${ctx}/Recuperar_clave" method="POST" class="needs-validation" novalidate>

                            <div class="mb-2">
                                <label for="correo" class="form-label fw-semibold">Correo Electrónico</label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text border-end-0">
                                        <i class="bi bi-envelope-at" style="color: var(--recover-primary);"></i>
                                    </span>
                                    <input
                                        type="email"
                                        id="correo"
                                        name="correo"
                                        class="form-control border-start-0 ps-0"
                                        placeholder="ejemplo@correo.com"
                                        autocomplete="email"
                                        maxlength="150"
                                        required>
                                    <div class="invalid-feedback">
                                        Ingresa un correo electrónico válido (ej: nombre@dominio.com).
                                    </div>
                                </div>
                                <div id="correoFeedbackOk" class="form-text small d-none">
                                    <i class="bi bi-check-circle-fill"></i> Correo con formato válido.
                                </div>
                            </div>

                            <div class="alert alert-light border small mb-4 d-flex align-items-start gap-2">
                                <i class="bi bi-lock-fill mt-1"></i>
                                <span>Te enviaremos un código temporal a tu bandeja de entrada. Revisa también la carpeta de spam o promociones.</span>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" id="btnEnviar" class="btn btn-primary fw-semibold py-2">
                                    <span id="btnText"><i class="bi bi-send-fill me-1"></i> Enviar Correo</span>
                                    <span id="btnSpinner" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                                </button>
                                <a href="${ctx}/Vista/Login.jsp" class="btn btn-outline-secondary py-2">
                                    <i class="bi bi-arrow-left me-1"></i> Volver al Login
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('formRecuperar');
            const btnEnviar = document.getElementById('btnEnviar');
            const btnText = document.getElementById('btnText');
            const btnSpinner = document.getElementById('btnSpinner');
            const inputCorreo = document.getElementById('correo');
            const correoFeedbackOk = document.getElementById('correoFeedbackOk');

            const REGEX_CORREO = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;

            function validarCorreo() {
                const valor = inputCorreo.value.trim();
                const esValido = REGEX_CORREO.test(valor);

                if (esValido) {
                    inputCorreo.classList.remove('is-invalid');
                    inputCorreo.classList.add('is-valid-custom');
                    correoFeedbackOk.classList.remove('d-none');
                } else {
                    inputCorreo.classList.remove('is-valid-custom');
                    correoFeedbackOk.classList.add('d-none');
                    if (valor.length > 0) {
                        inputCorreo.classList.add('is-invalid');
                    }
                }
                return esValido;
            }

            inputCorreo.addEventListener('input', validarCorreo);
            inputCorreo.addEventListener('blur', validarCorreo);

            form.addEventListener('submit', function (e) {
                const correoValido = validarCorreo();

                if (!correoValido || !form.checkValidity()) {
                    form.classList.add('was-validated');
                    e.preventDefault();
                    inputCorreo.focus();
                    return;
                }

                btnEnviar.disabled = true;
                btnText.innerHTML = '<i class="bi bi-send-fill me-1"></i> Enviando correo...';
                btnSpinner.classList.remove('d-none');
            });
        });
    </script>
</body>
</html>