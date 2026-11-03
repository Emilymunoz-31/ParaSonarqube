package Servlet;

import Controlador.Estado_pagoDAO;
import Modelo.Estado_pago;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroEstadoPagoServlet", urlPatterns = {"/RegistroEstadoPagoServlet"})
public class RegistroEstadoPagoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Estado_pagoDAO dao = new Estado_pagoDAO();
        String accion = limpiar(request.getParameter("accion"));
        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                ok = dao.eliminarEstado_pago(Integer.parseInt(limpiar(request.getParameter("id"))));
            } catch (Exception e) {
                ok = false;
            }
            response.sendRedirect(request.getContextPath() + "/RegistroEstadoPagoServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }
        if ("editar".equals(accion)) {
            try {
                request.setAttribute("estadoEditar", dao.consultaEstado_pago(Integer.parseInt(limpiar(request.getParameter("id")))));
            } catch (Exception e) {
                request.setAttribute("estadoEditar", null);
            }
        }
        request.setAttribute("estadosPago", dao.listarEstadosPago());
        request.getRequestDispatcher("/Vista/Registrar_estadopago.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = limpiar(request.getParameter("accion"));
        String descripcion = limpiar(request.getParameter("descripcion"));
        if (descripcion.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/RegistroEstadoPagoServlet?error=registro");
            return;
        }
        Estado_pago estado = new Estado_pago();
        estado.setdescripcion_estadop(descripcion);
        boolean guardado = false;
        try {
            Estado_pagoDAO dao = new Estado_pagoDAO();
            if ("actualizar".equals(accion)) {
                estado.setid_Estadopago(Integer.parseInt(limpiar(request.getParameter("id"))));
                guardado = dao.actualizarEstado_Pago(estado);
            } else {
                guardado = dao.insertarEstado_pago(estado);
            }
        } catch (Exception e) {
            guardado = false;
        }
        response.sendRedirect(request.getContextPath() + "/RegistroEstadoPagoServlet" + (guardado ? "?mensaje=guardado" : "?error=registro"));
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
