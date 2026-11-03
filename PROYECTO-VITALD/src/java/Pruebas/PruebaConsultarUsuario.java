package Pruebas;

import Controlador.UsuarioDAO;
import Modelo.Usuario;


public class PruebaConsultarUsuario {
    public static void main(String[] args) {
        
        UsuarioDAO dao = new UsuarioDAO();
        
        
        int idABuscar = 4; 
        Usuario usuarioEncontrado = dao.consultaUsuario(idABuscar);
        
        
        if (usuarioEncontrado != null) {
            System.out.println("--- Usuario Encontrado ---");
            System.out.println("ID: " + usuarioEncontrado.getId_Usuario());
            System.out.println("Nombre: " + usuarioEncontrado.getNombreus());
            System.out.println("Apellido: " + usuarioEncontrado.getApellido());
            System.out.println("Tipo de documento: " + usuarioEncontrado.getTipo_documento_id_Tipodocumento());
            System.out.println("Documento: " + usuarioEncontrado.getDocumento());
            System.out.println("Correo: " + usuarioEncontrado.getCorreo());
            System.out.println("Rol ID: " + usuarioEncontrado.getRol_id_Rol());
        } else {
            System.out.println("No se encontró ningún usuario con el ID: " + idABuscar);
        }
    }
}