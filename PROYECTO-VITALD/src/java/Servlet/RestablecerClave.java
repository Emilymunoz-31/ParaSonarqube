package Servlet;

import Controlador.UsuarioDAO;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "RestablecerClave", urlPatterns = {"/RestablecerClave"})
public class RestablecerClave extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RestablecerClave.class.getName());
    private static final String VISTA = "/Vista/RestablecerClave.jsp";
    private static final String MENSAJE = "mensaje";
    private static final String CORREO_PRECARGADO = "correoPrecargado";
    private static final String PASO_DOS = "pasoDosCompleto";
    private static final String CORREO_VERIFICADO = "correoVerificado";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(VISTA).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        String correo = request.getParameter("correo");

        if (correo == null || correo.trim().isEmpty()) {
            request.setAttribute(MENSAJE, "Por favor, ingresa tu correo electrónico.");
            request.getRequestDispatcher(VISTA).forward(request, response);
            return;
        }

        String correoLimpio = correo.trim();
        UsuarioDAO dao = new UsuarioDAO();

        try {
            if ("validarCodigo".equals(accion)) {
                String codigo = request.getParameter("codigo");
                boolean valido = codigo != null && dao.validarCodigoTemporal(correoLimpio, codigo.trim());

                request.setAttribute(CORREO_PRECARGADO, correoLimpio);
                if (valido) {
                    // Guardamos en sesión que este correo ya pasó la verificación
                    request.getSession().setAttribute(CORREO_VERIFICADO, correoLimpio);
                    request.setAttribute(PASO_DOS, true);
                    request.setAttribute("codigoValido", true);
                    request.setAttribute(MENSAJE, "Código verificado con éxito. Ingresa tu nueva contraseña.");
                } else {
                    request.getSession().removeAttribute(CORREO_VERIFICADO);
                    request.setAttribute(PASO_DOS, false);
                    request.setAttribute(MENSAJE, "El código ingresado es incorrecto.");
                }
                request.getRequestDispatcher(VISTA).forward(request, response);
                return;
            }

            if ("cambiarClave".equals(accion)) {
                // Exigir que el código haya sido validado antes
                HttpSession session = request.getSession(false);
                String verificado = session != null ? (String) session.getAttribute(CORREO_VERIFICADO) : null;

                if (verificado == null || !verificado.equals(correoLimpio)) {
                    request.setAttribute(MENSAJE, "Debes verificar el código primero.");
                    request.getRequestDispatcher(VISTA).forward(request, response);
                    return;
                }

                String nuevaClave = request.getParameter("nuevaClave");

                boolean actualizada = nuevaClave != null
                        && dao.actualizarContrasenaPorCorreo(correoLimpio, nuevaClave.trim());

                if (actualizada) {
                    // El permiso es de un solo uso
                    session.removeAttribute(CORREO_VERIFICADO);
                    request.setAttribute(MENSAJE, "¡Contraseña actualizada correctamente! Inicia sesión.");
                    request.getRequestDispatcher("/Vista/Login.jsp").forward(request, response);
                } else {
                    request.setAttribute(CORREO_PRECARGADO, correoLimpio);
                    request.setAttribute(PASO_DOS, true);
                    request.setAttribute(MENSAJE, "No se pudo actualizar la contraseña. Intenta de nuevo.");
                    request.getRequestDispatcher(VISTA).forward(request, response);
                }
                return;
            }

            request.getRequestDispatcher(VISTA).forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al restablecer la clave", e);
            request.setAttribute(MENSAJE, "Ocurrió un error en el servidor. Intenta de nuevo más tarde.");
            request.getRequestDispatcher(VISTA).forward(request, response);
        }
    }
}