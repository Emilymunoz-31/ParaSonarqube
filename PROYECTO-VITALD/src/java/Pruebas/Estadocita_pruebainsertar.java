/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Pruebas;

import Controlador.Estado_citaDAO;
import Modelo.Estado_cita;
import java.sql.SQLException;
import java.util.Scanner;

/**
 *
 * @author Aprendiz
 */
public class Estadocita_pruebainsertar {

    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        
        Estado_cita estado_cita = new Estado_cita();
        Estado_citaDAO dao = new Estado_citaDAO();

        System.out.print("Ingrese el ID del Estado de cita (ej: 1): ");
        estado_cita.setidEstado_cita(Integer.parseInt(sc.nextLine()));

        System.out.print("Ingrese la descripción del Estado de cita (ej: Atendida): ");
        estado_cita.setdescripcion_estadoci(sc.nextLine());

        
        boolean resultado = dao.insertarEstado_cita(estado_cita);

        if (resultado) {
            System.out.println("\nEl estado de cita se guardó correctamente en VITALEM.");
        } else {
            System.out.println("\nEl estado de cita no se guardó.");
        }
    }
}