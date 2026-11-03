/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Aprendiz
 */
public class Abono{
    private int id_Abono;
    private Double monto_abono;
    private String fecha_abono;
    private int Pago_id_Pago;
    
    public int getid_Abono() {
       return id_Abono;
    }
    
    public void setid_Abono(int id_Abono){
        this.id_Abono = id_Abono;
             
    }

    public Double getmonto_abono(){
        return monto_abono;
    }
    
    public void setmonto_abono (Double monto_abono){
        this.monto_abono = monto_abono;
    }
    
    public String getfecha_abono(){
        return fecha_abono;
    }
    
    public void setfecha_abono (String fecha_abono){
        this.fecha_abono = fecha_abono;
    }
    
    public int getPago_id_Pago(){
        return Pago_id_Pago;
    }
    
    public void setPago_id_Pago (int Pago_id_Pago){
        this.Pago_id_Pago = Pago_id_Pago;
    }
    
    
    
    
    
    
    
    
}


