package Pruebas;

import Controlador.Categoria_TratamientoDAO;
import java.sql.SQLException;

public class CategoriaTratamiento_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        Categoria_TratamientoDAO dao = new Categoria_TratamientoDAO();
        
        int eliminado = 1;
        
        System.out.println("Intentando eliminar la categoria del tratamiento con el ID: " + eliminado);
        
        
        dao.eliminarCategoria_Tratamiento
        (eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}