package Controlador;

import Conexion.Conexion;
import Modelo.Pago;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PagoDAO {
    Conexion conexion = new Conexion();

    public boolean guardarOActualizarPago(Pago pago) throws SQLException {
        Pago existente = obtenerPagoPorCita(pago.getCita_id_Cita());
        if (existente != null) {
            pago.setid_Pago(existente.getid_Pago());
            return actualizarPago(pago);
        }
        return insertarPago(pago);
    }

    public boolean insertarPago(Pago pago) throws SQLException {
        boolean insertado = false;
        String sql = "INSERT INTO pago (monto, Medio_pago_idMedio_pago, Estado_pago_idEstado_pago, Cita_id_Cita) VALUES (?, ?, ?, ?)";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, pago.getmonto());
            ps.setInt(2, pago.getMedio_pago_id_Mediopago());
            ps.setInt(3, pago.getEstado_pago_id_Estadopago());
            ps.setInt(4, pago.getCita_id_Cita());
            insertado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al insertar pago: " + e.getMessage());
            throw e;
        }

        if (insertado) {
            actualizarEstadoCitaPorSaldo(pago.getCita_id_Cita());
        }
        return insertado;
    }

    public boolean actualizarPago(Pago pago) throws SQLException {
        boolean actualizado = false;
        String sql = "UPDATE pago SET monto=?, Medio_pago_idMedio_pago=?, Estado_pago_idEstado_pago=?, Cita_id_Cita=? WHERE id_Pago=?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, pago.getmonto());
            ps.setInt(2, pago.getMedio_pago_id_Mediopago());
            ps.setInt(3, pago.getEstado_pago_id_Estadopago());
            ps.setInt(4, pago.getCita_id_Cita());
            ps.setInt(5, pago.getid_Pago());
            actualizado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar el pago: " + e.getMessage());
            throw e;
        }

        if (actualizado) {
            actualizarEstadoCitaPorSaldo(pago.getCita_id_Cita());
        }
        return actualizado;
    }

    public List<Pago> listarPagos() {
        List<Pago> pagos = new ArrayList<>();
        String sql = "SELECT p.id_Pago, p.monto AS monto_pago, p.Medio_pago_idMedio_pago, "
                + "p.Estado_pago_idEstado_pago, p.Cita_id_Cita, "
                + "mp.descripcion_mediopa, ep.descripcion_estadop, COALESCE(tt.costo, 0) AS costo_tratamiento, "
                + "COALESCE((SELECT SUM(a.monto_abono) FROM abono a WHERE a.Pago_id_Pago = p.id_Pago), 0.0) AS suma_abonos "
                + "FROM pago p "
                + "LEFT JOIN medio_pago mp ON p.Medio_pago_idMedio_pago = mp.id_Mediopago "
                + "LEFT JOIN estado_pago ep ON p.Estado_pago_idEstado_pago = ep.id_Estadopago "
                + "LEFT JOIN cita c ON p.Cita_id_Cita = c.id_Cita "
                + "LEFT JOIN tipo_tratamiento tt ON c.Tipo_tratamiento_id_Tipotratam = tt.id_Tipotratam "
                + "WHERE COALESCE(p.activo, 1) = 1 "
                + "ORDER BY p.id_Pago DESC";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Pago pago = new Pago();
                pago.setid_Pago(rs.getInt("id_Pago"));
                double montoPago = rs.getDouble("monto_pago");
                double totalAbonos = rs.getDouble("suma_abonos");
                double costoTratamiento = rs.getDouble("costo_tratamiento");

                pago.setmonto(montoPago);
                pago.setMedio_pago_id_Mediopago(rs.getInt("Medio_pago_idMedio_pago"));
                pago.setEstado_pago_id_Estadopago(rs.getInt("Estado_pago_idEstado_pago"));
                pago.setCita_id_Cita(rs.getInt("Cita_id_Cita"));
                pago.setDescripcionMedioPago(rs.getString("descripcion_mediopa"));
                pago.setDescripcionEstadoPago(rs.getString("descripcion_estadop"));
                pago.setTotalAbonado(montoPago + totalAbonos);
                pago.setSaldoPendiente(Math.max(0.0, costoTratamiento - montoPago - totalAbonos));
                pagos.add(pago);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar pagos: " + e.getMessage());
        }
        return pagos;
    }

    public Pago consultaPago(int id_Pago) {
        Pago pago = null;
        String querySQL = "SELECT id_Pago, monto, Medio_pago_idMedio_pago, Estado_pago_idEstado_pago, Cita_id_Cita FROM pago WHERE id_Pago = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(querySQL)) {
            ps.setInt(1, id_Pago);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    pago = new Pago();
                    pago.setid_Pago(rs.getInt(1));
                    pago.setmonto(rs.getDouble(2));
                    pago.setMedio_pago_id_Mediopago(rs.getInt(3));
                    pago.setEstado_pago_id_Estadopago(rs.getInt(4));
                    pago.setCita_id_Cita(rs.getInt(5));
                }
            }
        } catch (SQLException ex) {
            System.err.println("Error al consultar pago: " + ex.getMessage());
        }
        return pago;
    }

    public boolean eliminarPago(int id) throws SQLException {
        boolean eliminado = false;
        int idCita = obtenerIdCitaPorPago(id);
        String sql = "DELETE FROM pago WHERE id_Pago = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            eliminado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar el pago: " + e.getMessage());
            throw e;
        }

        if (eliminado && idCita > 0) {
            actualizarEstadoCitaPorSaldo(idCita);
        }
        return eliminado;
    }

    public Integer obtenerIdEstadoPorDescripcion(String descripcion) {
        String sql = "SELECT id_Estadopago FROM estado_pago "
                + "WHERE LOWER(TRIM(REPLACE(descripcion_estadop, '.', ''))) = LOWER(TRIM(REPLACE(?, '.', ''))) "
                + "OR LOWER(TRIM(descripcion_estadop)) LIKE LOWER(?) "
                + "ORDER BY id_Estadopago LIMIT 1";
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String valor = descripcion == null ? "" : descripcion.trim();
            ps.setString(1, valor);
            ps.setString(2, valor + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_Estadopago");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener estado de pago: " + e.getMessage());
        }
        return null;
    }

    public Integer obtenerPrimerMedioPagoDisponible() {
        String sql = "SELECT id_Mediopago FROM medio_pago ORDER BY id_Mediopago LIMIT 1";
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("id_Mediopago");
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener medio de pago: " + e.getMessage());
        }
        return null;
    }

    public Pago obtenerPagoPorCita(int idCita) {
        Pago pago = null;
        String sql = "SELECT id_Pago, monto, Medio_pago_idMedio_pago, Estado_pago_idEstado_pago, Cita_id_Cita "
                + "FROM pago WHERE Cita_id_Cita = ? AND COALESCE(activo, 1) = 1 ORDER BY id_Pago DESC LIMIT 1";
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCita);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    pago = new Pago();
                    pago.setid_Pago(rs.getInt("id_Pago"));
                    pago.setmonto(rs.getDouble("monto"));
                    pago.setMedio_pago_id_Mediopago(rs.getInt("Medio_pago_idMedio_pago"));
                    pago.setEstado_pago_id_Estadopago(rs.getInt("Estado_pago_idEstado_pago"));
                    pago.setCita_id_Cita(rs.getInt("Cita_id_Cita"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener pago por cita: " + e.getMessage());
        }
        return pago;
    }

    public int obtenerIdCitaPorPago(int idPago) {
        String sql = "SELECT Cita_id_Cita FROM pago WHERE id_Pago = ?";
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPago);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("Cita_id_Cita");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener cita del pago: " + e.getMessage());
        }
        return 0;
    }

    public double calcularSaldoPendiente(int idCita) {
        TotalesCita totales = obtenerTotalesCita(idCita);
        return Math.max(0.0, totales.costoTratamiento - totales.totalPagado);
    }

    public boolean actualizarEstadoCitaPorSaldo(int idCita) throws SQLException {
        TotalesCita totales = obtenerTotalesCita(idCita);
        double saldo = Math.max(0.0, totales.costoTratamiento - totales.totalPagado);
        Integer idEstadoCita;

        if (saldo <= 0.0 && totales.costoTratamiento > 0.0) {
            idEstadoCita = obtenerIdEstadoCitaPorDescripcion("Pagado", "Atendida");
        } else if (totales.totalPagado > 0.0) {
            idEstadoCita = obtenerIdEstadoCitaPorDescripcion("Pago parcial", "Programada");
        } else {
            idEstadoCita = obtenerIdEstadoCitaPorDescripcion("Pendiente", "Programada");
        }

        if (idEstadoCita == null) {
            return false;
        }

        String sql = "UPDATE cita SET Estado_cita_idEstado_cita = ? WHERE id_Cita = ?";
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idEstadoCita);
            ps.setInt(2, idCita);
            return ps.executeUpdate() > 0;
        }
    }

    private Integer obtenerIdEstadoCitaPorDescripcion(String... candidatos) {
        String sql = "SELECT idEstado_cita FROM estado_cita "
                + "WHERE LOWER(TRIM(REPLACE(descripcion_estadoci, '.', ''))) = LOWER(TRIM(REPLACE(?, '.', ''))) "
                + "OR LOWER(TRIM(descripcion_estadoci)) LIKE LOWER(?) "
                + "ORDER BY idEstado_cita LIMIT 1";

        try (Connection con = conexion.getConn()) {
            for (String candidato : candidatos) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    String valor = candidato == null ? "" : candidato.trim();
                    ps.setString(1, valor);
                    ps.setString(2, valor + "%");
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return rs.getInt("idEstado_cita");
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener estado de cita: " + e.getMessage());
        }
        return null;
    }

    private TotalesCita obtenerTotalesCita(int idCita) {
        TotalesCita totales = new TotalesCita();
        String sql = "SELECT COALESCE(tt.costo, 0) AS costo_tratamiento, "
                + "COALESCE(pagos.total_pagos, 0) + COALESCE(abonos.total_abonos, 0) AS total_pagado "
                + "FROM cita c "
                + "LEFT JOIN tipo_tratamiento tt ON c.Tipo_tratamiento_id_Tipotratam = tt.id_Tipotratam "
                + "LEFT JOIN (SELECT Cita_id_Cita, SUM(monto) AS total_pagos FROM pago WHERE COALESCE(activo, 1) = 1 GROUP BY Cita_id_Cita) pagos "
                + "ON pagos.Cita_id_Cita = c.id_Cita "
                + "LEFT JOIN (SELECT p.Cita_id_Cita, SUM(a.monto_abono) AS total_abonos FROM pago p "
                + "INNER JOIN abono a ON a.Pago_id_Pago = p.id_Pago WHERE COALESCE(p.activo, 1) = 1 GROUP BY p.Cita_id_Cita) abonos "
                + "ON abonos.Cita_id_Cita = c.id_Cita "
                + "WHERE c.id_Cita = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCita);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totales.costoTratamiento = rs.getDouble("costo_tratamiento");
                    totales.totalPagado = rs.getDouble("total_pagado");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al calcular saldo pendiente: " + e.getMessage());
        }
        return totales;
    }

    private static class TotalesCita {
        private double costoTratamiento;
        private double totalPagado;
    }
}