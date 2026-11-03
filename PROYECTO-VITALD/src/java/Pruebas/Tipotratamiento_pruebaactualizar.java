package pruebas;

import Controlador.Tipo_tratamientoDAO;
import Modelo.Tipo_tratamiento;
import java.sql.SQLException;
import java.util.Scanner;

public class Tipotratamiento_pruebaactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        Tipo_tratamientoDAO dao = new Tipo_tratamientoDAO ();
        Tipo_tratamiento m = new Tipo_tratamiento ();
        
        System.out.println("=== ACTUALIZAR TIPO DE TRATAMIENTO ===");
        
        System.out.print("Ingrese el ID del tipo de tratamiento a actualizar: ");
        m.setid_Tipotratam(sc.nextInt());
        sc.nextLine();
        
        System.out.print("Nueva descripcion del tipo de tratamiento: ");
        m.setdescripcion_tipotratam(sc.nextLine());
        
        
        System.out.print("Nuevo costo del tipo de tratamiento: ");
        m.setcosto(sc.nextDouble());
        
                
         dao.actualizarTipo_tratamiento(m);
        
        sc.close();
        
    }
}