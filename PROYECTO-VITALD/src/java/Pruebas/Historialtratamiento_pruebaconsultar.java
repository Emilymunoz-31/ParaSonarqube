package Pruebas;

import Controlador.Historial_tratamientoDAO;
import Modelo.Historial_tratamiento;


public class Historialtratamiento_pruebaconsultar{
    public static void main(String[] args) {
        
        Historial_tratamientoDAO dao = new Historial_tratamientoDAO();
        
        
        int idABuscar = 1; 
        Historial_tratamiento historial_tratamientoEncontrado = dao.consultaHistorial_tratamiento(idABuscar);
        
        
        if (historial_tratamientoEncontrado != null) {
            System.out.println("--- Historial de tratamiento encontrado ---");
            System.out.println("ID: " + historial_tratamientoEncontrado.getid_Historial());
            System.out.println("Año del tratamiento: " + historial_tratamientoEncontrado.getanio());
            System.out.println("costo en ese año: " + historial_tratamientoEncontrado.getcosto());
            System.out.println("tratamiento: " + historial_tratamientoEncontrado.getTipo_tratamiento_id_Tipotratam());
        } else {
            System.out.println("No se encontró ningún Historail de tratamiento con el ID: " + idABuscar);
        }
    }
}