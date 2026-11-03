/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Pruebas;

import Controlador.AbonoDAO;
import Modelo.Abono;
import java.sql.SQLException;
import java.util.Scanner;

/**
 *
 * @author Aprendiz
 */
public class Abonopruebainsertar {

    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        
        Abono abono = new Abono();
        AbonoDAO dao = new AbonoDAO();

        System.out.print("Ingrese el ID del Abono (ej: 1): ");
        abono.setid_Abono(Integer.parseInt(sc.nextLine()));

        System.out.print("Ingrese el monto del abono: ");
        abono.setmonto_abono(Double.parseDouble(sc.nextLine()));
        
        System.out.print("Ingrese la fecha en la cual se realizo el abono formato debe ser yyyy-mm-dd: ");
        abono.setfecha_abono(sc.nextLine());
        
        System.out.print("Ingrese el ID del pago: ");
        abono.setPago_id_Pago(Integer.parseInt(sc.nextLine()));

        boolean resultado = dao.insertarAbono(abono);

        if (resultado) {
            System.out.println("\nEl abono se guardó correctamente en VITALEM.");
        } else {
            System.out.println("\nEl abono no se guardó.");
        }
    }
}