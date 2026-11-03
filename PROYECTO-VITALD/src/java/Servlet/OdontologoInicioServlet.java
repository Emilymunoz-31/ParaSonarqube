package Servlet;

import Controlador.CitaDAO;
import Controlador.UsuarioDAO;
import Modelo.Cita;
import Modelo.Usuario;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "OdontologoInicioServlet", urlPatterns = {"/OdontologoInicioServlet"})
public class OdontologoInicioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            CitaDAO citaDAO = new CitaDAO();
            List<Cita> listaCitas = citaDAO.listarCitas();
            request.setAttribute("citas", listaCitas != null ? listaCitas : new ArrayList<Cita>());
        } catch (Exception e) {
            System.err.println("Error cargando citas en OdontologoInicioServlet: " + e.getMessage());
            request.setAttribute("citas", new ArrayList<Cita>());
        }

        try {
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            List<Usuario> listaPacientes = usuarioDAO.buscarPacientes("");
            request.setAttribute("totalPacientes", listaPacientes != null ? listaPacientes.size() : 0);
        } catch (Exception e) {
            System.err.println("Error contando pacientes en OdontologoInicioServlet: " + e.getMessage());
            request.setAttribute("totalPacientes", 0);
        }

        request.getRequestDispatcher("/Vista/odontologo_inicio.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}