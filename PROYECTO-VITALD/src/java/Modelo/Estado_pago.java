/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Emily
 */
public class Estado_pago {
    private int id_Estadopago;
    private String descripcion_estadop;
    
    public int getid_Estadopago() {
       return id_Estadopago;
    }
    
    public void setid_Estadopago(int id_Estadopago){
        this.id_Estadopago= id_Estadopago;
             
    }

    public String getdescripcion_estadop(){
        return descripcion_estadop;
    }
    
    public void setdescripcion_estadop(String descripcion_estadop){
        this.descripcion_estadop = descripcion_estadop;
    }
}
