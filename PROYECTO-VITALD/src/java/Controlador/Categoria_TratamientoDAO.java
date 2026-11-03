package Controlador;

import Conexion.Conexion;
import Modelo.Categoria_Tratamiento;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Categoria_TratamientoDAO {
    
    Conexion conexion = new Conexion();

    // 1. INSERTAR
    public boolean insertarCategoria_Tratamiento(Categoria_Tratamiento categoria) {
        boolean insertado = false;
        // CORRECCIÓN: 'categoria_tratamiento' en minúsculas
        String sql = "INSERT INTO categoria_tratamiento (nombre_categoria) VALUES (?)";
        
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, categoria.getnombre_categoria());

            if (ps.executeUpdate() > 0) {
                insertado = true;
                System.out.println("Categoría de tratamiento insertada con éxito.");
            }
            
        } catch (SQLException e) {
            System.err.println("Error al insertar categoría de tratamiento: " + e.getMessage());
        }
        return insertado;
    }

    public List<Categoria_Tratamiento> listarCategorias() {
        List<Categoria_Tratamiento> categorias = new ArrayList<>();
        // CORRECCIÓN: 'categoria_tratamiento' en minúsculas
        String sql = "SELECT id_Categoria, nombre_categoria FROM categoria_tratamiento ORDER BY nombre_categoria";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Categoria_Tratamiento categoria = new Categoria_Tratamiento();
                categoria.setid_Categoria(rs.getInt("id_Categoria"));
                categoria.setnombre_categoria(rs.getString("nombre_categoria"));
                categorias.add(categoria);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar categorias de tratamiento: " + e.getMessage());
        }
        return categorias;
    }
    
   
    public Categoria_Tratamiento consultaCategoria_Tratamiento(int id_Categoria) {
        Categoria_Tratamiento categoria = null;
        // CORRECCIÓN: 'categoria_tratamiento' en minúsculas
        String sql = "SELECT id_Categoria, nombre_categoria FROM categoria_tratamiento WHERE id_Categoria = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id_Categoria);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    categoria = new Categoria_Tratamiento();
                    categoria.setid_Categoria(rs.getInt("id_Categoria"));
                    categoria.setnombre_categoria(rs.getString("nombre_categoria"));
                }
            }

        } catch (SQLException ex) {
            System.out.println("Error en consultaCategoria_Tratamiento: " + ex.getMessage());
        }
        return categoria;
    }
    
 
    public boolean actualizarCategoria_Tratamiento(Categoria_Tratamiento categoria) {
        boolean actualizado = false;
        // CORRECCIÓN: 'categoria_tratamiento' en minúsculas
        String sql = "UPDATE categoria_tratamiento SET nombre_categoria=? WHERE id_Categoria=?";
        
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, categoria.getnombre_categoria());
            ps.setInt(2, categoria.getid_Categoria());
 
            if (ps.executeUpdate() > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar la categoría de tratamiento: " + e.getMessage());
        }
        return actualizado;
    }


    public boolean eliminarCategoria_Tratamiento(int id) {
        boolean eliminado = false;
        // CORRECCIÓN: 'categoria_tratamiento' en minúsculas
        String sql = "DELETE FROM categoria_tratamiento WHERE id_Categoria = ?";
        
        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, id);
            if (ps.executeUpdate() > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al eliminar la categoría de tratamiento: " + e.getMessage());
        }
        return eliminado;
    }
}