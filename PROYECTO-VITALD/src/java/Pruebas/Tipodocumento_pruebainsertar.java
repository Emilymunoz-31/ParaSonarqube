package Pruebas;

import Controlador.Tipo_documentoDAO;
import Modelo.Tipo_documento;
import java.sql.SQLException;
import java.util.Scanner;

public class Tipodocumento_pruebainsertar {

    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        
        Tipo_documento tipodocumento = new Tipo_documento();
        Tipo_documentoDAO dao = new Tipo_documentoDAO();

        System.out.print("Ingrese el ID del tipo de documento (ej: 1): ");
        tipodocumento.setid_Tipodocumento(Integer.parseInt(sc.nextLine()));

        System.out.print("Ingrese la descripción del tipo de documento (ej: Cedula): ");
       
        tipodocumento.setdescripcion_tipodoc(sc.nextLine());

        
        boolean resultado = dao.insertarTipo_documento(tipodocumento);

        if (resultado) {
            System.out.println("\nEl tipo de documento se guardó correctamente en VITALEM.");
        } else {
            System.out.println("\nEl tipo de documento no se guardó.");
        }
    }
}