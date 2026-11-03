package Servlet;

import Controlador.CitaDAO;
import Controlador.Estado_pagoDAO;
import Controlador.Medio_pagoDAO;
import Controlador.PagoDAO;
import Modelo.Pago;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroPagoServlet", urlPatterns = {"/RegistroPagoServlet"})
public class RegistroPagoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PagoDAO dao = new PagoDAO();
        String accion = limpiar(request.getParameter("accion"));

        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                ok = dao.eliminarPago(Integer.parseInt(limpiar(request.getParameter("id"))));
            } catch (Exception e) {
                ok = false;
            }
            response.sendRedirect(request.getContextPath() + "/RegistroPagoServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }

        if ("editar".equals(accion)) {
            try {
                request.setAttribute("pagoEditar", dao.consultaPago(Integer.parseInt(limpiar(request.getParameter("id")))));
            } catch (Exception e) {
                request.setAttribute("pagoEditar", null);
            }
        }

        request.setAttribute("pagos", dao.listarPagos());
        request.setAttribute("mediosPago", new Medio_pagoDAO().listarMediosPago());
        request.setAttribute("estadosPago", new Estado_pagoDAO().listarEstadosPago());
        request.setAttribute("citas", new CitaDAO().listarCitas());
        
        request.getRequestDispatcher("/Vista/Registrar_Pago.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = limpiar(request.getParameter("accion"));
        boolean guardado = false;

        try {
            double monto = parseMonto(request.getParameter("monto"));
            int medioPago = Integer.parseInt(limpiar(request.getParameter("medioPago")));
            int estadoPago = Integer.parseInt(limpiar(request.getParameter("estadoPago")));
            int cita = Integer.parseInt(limpiar(request.getParameter("cita")));

            if (monto >= 0 && medioPago > 0 && estadoPago > 0 && cita > 0) {
                Pago pago = new Pago();
                pago.setmonto(monto);
                pago.setMedio_pago_id_Mediopago(medioPago);
                pago.setEstado_pago_id_Estadopago(estadoPago);
                pago.setCita_id_Cita(cita);

                PagoDAO dao = new PagoDAO();
                CitaDAO citaDAO = new CitaDAO();

                if ("actualizar".equals(accion)) {
                    pago.setid_Pago(Integer.parseInt(limpiar(request.getParameter("id"))));
                    guardado = dao.actualizarPago(pago);
                } else {
                    guardado = dao.guardarOActualizarPago(pago);
                }

                if (guardado) {
                    try {
                        int nuevoEstadoCita = (estadoPago == 1) ? 4 : 2; 
                        citaDAO.actualizarEstadoCita(cita, nuevoEstadoCita);
                    } catch (Exception exCita) {
                        System.err.println("Aviso al actualizar cita: " + exCita.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            guardado = false;
            System.err.println("Error en RegistroPagoServlet: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/RegistroPagoServlet" + (guardado ? "?mensaje=guardado" : "?error=registro"));
    }

    private double parseMonto(String valor) {
        String montoLimpio = limpiar(valor).replace(" ", "").replace(".", "").replace(",", ".");
        return Double.parseDouble(montoLimpio);
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}