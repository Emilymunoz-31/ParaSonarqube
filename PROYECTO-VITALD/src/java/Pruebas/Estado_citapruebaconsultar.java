
package Pruebas;

import Controlador.Estado_citaDAO;
import Modelo.Estado_cita;


public class Estado_citapruebaconsultar{
    public static void main(String[] args) {
        
        Estado_citaDAO dao = new Estado_citaDAO();
        
        
        int idABuscar = 1; 
        Estado_cita estado_citaEncontrado = dao.consultaEstado_cita(idABuscar);
        
        
        if (estado_citaEncontrado != null) {
            System.out.println("--- Estado de cita Encontrado ---");    
            System.out.println("ID: " + estado_citaEncontrado.getidEstado_cita());
            System.out.println("Descripcion: " + estado_citaEncontrado.getdescripcion_estadoci());
     
        } else {
            System.out.println("No se encontró ningún Estado de cita con el ID: " + idABuscar);
        }
    }
}