package pruebas;

import Controlador.RolDAO;
import Modelo.Rol;
import java.sql.SQLException;
import java.util.Scanner;

public class Rol_pruebactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        RolDAO dao = new RolDAO ();
        Rol m = new Rol ();
        
        System.out.println("=== ACTUALIZAR ROL ===");
        
        System.out.print("Ingrese el ID del rol a actualizar: ");
        m.setid_Rol(sc.nextInt());
        sc.nextLine();
        
        System.out.print("Nueva descripcion del tipo de documento: ");
        m.setdescripcion_rol(sc.nextLine());
                
         dao.actualizarRol(m);
        
        sc.close();
        
    }
}