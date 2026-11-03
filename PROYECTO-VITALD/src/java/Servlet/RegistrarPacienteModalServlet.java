package Servlet;

import Controlador.UsuarioDAO;
import Modelo.Usuario;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistrarPacienteModalServlet", urlPatterns = {"/RegistrarPacienteModalServlet"})
public class RegistrarPacienteModalServlet extends HttpServlet {

    private static final Pattern SOLO_LETRAS = Pattern.compile("^[\\p{L} .'-]{2,60}$");
    private static final Pattern DOCUMENTO = Pattern.compile("^[0-9]{5,15}$");
    private static final Pattern TELEFONO = Pattern.compile("^[0-9]{7,15}$");
    private static final Pattern CORREO = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String nombres = limpiar(request.getParameter("txtNombresModal"));
            String apellidos = limpiar(request.getParameter("txtApellidosModal"));
            String tipoDocStr = limpiar(request.getParameter("txtTipoDocModal"));
            String documento = limpiar(request.getParameter("txtDocumentoModal"));
            String telefono = limpiar(request.getParameter("txtTelefonoModal"));
            String correo = limpiar(request.getParameter("txtCorreoModal"));
            String fechaNac = limpiar(request.getParameter("txtFechaNacModal"));

            if (!SOLO_LETRAS.matcher(nombres).matches()
                    || !SOLO_LETRAS.matcher(apellidos).matches()
                    || !DOCUMENTO.matcher(documento).matches()
                    || !TELEFONO.matcher(telefono).matches()
                    || !CORREO.matcher(correo).matches()
                    || tipoDocStr.isEmpty()
                    || fechaNac.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet?paciente_error=datos_invalidos");
                return;
            }

            LocalDate fecha = LocalDate.parse(fechaNac);
            if (fecha.isAfter(LocalDate.now())) {
                response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet?paciente_error=datos_invalidos");
                return;
            }

            UsuarioDAO dao = new UsuarioDAO();
            if (dao.existeDocumento(documento) || dao.existeCorreo(correo)) {
                response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet?paciente_error=registro");
                return;
            }

            Usuario paciente = new Usuario();
            paciente.setNombreus(nombres);
            paciente.setApellido(apellidos);
            paciente.setDocumento(documento);
            paciente.setTelefono(telefono);
            paciente.setCorreo(correo);
            paciente.setfecha_nacimiento(Date.valueOf(fecha));
            paciente.setTipo_documento_id_Tipodocumento(Integer.parseInt(tipoDocStr));
            paciente.setRol_id_Rol(3);
            paciente.setContrasena("PACIENTE_SIN_ACCESO_" + documento);
            paciente.settratamiento_datos(true);
            paciente.setActivo(true);

            boolean registrado = dao.insertarUsuario(paciente);
            response.sendRedirect(request.getContextPath() + (registrado
                    ? "/AgendarCitaServlet?paciente_registrado=1"
                    : "/AgendarCitaServlet?paciente_error=registro"));
        } catch (NumberFormatException | DateTimeParseException e) {
            response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet?paciente_error=datos_invalidos");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet?paciente_error=registro");
        }
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}