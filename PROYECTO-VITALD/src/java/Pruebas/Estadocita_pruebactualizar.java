package pruebas;

import Controlador.Estado_citaDAO;
import Modelo.Estado_cita;
import java.sql.SQLException;
import java.util.Scanner;

public class Estadocita_pruebactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        Estado_citaDAO dao = new Estado_citaDAO ();
        Estado_cita m = new Estado_cita ();
        
        System.out.println("=== ACTUALIZAR ESTADO DE CITA ===");
        
        System.out.print("Ingrese el ID del estado de cita a actualizar: ");
        m.setidEstado_cita(sc.nextInt());
        sc.nextLine();
        
        System.out.print("Nueva descripcion del estado de cita: ");
        m.setdescripcion_estadoci(sc.nextLine());
                   
         dao.actualizarEstado_cita(m);
        
        sc.close();
        
    }
}