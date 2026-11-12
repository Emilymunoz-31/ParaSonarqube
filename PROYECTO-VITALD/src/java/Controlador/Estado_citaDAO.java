package Controlador;

import Conexion.Conexion;
import Modelo.Estado_cita;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Estado_citaDAO {

    private static final Logger LOGGER = Logger.getLogger(Estado_citaDAO.class.getName());
    private final Conexion conexion = new Conexion();

    public boolean insertarEstado_cita(Estado_cita estadoCita) throws SQLException {
        String sql = "INSERT INTO estado_cita (descripcion_estadoci) VALUES (?)";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estadoCita.getdescripcion_estadoci());
            boolean insertado = ps.executeUpdate() > 0;

            if (insertado) {
                LOGGER.log(Level.INFO, "Estado de cita insertado con éxito.");
            }
            return insertado;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al insertar el estado de cita", e);
            return false;
        }
    }

    public List<Estado_cita> listarEstadosCita() {
        List<Estado_cita> estados = new ArrayList<>();
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
            LOGGER.log(Level.SEVERE, "Error al listar estados de cita", e);
        }
        return estados;
    }

    public Estado_cita consultaEstado_cita(int idEstadoCita) {
        Estado_cita estadoCita = null;
        String querySQL = "SELECT idEstado_cita, descripcion_estadoci FROM estado_cita WHERE idEstado_cita = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(querySQL)) {

            ps.setInt(1, idEstadoCita);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    estadoCita = new Estado_cita();
                    estadoCita.setidEstado_cita(rs.getInt(1));
                    estadoCita.setdescripcion_estadoci(rs.getString(2));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error al consultar el estado de cita", ex);
        }
        return estadoCita;
    }

    public boolean actualizarEstado_cita(Estado_cita estadoCita) throws SQLException {
        String sql = "UPDATE estado_cita SET descripcion_estadoci=? WHERE idEstado_cita=?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estadoCita.getdescripcion_estadoci());
            ps.setInt(2, estadoCita.getidEstado_cita());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar el estado de cita", e);
            return false;
        }
    }

    public boolean eliminarEstado_cita(int id) throws SQLException {
        String sql = "DELETE FROM estado_cita WHERE idEstado_cita = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar el estado de cita", e);
            return false;
        }
    }
}