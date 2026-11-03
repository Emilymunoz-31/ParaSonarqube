/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Emily
 */
public class Estado_cita {
    private int idEstado_cita;
    private String descripcion_estadoci;

    
    public int getidEstado_cita() {
       return idEstado_cita;
    }
    
    public void setidEstado_cita(int idEstado_cita){
        this.idEstado_cita = idEstado_cita;
             
    }

    public String getdescripcion_estadoci(){
        return descripcion_estadoci;
    }
    
    public void setdescripcion_estadoci (String descripcion_estadoci){
        this.descripcion_estadoci = descripcion_estadoci;
    } 
}
