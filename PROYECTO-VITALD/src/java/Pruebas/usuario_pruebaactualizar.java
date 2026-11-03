package pruebas;

import Controlador.UsuarioDAO;
import Modelo.Usuario;
import java.sql.SQLException;
import java.util.Scanner;

public class usuario_pruebaactualizar {
    
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        UsuarioDAO dao = new UsuarioDAO ();
        Usuario m = new Usuario ();
        
        System.out.println("=== ACTUALIZAR USUARIO ===");
        
        System.out.print("Ingrese el ID del usuario a actualizar: ");
        m.setId_Usuario(sc.nextInt());
        sc.nextLine();
        
        System.out.print("Nuevo nombre de usuario: ");
        m.setNombreus(sc.nextLine());
        
        
        System.out.print("Nuevo apellido de usuario: ");
        m.setApellido(sc.nextLine());
        
        
        System.out.print("Nuevo Documento de usuario: ");
        m.setDocumento(sc.nextLine());
       
         
        System.out.print("Nuevo telefono de usuario: ");
        m.setTelefono(sc.nextLine());
        
         
        System.out.print("Nuevo correo de usuario: ");
        m.setCorreo(sc.nextLine());
        
        
        System.out.print("Nueva contraseña de usuario: ");
        m.setContrasena(sc.nextLine());
        
        
        System.out.print("Nuevo Tipo de documento de usuario: ");
        m.setTipo_documento_id_Tipodocumento(sc.nextInt());
        
         
        System.out.print("Nuevo rol de usuario: ");
        m.setRol_id_Rol(sc.nextInt());
      
         
         dao.actualizarUsuario(m);
        
        sc.close();
        
    }
}