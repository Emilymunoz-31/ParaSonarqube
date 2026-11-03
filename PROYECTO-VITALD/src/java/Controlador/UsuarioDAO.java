package Controlador;

import Conexion.Conexion;
import Modelo.Rol;
import Modelo.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    Conexion conexion = new Conexion();

    public String obtenerRolUsuario(String documento, String contrasena) {
        String rol = null;
        String sql = "SELECT r.descripcion_rol FROM usuario u "
                + "INNER JOIN rol r ON u.Rol_id_Rol = r.id_Rol "
                + "WHERE TRIM(u.documento) = ? AND u.contrasena = ? AND COALESCE(u.activo, 1) = 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, documento == null ? "" : documento.trim());
            ps.setString(2, contrasena == null ? "" : contrasena.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    rol = rs.getString("descripcion_rol");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error en obtenerRolUsuario: " + e.getMessage());
        }
        return rol;
    }

    public boolean actualizarPerfil(Usuario usuario) {
        boolean actualizado = false;
        String sql = "UPDATE usuario SET nombreus = ?, apellido = ?, correo = ?, telefono = ? "
                + "WHERE documento = ? AND COALESCE(activo, 1) = 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario.getNombreus());
            ps.setString(2, usuario.getApellido());
            ps.setString(3, usuario.getCorreo());
            ps.setString(4, usuario.getTelefono());
            ps.setString(5, usuario.getDocumento());
            actualizado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar el perfil del usuario: " + e.getMessage());
        }
        return actualizado;
    }

    public Usuario validar(String documento, String contrasena) {
        Usuario usuario = null;
        String sql = "SELECT u.*, r.descripcion_rol "
                + "FROM usuario u "
                + "LEFT JOIN rol r ON u.Rol_id_Rol = r.id_Rol "
                + "WHERE TRIM(u.documento) = ? AND u.contrasena = ? AND COALESCE(u.activo, 1) = 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, documento == null ? "" : documento.trim());
            ps.setString(2, contrasena == null ? "" : contrasena.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = mapearUsuarioCompleto(rs);
                    usuario.setDescripcionRol(rs.getString("descripcion_rol"));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error en validar: " + e.getMessage());
        }
        return usuario;
    }

    public List<Usuario> listarUsuarios() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT u.id_Usuario, u.nombreus, u.apellido, u.documento, u.telefono, u.correo, "
                + "u.activo, u.Rol_id_Rol, r.descripcion_rol "
                + "FROM usuario u LEFT JOIN rol r ON u.Rol_id_Rol = r.id_Rol "
                + "ORDER BY r.descripcion_rol, u.activo DESC, u.nombreus, u.apellido";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId_Usuario(rs.getInt("id_Usuario"));
                usuario.setNombreus(rs.getString("nombreus"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setDocumento(rs.getString("documento"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setRol_id_Rol(rs.getInt("Rol_id_Rol"));
                usuario.setDescripcionRol(rs.getString("descripcion_rol"));
                usuario.setActivo(rs.getBoolean("activo"));
                usuarios.add(usuario);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar usuarios: " + e.getMessage());
        }
        return usuarios;
    }

    public boolean existeDocumento(String documento) {
        String sql = "SELECT 1 FROM usuario WHERE TRIM(documento) = ? LIMIT 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, documento == null ? "" : documento.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error al validar documento duplicado: " + e.getMessage());
        }
        return false;
    }

    public boolean existeCorreo(String correo) {
        String sql = "SELECT 1 FROM usuario WHERE LOWER(TRIM(correo)) = LOWER(?) LIMIT 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo == null ? "" : correo.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error al validar correo duplicado: " + e.getMessage());
        }
        return false;
    }

    public List<Usuario> listarUsuariosPorRol(String descripcionRol) {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT u.id_Usuario, u.nombreus, u.apellido, u.documento, u.activo, r.descripcion_rol "
                + "FROM usuario u INNER JOIN rol r ON u.Rol_id_Rol = r.id_Rol "
                + "WHERE LOWER(r.descripcion_rol) = LOWER(?) AND COALESCE(u.activo, 1) = 1 "
                + "ORDER BY u.nombreus, u.apellido";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, descripcionRol);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setId_Usuario(rs.getInt("id_Usuario"));
                    usuario.setNombreus(rs.getString("nombreus"));
                    usuario.setApellido(rs.getString("apellido"));
                    usuario.setDocumento(rs.getString("documento"));
                    usuario.setDescripcionRol(rs.getString("descripcion_rol"));
                    usuario.setActivo(rs.getBoolean("activo"));
                    usuarios.add(usuario);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al listar usuarios por rol: " + e.getMessage());
        }
        return usuarios;
    }

    public List<Usuario> listarOdontologos() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT u.id_Usuario, u.nombreus, u.apellido, u.documento, u.activo, r.descripcion_rol "
                + "FROM usuario u LEFT JOIN rol r ON u.Rol_id_Rol = r.id_Rol "
                + "WHERE COALESCE(u.activo, 1) = 1 "
                + "AND (LOWER(COALESCE(r.descripcion_rol, '')) LIKE '%odontologo%' OR u.Rol_id_Rol = 1) "
                + "ORDER BY u.nombreus, u.apellido";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId_Usuario(rs.getInt("id_Usuario"));
                usuario.setNombreus(rs.getString("nombreus"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setDocumento(rs.getString("documento"));
                usuario.setDescripcionRol(rs.getString("descripcion_rol"));
                usuario.setActivo(rs.getBoolean("activo"));
                usuarios.add(usuario);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar odontologos: " + e.getMessage());
        }
        return usuarios;
    }

    // NUEVO: lista solo pacientes (mismo criterio que ya usa buscarPacientes()),
    // necesario para precargar el buscador de pacientes en la app móvil.
    public List<Usuario> listarPacientes() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT u.id_Usuario, u.nombreus, u.apellido, u.documento, u.telefono, u.correo, "
                + "u.activo, r.descripcion_rol "
                + "FROM usuario u LEFT JOIN rol r ON u.Rol_id_Rol = r.id_Rol "
                + "WHERE COALESCE(u.activo, 1) = 1 "
                + "AND (LOWER(COALESCE(r.descripcion_rol, '')) LIKE '%paciente%' OR u.Rol_id_Rol = 3) "
                + "ORDER BY u.nombreus, u.apellido";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId_Usuario(rs.getInt("id_Usuario"));
                usuario.setNombreus(rs.getString("nombreus"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setDocumento(rs.getString("documento"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setDescripcionRol(rs.getString("descripcion_rol"));
                usuario.setActivo(rs.getBoolean("activo"));
                usuarios.add(usuario);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar pacientes: " + e.getMessage());
        }
        return usuarios;
    }

    public Usuario buscarPorDocumento(String documento) {
        Usuario usuario = null;
        String sql = "SELECT u.id_Usuario, u.nombreus, u.apellido, u.documento, u.telefono, u.correo, "
                + "u.activo, td.descripcion_tipodoc, r.descripcion_rol "
                + "FROM usuario u LEFT JOIN rol r ON u.Rol_id_Rol = r.id_Rol "
                + "LEFT JOIN tipo_documento td ON u.Tipo_documento_id_Tipodocumento = td.id_Tipodocumento "
                + "WHERE TRIM(u.documento) = ? AND COALESCE(u.activo, 1) = 1 LIMIT 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, documento == null ? "" : documento.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId_Usuario(rs.getInt("id_Usuario"));
                    usuario.setNombreus(rs.getString("nombreus"));
                    usuario.setApellido(rs.getString("apellido"));
                    usuario.setDocumento(rs.getString("documento"));
                    usuario.setTelefono(rs.getString("telefono"));
                    usuario.setCorreo(rs.getString("correo"));
                    usuario.setDescripcionRol(rs.getString("descripcion_rol"));
                    usuario.setActivo(rs.getBoolean("activo"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar usuario por documento: " + e.getMessage());
        }
        return usuario;
    }

    public List<Usuario> buscarPacientes(String termino) {
        List<Usuario> pacientes = new ArrayList<>();
        String busqueda = termino == null ? "" : termino.trim();
        if (busqueda.length() < 2) {
            return pacientes;
        }

        String sql = "SELECT u.id_Usuario, u.nombreus, u.apellido, u.documento, u.telefono, u.correo, "
                + "u.activo, td.descripcion_tipodoc, r.descripcion_rol "
                + "FROM usuario u "
                + "LEFT JOIN rol r ON u.Rol_id_Rol = r.id_Rol "
                + "LEFT JOIN tipo_documento td ON u.Tipo_documento_id_Tipodocumento = td.id_Tipodocumento "
                + "WHERE COALESCE(u.activo, 1) = 1 "
                + "AND (LOWER(COALESCE(r.descripcion_rol, '')) LIKE '%paciente%' OR u.Rol_id_Rol = 3) "
                + "AND (LOWER(CONCAT(COALESCE(u.nombreus, ''), ' ', COALESCE(u.apellido, ''))) LIKE LOWER(?) "
                + "OR TRIM(u.documento) LIKE ?) "
                + "ORDER BY u.nombreus, u.apellido LIMIT 8";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String patron = "%" + busqueda + "%";
            ps.setString(1, patron);
            ps.setString(2, patron);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setId_Usuario(rs.getInt("id_Usuario"));
                    usuario.setNombreus(rs.getString("nombreus"));
                    usuario.setApellido(rs.getString("apellido"));
                    usuario.setDocumento(rs.getString("documento"));
                    usuario.setTelefono(rs.getString("telefono"));
                    usuario.setCorreo(rs.getString("correo"));
                    usuario.setDescripcionRol(rs.getString("descripcion_rol"));
                    usuario.setActivo(rs.getBoolean("activo"));
                    pacientes.add(usuario);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar pacientes: " + e.getMessage());
        }
        return pacientes;
    }

    public boolean insertarUsuario(Usuario usuario) throws SQLException {
        boolean insertado = false;
        String sql = "INSERT INTO usuario (nombreus, apellido, contrasena, correo, documento, telefono, "
                + "fecha_nacimiento, tratamiento_datos, Rol_id_Rol, Tipo_documento_id_Tipodocumento, activo) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario.getNombreus());
            ps.setString(2, usuario.getApellido());
            ps.setString(3, usuario.getContrasena());
            ps.setString(4, usuario.getCorreo());
            ps.setString(5, usuario.getDocumento());
            ps.setString(6, usuario.getTelefono());
            ps.setDate(7, usuario.getfecha_nacimiento());
            ps.setBoolean(8, usuario.gettratamiento_datos());
            ps.setInt(9, usuario.getRol_id_Rol());
            ps.setInt(10, usuario.getTipo_documento_id_Tipodocumento());
            ps.setBoolean(11, true);
            insertado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al insertar usuario: " + e.getMessage());
        }
        return insertado;
    }

    public Usuario consultaUsuario(int id_Usuario) {
        Usuario usuario = null;
        String sql = "SELECT * FROM usuario WHERE id_Usuario = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id_Usuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = mapearUsuarioCompleto(rs);
                }
            }
        } catch (SQLException ex) {
            System.err.println("Error al consultar usuario: " + ex.getMessage());
        }
        return usuario;
    }

    public boolean actualizarUsuario(Usuario usuario) throws SQLException {
        boolean actualizado = false;
        String sql = "UPDATE usuario SET nombreus=?, apellido=?, documento=?, telefono=?, correo=?, contrasena=?, "
                + "fecha_nacimiento=?, tratamiento_datos=?, Tipo_documento_id_Tipodocumento=?, Rol_id_Rol=? "
                + "WHERE id_Usuario=?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario.getNombreus());
            ps.setString(2, usuario.getApellido());
            ps.setString(3, usuario.getDocumento());
            ps.setString(4, usuario.getTelefono());
            ps.setString(5, usuario.getCorreo());
            ps.setString(6, usuario.getContrasena());
            ps.setDate(7, usuario.getfecha_nacimiento());
            ps.setBoolean(8, usuario.gettratamiento_datos());
            ps.setInt(9, usuario.getTipo_documento_id_Tipodocumento());
            ps.setInt(10, usuario.getRol_id_Rol());
            ps.setInt(11, usuario.getId_Usuario());
            actualizado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar el usuario: " + e.getMessage());
        }
        return actualizado;
    }

    public boolean eliminarUsuario(int id) throws SQLException {
        return cambiarEstadoUsuario(id, false);
    }

    public boolean cambiarEstadoUsuario(int id, boolean activo) throws SQLException {
        boolean actualizado = false;
        String sql = "UPDATE usuario SET activo = ? WHERE id_Usuario = ?";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, activo);
            ps.setInt(2, id);
            actualizado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al cambiar estado del usuario: " + e.getMessage());
        }
        return actualizado;
    }

    public boolean actualizarContrasenaPorCorreo(String correo, String nuevaContrasena) {
        boolean actualizado = false;
        String sql = "UPDATE usuario SET contrasena = ? WHERE TRIM(correo) = ? AND COALESCE(activo, 1) = 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevaContrasena);
            ps.setString(2, correo == null ? "" : correo.trim());
            actualizado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al actualizar contrasena: " + e.getMessage());
        }
        return actualizado;
    }

    public boolean verificarCorreoExiste(String correo) {
        boolean existe = false;
        String sql = "SELECT COUNT(*) FROM usuario WHERE TRIM(correo) = ? AND COALESCE(activo, 1) = 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo == null ? "" : correo.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    existe = rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al verificar correo: " + e.getMessage());
        }
        return existe;
    }

    public boolean validarCodigoTemporal(String correo, String codigoTemporal) {
        boolean valido = false;
        String sql = "SELECT COUNT(*) FROM usuario WHERE TRIM(correo) = ? AND contrasena = ? AND COALESCE(activo, 1) = 1";

        try (Connection con = conexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo == null ? "" : correo.trim());
            ps.setString(2, codigoTemporal == null ? "" : codigoTemporal.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    valido = rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al validar codigo temporal: " + e.getMessage());
        }
        return valido;
    }

    private Usuario mapearUsuarioCompleto(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setId_Usuario(rs.getInt("id_Usuario"));
        usuario.setNombreus(rs.getString("nombreus"));
        usuario.setApellido(rs.getString("apellido"));
        usuario.setDocumento(rs.getString("documento"));
        usuario.setTelefono(rs.getString("telefono"));
        usuario.setCorreo(rs.getString("correo"));
        usuario.setContrasena(rs.getString("contrasena"));
        usuario.setfecha_nacimiento(rs.getDate("fecha_nacimiento"));
        usuario.settratamiento_datos(rs.getBoolean("tratamiento_datos"));
        usuario.setTipo_documento_id_Tipodocumento(rs.getInt("Tipo_documento_id_Tipodocumento"));
        usuario.setRol_id_Rol(rs.getInt("Rol_id_Rol"));
        usuario.setActivo(rs.getBoolean("activo"));
        return usuario;
    }
}