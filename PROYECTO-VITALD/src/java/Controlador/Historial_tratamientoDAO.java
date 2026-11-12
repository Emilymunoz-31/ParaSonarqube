package Controlador;

import Conexion.Conexion;
import Modelo.Historial_tratamiento;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Historial_tratamientoDAO {

    private static final Logger LOGGER = Logger.getLogger(Historial_tratamientoDAO.class.getName());
    private final Conexion conexion = new Conexion();

    public boolean insertarHistorial_tratamiento(Historial_tratamiento historialTratamiento) throws SQLException {
        String sql = "INSERT INTO historial_tratamiento (anio, costo, Tipo_tratamiento_id_Tipotratam) VALUES (?, ?, ?)";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, historialTratamiento.getanio());
            ps.setString(2, historialTratamiento.getcosto());
            ps.setInt(3, historialTratamiento.getTipo_tratamiento_id_Tipotratam());

            boolean insertado = ps.executeUpdate() > 0;
            if (insertado) {
                LOGGER.log(Level.INFO, "Historial del precio por tratamiento insertado con éxito.");
            }
            return insertado;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al insertar el historial de tratamiento", e);
            return false;
        }
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
            LOGGER.log(Level.SEVERE, "Error al listar el historial de tratamiento", e);
        }
        return historiales;
    }

    public Historial_tratamiento consultaHistorial_tratamiento(int idHistorial) {
        Historial_tratamiento historialTratamiento = null;
        String querySQL = "SELECT id_Historial, anio, costo, Tipo_tratamiento_id_Tipotratam FROM historial_tratamiento WHERE id_Historial = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(querySQL)) {

            ps.setInt(1, idHistorial);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    historialTratamiento = new Historial_tratamiento();
                    historialTratamiento.setid_Historial(rs.getInt(1));
                    historialTratamiento.setanio(rs.getString(2));
                    historialTratamiento.setcosto(rs.getString(3));
                    historialTratamiento.setTipo_tratamiento_id_Tipotratam(rs.getInt(4));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error al consultar el historial de tratamiento", ex);
        }
        return historialTratamiento;
    }

    public boolean actualizarHistorial_tratamiento(Historial_tratamiento historialTratamiento) throws SQLException {
        String sql = "UPDATE historial_tratamiento SET anio=?, costo=?, Tipo_tratamiento_id_Tipotratam=? WHERE id_Historial=?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, historialTratamiento.getanio());
            ps.setString(2, historialTratamiento.getcosto());
            ps.setInt(3, historialTratamiento.getTipo_tratamiento_id_Tipotratam());
            ps.setInt(4, historialTratamiento.getid_Historial());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar el historial de tratamiento", e);
            return false;
        }
    }

    public boolean eliminarHistorial_tratamiento(int idHistorial) throws SQLException {
        String sql = "DELETE FROM historial_tratamiento WHERE id_Historial = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idHistorial);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar el historial de tratamiento", e);
            return false;
        }
    }
}