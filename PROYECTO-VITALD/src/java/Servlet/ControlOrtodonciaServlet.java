package Servlet;

import Controlador.CitaDAO;
import Modelo.Cita;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ControlOrtodonciaServlet", urlPatterns = {"/ControlOrtodonciaServlet"})
public class ControlOrtodonciaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String documento = request.getParameter("txtDocumentoBusqueda");
        if (documento != null && !documento.trim().isEmpty()) {
            procesarBusqueda(documento.trim(), request, response);
            return;
        }
        request.getRequestDispatcher("/Vista/control_ortodoncia.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String documento = request.getParameter("txtDocumentoBusqueda");
        
        if (documento != null) {
            documento = documento.trim();
        }
        
        procesarBusqueda(documento, request, response);
    }

    private void procesarBusqueda(String documento, HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        CitaDAO citaDAO = new CitaDAO();
        List<Cita> listaControles = null;

        if (documento != null && !documento.isEmpty()) {
            try {
                listaControles = citaDAO.obtenerControlesOrtodonciaPorDocumento(documento);
            } catch (Exception e) {
                System.err.println("Error al obtener controles de ortodoncia: " + e.getMessage());
                listaControles = new ArrayList<>();
            }
        } else {
            listaControles = new ArrayList<>();
        }

        request.setAttribute("listaControles", listaControles != null ? listaControles : new ArrayList<Cita>());
        request.setAttribute("documentoBuscado", documento);

        request.getRequestDispatcher("/Vista/control_ortodoncia.jsp").forward(request, response);
    }
}