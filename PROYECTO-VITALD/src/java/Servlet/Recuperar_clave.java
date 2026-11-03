package Servlet;

import Controlador.UsuarioDAO;
import Conexion.EmailUtil;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "Recuperar_clave", urlPatterns = {"/RecuperarClave", "/Recuperar_clave"})
public class Recuperar_clave extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(Recuperar_clave.class.getName());
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final String VISTA = "/Vista/RestablecerClave.jsp";
    private static final String MENSAJE = "mensaje";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(VISTA).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String correo = request.getParameter("correo");

        try {
            if (correo == null || correo.trim().isEmpty()) {
                request.setAttribute(MENSAJE, "Por favor, ingresa tu correo electrónico.");
                request.getRequestDispatcher(VISTA).forward(request, response);
                return;
            }

            String correoLimpio = correo.trim();
            UsuarioDAO usuarioDao = new UsuarioDAO();

            boolean existe = usuarioDao.verificarCorreoExiste(correoLimpio);

            if (existe) {
                String codigoTemporal = "VD" + (100000 + RANDOM.nextInt(900000));

                usuarioDao.actualizarContrasenaPorCorreo(correoLimpio, codigoTemporal);

                boolean enviado = EmailUtil.enviarCodigoRecuperacion(correoLimpio, codigoTemporal);

                if (enviado) {
                    request.setAttribute("correoPrecargado", correoLimpio);
                    request.setAttribute(MENSAJE, "Te hemos enviado un código de verificación a tu correo.");
                    request.getRequestDispatcher(VISTA).forward(request, response);
                    return;
                } else {
                    request.setAttribute(MENSAJE, "No se pudo enviar el correo. Intenta de nuevo.");
                }
            } else {
                request.setAttribute(MENSAJE, "Si el correo existe en nuestro sistema, recibirás el código de verificación.");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al procesar la solicitud de recuperación de clave", e);
            request.setAttribute(MENSAJE, "Ocurrió un error al procesar la solicitud. Intenta de nuevo más tarde.");
        }

        request.getRequestDispatcher(VISTA).forward(request, response);
    }
}