package Controlador;

import Conexion.Conexion;
import Modelo.Historial_tratamiento;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Historial_tratamientoDAO {
       Conexion conexion = new Conexion();

   public boolean insertarHistorial_tratamiento(Historial_tratamiento historial_tratamiento) throws SQLException {
    boolean insertado = false;
    String sql = "INSERT INTO historial_tratamiento (anio, costo, Tipo_tratamiento_id_Tipotratam) VALUES (?, ?, ?)";
    
    try (Connection con = conexion.getConn();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, historial_tratamiento.getanio());
        ps.setString(2, historial_tratamiento.getcosto());
        ps.setInt(3, historial_tratamiento.getTipo_tratamiento_id_Tipotratam());

        int filasAfectadas = ps.executeUpdate();
        if (filasAfectadas > 0) {
            insertado = true;
            System.out.println("Historial del precio por tratamiento insertado con exito.");
        }
        
    } catch (SQLException e) {
        System.err.println("Historial tratamiento: " + e.getMessage());
    }
    return insertado;
}

    public List<Historial_tratamiento> listarHistorialesTratamiento() {
        List<Historial_tratamiento> historiales = new ArrayList<>();
        String sql = "SELECT id_Historial, anio, costo, Tipo_tratamiento_id_Tipotratam FROM historial_tratamiento ORDER BY anio DESC, id_Historial DESC";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Historial_tratamiento historial = new Historial_tratamiento();
                historial.setid_Historial(rs.getInt("id_Historial"));
                historial.setanio(rs.getString("anio"));
                historial.setcosto(rs.getString("costo"));
                historial.setTipo_tratamiento_id_Tipotratam(rs.getInt("Tipo_tratamiento_id_Tipotratam"));
                historiales.add(historial);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar historial de tratamiento: " + e.getMessage());
        }
        return historiales;
    }
    
    
    
    public Historial_tratamiento consultaHistorial_tratamiento(int id_Historial) {

        Historial_tratamiento historial_tratamiento = null;
        Conexion conexion = new Conexion();
        Connection con = conexion.getConn();

        try {
            String querySQL = "SELECT id_Historial, anio, costo, Tipo_tratamiento_id_Tipotratam FROM historial_tratamiento WHERE id_Historial = ?";

            PreparedStatement ps = con.prepareStatement(querySQL);
            ps.setInt(1, id_Historial);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                historial_tratamiento = new Historial_tratamiento();
                historial_tratamiento.setid_Historial(rs.getInt(1));
                historial_tratamiento.setanio(rs.getString(2));
                historial_tratamiento.setcosto(rs.getString(3));
                historial_tratamiento.setTipo_tratamiento_id_Tipotratam(rs.getInt(4));
            }

            return historial_tratamiento;

        } catch (Exception ex) {

            System.out.println(ex.getMessage());
            return historial_tratamiento;

        }
    }
    
  public boolean actualizarHistorial_tratamiento(Historial_tratamiento historial_tratamiento) throws SQLException {
        boolean actualizado = false;
        String sql = "UPDATE historial_tratamiento SET anio=?, costo=?, Tipo_tratamiento_id_Tipotratam=? WHERE id_Historial=?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, historial_tratamiento.getanio());
            ps.setString(2, historial_tratamiento.getcosto());
            ps.setInt(3, historial_tratamiento.getTipo_tratamiento_id_Tipotratam());
            ps.setInt(4, historial_tratamiento.getid_Historial());
            if (ps.executeUpdate() > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el Historial de tratamiento: " + e.getMessage());
        }
        return actualizado;
    }


    public boolean eliminarHistorial_tratamiento(int id_Historial) throws SQLException {
        boolean eliminado = false;
        String sql = "DELETE FROM historial_tratamiento WHERE id_Historial = ?";
        Conexion conexion = new Conexion();
        Connection con = (Connection) conexion.getConn();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id_Historial);
            if (ps.executeUpdate() > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al eliminar el historial de tratamiento:  " + e.getMessage());
        }
        return eliminado;
    }
}