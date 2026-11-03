<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Restablecer Contraseña</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${ctx}/Vista/Imagenes/logo2.0.png">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="login-page d-flex align-items-center justify-content-center min-vh-100">

    <div class="container d-flex justify-content-center">
        <div class="otp-wrapper-center w-100" style="max-width: 420px;">
            <div class="brand-mark">
                <span class="tooth-badge"><i class="bi bi-shield-check"></i></span>
                <span>VitalDentist</span>
            </div>

            <div class="otp-Form shadow-lg p-4 p-md-5 bg-white rounded-4 position-relative w-100">
                <a href="${ctx}/Inicio_sesion" class="exitBtn" title="Cancelar">&times;</a>

                <div class="step-track">
                    <span class="seg done"></span>
                    <span class="seg ${pasoDosCompleto ? 'done' : ''}"></span>
                </div>
                <p class="step-caption">Paso ${pasoDosCompleto ? '2' : '1'} de 2</p>

                <c:if test="${not empty mensaje}">
                    <div class="alert alert-info alert-dismissible fade show w-100 p-2 small text-center mb-3" role="alert">
                        <i class="bi bi-info-circle-fill me-1"></i>${mensaje}
                        <button type="button" class="btn-close p-2" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show w-100 p-2 small text-center mb-3" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i>${error}
                        <button type="button" class="btn-close p-2" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not pasoDosCompleto}">
                    <div class="text-center mb-4">
                        <span class="mainHeading h4 d-block mb-1">Verificación OTP</span>
                        <p class="otpSubheading small mb-0">Ingresa el código de 4 caracteres enviado a tu correo.</p>
                    </div>

                    <form id="formPaso1" action="${ctx}/RestablecerClave" method="POST" class="w-100 d-flex flex-column align-items-center gap-3" novalidate>
                        <input type="hidden" name="accion" value="validarCodigo">
                        <input type="hidden" name="correo" value="${correoPrecargado}">
                        <input type="hidden" id="codigoCompleto" name="codigo" value="">

                        <div class="inputContainer d-flex justify-content-center gap-2 w-100 my-2">
                            <input required maxlength="1" type="text" inputmode="text" class="otp-input form-control text-center fs-4 fw-bold" id="otp-input1" autofocus />
                            <input required maxlength="1" type="text" inputmode="text" class="otp-input form-control text-center fs-4 fw-bold" id="otp-input2" />
                            <input required maxlength="1" type="text" inputmode="text" class="otp-input form-control text-center fs-4 fw-bold" id="otp-input3" />
                            <input required maxlength="1" type="text" inputmode="text" class="otp-input form-control text-center fs-4 fw-bold" id="otp-input4" />
                        </div>
                        <div id="otpError" class="small text-center d-none">
                            <i class="bi bi-exclamation-circle-fill me-1"></i>Completa los 4 caracteres del código.
                        </div>

                        <button class="verifyButton btn btn-primary w-100 py-2 fw-bold shadow-sm" type="submit" id="btnValidar">
                            <span id="btnText1"><i class="bi bi-check2-circle me-1"></i>Verificar</span>
                            <span id="btnSpinner1" class="spinner-border spinner-border-sm d-none" role="status"></span>
                        </button>
                    </form>

                    <div class="resendNote text-center mt-3">
                        <span class="text-muted small">¿No recibiste el código?</span>
                        <form action="${ctx}/Recuperar_clave" method="POST" class="d-inline ms-1">
                            <input type="hidden" name="correo" value="${correoPrecargado}">
                            <button type="submit" class="resendBtn btn btn-link p-0 fw-bold text-decoration-none">Reenviar código</button>
                        </form>
                    </div>
                </c:if>

                <c:if test="${pasoDosCompleto}">
                    <div class="text-center mb-4">
                        <span class="mainHeading h4 d-block mb-1">Nueva Contraseña</span>
                        <p class="otpSubheading small mb-0">Crea y confirma tu nueva clave de acceso.</p>
                    </div>

                    <form id="formPaso2" action="${ctx}/RestablecerClave" method="POST" class="w-100 d-flex flex-column gap-3 text-start" novalidate>
                        <input type="hidden" name="accion" value="cambiarClave">
                        <input type="hidden" name="correo" value="${correoPrecargado}">

                        <div>
                            <label for="nuevaClave" class="form-label mb-1 fw-semibold small">Nueva Clave</label>
                            <div class="input-group">
                                <input type="password" id="nuevaClave" name="nuevaClave" class="input-pass-vital form-control border-end-0" placeholder="Mínimo 6 caracteres" minlength="6" required autocomplete="new-password">
                                <button type="button" class="btn btn-outline-secondary pass-toggle-btn" data-target="nuevaClave" tabindex="-1" aria-label="Mostrar u ocultar contraseña">
                                    <i class="bi bi-eye-fill"></i>
                                </button>
                            </div>
                            <div class="pass-strength-bar">
                                <div class="seg" data-seg="1"></div>
                                <div class="seg" data-seg="2"></div>
                                <div class="seg" data-seg="3"></div>
                                <div class="seg" data-seg="4"></div>
                            </div>
                            <ul class="req-list">
                                <li id="req-len"><i class="bi bi-circle"></i>6+ caracteres</li>
                                <li id="req-upper"><i class="bi bi-circle"></i>Una mayúscula</li>
                                <li id="req-num"><i class="bi bi-circle"></i>Un número</li>
                                <li id="req-special"><i class="bi bi-circle"></i>Un símbolo</li>
                            </ul>
                        </div>

                        <div>
                            <label for="confirmarClave" class="form-label mb-1 fw-semibold small">Confirmar Clave</label>
                            <div class="input-group">
                                <input type="password" id="confirmarClave" name="confirmarClave" class="input-pass-vital form-control border-end-0" placeholder="Repite la clave" minlength="6" required autocomplete="new-password">
                                <button type="button" class="btn btn-outline-secondary pass-toggle-btn" data-target="confirmarClave" tabindex="-1" aria-label="Mostrar u ocultar contraseña">
                                    <i class="bi bi-eye-fill"></i>
                                </button>
                            </div>
                            <div id="matchFeedback" class="match-feedback">
                                <i class="bi bi-check-circle-fill"></i> <span id="matchText"></span>
                            </div>
                        </div>

                        <button type="button" id="btnGuardar" class="verifyButton btn btn-primary w-100 py-2 fw-bold shadow-sm mt-2" onclick="abrirModalConfirmacion()">
                            <i class="bi bi-save2-fill me-1"></i>Guardar Clave
                        </button>
                    </form>
                </c:if>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalConfirmar" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold color-primario fs-6">Confirmar Cambio</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-muted small py-3 text-center">
                    ¿Estás seguro de que deseas actualizar tu contraseña?
                </div>
                <div class="modal-footer border-0 justify-content-center pt-0">
                    <button type="button" class="btn btn-light btn-sm px-3 fw-semibold rounded-pill" data-bs-dismiss="modal">Revisar</button>
                    <button type="button" id="btnConfirmarFinal" class="btn btn-primary btn-sm px-3 fw-semibold rounded-pill" onclick="ejecutarCambio()">
                        <span id="btnText2">Sí, Guardar</span>
                        <span id="btnSpinner2" class="spinner-border spinner-border-sm d-none" role="status"></span>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const inputs = document.querySelectorAll('.otp-input');
        const formPaso1 = document.getElementById('formPaso1');
        const otpError = document.getElementById('otpError');

        if (inputs.length > 0) {
            inputs.forEach((input, index) => {
                input.addEventListener('input', () => {
                    input.value = input.value.slice(0, 1);
                    otpError.classList.add('d-none');
                });
                input.addEventListener('keyup', (e) => {
                    if (input.value.length === 1 && index < inputs.length - 1) {
                        inputs[index + 1].focus();
                    }
                    if (e.key === 'Backspace' && index > 0 && input.value === '') {
                        inputs[index - 1].focus();
                    }
                });
                input.addEventListener('paste', (e) => {
                    e.preventDefault();
                    const texto = (e.clipboardData || window.clipboardData).getData('text').trim().toUpperCase();
                    for (let i = 0; i < inputs.length; i++) {
                        inputs[i].value = texto[i] || '';
                    }
                    const siguiente = Math.min(texto.length, inputs.length - 1);
                    inputs[siguiente].focus();
                });
            });

            formPaso1.addEventListener('submit', function (e) {
                let codigo = '';
                inputs.forEach(input => codigo += input.value.toUpperCase());

                if (codigo.length < 4) {
                    e.preventDefault();
                    otpError.classList.remove('d-none');
                    return;
                }

                document.getElementById('codigoCompleto').value = codigo;
                document.getElementById('btnText1').innerHTML = '<i class="bi bi-check2-circle me-1"></i>Verificando...';
                document.getElementById('btnSpinner1').classList.remove('d-none');
                document.getElementById('btnValidar').disabled = true;
            });
        }

        const nuevaClave = document.getElementById('nuevaClave');
        const confirmarClave = document.getElementById('confirmarClave');
        const strengthSegs = document.querySelectorAll('.pass-strength-bar .seg');
        const matchFeedback = document.getElementById('matchFeedback');
        const matchText = document.getElementById('matchText');
        const reqLen = document.getElementById('req-len');
        const reqUpper = document.getElementById('req-upper');
        const reqNum = document.getElementById('req-num');
        const reqSpecial = document.getElementById('req-special');

        document.querySelectorAll('.pass-toggle-btn').forEach(btn => {
            btn.addEventListener('click', function () {
                const targetId = this.getAttribute('data-target');
                const input = document.getElementById(targetId);
                const icon = this.querySelector('i');

                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.remove('bi-eye-fill');
                    icon.classList.add('bi-eye-slash-fill');
                } else {
                    input.type = 'password';
                    icon.classList.remove('bi-eye-slash-fill');
                    icon.classList.add('bi-eye-fill');
                }
                input.focus();
            });
        });

        function marcarRequisito(el, cumplido) {
            if (!el) return;
            const icon = el.querySelector('i');
            el.classList.toggle('met', cumplido);
            icon.classList.toggle('bi-circle', !cumplido);
            icon.classList.toggle('bi-check-circle-fill', cumplido);
        }

        function actualizarFuerza() {
            if (!nuevaClave) return;
            const clave = nuevaClave.value;

            const cumpleLargo = clave.length >= 6;
            const cumpleMayus = /[A-Z]/.test(clave);
            const cumpleNum = /[0-9]/.test(clave);
            const cumpleSimbolo = /[^A-Za-z0-9]/.test(clave);

            marcarRequisito(reqLen, cumpleLargo);
            marcarRequisito(reqUpper, cumpleMayus);
            marcarRequisito(reqNum, cumpleNum);
            marcarRequisito(reqSpecial, cumpleSimbolo);

            const puntos = [cumpleLargo, clave.length >= 10, cumpleMayus, cumpleNum, cumpleSimbolo].filter(Boolean).length;
            let activos = 0;
            let color = '#C4453B';

            if (clave.length === 0) {
                activos = 0;
            } else if (puntos <= 2) {
                activos = 1; color = '#C4453B';
            } else if (puntos === 3) {
                activos = 2; color = '#D98A2B';
            } else if (puntos === 4) {
                activos = 3; color = '#0E7C71';
            } else {
                activos = 4; color = '#2E9166';
            }

            strengthSegs.forEach((seg, i) => {
                seg.style.backgroundColor = i < activos ? color : '';
            });
        }

        function actualizarCoincidencia() {
            if (!confirmarClave || confirmarClave.value.length === 0) {
                matchFeedback.classList.remove('show', 'ok', 'bad');
                return;
            }
            matchFeedback.classList.add('show');
            if (nuevaClave.value === confirmarClave.value) {
                matchFeedback.classList.add('ok');
                matchFeedback.classList.remove('bad');
                matchText.textContent = 'Las contraseñas coinciden.';
            } else {
                matchFeedback.classList.add('bad');
                matchFeedback.classList.remove('ok');
                matchText.textContent = 'Las contraseñas no coinciden.';
            }
        }

        if (nuevaClave) {
            nuevaClave.addEventListener('input', function () {
                actualizarFuerza();
                actualizarCoincidencia();
            });
            confirmarClave.addEventListener('input', actualizarCoincidencia);
        }

        let modalConfirm;
        function abrirModalConfirmacion() {
            const clave1 = nuevaClave.value;
            const clave2 = confirmarClave.value;

            if (!clave1 || !clave2) {
                nuevaClave.classList.toggle('is-invalid', !clave1);
                confirmarClave.classList.toggle('is-invalid', !clave2);
                return;
            }
            if (clave1.length < 6) {
                nuevaClave.classList.add('is-invalid');
                actualizarFuerza();
                return;
            }
            if (clave1 !== clave2) {
                confirmarClave.classList.add('is-invalid');
                actualizarCoincidencia();
                return;
            }

            nuevaClave.classList.remove('is-invalid');
            confirmarClave.classList.remove('is-invalid');

            modalConfirm = new bootstrap.Modal(document.getElementById('modalConfirmar'));
            modalConfirm.show();
        }

        function ejecutarCambio() {
            document.getElementById('btnConfirmarFinal').disabled = true;
            document.getElementById('btnText2').textContent = "Guardando...";
            document.getElementById('btnSpinner2').classList.remove('d-none');
            document.getElementById('formPaso2').submit();
        }
    </script>
</body>
</html>