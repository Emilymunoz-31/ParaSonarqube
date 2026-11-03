
package Pruebas;

import Controlador.PagoDAO;
import Modelo.Pago;


public class Pago_pruebaconsultar{
    public static void main(String[] args) {
        
        PagoDAO dao = new PagoDAO();
        
        
        int idABuscar = 1; 
        Pago pagoEncontrado = dao.consultaPago(idABuscar);
        
        
        if (pagoEncontrado != null) {
            System.out.println("--- Pago Encontrado ---");
            System.out.println("ID: " + pagoEncontrado.getid_Pago());
            System.out.println("Medio de pago: " + pagoEncontrado.getMedio_pago_id_Mediopago());
            System.out.println("Estado de pago: " + pagoEncontrado.getEstado_pago_id_Estadopago());
            System.out.println("Cita a la que corresponde el pago: " + pagoEncontrado.getCita_id_Cita());
        } else {
            System.out.println("No se encontró ningún Pago con el ID: " + idABuscar);
        }
    }
}