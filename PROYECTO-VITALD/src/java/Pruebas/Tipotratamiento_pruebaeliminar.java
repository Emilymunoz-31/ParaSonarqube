package Pruebas;

import Controlador.Tipo_tratamientoDAO;
import java.sql.SQLException;

public class Tipotratamiento_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        Tipo_tratamientoDAO dao = new Tipo_tratamientoDAO();
        
        int eliminado = 1;
        
        System.out.println("Intentando eliminar el tipo de tratamiento con el ID: " + eliminado);
        
        
        dao.eliminarTipo_tratamiento
        (eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}