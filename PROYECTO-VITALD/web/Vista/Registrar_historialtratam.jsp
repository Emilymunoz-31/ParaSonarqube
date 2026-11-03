<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<!-- CAMBIO APLICADO: Agregada la librería de formato de Java -->
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de tratamiento</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/Vista/Imagenes/logo2.0.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"><link rel="stylesheet" href="${ctx}/Vista/Css/Cssvital.css"></head>
<body class="registration-page admin-module-page">
<main class="container py-5">
    <div class="admin-back-row"><a class="btn btn-outline-primary" href="${ctx}/AdminInicioServlet">Volver al Inicio</a></div>
    <div class="admin-module-header"><div><p class="admin-eyebrow">Modulo administrativo</p><h1 class="h3 text-primary fw-bold mb-0">Gestionar historial de tratamientos</h1></div></div>
    <c:if test="${param.mensaje == 'guardado'}"><div class="alert transaction-alert">Registro guardado correctamente.</div></c:if><c:if test="${param.mensaje == 'eliminado'}"><div class="alert transaction-alert">Registro eliminado correctamente.</div></c:if><c:if test="${not empty param.error}"><div class="alert alert-danger">No fue posible completar la operacion.</div></c:if>
    <div class="row g-4"><div class="col-lg-4"><form action="${ctx}/RegistroHistorialTratamientoServlet" method="POST" class="needs-validation admin-card p-4" novalidate><input type="hidden" name="accion" value="${empty historialEditar ? 'insertar' : 'actualizar'}"><input type="hidden" name="id" value="${historialEditar.id_Historial}"><div class="row g-3"><div class="col-12"><label class="form-label fw-semibold">Anio</label><input type="number" name="anio" class="form-control" min="1900" max="2099" value="${historialEditar.anio}" required></div><div class="col-12"><label class="form-label fw-semibold">Costo</label>
    
    <input type="text" name="costo" class="form-control" oninput="formatearNumero(this)" value="<fmt:formatNumber value='${historialEditar.costo}' pattern='###,###' />" required>
    
    </div><div class="col-12"><label class="form-label fw-semibold">Tratamiento</label><select name="tratamiento" class="form-select" required><option value="">Seleccione...</option><c:forEach var="tratamiento" items="${tratamientos}"><option value="${tratamiento.id_Tipotratam}" ${historialEditar.tipo_tratamiento_id_Tipotratam == tratamiento.id_Tipotratam ? 'selected' : ''}>${tratamiento.descripcion_tipotratam}</option></c:forEach></select></div><div class="col-12 d-flex gap-2"><button class="btn btn-primary" type="submit">${empty historialEditar ? 'Guardar' : 'Actualizar'}</button><c:if test="${not empty historialEditar}"><a class="btn btn-outline-secondary" href="${ctx}/RegistroHistorialTratamientoServlet">Cancelar</a></c:if></div></div></form></div>
        <div class="col-lg-8"><section class="card admin-card"><div class="card-header admin-card-header"><h2 class="h5 mb-0">Registros existentes</h2></div><div class="card-body p-0"><div class="table-responsive"><table class="table table-hover align-middle mb-0"><thead><tr><th>Anio</th><th>Costo</th><th>Tratamiento</th><th class="text-end">Acciones</th></tr></thead><tbody><c:forEach var="historial" items="${historiales}"><tr><td>${historial.anio}</td>
        
        <td>$ <fmt:formatNumber value="${historial.costo}" pattern="#,##0" /></td>
        
        <td>Tratamiento registrado</td><td class="text-end"><a class="btn btn-sm btn-outline-primary" href="${ctx}/RegistroHistorialTratamientoServlet?accion=editar&id=${historial.id_Historial}">Editar</a> <a class="btn btn-sm btn-outline-danger" href="${ctx}/RegistroHistorialTratamientoServlet?accion=eliminar&id=${historial.id_Historial}" onclick="return confirm('Desea eliminar este registro?')">Eliminar</a></td></tr></c:forEach><c:if test="${empty historiales}"><tr><td colspan="5" class="text-center text-muted py-4">No hay registros.</td></tr></c:if></tbody></table></div></div></section></div></div>
</main>
<script src="${ctx}/Vista/Javascript/validaciones.js"></script>
<script>
    function formatearNumero(input) {
        let valor = input.value.replace(/\D/g, "");
        valor = valor.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
        input.value = valor;
    }
</script>
</body>
</html>