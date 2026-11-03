package pruebas;

import Controlador.Estado_pagoDAO;
import Modelo.Estado_pago;
import java.sql.SQLException;
import java.util.Scanner;

public class Estadopago_pruebactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        Estado_pagoDAO dao = new Estado_pagoDAO ();
        Estado_pago m = new Estado_pago ();
        
        System.out.println("=== ACTUALIZAR ESTADO DE PAGO ===");
        
        System.out.print("Ingrese el ID del estado de pago a actualizar: ");
        m.setid_Estadopago(sc.nextInt());
        sc.nextLine();
        
        System.out.print("Nueva descripcion del estado de pago: ");
        m.setdescripcion_estadop(sc.nextLine());
                   
         dao.actualizarEstado_Pago(m);
        
        sc.close();
        
    }
}