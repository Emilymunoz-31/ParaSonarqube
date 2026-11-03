package Controlador;

import Conexion.Conexion;
import Modelo.Abono;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AbonoDAO {
       Conexion conexion = new Conexion();

   public boolean insertarAbono(Abono abono) throws SQLException {
    boolean insertado = false;
    String sql = "INSERT INTO abono (monto_abono, fecha_abono, Pago_id_Pago) VALUES (?, ?, ?)";
    
    try (Connection con = conexion.getConn();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setDouble(1, abono.getmonto_abono());
        ps.setString (2, abono.getfecha_abono());
        ps.setInt(3, abono.getPago_id_Pago());
        
        int filasAfectadas = ps.executeUpdate();
        if (filasAfectadas > 0) {
            insertado = true;
            System.out.println("Abono insertado correctamente");
        }
        
    } catch (SQLException e) {
        System.err.println("Error al insertar Abono: " + e.getMessage());
    }
    return insertado;
}

    public List<Abono> listarAbonos() {
        List<Abono> abonos = new ArrayList<>();
        String sql = "SELECT id_Abono, monto_abono, fecha_abono, Pago_id_Pago FROM abono ORDER BY id_Abono DESC";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Abono abono = new Abono();
                abono.setid_Abono(rs.getInt("id_Abono"));
                abono.setmonto_abono(rs.getDouble("monto_abono"));
                abono.setfecha_abono(rs.getString("fecha_abono"));
                abono.setPago_id_Pago(rs.getInt("Pago_id_Pago"));
                abonos.add(abono);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar abonos: " + e.getMessage());
        }
        return abonos;
    }
    
    
    
    public Abono consultaAbono(int id_Abono) {

        Abono abono = null;
        Conexion conexion = new Conexion();
        Connection con = conexion.getConn();

        try {
            // CORRECCIÓN: 'abono' en minúscula
            String querySQL = "SELECT id_Abono, monto_abono, fecha_abono, Pago_id_Pago FROM abono WHERE id_Abono = ? ";

            PreparedStatement ps = con.prepareStatement(querySQL);
            ps.setInt(1, id_Abono);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                abono = new Abono();
                abono.setid_Abono(rs.getInt(1));
                abono.setmonto_abono(rs.getDouble(2));
                abono.setfecha_abono(rs.getString(3));
                abono.setPago_id_Pago(rs.getInt(4));
            }

            return abono;

        } catch (Exception ex) {

            System.out.println(ex.getMessage());
            return abono;

        }
    }
    
  public boolean actualizarAbono(Abono abono) throws SQLException {
        boolean actualizado = false;
        // CORRECCIÓN: 'abono' en minúscula
        String sql = "UPDATE abono SET monto_abono=?, fecha_abono=?, Pago_id_Pago=? WHERE id_Abono=?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, abono.getmonto_abono());
            ps.setString(2, abono.getfecha_abono());
            ps.setInt(3, abono.getPago_id_Pago());
            ps.setInt(4, abono.getid_Abono());

            if (ps.executeUpdate() > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el Abono: " + e.getMessage());
        }
        return actualizado;
    }


    public boolean eliminarAbono(int id) throws SQLException {
        boolean eliminado = false;
        String sql = "DELETE FROM abono WHERE id_Abono = ?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            if (ps.executeUpdate() > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al eliminar Abono:  " + e.getMessage());
        }
        return eliminado;
    }
    
    public Double obtenerTotalAbonadoPorPago(int idPago) {
    Double total = 0.0;
    String sql = "SELECT SUM(monto_abono) AS total_abonado FROM abono WHERE Pago_id_Pago = ?";
    
    try (Connection con = conexion.getConn();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setInt(1, idPago);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getDouble("total_abonado");
            }
        }
    } catch (SQLException e) {
        System.out.println("Error al calcular total abonado: " + e.getMessage());
    }
    return total;
}
}