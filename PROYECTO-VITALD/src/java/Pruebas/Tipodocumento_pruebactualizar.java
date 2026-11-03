package pruebas;

import Controlador.Tipo_documentoDAO;
import Modelo.Tipo_documento;
import java.sql.SQLException;
import java.util.Scanner;

public class Tipodocumento_pruebactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        Tipo_documentoDAO dao = new Tipo_documentoDAO ();
        Tipo_documento m = new Tipo_documento ();
        
        System.out.println("=== ACTUALIZAR TIPO DE TRATAMIENTO ===");
        
        System.out.print("Ingrese el ID del tipo de documento a actualizar: ");
        m.setid_Tipodocumento(sc.nextInt());
        sc.nextLine();
        
        System.out.print("Nueva descripcion del tipo de documento: ");
        m.setdescripcion_tipodoc(sc.nextLine());
                
         dao.actualizarTipo_documento(m);
        
        sc.close();
        
    }
}