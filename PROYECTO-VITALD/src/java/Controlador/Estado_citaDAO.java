package Controlador;

import Conexion.Conexion;
import Modelo.Estado_cita;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Estado_citaDAO {
       Conexion conexion = new Conexion();

   public boolean insertarEstado_cita(Estado_cita estado_cita) throws SQLException {
    boolean insertado = false;
    // CORRECCIÓN: 'estado_cita' en minúscula
    String sql = "INSERT INTO estado_cita (descripcion_estadoci) VALUES (?)";
    
    try (Connection con = conexion.getConn();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, estado_cita.getdescripcion_estadoci());
        
        int filasAfectadas = ps.executeUpdate();
        if (filasAfectadas > 0) {
            insertado = true;
            System.out.println("Estado de cita insertado con exito.");
        }
        
    } catch (SQLException e) {
        System.err.println("Estado de cita: " + e.getMessage());
    }
    return insertado;
}

    public java.util.List<Estado_cita> listarEstadosCita() {
        java.util.List<Estado_cita> estados = new java.util.ArrayList<>();
        // CORRECCIÓN: 'estado_cita' en minúscula
        String sql = "SELECT idEstado_cita, descripcion_estadoci FROM estado_cita ORDER BY descripcion_estadoci";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Estado_cita estado = new Estado_cita();
                estado.setidEstado_cita(rs.getInt("idEstado_cita"));
                estado.setdescripcion_estadoci(rs.getString("descripcion_estadoci"));
                estados.add(estado);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar estados de cita: " + e.getMessage());
        }
        return estados;
    }
    
    
    
    public Estado_cita consultaEstado_cita(int idEstado_cita) {

        Estado_cita estado_cita = null;
        Conexion conexion = new Conexion();
        Connection con = conexion.getConn();

        try {
            // CORRECCIÓN: 'estado_cita' en minúscula
            String querySQL = "SELECT idEstado_cita, descripcion_estadoci FROM estado_cita WHERE idEstado_cita = ?";

            PreparedStatement ps = con.prepareStatement(querySQL);
            ps.setInt(1, idEstado_cita);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                estado_cita = new Estado_cita();
                estado_cita.setidEstado_cita(rs.getInt(1));
                estado_cita.setdescripcion_estadoci(rs.getString(2));
            }

            return estado_cita;

        } catch (Exception ex) {

            System.out.println(ex.getMessage());
            return estado_cita;

        }
    }
    
  public boolean actualizarEstado_cita(Estado_cita estado_cita) throws SQLException {
        boolean actualizado = false;
        // CORRECCIÓN: 'estado_cita' en minúscula
        String sql = "UPDATE estado_cita SET descripcion_estadoci=?  WHERE idEstado_cita=?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, estado_cita.getdescripcion_estadoci());
            ps.setInt(2, estado_cita.getidEstado_cita());
            
            if (ps.executeUpdate() > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el Estado de cita: " + e.getMessage());
        }
        return actualizado;
    }


    public boolean eliminarEstado_cita(int id) throws SQLException {
        boolean eliminado = false;
        // Este ya estaba perfecto en minúsculas
        String sql = "DELETE FROM estado_cita WHERE idEstado_cita = ?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            if (ps.executeUpdate() > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al eliminar el Estado de cita  " + e.getMessage());
        }
        return eliminado;
    }
}