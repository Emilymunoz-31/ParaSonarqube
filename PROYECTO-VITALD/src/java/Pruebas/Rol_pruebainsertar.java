/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Pruebas;

import Controlador.RolDAO;
import Modelo.Rol;
import java.sql.SQLException;
import java.util.Scanner;

/**
 *
 * @author Aprendiz
 */
public class Rol_pruebainsertar {

    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        
        Rol rol = new Rol();
        RolDAO dao = new RolDAO();

        System.out.print("Ingrese el ID del Rol (ej: 1): ");
        rol.setid_Rol(Integer.parseInt(sc.nextLine()));

        System.out.print("Ingrese la descripción del rol (ej: Odontologo): ");
       
        rol.setdescripcion_rol(sc.nextLine());

        
        boolean resultado = dao.insertarRol(rol);

        if (resultado) {
            System.out.println("\nEl rol se guardó correctamente en VITALEM.");
        } else {
            System.out.println("\nEl rol no se guardó.");
        }
    }
}