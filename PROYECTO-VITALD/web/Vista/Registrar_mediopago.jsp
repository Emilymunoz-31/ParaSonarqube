<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medios de pago</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/Vista/Imagenes/logo2.0.png">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    
    <link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css">
</head>
<body class="registration-page admin-module-page">
<main class="container py-5">
    <div class="admin-back-row"><a class="btn btn-outline-primary" href="${ctx}/AdminInicioServlet">Volver al Inicio</a></div>
    <div class="admin-module-header"><div><p class="admin-eyebrow">Modulo administrativo</p><h1 class="h3 text-primary fw-bold mb-0">Gestionar medios de pago</h1></div></div>
    <c:if test="${param.mensaje == 'guardado'}"><div class="alert transaction-alert">Registro guardado correctamente.</div></c:if><c:if test="${param.mensaje == 'eliminado'}"><div class="alert transaction-alert">Registro eliminado correctamente.</div></c:if><c:if test="${not empty param.error}"><div class="alert alert-danger">No fue posible completar la operacion.</div></c:if>
    <div class="row g-4"><div class="col-lg-4"><form action="${ctx}/RegistroMedioPagoServlet" method="POST" class="needs-validation admin-card p-4" novalidate><input type="hidden" name="accion" value="${empty medioEditar ? 'insertar' : 'actualizar'}"><input type="hidden" name="id" value="${medioEditar.id_Mediopago}"><div class="row g-3"><div class="col-12"><label class="form-label fw-semibold">Descripcion</label><input type="text" name="descripcion" class="form-control" value="${medioEditar.descripcion_mediopa}" required><div class="invalid-feedback">Ingrese la descripcion.</div></div><div class="col-12 d-flex gap-2"><button class="btn btn-primary" type="submit">${empty medioEditar ? 'Guardar' : 'Actualizar'}</button><c:if test="${not empty medioEditar}"><a class="btn btn-outline-secondary" href="${ctx}/RegistroMedioPagoServlet">Cancelar</a></c:if></div></div></form></div>
        <div class="col-lg-8"><section class="card admin-card"><div class="card-header admin-card-header"><h2 class="h5 mb-0">Registros existentes</h2></div><div class="card-body p-0"><div class="table-responsive"><table class="table table-hover align-middle mb-0"><thead><tr><th>Descripcion</th><th class="text-end">Acciones</th></tr></thead><tbody><c:forEach var="medio" items="${mediosPago}"><tr><td>${medio.descripcion_mediopa}</td><td class="text-end"><a class="btn btn-sm btn-outline-primary" href="${ctx}/RegistroMedioPagoServlet?accion=editar&id=${medio.id_Mediopago}">Editar</a> <a class="btn btn-sm btn-outline-danger" href="${ctx}/RegistroMedioPagoServlet?accion=eliminar&id=${medio.id_Mediopago}" onclick="return confirm('Desea eliminar este registro?')">Eliminar</a></td></tr></c:forEach><c:if test="${empty mediosPago}"><tr><td colspan="3" class="text-center text-muted py-4">No hay registros.</td></tr></c:if></tbody></table></div></div></section></div></div>
</main>
<script src="${ctx}/Vista/Javascript/validaciones.js"></script>
</body>
</html>