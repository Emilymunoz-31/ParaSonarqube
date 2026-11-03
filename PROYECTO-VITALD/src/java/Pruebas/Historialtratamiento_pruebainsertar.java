package Pruebas;

import Controlador.Historial_tratamientoDAO;
import Modelo.Historial_tratamiento;
import java.sql.SQLException;
import java.util.Scanner;

public class Historialtratamiento_pruebainsertar {

    public static void main(String[] args) throws SQLException {

        Scanner sc = new Scanner(System.in);
        Historial_tratamiento historial_tratamiento = new Historial_tratamiento();
        Historial_tratamientoDAO dao = new Historial_tratamientoDAO();
        
        System.out.print("Ingrese el Año del precio del tratamiento: ");
        String anio = sc.nextLine();
        historial_tratamiento.setanio(anio);
        
        
        System.out.print("Ingrese el costo del tratamiento correspondiente al año que ingreso anteriormente: ");
        historial_tratamiento.setcosto(sc.nextLine());
        
        
        System.out.print("Ingrese una contraseña segura: ");
        historial_tratamiento.setTipo_tratamiento_id_Tipotratam(sc.nextInt());
                

        boolean resultado = dao.insertarHistorial_tratamiento(historial_tratamiento);

        if (resultado) {
            System.out.println("\nEl historial de tratamiento se guardo correctamente en VITALEM.");
        } else {
            System.out.println("\nEl historia de tratamiento no se guardo.");
        }

       
    }
}