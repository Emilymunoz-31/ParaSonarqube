/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Pruebas;

import Controlador.Estado_pagoDAO;
import Modelo.Estado_pago;
import java.sql.SQLException;
import java.util.Scanner;

/**
 *
 * @author Aprendiz
 */
public class Estadopago_pruebainsertar {

    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        
        Estado_pago estado_pago = new Estado_pago();
        Estado_pagoDAO dao = new Estado_pagoDAO();

        System.out.print("Ingrese el ID del Estado de pago (ej: 1): ");
        estado_pago.setid_Estadopago(Integer.parseInt(sc.nextLine()));

        System.out.print("Ingrese la descripción del Estado de pago (ej: Pagado): ");
        estado_pago.setdescripcion_estadop(sc.nextLine());

        
        boolean resultado = dao.insertarEstado_pago(estado_pago);

        if (resultado) {
            System.out.println("\nEl estado de pago se guardó correctamente en VITALEM.");
        } else {
            System.out.println("\nEl estado de pago no se guardó.");
        }
    }
}