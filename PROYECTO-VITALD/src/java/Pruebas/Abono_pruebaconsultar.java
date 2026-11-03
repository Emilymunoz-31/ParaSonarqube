package pruebas;

import Controlador.AbonoDAO;
import Modelo.Abono;


public class Abono_pruebaconsultar{
    public static void main(String[] args) {
        
        AbonoDAO dao = new AbonoDAO();
        
        
        int idABuscar = 1; 
        Abono abonoEncontrado = dao.consultaAbono(idABuscar);
        
        
        if (abonoEncontrado != null) {
            System.out.println("--- Abono Encontrado ---");    
            System.out.println("ID: " + abonoEncontrado.getid_Abono());
            System.out.println("Monto del abono: " + abonoEncontrado.getmonto_abono());
            System.out.println("fecha del abono: " + abonoEncontrado.getfecha_abono());
            System.out.println("ID del pago: " + abonoEncontrado.getPago_id_Pago());
           
        } else {
            System.out.println("No se encontró ninguna cita con el ID: " + idABuscar);
        }
    }
}