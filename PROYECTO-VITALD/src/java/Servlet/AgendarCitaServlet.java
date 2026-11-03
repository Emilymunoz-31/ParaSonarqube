package Servlet;

import Controlador.CitaDAO;
import Controlador.Categoria_TratamientoDAO;
import Controlador.Estado_citaDAO;
import Controlador.Estado_pagoDAO;
import Controlador.Medio_pagoDAO;
import Controlador.PagoDAO;
import Controlador.Tipo_documentoDAO;
import Controlador.Tipo_tratamientoDAO;
import Controlador.UsuarioDAO;
import Conexion.EmailUtil;
import Modelo.Cita;
import Modelo.Pago;
import Modelo.Usuario;
import Modelo.Tipo_tratamiento;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AgendarCitaServlet", urlPatterns = {"/AgendarCitaServlet"})
public class AgendarCitaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("buscarPacientes".equals(request.getParameter("accion"))) {
            buscarPacientes(request, response);
            return;
        }
        if ("buscarPaciente".equals(request.getParameter("accion"))) {
            buscarPacientePorDocumento(request, response);
            return;
        }
        CitaDAO citaDAO = new CitaDAO();
        String accion = limpiar(request.getParameter("accion"));
        if ("eliminar".equals(accion)) {
            boolean ok = false;
            try {
                ok = citaDAO.eliminarCita(Integer.parseInt(limpiar(request.getParameter("id"))));
            } catch (Exception e) {
                ok = false;
            }
            response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet" + (ok ? "?mensaje=eliminado" : "?error=eliminar"));
            return;
        }
        if ("editar".equals(accion)) {
            try {
                Cita citaEditar = citaDAO.consultaCita(Integer.parseInt(limpiar(request.getParameter("id"))));
                request.setAttribute("citaEditar", citaEditar);
                cargarFechaHoraEdicion(request, citaEditar);
            } catch (Exception e) {
                request.setAttribute("citaEditar", null);
            }
        }

        cargarDatosFormulario(request);
        request.getRequestDispatcher("/Vista/Registro_cita.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String accion = limpiar(request.getParameter("accion"));
        String documentoPaciente = limpiar(request.getParameter("txtDocumentoCita"));
        String idOdontologoStr = limpiar(request.getParameter("txtIdOdontologo"));
        String idTratamientoStr = limpiar(request.getParameter("txtIdTratamiento"));
        String idEstadoCitaStr = limpiar(request.getParameter("txtEstadoCita"));
        String fechaCita = limpiar(request.getParameter("txtFechaCita"));
        String horaCita = limpiar(request.getParameter("txtHoraCita"));
        String observaciones = limpiar(request.getParameter("txtObservaciones"));
        CitaDAO dao = new CitaDAO();

        try {
            if ((documentoPaciente.isEmpty() && !"actualizar".equals(accion)) || fechaCita.isEmpty() || horaCita.isEmpty()
                    || idOdontologoStr.isEmpty() || idTratamientoStr.isEmpty()
                    || idEstadoCitaStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet?error=datos_invalidos");
                return;
            }

            if (!"actualizar".equals(accion) && !dao.existePacientePorDocumento(documentoPaciente)) {
                response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet?error=paciente_no_existe");
                return;
            }

            int idTratamiento = Integer.parseInt(idTratamientoStr);
            int idOdontologo = Integer.parseInt(idOdontologoStr);
            int idEstadoCita = Integer.parseInt(idEstadoCitaStr);

            LocalDate fecha = LocalDate.parse(fechaCita);
            LocalTime hora = LocalTime.parse(horaCita);
            LocalDateTime fechaHora = LocalDateTime.of(fecha, hora);
            String fechaYHora = fechaHora.toString().replace("T", " ") + ":00";

            Cita nuevaCita = new Cita();
            nuevaCita.setfecha_hora(fechaYHora);
            nuevaCita.setdescripcion_cita(observaciones);
            nuevaCita.setUsuario_id_Usuario(idOdontologo);
            nuevaCita.setEstado_cita_idEstado_cita(idEstadoCita);
            nuevaCita.setTipo_Tratamiento_id_Tipotratam(idTratamiento);

            if ("actualizar".equals(accion)) {
                nuevaCita.setid_Cita(Integer.parseInt(limpiar(request.getParameter("id"))));
                boolean actualizada = dao.actualizarCita(nuevaCita);
                response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet" + (actualizada ? "?mensaje=actualizado" : "?error=registro"));
                return;
            }

            int idCita = dao.insertarCitaRetornandoId(nuevaCita, documentoPaciente);

            if (idCita > 0) {
                try {
                    Usuario paciente = new UsuarioDAO().buscarPorDocumento(documentoPaciente);
                    if (paciente != null && paciente.getCorreo() != null && !paciente.getCorreo().trim().isEmpty()) {
                        String nombreTratamiento = "Tratamiento Odontológico";
                        try {
                            Tipo_tratamiento tratamientoObj = new Tipo_tratamientoDAO().consultaTipo_tratamiento(idTratamiento);
                            if (tratamientoObj != null && tratamientoObj.getdescripcion_tipotratam() != null) {
                                nombreTratamiento = tratamientoObj.getdescripcion_tipotratam();
                            }
                        } catch (Exception eTratam) {
                            System.out.println("No se pudo obtener el nombre detallado del tratamiento: " + eTratam.getMessage());
                        }

                        EmailUtil.enviarConfirmacionCita(
                            paciente.getCorreo(),
                            (paciente.getNombreus() + " " + paciente.getApellido()).trim(),
                            fechaYHora,
                            nombreTratamiento,
                            observaciones
                        );
                    }
                } catch (Exception mailEx) {
                    System.out.println("La cita se guardó, pero el envío de correo falló: " + mailEx.getMessage());
                }

                PagoDAO pagoDAO = new PagoDAO();
                Integer idEstadoPendiente = pagoDAO.obtenerIdEstadoPorDescripcion("Pendiente");
                Integer idMedioPago = pagoDAO.obtenerPrimerMedioPagoDisponible();

                if (idEstadoPendiente != null && idMedioPago != null) {
                    Pago pago = new Pago();
                    pago.setmonto(0.0);
                    pago.setMedio_pago_id_Mediopago(idMedioPago);
                    pago.setEstado_pago_id_Estadopago(idEstadoPendiente);
                    pago.setCita_id_Cita(idCita);
                    try {
                        pagoDAO.insertarPago(pago);
                    } catch (Exception e) {
                        System.out.println("Registro de pago pendiente omitido: " + e.getMessage());
                    }
                }

                response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet?mensaje=cita_creada");
            } else {
                response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet?error=no_guardada");
            }
        } catch (NumberFormatException | DateTimeParseException e) {
            response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet?error=datos_invalidos");
        } catch (Exception e) {
            System.out.println("Error al agendar cita: " + e.toString());
            response.sendRedirect(request.getContextPath() + "/AgendarCitaServlet?error=datos_invalidos");
        }
    }

    private void cargarDatosFormulario(HttpServletRequest request) {
        request.setAttribute("odontologos", new UsuarioDAO().listarOdontologos());
        request.setAttribute("tratamientos", new Tipo_tratamientoDAO().listarTiposTratamiento());
        
        try {
            request.setAttribute("categoriasTratamiento", new Categoria_TratamientoDAO().listarCategorias());
        } catch (Exception e) {
            System.out.println("Aviso sobre categorías: " + e.getMessage());
        }
        
        request.setAttribute("estadosCita", new Estado_citaDAO().listarEstadosCita());
        request.setAttribute("estadosPago", new Estado_pagoDAO().listarEstadosPago());
        request.setAttribute("mediosPago", new Medio_pagoDAO().listarMediosPago());
        request.setAttribute("tiposDocumento", new Tipo_documentoDAO().listarTiposDocumento());
        request.setAttribute("citas", new CitaDAO().listarCitas());
    }

    private void cargarFechaHoraEdicion(HttpServletRequest request, Cita citaEditar) {
        if (citaEditar == null || citaEditar.getfecha_hora() == null) {
            return;
        }
        String fechaHora = citaEditar.getfecha_hora().replace("T", " ");
        String[] partes = fechaHora.split(" ");
        if (partes.length > 0) {
            request.setAttribute("fechaEditar", partes[0]);
        }
        if (partes.length > 1 && partes[1].length() >= 5) {
            request.setAttribute("horaEditar", partes[1].substring(0, 5));
        }
    }

    private void buscarPacientes(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String termino = request.getParameter("q");
        List<Usuario> pacientes = new UsuarioDAO().buscarPacientes(termino);

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        StringBuilder json = new StringBuilder("[ ");
        for (int i = 0; i < pacientes.size(); i++) {
            Usuario paciente = pacientes.get(i);
            String nombreCompleto = (paciente.getNombreus() + " " + paciente.getApellido()).trim();
            if (i > 0) {
                json.append(",");
            }
            json.append("{")
                    .append("\"id\":").append(paciente.getId_Usuario()).append(",")
                    .append("\"nombre\":\"").append(escaparJson(nombreCompleto)).append("\",")
                    .append("\"documento\":\"").append(escaparJson(paciente.getDocumento())).append("\",")
                    .append("\"telefono\":\"").append(escaparJson(paciente.getTelefono())).append("\",")
                    .append("\"correo\":\"").append(escaparJson(paciente.getCorreo())).append("\"")
                    .append("}");
        }
        json.append("]");
        response.getWriter().write(json.toString());
    }

    private void buscarPacientePorDocumento(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String documento = limpiar(request.getParameter("documento"));
        Usuario paciente = new UsuarioDAO().buscarPorDocumento(documento);
        String q = String.valueOf((char) 34);

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        if (paciente == null) {
            response.getWriter().write("{" + q + "existe" + q + ":false}");
            return;
        }

        String nombreCompleto = (paciente.getNombreus() + " " + paciente.getApellido()).trim();
        String json = "{" + q + "existe" + q + ":true," + q + "nombre" + q + ":" + q
                + escaparJson(nombreCompleto) + q + "," + q + "documento" + q + ":" + q
                + escaparJson(paciente.getDocumento()) + q + "}";
        response.getWriter().write(json);
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }

    private String escaparJson(String valor) {
        if (valor == null) {
            return "";
        }
        return valor.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}