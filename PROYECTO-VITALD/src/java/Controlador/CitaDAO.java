/* Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Conexion.Conexion;
import Modelo.Cita;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CitaDAO {

    Conexion conexion = new Conexion();

    public boolean insertarCita(Cita cita, String documentoPaciente) {
        return insertarCitaRetornandoId(cita, documentoPaciente) > 0;
    }

    public int insertarCitaRetornandoId(Cita cita, String documentoPaciente) {
        boolean insertado = false;
        int idPacienteEncontrado = 0;
        int idCitaGenerada = 0;

        String sqlBuscarPaciente = "SELECT id_Usuario FROM usuario WHERE TRIM(documento) = ?";
        
        String sqlInsertarCita = "INSERT INTO cita (fecha_hora, descripcion_cita, Paciente_id_Paciente, Usuario_Id_Usuario, Estado_cita_idEstado_cita, Tipo_tratamiento_id_Tipotratam) "
                               + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = conexion.getConn()) {
            
            try (PreparedStatement psBuscar = con.prepareStatement(sqlBuscarPaciente)) {
                psBuscar.setString(1, documentoPaciente == null ? "" : documentoPaciente.trim());
                ResultSet rs = psBuscar.executeQuery();

                if (rs.next()) {
                    idPacienteEncontrado = rs.getInt("id_Usuario");
                } else {
                    System.out.println("No se encontró al paciente con documento: " + documentoPaciente);
                    return 0; 
                }
            }

            try (PreparedStatement psInsertar = con.prepareStatement(sqlInsertarCita, Statement.RETURN_GENERATED_KEYS)) {
                
                psInsertar.setString(1, cita.getfecha_hora());
                psInsertar.setString(2, cita.getdescripcion_cita());
                psInsertar.setInt(3, idPacienteEncontrado);
                psInsertar.setInt(4, cita.getUsuario_id_Usuario());
                psInsertar.setInt(5, cita.getEstado_cita_idEstado_cita());
                psInsertar.setInt(6, cita.getTipo_Tratamiento_id_Tipotratam());

                if (psInsertar.executeUpdate() > 0) {
                    insertado = true;
                    try (ResultSet rs = psInsertar.getGeneratedKeys()) {
                        if (rs.next()) {
                            idCitaGenerada = rs.getInt(1);
                        }
                    }
                    System.out.println("Cita guardada correctamente con el Usuario_id_Usuario: " + idPacienteEncontrado);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al insertar la cita en CitaDAO: " + e.getMessage());
        }

        return insertado ? idCitaGenerada : 0;
    }

    public boolean existePacientePorDocumento(String documentoPaciente) {
        String sql = "SELECT 1 FROM usuario WHERE TRIM(documento) = ? LIMIT 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, documentoPaciente == null ? "" : documentoPaciente.trim());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error al validar paciente por documento: " + e.getMessage());
        }
        return false;
    }

public List<Cita> listarCitas() {
    List<Cita> citas = new ArrayList<>();
    // NUEVO: agregamos p.telefono a la consulta SQL
    String sql = "SELECT c.id_Cita, c.fecha_hora, c.descripcion_cita, c.Usuario_Id_Usuario, "
            + "c.Estado_cita_idEstado_cita, c.Tipo_tratamiento_id_Tipotratam, "
            + "CONCAT(COALESCE(p.nombreus, ''), ' ', COALESCE(p.apellido, '')) AS nombre_paciente, "
            + "CONCAT(COALESCE(o.nombreus, ''), ' ', COALESCE(o.apellido, '')) AS nombre_odontologo, "
            + "ec.descripcion_estadoci, tt.descripcion_tipotratam, tt.costo, "
            + "p.telefono AS telefono_paciente "
            + "FROM cita c "
            + "LEFT JOIN usuario p ON c.Paciente_id_Paciente = p.id_Usuario "
            + "LEFT JOIN usuario o ON c.Usuario_Id_Usuario = o.id_Usuario "
            + "LEFT JOIN estado_cita ec ON c.Estado_cita_idEstado_cita = ec.idEstado_cita "
            + "LEFT JOIN tipo_tratamiento tt ON c.Tipo_tratamiento_id_Tipotratam = tt.id_Tipotratam "
            + "ORDER BY c.fecha_hora DESC";

    try (Connection con = conexion.getConn();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Cita cita = new Cita();
            cita.setid_Cita(rs.getInt("id_Cita"));
            cita.setfecha_hora(rs.getString("fecha_hora"));
            cita.setdescripcion_cita(rs.getString("descripcion_cita"));
            cita.setUsuario_id_Usuario(rs.getInt("Usuario_Id_Usuario"));
            cita.setEstado_cita_idEstado_cita(rs.getInt("Estado_cita_idEstado_cita"));
            cita.setTipo_Tratamiento_id_Tipotratam(rs.getInt("Tipo_tratamiento_id_Tipotratam"));
            cita.setNombrePaciente(rs.getString("nombre_paciente"));
            cita.setNombreOdontologo(rs.getString("nombre_odontologo"));
            cita.setDescripcionEstadoCita(rs.getString("descripcion_estadoci"));
            cita.setDescripcionTratamiento(rs.getString("descripcion_tipotratam"));
            cita.setCostoTratamiento(rs.getDouble("costo"));
            // NUEVO: guardamos el teléfono del paciente
            cita.setTelefonoPaciente(rs.getString("telefono_paciente"));

            citas.add(cita);
        }
    } catch (SQLException e) {
        System.err.println("Error al listar citas: " + e.getMessage());
    }
    return citas;
}

    public Cita consultaCita(int id_Cita) {
        Cita cita = null;
        // NUEVO: Agregamos tt.costo a la consulta SQL
        String sql = "SELECT c.id_Cita, c.fecha_hora, c.descripcion_cita, c.Usuario_Id_Usuario, "
                + "c.Estado_cita_idEstado_cita, c.Tipo_tratamiento_id_Tipotratam, "
                + "CONCAT(COALESCE(p.nombreus, ''), ' ', COALESCE(p.apellido, '')) AS nombre_paciente, "
                + "CONCAT(COALESCE(o.nombreus, ''), ' ', COALESCE(o.apellido, '')) AS nombre_odontologo, "
                + "ec.descripcion_estadoci, tt.descripcion_tipotratam, tt.costo "
                + "FROM cita c "
                + "LEFT JOIN usuario p ON c.Paciente_id_Paciente = p.id_Usuario "
                + "LEFT JOIN usuario o ON c.Usuario_Id_Usuario = o.id_Usuario "
                + "LEFT JOIN estado_cita ec ON c.Estado_cita_idEstado_cita = ec.idEstado_cita "
                + "LEFT JOIN tipo_tratamiento tt ON c.Tipo_tratamiento_id_Tipotratam = tt.id_Tipotratam "
                + "WHERE c.id_Cita = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id_Cita);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                cita = new Cita();
                cita.setid_Cita(rs.getInt("id_Cita"));
                cita.setfecha_hora(rs.getString("fecha_hora"));
                cita.setdescripcion_cita(rs.getString("descripcion_cita"));
                cita.setUsuario_id_Usuario(rs.getInt("Usuario_Id_Usuario"));
                cita.setEstado_cita_idEstado_cita(rs.getInt("Estado_cita_idEstado_cita"));
                cita.setTipo_Tratamiento_id_Tipotratam(rs.getInt("Tipo_tratamiento_id_Tipotratam"));
                cita.setNombrePaciente(rs.getString("nombre_paciente"));
                cita.setNombreOdontologo(rs.getString("nombre_odontologo"));
                cita.setDescripcionEstadoCita(rs.getString("descripcion_estadoci"));
                cita.setDescripcionTratamiento(rs.getString("descripcion_tipotratam"));
                // NUEVO: Guardamos el costo en el objeto Cita
                cita.setCostoTratamiento(rs.getDouble("costo"));
            }
        } catch (SQLException ex) {
            System.err.println("Error al consultar: " + ex.getMessage());
        }
        return cita;
    }

    public boolean actualizarCita(Cita cita) throws SQLException {
        boolean actualizado = false;
        
        String sql = "UPDATE cita SET fecha_hora=?, descripcion_cita=?, Usuario_Id_Usuario=?, Estado_cita_idEstado_cita=?, Tipo_tratamiento_id_Tipotratam=? WHERE id_Cita=?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, cita.getfecha_hora());
            ps.setString(2, cita.getdescripcion_cita());
            ps.setInt(3, cita.getUsuario_id_Usuario());
            ps.setInt(4, cita.getEstado_cita_idEstado_cita());
            ps.setInt(5, cita.getTipo_Tratamiento_id_Tipotratam());
            ps.setInt(6, cita.getid_Cita());

            if (ps.executeUpdate() > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.err.println("Error al actualizar cita: " + e.getMessage());
        }
        return actualizado;
    }

    public boolean eliminarCita(int id) throws SQLException {
        boolean eliminado = false;
        String sqlEliminarAbonos = "DELETE FROM abono WHERE Pago_id_Pago IN (SELECT id_Pago FROM pago WHERE Cita_id_Cita = ?)";
        String sqlEliminarPagos = "DELETE FROM pago WHERE Cita_id_Cita = ?";
        String sqlEliminarCita = "DELETE FROM cita WHERE id_Cita = ?";

        try (Connection con = conexion.getConn()) {
            con.setAutoCommit(false);
            try (PreparedStatement psAbonos = con.prepareStatement(sqlEliminarAbonos);
                 PreparedStatement psPagos = con.prepareStatement(sqlEliminarPagos);
                 PreparedStatement psCita = con.prepareStatement(sqlEliminarCita)) {
                psAbonos.setInt(1, id);
                psAbonos.executeUpdate();

                psPagos.setInt(1, id);
                psPagos.executeUpdate();

                psCita.setInt(1, id);
                eliminado = psCita.executeUpdate() > 0;
                con.commit();
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        } catch (SQLException e) {
            System.err.println("Error al eliminar la cita: " + e.getMessage());
        }
        return eliminado;
    }

    public List<Cita> obtenerControlesOrtodonciaPorDocumento(String documentoPaciente) {
        List<Cita> listaControles = new ArrayList<>();
        
        String sql = "SELECT c.id_Cita, c.fecha_hora, c.descripcion_cita, "
                   + "ec.descripcion_estadoci, tt.descripcion_tipotratam, tt.costo, "
                   + "CONCAT(COALESCE(u.nombreus, ''), ' ', COALESCE(u.apellido, '')) AS nombre_paciente, "
                   + "CONCAT(COALESCE(o.nombreus, ''), ' ', COALESCE(o.apellido, '')) AS nombre_odontologo "
                   + "FROM cita c "
                   + "JOIN usuario u ON c.Paciente_id_Paciente = u.id_Usuario "
                   + "LEFT JOIN usuario o ON c.Usuario_Id_Usuario = o.id_Usuario "
                   + "JOIN tipo_tratamiento tt ON c.Tipo_tratamiento_id_Tipotratam = tt.id_Tipotratam "
                   + "LEFT JOIN categoria_tratamiento ct ON tt.categoria_Tratamiento_id_categoria = ct.id_Categoria "
                   + "JOIN estado_cita ec ON c.Estado_cita_idEstado_cita = ec.idEstado_cita "
                   + "WHERE TRIM(u.documento) = ? "
                   + "AND (LOWER(tt.descripcion_tipotratam) LIKE '%ortodoncia%' "
                   + "     OR LOWER(ct.nombre_categoria) LIKE '%ortodoncia%') "
                   + "ORDER BY c.fecha_hora ASC";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, documentoPaciente == null ? "" : documentoPaciente.trim());
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cita cita = new Cita();
                    cita.setid_Cita(rs.getInt("id_Cita"));
                    cita.setfecha_hora(rs.getString("fecha_hora"));
                    cita.setdescripcion_cita(rs.getString("descripcion_cita"));
                    cita.setNombrePaciente(rs.getString("nombre_paciente"));
                    cita.setNombreOdontologo(rs.getString("nombre_odontologo"));
                    cita.setDescripcionEstadoCita(rs.getString("descripcion_estadoci"));
                    cita.setDescripcionTratamiento(rs.getString("descripcion_tipotratam"));

                    
                    listaControles.add(cita);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al consultar controles de ortodoncia: " + e.getMessage());
        }
        return listaControles;
    }

    public void actualizarEstadoCita(int cita, int nuevoEstadoCita) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}