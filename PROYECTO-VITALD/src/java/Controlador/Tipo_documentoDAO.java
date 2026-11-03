package Controlador;

import Conexion.Conexion;
import Modelo.Tipo_documento;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Tipo_documentoDAO {
    Conexion conexion = new Conexion();

    public boolean insertarTipo_documento(Tipo_documento tipo_documento) throws SQLException {
        boolean insertado = false;
        String sql = "INSERT INTO tipo_documento (descripcion_tipodoc) VALUES (?)";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, tipo_documento.getdescripcion_tipodoc());

            if (ps.executeUpdate() > 0) {
                insertado = true;
            }
        } catch (SQLException e) {
            System.err.println("Error al insertar tipo de documento: " + e.getMessage());
        }
        return insertado;
    }

    public List<Tipo_documento> listarTiposDocumento() {
        List<Tipo_documento> tiposDocumento = new ArrayList<>();
        String sql = "SELECT id_Tipodocumento, descripcion_tipodoc FROM tipo_documento ORDER BY descripcion_tipodoc";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Tipo_documento tipoDocumento = new Tipo_documento();
                tipoDocumento.setid_Tipodocumento(rs.getInt("id_Tipodocumento"));
                tipoDocumento.setdescripcion_tipodoc(rs.getString("descripcion_tipodoc"));
                tiposDocumento.add(tipoDocumento);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar tipos de documento: " + e.getMessage());
        }
        return tiposDocumento;
    }

    public Tipo_documento consultaTipo_documento(int id_Tipodocumento) {
        Tipo_documento tipo_documento = null;
        String querySQL = "SELECT id_Tipodocumento, descripcion_tipodoc FROM tipo_documento WHERE id_Tipodocumento = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(querySQL)) {

            ps.setInt(1, id_Tipodocumento);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tipo_documento = new Tipo_documento();
                    tipo_documento.setid_Tipodocumento(rs.getInt("id_Tipodocumento"));
                    tipo_documento.setdescripcion_tipodoc(rs.getString("descripcion_tipodoc"));
                }
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return tipo_documento;
    }

    public Integer obtenerIdPorDescripcion(String descripcion) {
        String sql = "SELECT id_Tipodocumento FROM tipo_documento WHERE LOWER(descripcion_tipodoc) = LOWER(?) LIMIT 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, descripcion);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_Tipodocumento");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar tipo de documento: " + e.getMessage());
        }
        return null;
    }

    public boolean actualizarTipo_documento(Tipo_documento tipo_documento) throws SQLException {
        boolean actualizado = false;
        String sql = "UPDATE tipo_documento SET descripcion_tipodoc=? WHERE id_Tipodocumento=?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tipo_documento.getdescripcion_tipodoc());
            ps.setInt(2, tipo_documento.getid_Tipodocumento());

            if (ps.executeUpdate() > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el tipo de documento: " + e.getMessage());
        }
        return actualizado;
    }

    public boolean eliminarTipo_documento(int id) throws SQLException {
        boolean eliminado = false;
        String sql = "DELETE FROM tipo_documento WHERE id_Tipodocumento = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            if (ps.executeUpdate() > 0) {
                eliminado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al eliminar el tipo de documento: " + e.getMessage());
        }
        return eliminado;
    }
}
