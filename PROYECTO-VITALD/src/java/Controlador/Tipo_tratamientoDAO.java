package Controlador;

import Conexion.Conexion;
import Modelo.Tipo_tratamiento;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Tipo_tratamientoDAO {
    Conexion conexion = new Conexion();

    public boolean insertarTipo_tratamiento(Tipo_tratamiento tipo_tratamiento) {
        boolean insertado = false;
        // CORRECCIÓN: tipo_tratamiento y Categoria_Tratamiento_id_categoria exactos a la BD
        String sql = "INSERT INTO tipo_tratamiento (descripcion_tipotratam, costo, Categoria_Tratamiento_id_categoria) VALUES (?, ?, ?)";
        
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, tipo_tratamiento.getdescripcion_tipotratam());
            ps.setDouble(2, tipo_tratamiento.getcosto());
            ps.setInt(3, tipo_tratamiento.getCategoria_Tratamiento_id_Categoria()); 

            if (ps.executeUpdate() > 0) {
                insertado = true;
                System.out.println("Tipo de tratamiento insertado con exito.");
            }
            
        } catch (SQLException e) {
            System.err.println("Error al insertar tipo de tratamiento: " + e.getMessage());
        }
        return insertado;
    }

    public List<Tipo_tratamiento> listarTiposTratamiento() {
        List<Tipo_tratamiento> tratamientos = new ArrayList<>();
        // CORRECCIÓN: tipo_tratamiento en minúscula
        String sql = "SELECT id_Tipotratam, descripcion_tipotratam, costo, Categoria_Tratamiento_id_categoria FROM tipo_tratamiento ORDER BY descripcion_tipotratam";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Tipo_tratamiento tratamiento = new Tipo_tratamiento();
                tratamiento.setid_Tipotratam(rs.getInt("id_Tipotratam"));
                tratamiento.setdescripcion_tipotratam(rs.getString("descripcion_tipotratam"));
                tratamiento.setcosto(rs.getDouble("costo"));
                tratamiento.setCategoria_Tratamiento_id_Categoria(rs.getInt("Categoria_Tratamiento_id_categoria"));
                tratamientos.add(tratamiento);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar tipos de tratamiento: " + e.getMessage());
        }
        return tratamientos;
    }
    
   
    public Tipo_tratamiento consultaTipo_tratamiento(int id_Tipotratam) {
        Tipo_tratamiento tipo_tratamiento = null;
        // CORRECCIÓN: tipo_tratamiento en minúscula
        String sql = "SELECT id_Tipotratam, descripcion_tipotratam, costo, Categoria_Tratamiento_id_categoria FROM tipo_tratamiento WHERE id_Tipotratam = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id_Tipotratam);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tipo_tratamiento = new Tipo_tratamiento();
                    tipo_tratamiento.setid_Tipotratam(rs.getInt("id_Tipotratam"));
                    tipo_tratamiento.setdescripcion_tipotratam(rs.getString("descripcion_tipotratam"));
                    tipo_tratamiento.setcosto(rs.getDouble("costo"));
                    tipo_tratamiento.setCategoria_Tratamiento_id_Categoria(rs.getInt("Categoria_Tratamiento_id_categoria"));
                }
            }

        } catch (SQLException ex) {
            System.out.println("Error en consultaTipo_tratamiento: " + ex.getMessage());
        }
        return tipo_tratamiento;
    }
    
    public boolean actualizarTipo_tratamiento(Tipo_tratamiento tipo_tratamiento) {
        boolean actualizado = false;
        // CORRECCIÓN: tipo_tratamiento en minúscula
        String sql = "UPDATE tipo_tratamiento SET descripcion_tipotratam=?, costo=?, Categoria_Tratamiento_id_categoria=? WHERE id_Tipotratam=?";
        
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, tipo_tratamiento.getdescripcion_tipotratam());
            ps.setDouble(2, tipo_tratamiento.getcosto());
            ps.setInt(3, tipo_tratamiento.getCategoria_Tratamiento_id_Categoria());
            ps.setInt(4, tipo_tratamiento.getid_Tipotratam());
 
            if (ps.executeUpdate() > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el tipo de tratamiento: " + e.getMessage());
        }
        return actualizado;
    }

   
    public boolean eliminarTipo_tratamiento(int id) {
        boolean eliminado = false;
        String sql = "DELETE FROM tipo_tratamiento WHERE id_Tipotratam = ?";
        
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, id);
            if (ps.executeUpdate() > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al eliminar el tipo de tratamiento: " + e.getMessage());
        }
        return eliminado;
    }
}