package Controlador;

import Conexion.Conexion;
import Modelo.Estado_pago;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Estado_pagoDAO {
       Conexion conexion = new Conexion();

   public boolean insertarEstado_pago(Estado_pago estado_pago) throws SQLException {
    boolean insertado = false;
    // CORRECCIÓN: 'estado_pago' en minúscula
    String sql = "INSERT INTO estado_pago (descripcion_estadop) VALUES (?)";
    
    try (Connection con = conexion.getConn();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, estado_pago.getdescripcion_estadop());
        
        int filasAfectadas = ps.executeUpdate();
        if (filasAfectadas > 0) {
            insertado = true;
            System.out.println("Estado de pago insertado con exito.");
        }
        
    } catch (SQLException e) {
        System.err.println("Estado de pago: " + e.getMessage());
    }
    return insertado;
}

    public java.util.List<Estado_pago> listarEstadosPago() {
        java.util.List<Estado_pago> estados = new java.util.ArrayList<>();
        // CORRECCIÓN: 'estado_pago' en minúscula
        String sql = "SELECT id_Estadopago, descripcion_estadop FROM estado_pago ORDER BY descripcion_estadop";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Estado_pago estado = new Estado_pago();
                estado.setid_Estadopago(rs.getInt("id_Estadopago"));
                estado.setdescripcion_estadop(rs.getString("descripcion_estadop"));
                estados.add(estado);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar estados de pago: " + e.getMessage());
        }
        return estados;
    }
    
    
    
    public Estado_pago consultaEstado_pago(int id_Estadopago) {

        Estado_pago estado_pago = null;
        Conexion conexion = new Conexion();
        Connection con = conexion.getConn();

        try {
            // CORRECCIÓN: 'estado_pago' en minúscula
            String querySQL = "SELECT id_Estadopago, descripcion_estadop FROM estado_pago WHERE id_Estadopago = ?";

            PreparedStatement ps = con.prepareStatement(querySQL);
            ps.setInt(1, id_Estadopago);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                estado_pago = new Estado_pago();
                estado_pago.setid_Estadopago(rs.getInt(1));
                estado_pago.setdescripcion_estadop(rs.getString(2));
            }

            return estado_pago;

        } catch (Exception ex) {

            System.out.println(ex.getMessage());
            return estado_pago;

        }
    }
    
  public boolean actualizarEstado_Pago(Estado_pago estado_pago) throws SQLException {
        boolean actualizado = false;
        // CORRECCIÓN: 'estado_pago' en minúscula
        String sql = "UPDATE estado_pago SET descripcion_estadop=?  WHERE id_Estadopago=?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, estado_pago.getdescripcion_estadop());
            ps.setInt(2, estado_pago.getid_Estadopago());
            
            if (ps.executeUpdate() > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el Estado de pago: " + e.getMessage());
        }
        return actualizado;
    }


    public boolean eliminarEstado_pago(int id) throws SQLException {
        boolean eliminado = false;
        // Este ya estaba perfecto
        String sql = "DELETE FROM estado_pago WHERE id_Estadopago = ?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            if (ps.executeUpdate() > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al eliminar el Estado de pago  " + e.getMessage());
        }
        return eliminado;
    }
}