package Servlet;

import Controlador.RolDAO;
import Modelo.Rol;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroRolServlet", urlPatterns = {"/RegistroRolServlet"})
public class RegistroRolServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RolDAO dao = new RolDAO();
        String accion = limpiar(request.getParameter("accion"));
        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                ok = dao.eliminarRol(Integer.parseInt(limpiar(request.getParameter("id"))));
            } catch (Exception e) {
                ok = false;
            }
            response.sendRedirect(request.getContextPath() + "/RegistroRolServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }
        if ("editar".equals(accion)) {
            try {
                request.setAttribute("rolEditar", dao.consultaRol(Integer.parseInt(limpiar(request.getParameter("id")))));
            } catch (Exception e) {
                request.setAttribute("rolEditar", null);
            }
        }
        request.setAttribute("roles", dao.listarRoles());
        request.getRequestDispatcher("/Vista/Registrar_Rol.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = limpiar(request.getParameter("accion"));
        String descripcion = limpiar(request.getParameter("descripcion"));
        if (descripcion.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/RegistroRolServlet?error=registro");
            return;
        }
        Rol rol = new Rol();
        rol.setdescripcion_rol(descripcion);
        boolean guardado = false;
        try {
            RolDAO dao = new RolDAO();
            if ("actualizar".equals(accion)) {
                rol.setid_Rol(Integer.parseInt(limpiar(request.getParameter("id"))));
                guardado = dao.actualizarRol(rol);
            } else {
                guardado = dao.insertarRol(rol);
            }
        } catch (Exception e) {
            guardado = false;
        }
        response.sendRedirect(request.getContextPath() + "/RegistroRolServlet" + (guardado ? "?mensaje=guardado" : "?error=registro"));
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
