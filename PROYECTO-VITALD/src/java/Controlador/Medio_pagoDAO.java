package Controlador;

import Conexion.Conexion;
import Modelo.Medio_pago;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Medio_pagoDAO {
       Conexion conexion = new Conexion();

   public boolean insertarMedio_pago(Medio_pago medio_pago) throws SQLException {
    boolean insertado = false;
    String sql = "INSERT INTO medio_pago (descripcion_mediopa) VALUES (?)";
    
    try (Connection con = conexion.getConn();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, medio_pago.getdescripcion_mediopa());
        
        int filasAfectadas = ps.executeUpdate();
        if (filasAfectadas > 0) {
            insertado = true;
            System.out.println("Medio de pago insertado con exito.");
        }
        
    } catch (SQLException e) {
        System.err.println("Medio de pago: " + e.getMessage());
    }
    return insertado;
}

    public java.util.List<Medio_pago> listarMediosPago() {
        java.util.List<Medio_pago> medios = new java.util.ArrayList<>();
        String sql = "SELECT id_Mediopago, descripcion_mediopa FROM medio_pago ORDER BY descripcion_mediopa";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Medio_pago medio = new Medio_pago();
                medio.setid_Mediopago(rs.getInt("id_Mediopago"));
                medio.setdescripcion_mediopa(rs.getString("descripcion_mediopa"));
                medios.add(medio);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar medios de pago: " + e.getMessage());
        }
        return medios;
    }
    
    
    
    public Medio_pago consultaMedio_pago(int id_Mediopago) {

        Medio_pago medio_pago = null;
        Conexion conexion = new Conexion();
        Connection con = conexion.getConn();

        try {
            String querySQL = "SELECT id_Mediopago, descripcion_mediopa FROM medio_pago WHERE id_Mediopago = ?";

            PreparedStatement ps = con.prepareStatement(querySQL);
            ps.setInt(1, id_Mediopago);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                medio_pago = new Medio_pago();
                medio_pago.setid_Mediopago(rs.getInt(1));
                medio_pago.setdescripcion_mediopa(rs.getString(2));
            }

            return medio_pago;

        } catch (Exception ex) {

            System.out.println(ex.getMessage());
            return medio_pago;

        }
    }
    
  public boolean actualizarMedio_Pago(Medio_pago medio_pago) throws SQLException {
        boolean actualizado = false;
        String sql = "UPDATE medio_pago SET descripcion_mediopa=?  WHERE id_Mediopago=?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, medio_pago.getdescripcion_mediopa());
            ps.setInt(2, medio_pago.getid_Mediopago());
            
            if (ps.executeUpdate() > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el Medio de pago: " + e.getMessage());
        }
        return actualizado;
    }


    public boolean eliminarMedio_pago(int id) throws SQLException {
        boolean eliminado = false;
        String sql = "DELETE FROM medio_pago WHERE id_Mediopago = ?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            if (ps.executeUpdate() > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al eliminar el medio de pago  " + e.getMessage());
        }
        return eliminado;
    }
} 
