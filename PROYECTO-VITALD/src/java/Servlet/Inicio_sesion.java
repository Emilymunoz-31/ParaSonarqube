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

@WebServlet(name = "Servlet.Inicio_sesion", urlPatterns = {"/Inicio_sesion"})
public class Inicio_sesion extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("cerrar".equals(accion)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/Inicio_sesion");
            return;
        }

        request.getRequestDispatcher("/Vista/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String documento = request.getParameter("documento");
        String contrasena = request.getParameter("contrasena");

        System.out.println("LOGIN INTENTO -> Documento: [" + documento + "]");

        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = dao.validar(documento, contrasena);

        if (usuario != null && usuario.getDocumento() != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", usuario);

            String rol = usuario.getDescripcionRol() == null ? "" : usuario.getDescripcionRol().replace(".", "").trim();

            System.out.println("LOGIN EXITOSO -> Usuario: " + usuario.getNombreus() + " | Rol detectado: [" + rol + "]");

            if (rol.equalsIgnoreCase("Administrador")) {
                response.sendRedirect(request.getContextPath() + "/AdminInicioServlet");
            } else if (rol.equalsIgnoreCase("Odontologo")) {
                response.sendRedirect(request.getContextPath() + "/OdontologoInicioServlet");
            } else {
                response.sendRedirect(request.getContextPath() + "/Vista/inicio.jsp");
            }
        } else {
            System.out.println("LOGIN FALLIDO -> Credenciales incorrectas para documento: [" + documento + "]");
            request.setAttribute("error", "Credenciales incorrectas. El documento o la contraseña no coinciden.");
            request.getRequestDispatcher("/Vista/Login.jsp").forward(request, response);
        }
    }
}
