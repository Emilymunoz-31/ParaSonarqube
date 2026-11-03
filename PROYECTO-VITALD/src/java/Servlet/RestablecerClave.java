package Servlet;

import Controlador.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RestablecerClave", urlPatterns = {"/RestablecerClave"})
public class RestablecerClave extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Vista/RestablecerClave.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        String correo = request.getParameter("correo");

        UsuarioDAO dao = new UsuarioDAO();

        try {
            if ("validarCodigo".equals(accion)) {
                String codigo = request.getParameter("codigo");

                boolean valido = dao.validarCodigoTemporal(correo.trim(), codigo.trim());

                if (valido) {
                    request.setAttribute("correoPrecargado", correo.trim());
                    request.setAttribute("pasoDosCompleto", true); 
                    request.setAttribute("codigoValido", true);
                    request.setAttribute("mensaje", "Código verificado con éxito. Ingresa tu nueva contraseña.");
                } else {
                    request.setAttribute("correoPrecargado", correo.trim());
                    request.setAttribute("pasoDosCompleto", false);
                    request.setAttribute("mensaje", "El código ingresado es incorrecto.");
                }
                request.getRequestDispatcher("/Vista/RestablecerClave.jsp").forward(request, response);
                return;
            }

            if ("cambiarClave".equals(accion)) {
                String nuevaClave = request.getParameter("nuevaClave");

                boolean actualizada = dao.actualizarContrasenaPorCorreo(correo.trim(), nuevaClave.trim());

                if (actualizada) {
                    request.setAttribute("mensaje", "¡Contraseña actualizada correctamente! Inicia sesión.");
                    request.getRequestDispatcher("/Vista/Login.jsp").forward(request, response);
                } else {
                    request.setAttribute("correoPrecargado", correo.trim());
                    request.setAttribute("pasoDosCompleto", true);
                    request.setAttribute("mensaje", "No se pudo actualizar la contraseña. Intenta de nuevo.");
                    request.getRequestDispatcher("/Vista/RestablecerClave.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Ocurrió un error en el servidor: " + e.getMessage());
            request.getRequestDispatcher("/Vista/RestablecerClave.jsp").forward(request, response);
        }
    }
}