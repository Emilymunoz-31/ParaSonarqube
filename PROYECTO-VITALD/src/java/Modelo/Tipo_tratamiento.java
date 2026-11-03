/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Emily
 */
public class Tipo_tratamiento {
    
    private int id_Tipotratam;
    private String descripcion_tipotratam;
    private Double costo;
    private int Categoria_Tratamiento_id_Categoria; 
    
    public int getid_Tipotratam() {
       return id_Tipotratam;
    }
    
    public void setid_Tipotratam(int id_Tipotratam){
        this.id_Tipotratam = id_Tipotratam;
             
    }
    public String getdescripcion_tipotratam() {
       return descripcion_tipotratam;
    }
    
    public void setdescripcion_tipotratam(String descripcion_tipotratam){
        this.descripcion_tipotratam= descripcion_tipotratam;
             
    }
    
     public Double getcosto() {
       return costo;
    }
     
    public void setcosto(Double costo){
        this.costo = costo;
    }

    public int getCategoria_Tratamiento_id_Categoria() {
        return Categoria_Tratamiento_id_Categoria;
    }

    public void setCategoria_Tratamiento_id_Categoria(int Categoria_Tratamiento_id_Categoria) {
        this.Categoria_Tratamiento_id_Categoria = Categoria_Tratamiento_id_Categoria;
    }
}