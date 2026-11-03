package Servlet;

import Controlador.CitaDAO;
import Controlador.UsuarioDAO;
import Controlador.Categoria_TratamientoDAO;
import Controlador.Tipo_tratamientoDAO;
import Controlador.Estado_citaDAO;
import Controlador.Tipo_documentoDAO;
import Modelo.Cita;
import Modelo.Usuario;
import Modelo.Categoria_Tratamiento;
import Modelo.Tipo_tratamiento;
import Modelo.Estado_cita;
import Modelo.Tipo_documento;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MobileApiServlet", urlPatterns = {"/api/movil"})
public class MobileApiServlet extends HttpServlet {

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setAccessControlHeaders(response);
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private void setAccessControlHeaders(HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, X-Requested-With");
    }

    private String escaparJson(String valor) {
        if (valor == null) return "";
        return valor.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        setAccessControlHeaders(response);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String accion = request.getParameter("accion");

        try {
            if ("datos_formulario".equals(accion)) {
                out.print("{");

                // 1. Odontólogos
                out.print("\"odontologos\": [");
                List<Usuario> odontologos = new UsuarioDAO().listarOdontologos();
                for (int i = 0; i < odontologos.size(); i++) {
                    Usuario u = odontologos.get(i);
                    String nombreCompleto = u.getNombreus() + (u.getApellido() != null ? " " + u.getApellido() : "");
                    out.print("{\"id_Usuario\": \"" + u.getId_Usuario() + "\", \"nombre\": \"" + escaparJson(nombreCompleto) + "\"}");
                    if (i < odontologos.size() - 1) out.print(",");
                }
                out.print("],");

                // 2. Categorías
                out.print("\"categorias\": [");
                List<Categoria_Tratamiento> categorias = new Categoria_TratamientoDAO().listarCategorias();
                for (int i = 0; i < categorias.size(); i++) {
                    Categoria_Tratamiento c = categorias.get(i);
                    out.print("{\"id_Categoria\": \"" + c.getid_Categoria() + "\", \"nombre\": \"" + escaparJson(c.getnombre_categoria()) + "\"}");
                    if (i < categorias.size() - 1) out.print(",");
                }
                out.print("],");

                // 3. Tratamientos
                out.print("\"tratamientos\": [");
                List<Tipo_tratamiento> tratamientos = new Tipo_tratamientoDAO().listarTiposTratamiento();
                for (int i = 0; i < tratamientos.size(); i++) {
                    Tipo_tratamiento t = tratamientos.get(i);
                    out.print("{\"id_Tipotratam\": \"" + t.getid_Tipotratam() + "\", \"id_categoria\": \"" + t.getCategoria_Tratamiento_id_Categoria() + "\", \"nombre\": \"" + escaparJson(t.getdescripcion_tipotratam()) + "\"}");
                    if (i < tratamientos.size() - 1) out.print(",");
                }
                out.print("],");

                // 4. Estados
                out.print("\"estados\": [");
                List<Estado_cita> estados = new Estado_citaDAO().listarEstadosCita();
                for (int i = 0; i < estados.size(); i++) {
                    Estado_cita e = estados.get(i);
                    out.print("{\"idEstado_cita\": \"" + e.getidEstado_cita() + "\", \"nombre\": \"" + escaparJson(e.getdescripcion_estadoci()) + "\"}");
                    if (i < estados.size() - 1) out.print(",");
                }
                out.print("],");

                out.print("\"tiposDocumento\": [");
                List<Tipo_documento> tiposDoc = new Tipo_documentoDAO().listarTiposDocumento();
                for (int i = 0; i < tiposDoc.size(); i++) {
                    Tipo_documento t = tiposDoc.get(i);
                    out.print("{\"id_Tipodocumento\": \"" + t.getid_Tipodocumento() + "\", \"nombre\": \"" + escaparJson(t.getdescripcion_tipodoc()) + "\"}");
                    if (i < tiposDoc.size() - 1) out.print(",");
                }
                out.print("],");

                out.print("\"pacientes\": [");
                List<Usuario> pacientes = new UsuarioDAO().listarPacientes();
                for (int i = 0; i < pacientes.size(); i++) {
                    Usuario p = pacientes.get(i);
                    String nombreCompleto = p.getNombreus() + (p.getApellido() != null ? " " + p.getApellido() : "");
                    out.print("{\"id_Usuario\": \"" + p.getId_Usuario() + "\", \"nombre\": \"" + escaparJson(nombreCompleto) + "\", "
                            + "\"documento\": \"" + escaparJson(p.getDocumento()) + "\", "
                            + "\"telefono\": \"" + escaparJson(p.getTelefono()) + "\"}");
                    if (i < pacientes.size() - 1) out.print(",");
                }
                out.print("]");

                out.print("}");
            } else {
                // LISTADO DE CITAS PRINCIPAL
                CitaDAO dao = new CitaDAO();
                List<Cita> listaCitas = dao.listarCitas();

                out.print("[");
                for (int i = 0; i < listaCitas.size(); i++) {
                    Cita c = listaCitas.get(i);

                    String paciente = c.getNombrePaciente() != null ? c.getNombrePaciente().trim() : "Paciente";
                    String desc = c.getdescripcion_cita() != null ? c.getdescripcion_cita() : "Sin observaciones";

                    String tratamiento = c.getDescripcionTratamiento() != null ? c.getDescripcionTratamiento() : "Procedimiento Odontológico";

                    String telefonoRaw = c.getTelefonoPaciente() != null ? c.getTelefonoPaciente() : "";
                    String telefono = telefonoRaw.replaceAll("[^0-9]", "");

                    out.print("{");
                    out.print("\"id\": \"" + c.getid_Cita() + "\",");
                    out.print("\"fecha\": \"" + escaparJson(c.getfecha_hora()) + "\",");
                    out.print("\"descripcion\": \"" + escaparJson(desc) + "\",");
                    out.print("\"tratamiento\": \"" + escaparJson(tratamiento) + "\",");
                    out.print("\"paciente\": \"" + escaparJson(paciente) + "\",");
                    out.print("\"telefono\": \"" + telefono + "\"");
                    out.print("}");

                    if (i < listaCitas.size() - 1) {
                        out.print(",");
                    }
                }
                out.print("]");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Error al consultar los datos: " + escaparJson(e.getMessage()) + "\"}");
        } finally {
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        setAccessControlHeaders(response);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String documento = request.getParameter("documento");
            String contrasena = request.getParameter("contrasena");

            if (documento == null || contrasena == null) {
                out.print("{\"status\": \"ERROR\", \"mensaje\": \"Faltan datos\"}");
                return;
            }

            UsuarioDAO dao = new UsuarioDAO();
            Usuario usuario = dao.validar(documento, contrasena);

            if (usuario != null && usuario.getDocumento() != null) {
                out.print("{\"status\": \"LOGIN_EXITOSO\", \"nombre\": \"" + escaparJson(usuario.getNombreus()) + "\"}");
            } else {
                out.print("{\"status\": \"ERROR\", \"mensaje\": \"Credenciales incorrectas\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\": \"ERROR\", \"mensaje\": \"Error en el servidor\"}");
        } finally {
            out.flush();
        }
    }
}