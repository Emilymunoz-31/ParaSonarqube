package pruebas;

import Controlador.Historial_tratamientoDAO;
import Modelo.Historial_tratamiento;
import java.sql.SQLException;
import java.util.Scanner;

public class Historialtratamiento_pruebaactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        Historial_tratamientoDAO dao = new Historial_tratamientoDAO ();
        Historial_tratamiento m = new Historial_tratamiento ();
        
        System.out.println("=== ACTUALIZAR HISTORIAL DE TRATAMIENTO ===");
        
        System.out.print("Ingrese el ID del historial de tratamiento a actualizar: ");
        m.setid_Historial(sc.nextInt());
        sc.nextLine();
        
        System.out.print("Nuevo año del tratamiento: ");
        m.setanio(sc.nextLine());
        
        System.out.print("Nuevo costo del tratamiento en ese mismo año : ");
        m.setcosto(sc.nextLine());
        
        System.out.print("Nuevo tratamiento a actualizar: ");
        m.setTipo_tratamiento_id_Tipotratam(sc.nextInt());
        
       
         dao.actualizarHistorial_tratamiento(m);
        
        sc.close();
        
    }
}

