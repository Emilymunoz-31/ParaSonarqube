package Servlet;

import Controlador.Tipo_documentoDAO;
import Modelo.Tipo_documento;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroTipoDocumentoServlet", urlPatterns = {"/RegistroTipoDocumentoServlet"})
public class RegistroTipoDocumentoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Tipo_documentoDAO dao = new Tipo_documentoDAO();
        String accion = limpiar(request.getParameter("accion"));
        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                ok = dao.eliminarTipo_documento(Integer.parseInt(limpiar(request.getParameter("id"))));
            } catch (Exception e) {
                ok = false;
            }
            response.sendRedirect(request.getContextPath() + "/RegistroTipoDocumentoServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }
        if ("editar".equals(accion)) {
            try {
                request.setAttribute("tipoEditar", dao.consultaTipo_documento(Integer.parseInt(limpiar(request.getParameter("id")))));
            } catch (Exception e) {
                request.setAttribute("tipoEditar", null);
            }
        }
        request.setAttribute("tiposDocumento", dao.listarTiposDocumento());
        request.getRequestDispatcher("/Vista/Registrar_tipodocumento.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = limpiar(request.getParameter("accion"));
        String descripcion = limpiar(request.getParameter("descripcion"));
        if (descripcion.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/RegistroTipoDocumentoServlet?error=registro");
            return;
        }
        Tipo_documento tipo = new Tipo_documento();
        tipo.setdescripcion_tipodoc(descripcion);
        boolean guardado = false;
        try {
            Tipo_documentoDAO dao = new Tipo_documentoDAO();
            if ("actualizar".equals(accion)) {
                tipo.setid_Tipodocumento(Integer.parseInt(limpiar(request.getParameter("id"))));
                guardado = dao.actualizarTipo_documento(tipo);
            } else {
                guardado = dao.insertarTipo_documento(tipo);
            }
        } catch (Exception e) {
            guardado = false;
        }
        response.sendRedirect(request.getContextPath() + "/RegistroTipoDocumentoServlet" + (guardado ? "?mensaje=guardado" : "?error=registro"));
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
