
package Pruebas;

import Controlador.Estado_pagoDAO;
import Modelo.Estado_pago;


public class Estado_pagopruebaconsultar{
    public static void main(String[] args) {
        
        Estado_pagoDAO dao = new Estado_pagoDAO();
        
        
        int idABuscar = 1; 
        Estado_pago estado_pagoEncontrado = dao.consultaEstado_pago(idABuscar);
        
        
        if (estado_pagoEncontrado != null) {
            System.out.println("--- Estado de pago Encontrado ---");
            System.out.println("ID: " + estado_pagoEncontrado.getid_Estadopago());
            System.out.println("Descripcion: " + estado_pagoEncontrado.getdescripcion_estadop());
     
        } else {
            System.out.println("No se encontró ningún Estado de pago con el ID: " + idABuscar);
        }
    }
}