/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Pruebas;

import Controlador.PagoDAO;
import Modelo.Pago;
import java.sql.SQLException;
import java.util.Scanner;

/**
 *
 * @author Aprendiz
 */
public class Pago_pruebainsertar {

        /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);

         Pago pago = new Pago();
         PagoDAO dao = new PagoDAO();

          System.out.print("Ingrese el monto del pago: ");
          pago.setmonto(Double.parseDouble(sc.nextLine()));

          System.out.print("Ingrese el medio de pago: ");
          pago.setMedio_pago_id_Mediopago(Integer.parseInt(sc.nextLine()));
          
          System.out.print("Ingrese el Estado del pago: ");
          pago.setEstado_pago_id_Estadopago(Integer.parseInt(sc.nextLine()));
          
          System.out.print("Ingrese la cita del pago : ");
          pago.setCita_id_Cita(Integer.parseInt(sc.nextLine()));

          boolean resultado = dao.insertarPago(pago);

          if (resultado) {
          System.out.println("El pago se guardó correctamente.");
          } else {
          System.out.println("El pago no se guardó.");
}
    }
}

