package Servlet;

import Controlador.Historial_tratamientoDAO;
import Controlador.Tipo_tratamientoDAO;
import Modelo.Historial_tratamiento;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroHistorialTratamientoServlet", urlPatterns = {"/RegistroHistorialTratamientoServlet"})
public class RegistroHistorialTratamientoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Historial_tratamientoDAO dao = new Historial_tratamientoDAO();
        String accion = limpiar(request.getParameter("accion"));
        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                ok = dao.eliminarHistorial_tratamiento(Integer.parseInt(limpiar(request.getParameter("id"))));
            } catch (Exception e) {
                ok = false;
            }
            response.sendRedirect(request.getContextPath() + "/RegistroHistorialTratamientoServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }
        if ("editar".equals(accion)) {
            try {
                request.setAttribute("historialEditar", dao.consultaHistorial_tratamiento(Integer.parseInt(limpiar(request.getParameter("id")))));
            } catch (Exception e) {
                request.setAttribute("historialEditar", null);
            }
        }
        request.setAttribute("historiales", dao.listarHistorialesTratamiento());
        request.setAttribute("tratamientos", new Tipo_tratamientoDAO().listarTiposTratamiento());
        request.getRequestDispatcher("/Vista/Registrar_historialtratam.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = limpiar(request.getParameter("accion"));
        boolean guardado = false;
        try {
            String anio = limpiar(request.getParameter("anio"));
            
            String costoStr = limpiar(request.getParameter("costo"));
            if (!costoStr.isEmpty()) {
                costoStr = costoStr.replace(".", ""); 
            }
            
            int tratamientoId = Integer.parseInt(limpiar(request.getParameter("tratamiento")));

            if (anio.matches("^(19|20)[0-9]{2}$") && costoStr.matches("^[0-9]+(\\.[0-9]{1,2})?$") && tratamientoId > 0) {
                Historial_tratamiento historial = new Historial_tratamiento();
                historial.setanio(anio);
                historial.setcosto(costoStr);
                historial.setTipo_tratamiento_id_Tipotratam(tratamientoId);
                Historial_tratamientoDAO dao = new Historial_tratamientoDAO();
                
                if ("actualizar".equals(accion)) {
                    historial.setid_Historial(Integer.parseInt(limpiar(request.getParameter("id"))));
                    guardado = dao.actualizarHistorial_tratamiento(historial);
                } else {
                    guardado = dao.insertarHistorial_tratamiento(historial);
                }
            }
        } catch (Exception e) {
            guardado = false;
            System.err.println("Error Historial Servlet: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/RegistroHistorialTratamientoServlet" + (guardado ? "?mensaje=guardado" : "?error=registro"));
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}