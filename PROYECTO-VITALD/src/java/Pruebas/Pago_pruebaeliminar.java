package Pruebas;

import Controlador.PagoDAO;
import java.sql.SQLException;

public class Pago_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        PagoDAO dao = new PagoDAO();
        
        int eliminado = 1;
        
        System.out.println("Intentando eliminar el pago con el ID: " + eliminado);
        
        
        dao.eliminarPago
        (eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}