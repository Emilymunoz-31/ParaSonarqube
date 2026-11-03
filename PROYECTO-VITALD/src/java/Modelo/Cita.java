/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;
/**
 *
 * @author Emily
 */
public class Cita {
     private int id_Cita;
    private String fecha_hora;
    private String descripcion_cita;
    private int Usuario_id_Usuario;
    private int Estado_cita_id_cita;
    private int Tipo_Tratamiento_id_Tipotratam;
    private String nombrePaciente;
    private String nombreOdontologo;
    private String descripcionEstadoCita;
    private String descripcionTratamiento;
    private String telefonoPaciente; // NUEVO: teléfono del paciente para WhatsApp

    public int getid_Cita() {
       return id_Cita;
    }
    
    public void setid_Cita(int id_Cita){
        this.id_Cita = id_Cita;
             
    }
    public String getfecha_hora(){
        return fecha_hora;
    }
    
    public void setfecha_hora(String fecha_hora){
        this.fecha_hora = fecha_hora;
    }
    
    public String getdescripcion_cita() {
       return descripcion_cita;
    }
    
    public void setdescripcion_cita(String descripcion_cita){
        this.descripcion_cita = descripcion_cita;
             
    }
    
     public int getUsuario_id_Usuario(){
        return Usuario_id_Usuario;
    }
    
    public void setUsuario_id_Usuario(int Usuario_id_Usuario){
        this.Usuario_id_Usuario = Usuario_id_Usuario;
    }
    
     public int getEstado_cita_idEstado_cita(){
        return Estado_cita_id_cita;
    }
    
    public void setEstado_cita_idEstado_cita(int Estado_cita_id_cita){
        this.Estado_cita_id_cita = Estado_cita_id_cita;
    }
    
     public int getTipo_Tratamiento_id_Tipotratam(){
        return Tipo_Tratamiento_id_Tipotratam;
    }
    
    public void setTipo_Tratamiento_id_Tipotratam(int Tipo_Tratamiento_id_Tipotratam){
        this.Tipo_Tratamiento_id_Tipotratam = Tipo_Tratamiento_id_Tipotratam;
    }
    public String getNombrePaciente() {
        return nombrePaciente;
    }
    public void setNombrePaciente(String nombrePaciente) {
        this.nombrePaciente = nombrePaciente;
    }
    public String getNombreOdontologo() {
        return nombreOdontologo;
    }
    public void setNombreOdontologo(String nombreOdontologo) {
        this.nombreOdontologo = nombreOdontologo;
    }
    public String getDescripcionEstadoCita() {
        return descripcionEstadoCita;
    }
    public void setDescripcionEstadoCita(String descripcionEstadoCita) {
        this.descripcionEstadoCita = descripcionEstadoCita;
    }
    public String getDescripcionTratamiento() {
        return descripcionTratamiento;
    }
    public void setDescripcionTratamiento(String descripcionTratamiento) {
        this.descripcionTratamiento = descripcionTratamiento;
    }
    
    private double costoTratamiento;
    public double getCostoTratamiento() {
        return costoTratamiento;
      }
    public void setCostoTratamiento(double costoTratamiento) {
        this.costoTratamiento = costoTratamiento;
    }

    public String getTelefonoPaciente() {
        return telefonoPaciente;
    }
    public void setTelefonoPaciente(String telefonoPaciente) {
        this.telefonoPaciente = telefonoPaciente;
    }
    
}