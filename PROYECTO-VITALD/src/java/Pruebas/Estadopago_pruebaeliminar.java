package Pruebas;

import Controlador.Estado_pagoDAO;
import java.sql.SQLException;

public class Estadopago_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        Estado_pagoDAO dao = new Estado_pagoDAO();
        
        int eliminado = 1;
        
        System.out.println("Intentando eliminar el tipo de documento con el ID: " + eliminado);
        
        
        dao.eliminarEstado_pago
        (eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}