package Controlador;

import Conexion.Conexion;
import Modelo.Rol;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RolDAO {
    Conexion conexion = new Conexion();

    public boolean insertarRol(Rol rol) throws SQLException {
        boolean insertado = false;
        String sql = "INSERT INTO rol (descripcion_rol) VALUES (?)";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, rol.getdescripcion_rol());

            if (ps.executeUpdate() > 0) {
                insertado = true;
            }
        } catch (SQLException e) {
            System.err.println("Error al insertar Rol: " + e.getMessage());
        }
        return insertado;
    }

    public List<Rol> listarRoles() {
        List<Rol> roles = new ArrayList<>();
        // Asegúrate de incluir el campo de estado/activo si tu tabla lo tiene, 
        // de lo contrario se ajusta según tu esquema actual de base de datos.
        String sql = "SELECT id_Rol, descripcion_rol FROM rol ORDER BY descripcion_rol";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Rol rol = new Rol();
                rol.setid_Rol(rs.getInt("id_Rol"));
                rol.setdescripcion_rol(rs.getString("descripcion_rol"));
                roles.add(rol);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar roles: " + e.getMessage());
        }
        return roles;
    }

    public Rol consultaRol(int id_Rol) {
        Rol rol = null;
        String querySQL = "SELECT id_Rol, descripcion_rol FROM rol WHERE id_Rol = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(querySQL)) {

            ps.setInt(1, id_Rol);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    rol = new Rol();
                    rol.setid_Rol(rs.getInt("id_Rol"));
                    rol.setdescripcion_rol(rs.getString("descripcion_rol"));
                }
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return rol;
    }

    public Integer obtenerIdPorDescripcion(String descripcion) {
        String sql = "SELECT id_Rol FROM rol WHERE LOWER(descripcion_rol) = LOWER(?) LIMIT 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, descripcion);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_Rol");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar rol: " + e.getMessage());
        }
        return null;
    }

    public boolean actualizarRol(Rol rol) throws SQLException {
        boolean actualizado = false;
        String sql = "UPDATE rol SET descripcion_rol=? WHERE id_Rol=?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, rol.getdescripcion_rol());
            ps.setInt(2, rol.getid_Rol());

            if (ps.executeUpdate() > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el rol: " + e.getMessage());
        }
        return actualizado;
    }

    // ==========================================================
    // NUEVOS MÉTODOS: ACTIVAR E INACTIVAR ROL (CAMBIO DE ESTADO)
    // ==========================================================
    public boolean cambiarEstadoRol(int idRol, boolean activo) {
        boolean cambiado = false;
        // Nota: Asegúrate de que tu tabla 'rol' tenga una columna booleana o tinyint llamada 'activo' o 'estado'.
        // Si tu columna se llama diferente (ej: 'estado'), cámbiala en el SQL de abajo.
        String sql = "UPDATE rol SET activo = ? WHERE id_Rol = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setBoolean(1, activo);
            ps.setInt(2, idRol);

            if (ps.executeUpdate() > 0) {
                cambiado = true;
            }
        } catch (SQLException e) {
            System.err.println("Error al cambiar estado del rol: " + e.getMessage());
        }
        return cambiado;
    }

    public boolean eliminarRol(int id) throws SQLException {
        boolean eliminado = false;
        String sql = "DELETE FROM rol WHERE id_Rol = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            if (ps.executeUpdate() > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al eliminar rol: " + e.getMessage());
        }
        return eliminado;
    }
    
    public List<Rol> listarRol() {
        List<Rol> roles = new ArrayList<>();
        String sql = "SELECT id_Rol, descripcion_rol FROM rol ORDER BY descripcion_rol";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Rol rol = new Rol();
                rol.setid_Rol(rs.getInt("id_Rol"));
                rol.setdescripcion_rol(rs.getString("descripcion_rol"));
                roles.add(rol);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar roles: " + e.getMessage());
        }
        return roles;
    }
    
}