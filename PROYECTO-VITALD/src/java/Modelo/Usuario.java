package Modelo;

import java.sql.Date;

/**
 *
 * @author Emily
 */
public class Usuario {

    private int id_Usuario;
    private String nombreus;
    private String apellido;
    private String contrasena;
    private String correo;
    private String documento;
    private String telefono;
    private Date fecha_nacimiento;
    private Boolean tratamiento_datos;
    private int Rol_id_Rol;
    private String descripcionRol;
    private int Tipo_documento_id_Tipodocumento;
    private boolean activo = true;

    public Usuario() {
    }

    public int getId_Usuario() {
        return id_Usuario;
    }

    public void setId_Usuario(int id_Usuario) {
        this.id_Usuario = id_Usuario;
    }

    public String getNombreus() {
        return nombreus;
    }

    public void setNombreus(String nombreus) {
        this.nombreus = nombreus;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public boolean isTratamiento_datos() {
        return Boolean.TRUE.equals(tratamiento_datos);
    }

    public boolean gettratamiento_datos() {
        return Boolean.TRUE.equals(tratamiento_datos);
    }

    public void settratamiento_datos(boolean tratamiento_datos) {
        this.tratamiento_datos = tratamiento_datos;
    }

    public int getRol_id_Rol() {
        return Rol_id_Rol;
    }

    public void setRol_id_Rol(int Rol_id_Rol) {
        this.Rol_id_Rol = Rol_id_Rol;
    }

    public String getDescripcionRol() {
        return descripcionRol;
    }

    public void setDescripcionRol(String descripcionRol) {
        this.descripcionRol = descripcionRol;
    }

    public Date getfecha_nacimiento() {
        return fecha_nacimiento;
    }

    public void setfecha_nacimiento(Date fecha_nacimiento) {
        this.fecha_nacimiento = fecha_nacimiento;
    }

    public int getTipo_documento_id_Tipodocumento() {
        return Tipo_documento_id_Tipodocumento;
    }

    public void setTipo_documento_id_Tipodocumento(int Tipo_documento_id_Tipodocumento) {
        this.Tipo_documento_id_Tipodocumento = Tipo_documento_id_Tipodocumento;
    }

    public boolean isActivo() {
        return activo;
    }

    public boolean getActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }
}