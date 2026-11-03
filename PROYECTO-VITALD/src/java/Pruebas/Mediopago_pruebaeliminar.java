package Pruebas;

import Controlador.Medio_pagoDAO;
import java.sql.SQLException;

public class Mediopago_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        Medio_pagoDAO dao = new Medio_pagoDAO();
        
        int eliminado = 1;
        
        System.out.println("Intentando eliminar el medio de pago con el ID: " + eliminado);
        
        
        dao.eliminarMedio_pago
        (eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}