package pruebas;

import Controlador.PagoDAO;
import Modelo.Pago;
import java.sql.SQLException;
import java.util.Scanner;

public class Pago_pruebactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        PagoDAO dao = new PagoDAO ();
        Pago m = new Pago ();
        
        System.out.println("=== ACTUALIZAR PAGO ===");
        
        System.out.print("Ingrese el ID del pago a actualizar: ");
        m.setid_Pago(sc.nextInt());
        sc.nextLine();
        
        System.out.print("Nuevo monto del pago: ");
        m.setmonto(sc.nextDouble());
        
        System.out.print("Nuevo medio de pago: ");
        m.setMedio_pago_id_Mediopago(sc.nextInt());
        
        System.out.print("Nuevo estado de pago: ");
        m.setEstado_pago_id_Estadopago(sc.nextInt());
        
        System.out.print("Nuevo ID de cita delx pago: ");
        m.setCita_id_Cita(sc.nextInt());
       
               
         dao.actualizarPago(m);
        
        sc.close();
        
    }
}