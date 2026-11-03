package Pruebas;

import Controlador.AbonoDAO;
import java.sql.SQLException;

public class Abono_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        AbonoDAO dao = new AbonoDAO();
        
        int eliminado = 1;
        
        System.out.println("Intentando eliminar Abono con el ID: " + eliminado);
        
        
        dao.eliminarAbono
        (eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}