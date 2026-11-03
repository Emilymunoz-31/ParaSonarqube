package Servlet;

import Controlador.Medio_pagoDAO;
import Modelo.Medio_pago;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroMedioPagoServlet", urlPatterns = {"/RegistroMedioPagoServlet"})
public class RegistroMedioPagoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Medio_pagoDAO dao = new Medio_pagoDAO();
        String accion = limpiar(request.getParameter("accion"));
        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                ok = dao.eliminarMedio_pago(Integer.parseInt(limpiar(request.getParameter("id"))));
            } catch (Exception e) {
                ok = false;
            }
            response.sendRedirect(request.getContextPath() + "/RegistroMedioPagoServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }
        if ("editar".equals(accion)) {
            try {
                request.setAttribute("medioEditar", dao.consultaMedio_pago(Integer.parseInt(limpiar(request.getParameter("id")))));
            } catch (Exception e) {
                request.setAttribute("medioEditar", null);
            }
        }
        request.setAttribute("mediosPago", dao.listarMediosPago());
        request.getRequestDispatcher("/Vista/Registrar_mediopago.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = limpiar(request.getParameter("accion"));
        String descripcion = limpiar(request.getParameter("descripcion"));
        if (descripcion.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/RegistroMedioPagoServlet?error=registro");
            return;
        }
        Medio_pago medio = new Medio_pago();
        medio.setdescripcion_mediopa(descripcion);
        boolean guardado = false;
        try {
            Medio_pagoDAO dao = new Medio_pagoDAO();
            if ("actualizar".equals(accion)) {
                medio.setid_Mediopago(Integer.parseInt(limpiar(request.getParameter("id"))));
                guardado = dao.actualizarMedio_Pago(medio);
            } else {
                guardado = dao.insertarMedio_pago(medio);
            }
        } catch (Exception e) {
            guardado = false;
        }
        response.sendRedirect(request.getContextPath() + "/RegistroMedioPagoServlet" + (guardado ? "?mensaje=guardado" : "?error=registro"));
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
