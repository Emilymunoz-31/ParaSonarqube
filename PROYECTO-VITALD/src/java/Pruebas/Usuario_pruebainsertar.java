package Pruebas;

import Controlador.UsuarioDAO;
import Modelo.Usuario;
import java.sql.SQLException;
import java.util.Scanner;

public class Usuario_pruebainsertar {

    public static void main(String[] args) throws SQLException {

        Scanner sc = new Scanner(System.in);
        Usuario usuario = new Usuario();
        UsuarioDAO dao = new UsuarioDAO();
        
        System.out.println("=== REGISTRO DE NUEVO USUARIO ===");

        System.out.print("\nIngrese el nombre del Usuario: ");
        String nombre = sc.nextLine();
        usuario.setNombreus(nombre);
        
        System.out.print("\nIngrese el apellido del Usuario: ");
        usuario.setApellido(sc.nextLine());
        
        System.out.print("\nIngrese una contraseña segura: ");
        usuario.setContrasena(sc.nextLine());
        
        System.out.print("\nIngrese el correo del Usuario: ");
        usuario.setCorreo(sc.nextLine());
        
        System.out.print("\nIngrese el documento del Usuario: ");
        usuario.setDocumento(sc.nextLine());
        
        System.out.print("\nIngrese el telefono del Usuario: ");
        usuario.setTelefono(sc.nextLine());
        
        System.out.print("\nIngrese la fecha de nacimiento del Usuario (Formato AAAA-MM-DD): ");
        String fechaIngresada = sc.nextLine(); 
        usuario.setfecha_nacimiento(java.sql.Date.valueOf(fechaIngresada)); 
        
        System.out.print("\nIngrese su tipo de usuario: ");
        usuario.setRol_id_Rol(sc.nextInt());
        
        System.out.print("\nIngrese Tipo de documento: ");
        usuario.setTipo_documento_id_Tipodocumento(sc.nextInt());

        sc.nextLine(); 

        System.out.println("\n¿Acepta el tratamiento de datos personales? S/N");
        String opcion = sc.nextLine(); 

        if (opcion.equalsIgnoreCase("S")) {
            usuario.settratamiento_datos(true); 
            
            boolean resultado = dao.insertarUsuario(usuario); 

            if (resultado) {
                System.out.println("\n[EXITO] Registro completado en VITALEM.");
            } else {
                System.out.println("\n[ERROR] No se pudo guardar en la base de datos.");
            }
            
        } else {
            usuario.settratamiento_datos(false);
            System.out.println("\n[BLOQUEO] Registro cancelado. Sin autorización no hay registro.");
            sc.close();
            return; 
        }
        
        sc.close();
    } 
} 