 /*
* Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Emily
 */
public class Pago {
    private int id_Pago;
    private Double monto;
    private int Medio_pago_id_Mediopago;
    private int Estado_pago_id_Estadopago;
    private int Cita_id_Cita;
    private String descripcionMedioPago;
    private String descripcionEstadoPago;
    
    public int getid_Pago() {
       return id_Pago;
    }
    
    public void setid_Pago(int id_Pago){
        this.id_Pago = id_Pago;
             
    }
    public Double getmonto() {
       return monto;
    }
    
    public void setmonto(Double monto){
        this.monto = monto;
             
    }
     public int getEstado_pago_id_Estadopago() {
       return Estado_pago_id_Estadopago;
    }
    
    public void setEstado_pago_id_Estadopago(int Estado_pago_id_Estadopago){
        this.Estado_pago_id_Estadopago = Estado_pago_id_Estadopago;
             
    } public int getMedio_pago_id_Mediopago() {
       return Medio_pago_id_Mediopago;
    }
    
    public void setMedio_pago_id_Mediopago(int setMedio_pago_id_Mediopago){
        this.Medio_pago_id_Mediopago = setMedio_pago_id_Mediopago;
             
    } public int getCita_id_Cita() {
       return Cita_id_Cita;
    }
    
    public void setCita_id_Cita(int Cita_id_Cita){
        this.Cita_id_Cita = Cita_id_Cita;
             
    }

    public String getDescripcionMedioPago() {
        return descripcionMedioPago;
    }

    public void setDescripcionMedioPago(String descripcionMedioPago) {
        this.descripcionMedioPago = descripcionMedioPago;
    }

    public String getDescripcionEstadoPago() {
        return descripcionEstadoPago;
    }

    public void setDescripcionEstadoPago(String descripcionEstadoPago) {
        this.descripcionEstadoPago = descripcionEstadoPago;
    }
    
    // 💡 ATRIBUTOS AUXILIARES (Para calcular y mostrar en las vistas JSP)
    private Double totalAbonado = 0.0;
    private Double saldoPendiente = 0.0;

    public Double getTotalAbonado() {
        return totalAbonado;
    }

    public void setTotalAbonado(Double totalAbonado) {
        this.totalAbonado = totalAbonado;
    }

    public Double getSaldoPendiente() {
        return saldoPendiente;
    }

    public void setSaldoPendiente(Double saldoPendiente) {
        this.saldoPendiente = saldoPendiente;
    }
    
}
