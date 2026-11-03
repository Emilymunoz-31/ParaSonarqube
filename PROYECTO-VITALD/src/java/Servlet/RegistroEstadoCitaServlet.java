package Servlet;

import Controlador.Estado_citaDAO;
import Modelo.Estado_cita;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroEstadoCitaServlet", urlPatterns = {"/RegistroEstadoCitaServlet"})
public class RegistroEstadoCitaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Estado_citaDAO dao = new Estado_citaDAO();
        String accion = limpiar(request.getParameter("accion"));
        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                ok = dao.eliminarEstado_cita(Integer.parseInt(limpiar(request.getParameter("id"))));
            } catch (Exception e) {
                ok = false;
            }
            response.sendRedirect(request.getContextPath() + "/RegistroEstadoCitaServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }
        if ("editar".equals(accion)) {
            try {
                request.setAttribute("estadoEditar", dao.consultaEstado_cita(Integer.parseInt(limpiar(request.getParameter("id")))));
            } catch (Exception e) {
                request.setAttribute("estadoEditar", null);
            }
        }
        request.setAttribute("estadosCita", dao.listarEstadosCita());
        request.getRequestDispatcher("/Vista/Registrar_estadocita.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = limpiar(request.getParameter("accion"));
        String descripcion = limpiar(request.getParameter("descripcion"));
        if (descripcion.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/RegistroEstadoCitaServlet?error=registro");
            return;
        }
        Estado_cita estado = new Estado_cita();
        estado.setdescripcion_estadoci(descripcion);
        boolean guardado = false;
        try {
            Estado_citaDAO dao = new Estado_citaDAO();
            if ("actualizar".equals(accion)) {
                estado.setidEstado_cita(Integer.parseInt(limpiar(request.getParameter("id"))));
                guardado = dao.actualizarEstado_cita(estado);
            } else {
                guardado = dao.insertarEstado_cita(estado);
            }
        } catch (Exception e) {
            guardado = false;
        }
        response.sendRedirect(request.getContextPath() + "/RegistroEstadoCitaServlet" + (guardado ? "?mensaje=guardado" : "?error=registro"));
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
