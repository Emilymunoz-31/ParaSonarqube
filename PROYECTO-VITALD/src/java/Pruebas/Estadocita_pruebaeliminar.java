package Pruebas;

import Controlador.Estado_citaDAO;
import java.sql.SQLException;

public class Estadocita_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        Estado_citaDAO dao = new Estado_citaDAO();
        
        int eliminado = 1;
        
        System.out.println("Intentando eliminar el tipo de documento con el ID: " + eliminado);
        
        
        dao.eliminarEstado_cita
        (eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}