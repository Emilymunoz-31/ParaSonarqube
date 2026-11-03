package Pruebas;

import Controlador.RolDAO;
import java.sql.SQLException;

public class Rol_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        RolDAO dao = new RolDAO();
        
        int eliminado = 1;
        
        System.out.println("Intentando eliminar el rol con el ID: " + eliminado);
        
        
        dao.eliminarRol
        (eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}