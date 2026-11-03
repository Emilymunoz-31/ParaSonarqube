package Servlet;

import Controlador.UsuarioDAO;
import Modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ActualizarPerfilServlet", urlPatterns = {"/ActualizarPerfilServlet"})
public class ActualizarPerfilServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Usuario usuarioLogueado = session == null ? null : (Usuario) session.getAttribute("usuarioLogueado");

        if (usuarioLogueado == null) {
            response.sendRedirect(request.getContextPath() + "/Vista/Login.jsp");
            return;
        }

        String nombre = limpiar(request.getParameter("txtNombre"));
        String apellido = limpiar(request.getParameter("txtApellido"));
        String correo = limpiar(request.getParameter("txtCorreo"));
        String telefono = limpiar(request.getParameter("txtTelefono"));
        String documento = usuarioLogueado.getDocumento();

        Usuario usuarioActualizado = new Usuario();
        usuarioActualizado.setNombreus(nombre);
        usuarioActualizado.setApellido(apellido);
        usuarioActualizado.setCorreo(correo);
        usuarioActualizado.setTelefono(telefono);
        usuarioActualizado.setDocumento(documento);

        UsuarioDAO dao = new UsuarioDAO();
        boolean exito = dao.actualizarPerfil(usuarioActualizado);
        String panel = obtenerPanelPorRol(usuarioLogueado);

        if (exito) {
            usuarioLogueado.setNombreus(nombre);
            usuarioLogueado.setApellido(apellido);
            usuarioLogueado.setCorreo(correo);
            usuarioLogueado.setTelefono(telefono);
            session.setAttribute("usuarioLogueado", usuarioLogueado);
            response.sendRedirect(request.getContextPath() + panel);
        } else {
            response.sendRedirect(request.getContextPath() + panel + "?error=actualizacion_fallida");
        }
    }

    private String obtenerPanelPorRol(Usuario usuario) {
        String rol = usuario.getDescripcionRol() == null ? "" : usuario.getDescripcionRol().replace(".", "").trim();
        if (rol.equalsIgnoreCase("Odontologo")) {
            return "/OdontologoInicioServlet";
        }
        return "/AdminInicioServlet";
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}