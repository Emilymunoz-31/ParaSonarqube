package Servlet;

import Controlador.CitaDAO;
import Controlador.Estado_citaDAO;
import Modelo.Cita;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ControlCitasAgendadasServlet", urlPatterns = {"/ControlCitasAgendadasServlet"})
public class ControlCitasAgendadasServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        CitaDAO dao = new CitaDAO();
        String accion = request.getParameter("accion");

        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                ok = dao.eliminarCita(id);
            } catch (SQLException | NumberFormatException e) {
                System.out.println("Error al intentar eliminar la cita: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/ControlCitasAgendadasServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }

        cargarDatos(request);
        request.getRequestDispatcher("/Vista/ControlCitasAgendadas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("cambiarEstado".equals(accion)) {
            boolean actualizado = false;
            try {
                int idCita = Integer.parseInt(request.getParameter("idCita"));
                int nuevoEstado = Integer.parseInt(request.getParameter("nuevoEstado"));
                
                CitaDAO dao = new CitaDAO();
                Cita cita = dao.consultaCita(idCita);
                if (cita != null) {
                    cita.setEstado_cita_idEstado_cita(nuevoEstado);
                    actualizado = dao.actualizarCita(cita);
                }
            } catch (Exception e) {
                System.out.println("Error al cambiar estado de cita: " + e.getMessage());
            }
            
            response.sendRedirect(request.getContextPath() + "/ControlCitasAgendadasServlet" + (actualizado ? "?mensaje=estado_actualizado" : "?error=actualizar"));
            return;
        }

        doGet(request, response);
    }

    private void cargarDatos(HttpServletRequest request) {
        request.setAttribute("citas", new CitaDAO().listarCitas());
        request.setAttribute("estadosCita", new Estado_citaDAO().listarEstadosCita());
    }
}