package Pruebas;

import Controlador.Historial_tratamientoDAO;
import java.sql.SQLException;

public class Historialtratamiento_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        Historial_tratamientoDAO dao = new Historial_tratamientoDAO();
        
        int eliminado = 1;
        
        System.out.println("Intentando eliminar el historial de tratamiento con el ID: " + eliminado);
        
        
        dao.eliminarHistorial_tratamiento
        (eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}