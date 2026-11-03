package Servlet;

import Controlador.Categoria_TratamientoDAO;
import Controlador.Tipo_tratamientoDAO;
import Modelo.Tipo_tratamiento;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroTipoTratamientoServlet", urlPatterns = {"/RegistroTipoTratamientoServlet"})
public class RegistroTipoTratamientoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Tipo_tratamientoDAO dao = new Tipo_tratamientoDAO();
        String accion = limpiar(request.getParameter("accion"));
        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                ok = dao.eliminarTipo_tratamiento(Integer.parseInt(limpiar(request.getParameter("id"))));
            } catch (Exception e) {
                ok = false;
            }
            response.sendRedirect(request.getContextPath() + "/RegistroTipoTratamientoServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }
        if ("editar".equals(accion)) {
            try {
                request.setAttribute("tratamientoEditar", dao.consultaTipo_tratamiento(Integer.parseInt(limpiar(request.getParameter("id")))));
            } catch (Exception e) {
                request.setAttribute("tratamientoEditar", null);
            }
        }
        request.setAttribute("tratamientos", dao.listarTiposTratamiento());
        request.setAttribute("categorias", new Categoria_TratamientoDAO().listarCategorias());
        request.getRequestDispatcher("/Vista/Registrar_tipotratam.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = limpiar(request.getParameter("accion"));
        boolean guardado = false;
        try {
            String descripcion = limpiar(request.getParameter("descripcion"));
            
            String costoStr = limpiar(request.getParameter("costo"));
            if (!costoStr.isEmpty()) {
                costoStr = costoStr.replace(".", ""); 
            }
            double costo = Double.parseDouble(costoStr);
            
            int categoria = Integer.parseInt(limpiar(request.getParameter("categoria")));

            if (!descripcion.isEmpty() && costo > 0 && categoria > 0) {
                Tipo_tratamiento tratamiento = new Tipo_tratamiento();
                tratamiento.setdescripcion_tipotratam(descripcion);
                tratamiento.setcosto(costo);
                tratamiento.setCategoria_Tratamiento_id_Categoria(categoria);
                Tipo_tratamientoDAO dao = new Tipo_tratamientoDAO();
                
                if ("actualizar".equals(accion)) {
                    tratamiento.setid_Tipotratam(Integer.parseInt(limpiar(request.getParameter("id"))));
                    guardado = dao.actualizarTipo_tratamiento(tratamiento);
                } else {
                    guardado = dao.insertarTipo_tratamiento(tratamiento);
                }
            }
        } catch (Exception e) {
            guardado = false;
            System.err.println("Error Tipo Tratamiento Servlet: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/RegistroTipoTratamientoServlet" + (guardado ? "?mensaje=guardado" : "?error=registro"));
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
