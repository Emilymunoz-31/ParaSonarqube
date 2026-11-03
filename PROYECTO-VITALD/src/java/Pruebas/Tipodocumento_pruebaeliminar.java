package Pruebas;

import Controlador.Tipo_documentoDAO;
import java.sql.SQLException;

public class Tipodocumento_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        Tipo_documentoDAO dao = new Tipo_documentoDAO();
        
        int eliminado = 2;
        
        System.out.println("Intentando eliminar el tipo de documento con el ID: " + eliminado);
        
        
        dao.eliminarTipo_documento
        (eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}