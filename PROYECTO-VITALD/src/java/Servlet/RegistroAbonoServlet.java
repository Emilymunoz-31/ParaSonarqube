package Servlet;

import Controlador.AbonoDAO;
import Controlador.CitaDAO;
import Controlador.PagoDAO;
import Modelo.Abono;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroAbonoServlet", urlPatterns = {"/RegistroAbonoServlet"})
public class RegistroAbonoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        AbonoDAO dao = new AbonoDAO();
        PagoDAO pagoDAO = new PagoDAO();
        CitaDAO citaDAO = new CitaDAO();
        String accion = limpiar(request.getParameter("accion"));

        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                int idAbono = Integer.parseInt(limpiar(request.getParameter("id")));
                Abono abono = dao.consultaAbono(idAbono);
                int idPago = abono != null ? abono.getPago_id_Pago() : 0;
                int idCita = idPago > 0 ? pagoDAO.obtenerIdCitaPorPago(idPago) : 0;
                
                ok = dao.eliminarAbono(idAbono);
                
                if (ok && idCita > 0) {
                    pagoDAO.actualizarEstadoCitaPorSaldo(idCita);
                }
            } catch (Exception e) {
                ok = false;
                System.err.println("Error al eliminar abono: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/RegistroAbonoServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }

        if ("editar".equals(accion)) {
            try {
                request.setAttribute("abonoEditar", dao.consultaAbono(Integer.parseInt(limpiar(request.getParameter("id")))));
            } catch (Exception e) {
                request.setAttribute("abonoEditar", null);
            }
        }

        request.setAttribute("abonos", dao.listarAbonos());
        request.setAttribute("pagos", pagoDAO.listarPagos());
        request.setAttribute("citas", citaDAO.listarCitas());
        
        request.getRequestDispatcher("/Vista/Registrar_abono.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = limpiar(request.getParameter("accion"));
        boolean guardado = false;
        int pagoId = 0;

        try {
            String montoStr = limpiar(request.getParameter("monto")).replace(" ", "").replace(".", "").replace(",", ".");
            double monto = Double.parseDouble(montoStr);
            String fecha = limpiar(request.getParameter("fecha"));
            pagoId = Integer.parseInt(limpiar(request.getParameter("pago")));

            if (monto > 0 && !fecha.isEmpty() && pagoId > 0) {
                Abono abono = new Abono();
                abono.setmonto_abono(monto);
                abono.setfecha_abono(fecha);
                abono.setPago_id_Pago(pagoId);
                
                AbonoDAO dao = new AbonoDAO();
                
                if ("actualizar".equals(accion)) {
                    abono.setid_Abono(Integer.parseInt(limpiar(request.getParameter("id"))));
                    guardado = dao.actualizarAbono(abono);
                } else {
                    guardado = dao.insertarAbono(abono);
                }
            }

            if (guardado) {
                PagoDAO pagoDAO = new PagoDAO();
                int idCita = pagoDAO.obtenerIdCitaPorPago(pagoId);
                if (idCita > 0) {
                    pagoDAO.actualizarEstadoCitaPorSaldo(idCita);
                }
            }
        } catch (Exception e) {
            guardado = false;
            System.err.println("Error en RegistroAbonoServlet: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/RegistroAbonoServlet" + (guardado ? "?mensaje=guardado" : "?error=registro"));
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}