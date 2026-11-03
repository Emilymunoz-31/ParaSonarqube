/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Pruebas;

import Controlador.Medio_pagoDAO;
import Modelo.Medio_pago;
import java.sql.SQLException;
import java.util.Scanner;

/**
 *
 * @author Aprendiz
 */
public class Medio_pagopruebainsertar {

    public static void main(String[] args) throws SQLException {
        
        Scanner sc = new Scanner(System.in);
        
        Medio_pago medio_pago = new Medio_pago();
        Medio_pagoDAO dao = new Medio_pagoDAO();

        System.out.print("Ingrese el ID del Medio de pago (ej: 1): ");
        medio_pago.setid_Mediopago(Integer.parseInt(sc.nextLine()));

        System.out.print("Ingrese la descripción del medio de pago (ej: efectivo): ");
        
        
        medio_pago.setdescripcion_mediopa(sc.nextLine());

        
        boolean resultado = dao.insertarMedio_pago(medio_pago);

        if (resultado) {
            System.out.println("\nEl medio de pago se guardó correctamente en VITALEM.");
        } else {
            System.out.println("\nEl medio de pago no se guardó.");
        }
    }
}