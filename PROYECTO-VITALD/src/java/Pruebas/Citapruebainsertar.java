package Pruebas;

import Controlador.CitaDAO;
import Modelo.Cita;
import java.util.Scanner;

public class Citapruebainsertar {

    public static void main(String[] args) {
        
        Scanner sc = new Scanner(System.in);
        Cita cita = new Cita();
        CitaDAO dao = new CitaDAO();

        System.out.println("--- PRUEBA: AGENDAR CITA EN VITALDENTIST ---");


        System.out.print("Ingrese la fecha y hora de la cita (ej: 2028-03-31 14:00:00): ");
        cita.setfecha_hora(sc.nextLine());
        
        System.out.print("Ingrese una descripción u observaciones de la cita: ");
        cita.setdescripcion_cita(sc.nextLine());
        
        System.out.print("Ingrese el DOCUMENTO del paciente: ");
        String documentoPac = sc.nextLine();
        
        
        System.out.print("Ingrese el ID del tipo de tratamiento a realizar (ej: 1, 2, 3...): ");
        cita.setTipo_Tratamiento_id_Tipotratam(Integer.parseInt(sc.nextLine()));

        System.out.println("\nProcesando... Buscando paciente y agendando cita...");
        
        boolean resultado = dao.insertarCita(cita, documentoPac);

        if (resultado) {
            System.out.println("\n✅ ¡ÉXITO! La cita se guardó correctamente en la Base de Datos.");
        } else {
            System.out.println("\n❌ ERROR: La cita no se guardó. (Verifica que el documento del paciente exista en la tabla usuario).");
        }
        
        sc.close();
    }
}