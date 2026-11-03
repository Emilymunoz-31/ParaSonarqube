package pruebas;

import Controlador.Medio_pagoDAO;
import Modelo.Medio_pago;
import Modelo.Pago;
import java.sql.SQLException;
import java.util.Scanner;

public class Mediopago_pruebactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        Medio_pagoDAO dao = new Medio_pagoDAO ();
        Medio_pago m = new Medio_pago ();
        
        System.out.println("=== ACTUALIZAR MEDIO DE PAGO ===");
        
        System.out.print("Ingrese el ID del medio de pago a actualizar: ");
        m.setid_Mediopago(sc.nextInt());
        sc.nextLine();
        
        System.out.print("Nueva descripcion del medio de pago: ");
        m.setdescripcion_mediopa(sc.nextLine());
                   
         dao.actualizarMedio_Pago(m);
        
        sc.close();
        
    }
}