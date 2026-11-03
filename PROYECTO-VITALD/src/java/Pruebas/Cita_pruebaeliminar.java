package Pruebas;

import Controlador.CitaDAO;
import java.sql.SQLException;

public class Cita_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        CitaDAO dao = new CitaDAO();
        
        int eliminado = 1;
        
        System.out.println("Intentando eliminar cita con el ID: " + eliminado);
        
        
        dao.eliminarCita
        (eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}