package Pruebas;

import Controlador.Tipo_tratamientoDAO;
import Modelo.Tipo_tratamiento;


public class Tipo_tratamiento_pruebaconsultar {
    public static void main(String[] args) {
        
        Tipo_tratamientoDAO dao = new Tipo_tratamientoDAO();
        
        
        int idABuscar = 1; 
        Tipo_tratamiento tipo_tratamientoEncontrado = dao.consultaTipo_tratamiento(idABuscar);
        
        
        if (tipo_tratamientoEncontrado != null) {
            System.out.println("--- Tipo de tratamiento Encontrado ---");
            System.out.println("ID: " + tipo_tratamientoEncontrado.getid_Tipotratam());
            System.out.println("Descripcion: " + tipo_tratamientoEncontrado.getdescripcion_tipotratam());
        } else {
            System.out.println("No se encontró ningún Tipo de tratamiento con el ID: " + idABuscar);
        }
    }
}