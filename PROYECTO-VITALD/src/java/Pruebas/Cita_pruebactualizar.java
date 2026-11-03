package pruebas;

import Controlador.CitaDAO;
import Modelo.Cita;
import java.sql.SQLException;
import java.util.Scanner;

public class Cita_pruebactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        CitaDAO dao = new CitaDAO ();
        Cita m = new Cita ();
        
        System.out.println("=== ACTUALIZAR CITA ===");
        
        System.out.print("Ingrese el ID de la cita a actualizar: ");
        m.setid_Cita(sc.nextInt());
        sc.nextLine();
        
        System.out.print("Nueva fecha y hora de la cita: ");
        m.setfecha_hora(sc.nextLine());
        
        System.out.print("Nuevo Usuario de la cita: ");
        m.setUsuario_id_Usuario(sc.nextInt());
        
        System.out.print("Nuevo estado de la cita: ");
        m.setEstado_cita_idEstado_cita(sc.nextInt());
        
        System.out.print("Nuevo tratamiento de la cita: ");
        m.setTipo_Tratamiento_id_Tipotratam(sc.nextInt());
        
       
         dao.actualizarCita(m);
        
        sc.close();
        
    }
}

