<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VitalDentist - Iniciar Sesión</title>
    <link rel="icon" type="image/png" href="${ctx}/Vista/Imagenes/logo2.0.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --navy-deep: #0a1c2a;
            --login-box-color: #0e2536;
            --input-color: #243655;
            --button-color: #243655;
            --footer-color: rgba(255, 255, 255, 0.5);
            --teal-accent: #4fd1c5;
        }

        * { box-sizing: border-box; }

        html, body {
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        body.login-page-custom {
            min-height: 100vh;
            display: flex;
            font-family: 'Outfit', sans-serif;
            background: var(--navy-deep);
        }

        /* ---------- Panel izquierdo: imagen ---------- */
        .panel-imagen {
            position: relative;
            flex: 1.1;
            min-height: 100vh;
            display: flex;
            align-items: flex-end;
            overflow: hidden;
        }

        .panel-imagen img {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
        }

        .panel-imagen::after {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(
                180deg,
                rgba(10, 28, 42, 0.15) 0%,
                rgba(10, 28, 42, 0.55) 65%,
                rgba(10, 28, 42, 0.92) 100%
            );
        }

        .panel-imagen-texto {
            position: relative;
            z-index: 2;
            padding: 48px;
            color: #fff;
        }

        .panel-imagen-texto .marca {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
            font-size: 1.05rem;
            margin-bottom: 18px;
            letter-spacing: 0.2px;
        }

        .panel-imagen-texto .marca i {
            color: var(--teal-accent);
            font-size: 1.3rem;
        }

        .panel-imagen-texto h1 {
            font-size: clamp(1.6rem, 3vw, 2.4rem);
            font-weight: 700;
            line-height: 1.25;
            max-width: 480px;
            margin: 0 0 10px;
        }

        .panel-imagen-texto p {
            max-width: 420px;
            color: rgba(255, 255, 255, 0.75);
            font-size: 0.95rem;
            margin: 0;
        }

        .btn-back-absolute {
            position: absolute;
            top: 24px;
            left: 24px;
            color: rgba(255, 255, 255, 0.85);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            z-index: 3;
            transition: color 0.2s;
        }

        .btn-back-absolute:hover { color: #fff; }

        /* ---------- Panel derecho: formulario ---------- */
        .panel-formulario {
            flex: 1;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 32px;
            background: var(--navy-deep);
        }

        .login-wrapper-react {
            --form-width: 320px;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-box-react {
            background: var(--login-box-color);
            border-radius: 24px;
            padding: 32px 28px;
            width: var(--form-width);
            position: relative;
            z-index: 10;
            box-shadow:
                0 4px 8px rgba(0, 0, 0, 0.25),
                0 8px 24px rgba(0, 0, 0, 0.25),
                inset 0 40px 60px -8px rgba(255, 255, 255, 0.10),
                inset 4px 0 12px -6px rgba(255, 255, 255, 0.10),
                inset 0 0 12px -4px rgba(255, 255, 255, 0.10);
        }

        .form-react-style {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            gap: 12px;
        }

        .logo-react-box {
            width: 62px;
            height: 62px;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), rgba(0, 0, 0, 0.2));
            box-shadow:
                8px 8px 16px rgba(0, 0, 0, 0.2),
                -8px -8px 16px rgba(255, 255, 255, 0.06);
            border-radius: 18px;
            border: 2px solid #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            margin-bottom: 4px;
        }

        .logo-react-box::before {
            content: "";
            position: absolute;
            bottom: 10px;
            width: 50%;
            height: 20%;
            border-top-left-radius: 40px;
            border-top-right-radius: 40px;
            border-bottom-right-radius: 20px;
            border-bottom-left-radius: 20px;
            border: 2.5px solid #fff;
        }

        .logo-react-box::after {
            content: "";
            position: absolute;
            top: 10px;
            width: 30%;
            height: 30%;
            border-radius: 50%;
            border: 2.5px solid #fff;
        }

        .header-react-text {
            width: 100%;
            text-align: center;
            font-size: 22px;
            font-weight: 700;
            color: white;
        }

        .subheader-react-text {
            width: 100%;
            text-align: center;
            font-size: 13px;
            color: rgba(255, 255, 255, 0.55);
            margin-top: -8px;
            margin-bottom: 4px;
        }

        .input-react-style {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid transparent;
            border-radius: 12px;
            background: var(--input-color);
            color: white;
            outline: none;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.2s;
        }

        .input-react-style::placeholder { color: rgba(255, 255, 255, 0.45); }
        .input-react-style:focus { border-color: var(--teal-accent); }

        .password-container-flex { position: relative; width: 100%; }
        .password-container-flex .input-react-style { padding-right: 40px; }

        .toggle-password-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: transparent;
            border: none;
            color: rgba(255, 255, 255, 0.55);
            cursor: pointer;
            font-size: 1rem;
            padding: 0;
        }

        .toggle-password-btn:hover { color: #fff; }

        .button-react-style {
            width: 100%;
            height: 42px;
            border: none;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            background: var(--button-color);
            color: white;
            transition: 0.25s;
            box-shadow:
                inset 0px 3px 6px -4px rgba(255, 255, 255, 0.6),
                inset 0px -3px 6px -2px rgba(0, 0, 0, 0.8);
            margin-top: 6px;
        }

        .button-react-style:hover {
            background: #2f4674;
            box-shadow:
                inset 0px 3px 6px rgba(255, 255, 255, 0.6),
                inset 0px -3px 6px rgba(0, 0, 0, 0.8),
                0px 0px 10px rgba(79, 209, 197, 0.25);
        }

        .footer-react-text {
            width: 100%;
            text-align: center;
            color: var(--footer-color);
            font-size: 12px;
            margin-top: 4px;
        }

        .footer-react-text .link-react {
            position: relative;
            color: var(--footer-color);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-react-text .link-react:hover { color: #fff; text-decoration: underline; }

        .alert-error-react {
            background: rgba(196, 69, 59, 0.3);
            border: 1px solid #C4453B;
            color: #ff8e86;
            font-size: 0.75rem;
            border-radius: 8px;
            padding: 6px 10px;
            width: 100%;
            text-align: center;
        }

        /* ---------- Responsive ---------- */
        @media (max-width: 900px) {
            body.login-page-custom { flex-direction: column; }
            .panel-imagen { flex: none; height: 34vh; min-height: 220px; }
            .panel-imagen-texto { padding: 24px; }
            .panel-imagen-texto h1 { font-size: 1.3rem; }
            .panel-imagen-texto p { display: none; }
            .panel-formulario { flex: none; padding: 24px 16px 40px; }
            .btn-back-absolute { top: 14px; left: 14px; }
        }
    </style>
</head>
<body class="login-page-custom">

    <div class="panel-imagen">
        <a href="${ctx}/" class="btn-back-absolute">
            <i class="bi bi-arrow-left-circle-fill" style="color:#4fd1c5;"></i> Volver al Inicio
        </a>
        <img src="${ctx}/Vista/Imagenes/sonrisa.jpg" alt="Sonrisa saludable">
        <div class="panel-imagen-texto">
            <div class="marca">
                <i class="bi bi-emoji-smile"></i>
                <span>VitalDentist</span>
            </div>
            <h1>Cada cita es un paso más hacia una sonrisa sana.</h1>
            <p>Accede al panel del personal para gestionar pacientes, agendas y tratamientos.</p>
        </div>
    </div>

    <div class="panel-formulario">
        <div class="login-wrapper-react">
            <div class="login-box-react">
                <form id="loginForm" action="${ctx}/Inicio_sesion" method="POST" class="form-react-style" novalidate>
                    <div class="logo-react-box"></div>

                    <span class="header-react-text">Bienvenido de nuevo</span>
                    <span class="subheader-react-text">Ingresa con tus credenciales de personal</span>

                    <c:if test="${not empty error}">
                        <div class="alert-error-react">
                            <span>${error}</span>
                        </div>
                    </c:if>

                    <input type="text"
                           id="documento"
                           name="documento"
                           placeholder="Número de documento"
                           class="input-react-style"
                           required
                           pattern="[0-9]+"
                           inputmode="numeric"
                           autocomplete="off">

                    <div class="password-container-flex">
                        <input type="password"
                               id="contrasena"
                               name="contrasena"
                               placeholder="Contraseña"
                               class="input-react-style"
                               required
                               autocomplete="current-password">
                        <button type="button" class="toggle-password-btn" onclick="togglePassword()" title="Mostrar/Ocultar contraseña">
                            <i class="bi bi-eye-slash" id="iconoOjo"></i>
                        </button>
                    </div>

                    <button type="submit" class="button-react-style">Iniciar sesión</button>

                    <p class="footer-react-text">
                        <a href="${ctx}/Vista/Recuperar_contrasena.jsp" class="link-react">¿Olvidaste tu contraseña?</a>
                    </p>

                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function togglePassword() {
            const inputPass = document.getElementById('contrasena');
            const icono = document.getElementById('iconoOjo');

            if (inputPass.type === 'password') {
                inputPass.type = 'text';
                icono.classList.remove('bi-eye-slash');
                icono.classList.add('bi-eye');
            } else {
                inputPass.type = 'password';
                icono.classList.remove('bi-eye');
                icono.classList.add('bi-eye-slash');
            }
        }
    </script>
</body>
</html>
