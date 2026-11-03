package Pruebas;

import Controlador.UsuarioDAO;
import java.sql.SQLException;

public class Usuario_pruebaeliminar {
    public static void main(String[] args) throws SQLException {
        
        UsuarioDAO dao = new UsuarioDAO();
        
        int eliminado = 2;
        
        System.out.println("Intentando eliminar el usuario con el ID: " + eliminado);
        
        
        dao.eliminarUsuario(eliminado);
        
        System.out.println("Proceso finalizado. Verifica la base de datos VITALEM.");
    }
}