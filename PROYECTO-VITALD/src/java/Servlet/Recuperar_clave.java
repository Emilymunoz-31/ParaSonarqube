package Servlet;

import Controlador.UsuarioDAO;
import Conexion.EmailUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "Recuperar_clave", urlPatterns = {"/RecuperarClave", "/Recuperar_clave"})
public class Recuperar_clave extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Vista/RestablecerClave.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String correo = request.getParameter("correo");

        try {
            if (correo == null || correo.trim().isEmpty()) {
                request.setAttribute("mensaje", "Por favor, ingresa tu correo electrónico.");
                request.getRequestDispatcher("/Vista/RestablecerClave.jsp").forward(request, response);
                return;
            }

            String correoLimpio = correo.trim();
            UsuarioDAO usuarioDao = new UsuarioDAO();

            boolean existe = usuarioDao.verificarCorreoExiste(correoLimpio);

            if (existe) {
                String codigoTemporal = "VD" + (int) (Math.random() * 90 + 10);

                usuarioDao.actualizarContrasenaPorCorreo(correoLimpio, codigoTemporal);

                boolean enviado = EmailUtil.enviarCodigoRecuperacion(correoLimpio, codigoTemporal);

                if (enviado) {
                    request.setAttribute("correoPrecargado", correoLimpio);
                    request.setAttribute("mensaje", "Te hemos enviado un código de verificación a tu correo.");
                    
                    request.getRequestDispatcher("/Vista/RestablecerClave.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("mensaje", "No se pudo enviar el correo. Intenta de nuevo.");
                }
            } else {
                request.setAttribute("mensaje", "Si el correo existe en nuestro sistema, recibirás el código de verificación.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Ocurrió un error al procesar la solicitud: " + e.getMessage());
        }

        request.getRequestDispatcher("/Vista/RestablecerClave.jsp").forward(request, response);
    }
}