
package Pruebas;

import Controlador.Medio_pagoDAO;
import Modelo.Medio_pago;


public class Mediodepago_pruebaconsultar{
    public static void main(String[] args) {
        
        Medio_pagoDAO dao = new Medio_pagoDAO();
        
        
        int idABuscar = 1; 
        Medio_pago medio_pagoEncontrado = dao.consultaMedio_pago(idABuscar);
        
        
        if (medio_pagoEncontrado != null) {
            System.out.println("--- Medio de pago Encontrado ---");
            System.out.println("ID: " + medio_pagoEncontrado.getid_Mediopago());
            System.out.println("Descripcion: " + medio_pagoEncontrado.getdescripcion_mediopa());
     
        } else {
            System.out.println("No se encontró ningún medio de pago con el ID: " + idABuscar);
        }
    }
}