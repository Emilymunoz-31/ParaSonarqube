/*
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Emily
 */
public class Medio_pago {
    private int id_Mediopago;
    private String descripcion_mediopa;
 
    
    public int getid_Mediopago() {
       return id_Mediopago;
    }
    
    public void setid_Mediopago(int id_Mediopago){
        this.id_Mediopago = id_Mediopago;
             
    }

    public String getdescripcion_mediopa(){
        return descripcion_mediopa;
    }
    
    public void setdescripcion_mediopa (String descripcion_mediopa){
        this.descripcion_mediopa = descripcion_mediopa;
    }
    
}
