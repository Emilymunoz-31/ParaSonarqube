function validarLogin() {
    const documentoInput = document.getElementById('documento');
    const contrasenaInput = document.getElementById('contrasena');

    if (!documentoInput || !contrasenaInput) {
        return true;
    }

    const documento = documentoInput.value.trim();
    const contrasena = contrasenaInput.value.trim();

    if (documento === "" || contrasena === "") {
        return false;
    }

    if (!/^[0-9]+$/.test(documento)) {
        alert("El documento debe ser numerico.");
        return false;
    }

    return true;
}

const reglas = {
    txtNombres: {
        patron: /^[\p{L} .'-]{2,60}$/u,
        mensaje: "Ingrese nombres validos."
    },
    txtApellidos: {
        patron: /^[\p{L} .'-]{2,60}$/u,
        mensaje: "Ingrese apellidos validos."
    },
    txtDocumento: {
        patron: /^[0-9]{7,10}$/,
        mensaje: "El documento debe tener de 7 a 10 dígitos."
    },
    documentoRecuperacion: {
        patron: /^[0-9]{5,15}$/,
        mensaje: "Ingrese un documento valido."
    },
   txtTelefono: {
    patron: /^[0-9]{7,10}$/,
    mensaje: "El número de teléfono debe tener de 7 a 10 dígitos."
    },
    txtCorreo: {
        patron: /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/,
        mensaje: "Ingrese un correo valido."
    },
    txtPassword: {
        patron: /^.{6,}$/,
        mensaje: "La contraseña debe tener minimo 6 caracteres."
    },
    descripcion: {
        patron: /^[\p{L}0-9 .,'-]{2,80}$/u,
        mensaje: "Ingrese una descripcion valida."
    },
    // Reglas flexibilizadas para permitir formato de miles como 1.800.000
    costo: {
        patron: /^[\d.,]+$/,
        mensaje: "Ingrese un costo valido (solo números, puntos o comas)."
    },
    monto: {
        patron: /^[\d.,]+$/,
        mensaje: "Ingrese un monto valido (solo números, puntos o comas)."
    },
    txtMontoPago: {
        patron: /^[\d.,]+$/,
        mensaje: "Ingrese un monto valido."
    },
    anio: {
        patron: /^(19|20)[0-9]{2}$/,
        mensaje: "Ingrese un año valido."
    }
};

function mostrarError(campo, mensaje) {
    campo.classList.add('is-invalid');
    campo.classList.remove('is-valid');

    const contenedor = campo.closest('.mb-3, .mb-4, .form-check, .col-md-6, .col-md-4, .col-md-8, .col-md-3') || campo.parentElement;
    let feedback = contenedor ? contenedor.querySelector('.invalid-feedback') : null;

    if (!feedback) {
        feedback = document.createElement('div');
        feedback.className = 'invalid-feedback';
        campo.insertAdjacentElement('afterend', feedback);
    }

    feedback.textContent = mensaje;
}

function marcarValido(campo) {
    campo.classList.remove('is-invalid');
    campo.classList.add('is-valid');
}

function validarCampo(campo) {
    if (campo.disabled || campo.type === 'hidden') {
        return true;
    }

    const valor = campo.value.trim();
    const nombre = campo.name || campo.id;

    if (campo.required && campo.type === 'checkbox' && !campo.checked) {
        mostrarError(campo, "Debe aceptar este campo.");
        return false;
    }

    if (campo.required && valor === "") {
        mostrarError(campo, "Este campo es obligatorio.");
        return false;
    }

    if (valor !== "" && reglas[nombre] && !reglas[nombre].patron.test(valor)) {
        mostrarError(campo, reglas[nombre].mensaje);
        return false;
    }

    if (campo.type === 'email' && valor !== "" && !reglas.txtCorreo.patron.test(valor)) {
        mostrarError(campo, reglas.txtCorreo.mensaje);
        return false;
    }

    if (campo.type === 'date' && campo.required) {
        const fecha = new Date(valor + "T00:00:00");
        const hoy = new Date();
        hoy.setHours(0, 0, 0, 0);

        if (Number.isNaN(fecha.getTime())) {
            mostrarError(campo, "Ingrese una fecha valida.");
            return false;
        }

        if (nombre === "txtFechaNac" && fecha > hoy) {
            mostrarError(campo, "La fecha de nacimiento no puede ser futura.");
            return false;
        }
    }

    marcarValido(campo);
    return true;
}

function validarFormulario(formulario) {
    const campos = formulario.querySelectorAll('input, select, textarea');
    let valido = true;

    campos.forEach((campo) => {
        if (!validarCampo(campo)) {
            valido = false;
        }
    });

    formulario.classList.add('was-validated');
    return valido;
}

document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');

    if (loginForm) {
        loginForm.addEventListener('submit', (event) => {
            if (!validarLogin()) {
                event.preventDefault();
            }
        });
    }

    document.querySelectorAll('form.needs-validation').forEach((formulario) => {
        formulario.addEventListener('submit', (event) => {
            if (!validarFormulario(formulario)) {
                event.preventDefault();
                event.stopPropagation();
            }
        });

        formulario.querySelectorAll('input, select, textarea').forEach((campo) => {
            campo.addEventListener('input', () => validarCampo(campo));
            campo.addEventListener('change', () => validarCampo(campo));
        });
    });

    const tratamientoSelect = document.getElementById('txtIdTratamiento');
    const montoPagoInput = document.getElementById('txtMontoPago');

    if (tratamientoSelect && montoPagoInput) {
        const actualizarMontoTratamiento = () => {
            const opcionSeleccionada = tratamientoSelect.options[tratamientoSelect.selectedIndex];
            const costo = opcionSeleccionada ? opcionSeleccionada.dataset.costo : "";

            if (costo) {
                montoPagoInput.value = Number(costo).toFixed(2);
                validarCampo(montoPagoInput);
            } else {
                montoPagoInput.value = "";
                montoPagoInput.placeholder = "Seleccione un tratamiento";
            }
        };

        tratamientoSelect.addEventListener('change', actualizarMontoTratamiento);
        actualizarMontoTratamiento();
    }

    const documentoCitaInput = document.getElementById('txtDocumentoCita');
    const nombrePacienteInput = document.getElementById('txtNombrePaciente');

    if (documentoCitaInput && nombrePacienteInput) {
        const buscarPaciente = async () => {
            const documento = documentoCitaInput.value.trim();
            nombrePacienteInput.value = "";

            if (!/^[0-9]{5,15}$/.test(documento)) {
                nombrePacienteInput.placeholder = "Ingrese un documento valido";
                return;
            }

            nombrePacienteInput.placeholder = "Buscando paciente...";

            try {
                const baseUrl = documentoCitaInput.dataset.busquedaUrl || window.location.pathname.replace(/\/[^/]*$/, '');
                const url = `${baseUrl}/AgendarCitaServlet?accion=buscarPaciente&documento=${encodeURIComponent(documento)}`;
                const respuesta = await fetch(url, { headers: { Accept: 'application/json' } });
                const datos = await respuesta.json();

                if (datos.existe) {
                    nombrePacienteInput.value = datos.nombre;
                    nombrePacienteInput.placeholder = "Paciente encontrado";
                    marcarValido(documentoCitaInput);
                    return;
                }

                nombrePacienteInput.placeholder = "Paciente no encontrado";
                mostrarError(documentoCitaInput, "No existe un paciente con ese documento.");
            } catch (error) {
                nombrePacienteInput.placeholder = "No se pudo consultar el paciente";
                mostrarError(documentoCitaInput, "No se pudo consultar el paciente.");
            }
        };

        documentoCitaInput.addEventListener('blur', buscarPaciente);
        documentoCitaInput.addEventListener('change', buscarPaciente);
    }

    // === NUEVA VALIDACIÓN: Bloqueo de documento duplicado en Registro de Usuarios ===
    const inputDocRegistro = document.getElementById('txtDocumento');
    const formRegistroUsuario = document.getElementById('registroUsuarioForm');

    if (inputDocRegistro && formRegistroUsuario) {
        inputDocRegistro.addEventListener('blur', async () => {
            const documento = inputDocRegistro.value.trim();
            const accionInput = formRegistroUsuario.querySelector('input[name="accion"]');
            const accion = accionInput ? accionInput.value : 'insertar';

            // Solo verificamos existencia al intentar insertar un usuario nuevo
            if (accion === 'insertar' && /^[0-9]{7,10}$/.test(documento)) {
                try {
                    // Reutilizamos el endpoint de buscarPaciente que ya existe para las citas
                    const baseUrl = window.location.pathname.replace(/\/[^/]*$/, '');
                    const url = `${baseUrl}/AgendarCitaServlet?accion=buscarPaciente&documento=${encodeURIComponent(documento)}`;
                    const respuesta = await fetch(url, { headers: { Accept: 'application/json' } });
                    const datos = await respuesta.json();

                    if (datos.existe) {
                        mostrarError(inputDocRegistro, "Este documento ya se encuentra registrado en el sistema.");
                        inputDocRegistro.dataset.duplicado = "true";
                    } else {
                        marcarValido(inputDocRegistro);
                        inputDocRegistro.dataset.duplicado = "false";
                    }
                } catch (error) {
                    console.warn("No se pudo verificar el documento en tiempo real.", error);
                }
            }
        });

        // Interceptamos el envío del formulario si está duplicado
        formRegistroUsuario.addEventListener('submit', (event) => {
            if (inputDocRegistro.dataset.duplicado === "true") {
                event.preventDefault();
                event.stopPropagation();
                mostrarError(inputDocRegistro, "Cambie el documento. Este ya pertenece a otro usuario.");
            }
        });
    }

    aplicarIconosFormulario();
    mostrarTransaccionFormulario();
});

function cargarSweetAlert() {
    if (window.Swal) {
        return Promise.resolve();
    }

    return new Promise((resolve, reject) => {
        const cssId = 'sweetalert2-css';
        if (!document.getElementById(cssId)) {
            const link = document.createElement('link');
            link.id = cssId;
            link.rel = 'stylesheet';
            link.href = 'https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css';
            document.head.appendChild(link);
        }

        const script = document.createElement('script');
        script.src = 'https://cdn.jsdelivr.net/npm/sweetalert2@11';
        script.onload = resolve;
        script.onerror = reject;
        document.body.appendChild(script);
    });
}

function mostrarTransaccionFormulario() {
    const params = new URLSearchParams(window.location.search);
    const mensaje = params.get('mensaje');
    const error = params.get('error');
    const esExito = ['guardado', 'exitoso', 'cita_creada', 'paciente_registrado'].includes(mensaje);
    const esError = ['registro', 'datos_invalidos', 'no_guardada', 'paciente_no_existe'].includes(error);

    if (!esExito && !esError) {
        return;
    }

    cargarSweetAlert().then(() => {
        Swal.fire({
            title: esExito ? 'Transaccion exitosa' : 'No se pudo registrar',
            html: esExito
                ? '<strong>Registro guardado correctamente.</strong><br>La informacion quedo almacenada correctamente en VitalDentist.'
                : '<strong>No se pudo guardar.</strong><br>Revise los datos e intentelo nuevamente.',
            icon: esExito ? 'success' : 'error',
            customClass: {
                popup: 'vital-transaction-popup',
                confirmButton: 'vital-confirm-button'
            },
            confirmButtonText: esExito ? 'Continuar' : 'Revisar'
        }).then(() => {
            window.history.replaceState(null, null, window.location.pathname);
        });
    });
}

function aplicarIconosFormulario() {
    const iconos = {
        txtNombres: 'bi-person',
        txtApellidos: 'bi-person-badge',
        txtDocumento: 'bi-credit-card-2-front',
        txtDocumentoCita: 'bi-search',
        txtNombrePaciente: 'bi-person-check',
        documento: 'bi-credit-card-2-front',
        documentoRecuperacion: 'bi-credit-card-2-front',
        txtTipoDoc: 'bi-file-earmark-text',
        txtFechaNac: 'bi-calendar-heart',
        txtRol: 'bi-person-gear',
        txtCorreo: 'bi-envelope',
        txtTelefono: 'bi-telephone',
        txtPassword: 'bi-lock',
        contrasena: 'bi-lock',
        txtIdOdontologo: 'bi-person-workspace',
        txtIdTratamiento: 'bi-heart-pulse',
        txtFechaCita: 'bi-calendar-event',
        txtHoraCita: 'bi-clock',
        txtEstadoCita: 'bi-clipboard-check',
        txtEstadoPago: 'bi-check-circle',
        txtMedioPago: 'bi-wallet2',
        txtMontoPago: 'bi-cash-coin',
        txtObservaciones: 'bi-chat-left-text',
        descripcion: 'bi-pencil-square',
        costo: 'bi-cash-coin',
        monto: 'bi-cash-coin',
        anio: 'bi-calendar3',
        fecha: 'bi-calendar-event',
        pago: 'bi-receipt',
        categoria: 'bi-tags',
        tratamiento: 'bi-heart-pulse'
    };

    document.querySelectorAll('input, select, textarea').forEach((campo) => {
        const clave = campo.name || campo.id;
        const icono = iconos[clave];
        if (!icono) {
            return;
        }

        const id = campo.id;
        let label = id ? document.querySelector(`label[for="${id}"]`) : null;
        if (!label) {
            const contenedor = campo.closest('.mb-3, .mb-4, .col-md-3, .col-md-4, .col-md-5, .col-md-6, .col-md-7, .col-md-8');
            label = contenedor ? contenedor.querySelector('.form-label') : null;
        }

        if (!label || label.querySelector('.bi')) {
            return;
        }

        const i = document.createElement('i');
        i.className = `bi ${icono}`;
        i.setAttribute('aria-hidden', 'true');
        label.prepend(i);
    });
}