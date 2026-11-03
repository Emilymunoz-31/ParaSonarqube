/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Emily
 */
public class Historial_tratamiento {
    private int id_Historial;
    private String anio;
    private String costo;
    private int Tipo_tratamiento_id_Tipotratam;
    
 
    
    public int getid_Historial() {
       return id_Historial;
    }
    
    public void setid_Historial(int id_Historial){
        this.id_Historial = id_Historial;
             
    }

    public String getanio(){
        return anio;
    }
    
    public void setanio (String anio){
        this.anio = anio;
    }
    
     public String getcosto(){
        return costo;
    }
    
    public void setcosto (String costo){
        this.costo = costo;
    }
    
     public int getTipo_tratamiento_id_Tipotratam(){
        return Tipo_tratamiento_id_Tipotratam;
    }
    
    public void setTipo_tratamiento_id_Tipotratam (int Tipo_tratamiento_id_Tipotratam){
        this.Tipo_tratamiento_id_Tipotratam = Tipo_tratamiento_id_Tipotratam;
    }
}
