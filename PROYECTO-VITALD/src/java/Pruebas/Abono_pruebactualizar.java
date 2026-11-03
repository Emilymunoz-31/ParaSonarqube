package pruebas;

import Controlador.AbonoDAO;
import Modelo.Abono;
import java.sql.SQLException;
import java.util.Scanner;

public class Abono_pruebactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        AbonoDAO dao = new AbonoDAO ();
        Abono m = new Abono ();
        
        System.out.println("=== ACTUALIZAR ABONO ===");
        
        System.out.print("Ingrese el ID del abono a actualizar: ");
        m.setid_Abono(sc.nextInt());
        sc.nextLine();
        
        System.out.print("Nuevo monto de abono: ");
        m.setmonto_abono(sc.nextDouble());
        sc.nextLine();
        
        System.out.print("Nuevo fecha del abono: ");
        m.setfecha_abono(sc.nextLine());
        
        
        System.out.print("Nuevo ID de pago del abono: ");
        m.setPago_id_Pago(sc.nextInt());

       
         dao.actualizarAbono(m);
        
        sc.close();
        
    }
}

