<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vital Dentist | Inicio</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/Vista/Imagenes/logo2.0.png">    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/Vista/Css/Landing.css">
</head>
<body class="landing-page d-flex flex-column min-vh-100 position-relative">

    <div class="logo-intro" aria-hidden="true">
        <img src="${ctx}/Vista/Imagenes/logo2.0.png" alt="Vital Dentist">
    </div>

    <div class="video-bg-container" aria-hidden="true">
        <video class="video-bg" autoplay muted loop playsinline>
            <source src="${ctx}/Vista/video/video_landing.mp4" type="video/mp4">
        </video>
    </div>
    <div class="video-overlay" aria-hidden="true"></div>
    <div class="tech-grid-overlay" aria-hidden="true"></div>
    <div class="glow-orb glow-orb--one" aria-hidden="true"></div>
    <div class="glow-orb glow-orb--two" aria-hidden="true"></div>

    <!-- ENCABEZADO -->
    <header class="header-color px-3 py-3 position-relative z-index-10">
        <div class="container-fluid d-flex align-items-center">
            <img src="${ctx}/Vista/Imagenes/logo2.0.png" alt="Logo" class="brand-logo me-3">
            <span class="brand-name m-0 fs-3 fw-bold">Vital Dentist</span>
        </div>
    </header>

    <main class="landing-main flex-grow-1 d-flex align-items-center position-relative z-index-10">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12 col-lg-9 text-center">
                    <p class="landing-kicker mb-3">Agenda odontológica inteligente</p>
                    <h1 class="landing-title mb-3">Vital <span>Dentist</span></h1>
                    <p class="landing-copy mb-4 mx-auto">
                        Gestiona citas odontológicas de forma rápida, segura y sencilla. Nuestra plataforma permite a especialistas administrar agendas, consultar horarios disponibles y mantener un mejor control de cada atención.
                    </p>
                    <div class="landing-actions mb-5">
                        <a href="${ctx}/Vista/Login.jsp" class="btn-gradient">
                            <i class="bi bi-box-arrow-in-right"></i> Iniciar Sesión
                        </a>
                        <a href="#caracteristicas" class="btn-outline-tech">
                            Conocer más
                        </a>
                    </div>
                </div>
            </div>

            <div id="caracteristicas" class="features-section row g-4 justify-content-center">
                <div class="col-12 col-md-4">
                    <div class="feature-card" style="animation-delay:1.45s">
                        <div class="feature-icon"><i class="bi bi-calendar2-check"></i></div>
                        <h3>Agenda en tiempo real</h3>
                        <p>Consulta y organiza horarios disponibles al instante, sin choques ni confusiones.</p>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="feature-card" style="animation-delay:1.55s">
                        <div class="feature-icon"><i class="bi bi-shield-lock"></i></div>
                        <h3>Datos seguros</h3>
                        <p>La información de pacientes y especialistas está protegida en todo momento.</p>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="feature-card" style="animation-delay:1.65s">
                        <div class="feature-icon"><i class="bi bi-graph-up-arrow"></i></div>
                        <h3>Control total</h3>
                        <p>Visualiza el historial de atenciones y el rendimiento de cada consultorio.</p>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer-color p-3 text-center position-relative z-index-10">
        <span class="text-light small fw-light">&copy; 2026 Vital Dentist. Panel de Agenda Odontológica.</span>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>