package Servlet;

import Controlador.Categoria_TratamientoDAO;
import Modelo.Categoria_Tratamiento;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroCategoriaTratamientoServlet", urlPatterns = {"/RegistroCategoriaTratamientoServlet"})
public class RegistroCategoriaTratamientoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Categoria_TratamientoDAO dao = new Categoria_TratamientoDAO();
        String accion = limpiar(request.getParameter("accion"));

        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                ok = dao.eliminarCategoria_Tratamiento(Integer.parseInt(limpiar(request.getParameter("id"))));
            } catch (Exception e) {
                ok = false;
                System.err.println("Error al eliminar categoría: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/RegistroCategoriaTratamientoServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }

        if ("editar".equals(accion)) {
            try {
                request.setAttribute("categoriaEditar", dao.consultaCategoria_Tratamiento(Integer.parseInt(limpiar(request.getParameter("id")))));
            } catch (Exception e) {
                request.setAttribute("categoriaEditar", null);
            }
        }

        request.setAttribute("categorias", dao.listarCategorias());
        request.getRequestDispatcher("/Vista/Registrar_categoriatratmiento.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = limpiar(request.getParameter("accion"));
        String descripcion = limpiar(request.getParameter("descripcion"));

        if (descripcion.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/RegistroCategoriaTratamientoServlet?error=registro");
            return;
        }

        Categoria_Tratamiento categoria = new Categoria_Tratamiento();
        categoria.setnombre_categoria(descripcion);
        boolean guardado = false;

        try {
            Categoria_TratamientoDAO dao = new Categoria_TratamientoDAO();
            if ("actualizar".equals(accion)) {
                categoria.setid_Categoria(Integer.parseInt(limpiar(request.getParameter("id"))));
                guardado = dao.actualizarCategoria_Tratamiento(categoria);
            } else {
                guardado = dao.insertarCategoria_Tratamiento(categoria);
            }
        } catch (Exception e) {
            guardado = false;
            System.err.println("Error al guardar categoría: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/RegistroCategoriaTratamientoServlet" + (guardado ? "?mensaje=guardado" : "?error=registro"));
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}